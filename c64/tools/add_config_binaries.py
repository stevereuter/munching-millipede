#!/usr/bin/env python3
"""Build configured binary PRG assets and add them to a D64 image."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path
from typing import Any


def fail(message: str) -> None:
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(1)


def parse_load_address(value: object) -> int:
    if isinstance(value, int):
        addr = value
    elif isinstance(value, str):
        cleaned = value.strip()

        # Supports "00 C0" (little-endian bytes), "0xC000", and "C000".
        parts = cleaned.split()
        if len(parts) == 2:
            low = int(parts[0], 16)
            high = int(parts[1], 16)
            addr = (high << 8) | low
        elif cleaned.lower().startswith("0x"):
            addr = int(cleaned, 16)
        else:
            addr = int(cleaned, 16)
    else:
        fail(f"Unsupported loadAddress type: {type(value).__name__}")

    if addr < 0 or addr > 0xFFFF:
        fail(f"loadAddress out of range: {addr}")
    return addr


def resolve_d64_path(config: dict[str, Any], repo_root: Path, build_dir: Path) -> Path:
    configured_path = config.get("d64Path") or config.get("diskImagePath") or config.get("d64Image")
    if configured_path:
        d64_path = Path(str(configured_path))
        if not d64_path.is_absolute():
            d64_path = repo_root / d64_path
        if not d64_path.exists():
            fail(f"Configured D64 image not found: {d64_path}")
        return d64_path

    candidates = sorted(build_dir.glob("*.d64"))
    if len(candidates) == 1:
        return candidates[0]
    if not candidates:
        fail(
            "No D64 image found in build directory. Set config.json d64Path or create a .d64 in "
            f"{build_dir}"
        )

    listed = ", ".join(str(path.name) for path in candidates)
    fail(
        "Multiple D64 images found in build directory. Set config.json d64Path to disambiguate. "
        f"Candidates: {listed}"
    )


def normalize_hex(value: str) -> str:
    cleaned = value.strip().upper()
    if not cleaned.startswith("#"):
        cleaned = "#" + cleaned
    if len(cleaned) == 7:
        cleaned = cleaned + "FF"
    if len(cleaned) != 9:
        fail(f"Invalid hex color '{value}'. Expected #RRGGBB or #RRGGBBAA")
    return cleaned


def parse_color_map(config: dict[str, Any]) -> dict[str, dict[str, Any]]:
    entries = config.get("asepriteColorMap", [])
    if not isinstance(entries, list):
        fail("config.json field 'asepriteColorMap' must be an array")

    by_hex: dict[str, dict[str, Any]] = {}
    for entry in entries:
        if not isinstance(entry, dict):
            fail("Each asepriteColorMap entry must be an object")

        raw_hex = entry.get("hex")
        c64_index = entry.get("c64Index")
        role = str(entry.get("role", "")).strip().lower()
        if not raw_hex:
            fail("asepriteColorMap entry missing 'hex'")
        if c64_index is None:
            fail(f"asepriteColorMap entry '{raw_hex}' missing 'c64Index'")
        if role not in {"background", "shared1", "shared2", "character"}:
            fail(
                f"asepriteColorMap entry '{raw_hex}' has invalid role '{entry.get('role')}'. "
                "Expected one of: background, shared1, shared2, character"
            )

        try:
            c64_val = int(c64_index)
        except (TypeError, ValueError):
            fail(f"asepriteColorMap entry '{raw_hex}' has invalid c64Index '{c64_index}'")
        if c64_val < 0 or c64_val > 15:
            fail(f"asepriteColorMap entry '{raw_hex}' c64Index out of range 0-15: {c64_val}")

        key = normalize_hex(str(raw_hex))
        if key in by_hex:
            fail(f"Duplicate asepriteColorMap hex value: {key}")
        by_hex[key] = {"hex": key, "c64Index": c64_val, "role": role}

    return by_hex


def build_raw_to_color_rule(screen_json: dict[str, Any], by_hex: dict[str, dict[str, Any]]) -> dict[int, dict[str, Any]]:
    color_ref = screen_json.get("colorReference")
    if not isinstance(color_ref, dict):
        fail("Screen JSON is missing 'colorReference' object")

    entries = color_ref.get("entries", [])
    if not isinstance(entries, list):
        fail("Screen JSON field 'colorReference.entries' must be an array")

    raw_to_rule: dict[int, dict[str, Any]] = {}
    for entry in entries:
        if not isinstance(entry, dict):
            fail("Each colorReference entry must be an object")
        raw_value = entry.get("rawValue")
        raw_hex = entry.get("hex")
        if raw_value is None or raw_hex is None:
            fail("colorReference entry requires both 'rawValue' and 'hex'")

        try:
            raw_key = int(raw_value)
        except (TypeError, ValueError):
            fail(f"Invalid rawValue in colorReference: {raw_value}")

        hex_key = normalize_hex(str(raw_hex))
        rule = by_hex.get(hex_key)
        if not rule:
            fail(f"No asepriteColorMap mapping for colorReference hex {hex_key}")

        raw_to_rule[raw_key] = rule

    return raw_to_rule


def generate_screen_map_bytes(screen_json: dict[str, Any]) -> bytes:
    cells = screen_json.get("cells", [])
    if not isinstance(cells, list):
        fail("Screen JSON field 'cells' must be an array")

    out = bytearray()
    for i, value in enumerate(cells):
        try:
            byte_val = int(value)
        except (TypeError, ValueError):
            fail(f"Screen cell #{i} is not an integer: {value}")
        if byte_val < 0 or byte_val > 255:
            fail(f"Screen cell #{i} out of byte range 0-255: {byte_val}")
        out.append(byte_val)
    return bytes(out)


def generate_character_bytes(screen_json: dict[str, Any], raw_to_rule: dict[int, dict[str, Any]]) -> bytes:
    tiles_obj = screen_json.get("tiles")
    if not isinstance(tiles_obj, dict):
        fail("Screen JSON is missing 'tiles' object")
    tiles = tiles_obj.get("tiles", [])
    if not isinstance(tiles, list):
        fail("Screen JSON field 'tiles.tiles' must be an array")

    role_to_bits = {
        "background": 0b00,
        "shared1": 0b01,
        "shared2": 0b10,
        "character": 0b11,
    }

    out = bytearray()
    for tile in tiles:
        if not isinstance(tile, dict):
            fail("Each tile entry must be an object")
        tile_index = tile.get("tileIndex", "?")
        rows = tile.get("rows", [])
        if not isinstance(rows, list):
            fail(f"Tile {tile_index} rows must be an array")
        if len(rows) != 8:
            fail(f"Tile {tile_index} must contain 8 rows, found {len(rows)}")

        for row_idx, row in enumerate(rows):
            if not isinstance(row, list):
                fail(f"Tile {tile_index} row {row_idx} must be an array")
            if len(row) != 4:
                fail(f"Tile {tile_index} row {row_idx} must contain 4 logical pixels")

            packed = 0
            for col_idx, raw_value in enumerate(row):
                try:
                    raw_key = int(raw_value)
                except (TypeError, ValueError):
                    fail(f"Tile {tile_index} row {row_idx} col {col_idx} invalid raw value: {raw_value}")

                rule = raw_to_rule.get(raw_key)
                if not rule:
                    fail(
                        f"Tile {tile_index} row {row_idx} col {col_idx} raw value {raw_key} "
                        "has no asepriteColorMap mapping"
                    )

                bits = role_to_bits[rule["role"]]
                packed |= bits << (6 - (col_idx * 2))

            out.append(packed)

    return bytes(out)


def build_tile_character_colors(screen_json: dict[str, Any], raw_to_rule: dict[int, dict[str, Any]]) -> list[int]:
    tiles_obj = screen_json.get("tiles")
    if not isinstance(tiles_obj, dict):
        fail("Screen JSON is missing 'tiles' object")
    tiles = tiles_obj.get("tiles", [])
    if not isinstance(tiles, list):
        fail("Screen JSON field 'tiles.tiles' must be an array")

    tile_char_colors: list[int] = []
    for tile in tiles:
        if not isinstance(tile, dict):
            fail("Each tile entry must be an object")

        tile_index = tile.get("tileIndex", "?")
        rows = tile.get("rows", [])
        if not isinstance(rows, list):
            fail(f"Tile {tile_index} rows must be an array")

        char_colors: set[int] = set()
        for row in rows:
            if not isinstance(row, list):
                fail(f"Tile {tile_index} row must be an array")
            for raw_value in row:
                try:
                    raw_key = int(raw_value)
                except (TypeError, ValueError):
                    fail(f"Tile {tile_index} contains invalid raw value: {raw_value}")

                rule = raw_to_rule.get(raw_key)
                if not rule:
                    fail(f"Tile {tile_index} raw value {raw_key} has no asepriteColorMap mapping")
                if rule["role"] == "character":
                    try:
                        char_index = int(rule["c64Index"])
                    except (TypeError, ValueError):
                        fail(f"Tile {tile_index} has invalid character c64Index '{rule['c64Index']}'")

                    # Accept character colors as either logical 0-7 or direct color RAM 8-15.
                    if 0 <= char_index <= 7:
                        char_colors.add(char_index + 8)
                    elif 8 <= char_index <= 15:
                        char_colors.add(char_index)
                    else:
                        fail(
                            f"Tile {tile_index} character color index out of range 0-15: {char_index}"
                        )

        if len(char_colors) > 1:
            fail(
                f"Tile {tile_index} contains multiple character colors {sorted(char_colors)}. "
                "Each tile must resolve to a single character color."
            )

        # Background-only tiles can use multicolor color RAM value 8 (color code 0 + multicolor flag).
        color_val = next(iter(char_colors)) if char_colors else 8
        if color_val < 8 or color_val > 15:
            fail(
                f"Tile {tile_index} character color must be in 8-15 for C64 multicolor text chars, "
                f"got {color_val}"
            )
        tile_char_colors.append(color_val)

    return tile_char_colors


def generate_color_ram_bytes(screen_json: dict[str, Any], raw_to_rule: dict[int, dict[str, Any]]) -> bytes:
    cells = screen_json.get("cells", [])
    if not isinstance(cells, list):
        fail("Screen JSON field 'cells' must be an array")

    tile_char_colors = build_tile_character_colors(screen_json, raw_to_rule)
    out = bytearray()
    for i, cell in enumerate(cells):
        try:
            tile_index = int(cell)
        except (TypeError, ValueError):
            fail(f"Screen cell #{i} is not an integer: {cell}")

        if tile_index < 0 or tile_index >= len(tile_char_colors):
            fail(
                f"Screen cell #{i} references tile index {tile_index}, "
                f"but only {len(tile_char_colors)} tiles are available"
            )

        out.append(tile_char_colors[tile_index])

    return bytes(out)


def generate_asset_bytes(
    entry: dict[str, Any], repo_root: Path, by_hex: dict[str, dict[str, Any]], json_cache: dict[Path, dict[str, Any]]
) -> bytes:
    asset_type = str(entry.get("type") or "raw-bin").strip().lower()
    path = entry.get("path")
    if not path:
        fail("binaries entry is missing 'path'")

    source_file = repo_root / str(path)
    if not source_file.exists():
        fail(f"Source file not found: {source_file}")

    if asset_type == "raw-bin":
        return source_file.read_bytes()

    if asset_type not in {"screen-map", "screen-chars", "screen-colors"}:
        fail(f"Unsupported binaries entry type '{asset_type}' for path {path}")

    screen_json = json_cache.get(source_file)
    if screen_json is None:
        with source_file.open("r", encoding="utf-8") as handle:
            screen_json = json.load(handle)
        json_cache[source_file] = screen_json

    raw_to_rule = build_raw_to_color_rule(screen_json, by_hex)

    if asset_type == "screen-map":
        return generate_screen_map_bytes(screen_json)
    if asset_type == "screen-chars":
        return generate_character_bytes(screen_json, raw_to_rule)

    return generate_color_ram_bytes(screen_json, raw_to_rule)


def main() -> None:
    repo_root = Path(__file__).resolve().parents[2]
    c64_root = repo_root / "c64"
    build_dir = c64_root / "build"
    config_path = repo_root / "config.json"

    if not config_path.exists():
        fail(f"Missing config file: {config_path}")

    with config_path.open("r", encoding="utf-8") as handle:
        config = json.load(handle)

    d64_path = resolve_d64_path(config, repo_root, build_dir)

    binaries = config.get("binaries", [])
    if not isinstance(binaries, list):
        fail("config.json field 'binaries' must be an array")
    if not binaries:
        print("No configured binaries found; nothing to add.")
        return

    by_hex = parse_color_map(config)
    json_cache: dict[Path, dict[str, Any]] = {}

    build_dir.mkdir(parents=True, exist_ok=True)

    for entry in binaries:
        if not isinstance(entry, dict):
            fail("Each binaries entry must be an object")

        if entry.get("enabled", True) is False:
            print(f"Skipping disabled entry: {entry.get('name', entry.get('path', '<unknown>'))}")
            continue

        load_address = entry.get("loadAddress")
        disk_name = entry.get("discName") or entry.get("diskName")

        if load_address is None:
            fail(f"binaries entry '{entry.get('path')}' is missing 'loadAddress'")
        if not disk_name:
            fail(f"binaries entry '{entry.get('path')}' is missing 'discName' or 'diskName'")

        data = generate_asset_bytes(entry, repo_root, by_hex, json_cache)
        addr = parse_load_address(load_address)
        prg_name = f"{str(disk_name).lower()}.prg"
        prg_path = build_dir / prg_name

        # PRG payload starts with little-endian load address.
        prg_path.write_bytes(bytes((addr & 0xFF, (addr >> 8) & 0xFF)) + data)

        cmd = [
            "c1541",
            str(d64_path),
            "-delete",
            str(disk_name),
            "-write",
            str(prg_path),
            str(disk_name),
        ]

        try:
            subprocess.run(cmd, check=True, capture_output=True, text=True)
        except subprocess.CalledProcessError:
            # File might not exist yet; retry without delete.
            write_cmd = [
                "c1541",
                str(d64_path),
                "-write",
                str(prg_path),
                str(disk_name),
            ]
            subprocess.run(write_cmd, check=True)

        print(
            f"Added {entry.get('path')} ({entry.get('type', 'raw-bin')}) -> "
            f"{prg_path.name} @ ${addr:04X} as '{disk_name}'"
        )


if __name__ == "__main__":
    main()
