import { getAssetsAsync, Asset } from "./asset.mjs";
import { CanvasIds, getCanvases } from "./dom.mjs";
import { Direction } from "./keyboard.mjs";

const WIDTH = 384;
const HEIGHT = 272;
export const Screen = {
    X: 40,
    Y: 25,
};
const contexts = new Map();
const images = new Map();
export const Scene = {
    LoadingBackground: 0,
    TitleBackground: 1,
    GameBackground: 2,
    GameOverForeground: 3,
    ReadyForeground: 4,
    SetForeground: 5,
    GoForeground: 6,
};
const Offset = {
    Top: 35,
    Left: 32,
};
const cellSize = 8;
const NumberSprite = [0, 8, 16, 24, 32, 40, 48, 56, 64, 72];
const PlayerSprite = {
    Body: 0,
    Right: 8,
    Left: 16,
    Up: 24,
    Down: 32,
};
const PlayerSpriteRowY = 3 * cellSize;
const TextColor = {
    White: 0,
    Grey: 8,
    Black: 16,
};

export async function initContextsAsync() {
    contexts.clear();
    const canvases = getCanvases();
    Object.entries(canvases).forEach(([key, canvas]) => {
        contexts.set(key, canvas.getContext("2d"));
    });
    const [backgroundImage, spritesImage] = await getAssetsAsync();
    images.set(Asset.Screens, backgroundImage);
    images.set(Asset.Sprites, spritesImage);
}

/**
 * @description draws background image
 * @param {Scene} screen
 */
export function drawBackground(screen = Scene.LoadingBackground) {
    const image = images.get(Asset.Screens);
    const sectionWidth = image.width / 7;
    const x = screen * sectionWidth;
    const backgroundContext = contexts.get(CanvasIds.Background);
    backgroundContext.drawImage(
        image,
        x,
        0,
        sectionWidth,
        image.height,
        0,
        0,
        WIDTH,
        HEIGHT,
    );
}

export function drawForeground(screen = Scene.GameOverForeground) {
    const image = images.get(Asset.Screens);
    const sectionWidth = image.width / 7;
    const x = screen * sectionWidth;
    const foregroundContext = contexts.get(CanvasIds.Foreground);
    foregroundContext.drawImage(
        image,
        x,
        0,
        sectionWidth,
        image.height,
        0,
        0,
        WIDTH,
        HEIGHT,
    );
}

export function drawDifficulty(difficulty) {
    const image = images.get(Asset.Sprites);
    const foregroundContext = contexts.get(CanvasIds.Foreground);
    const x = NumberSprite[difficulty];
    foregroundContext.drawImage(
        image,
        x,
        TextColor.White,
        cellSize,
        cellSize,
        Offset.Left + 26 * cellSize,
        Offset.Top + 11 * cellSize,
        cellSize,
        cellSize,
    );
}

export function clearForeground() {
    const foregroundContext = contexts.get(CanvasIds.Foreground);
    foregroundContext.clearRect(0, 0, WIDTH, HEIGHT);
}

export function clearMain() {
    const mainContext = contexts.get(CanvasIds.Main);
    mainContext.clearRect(0, 0, WIDTH, HEIGHT);
}

export function drawPlayer(position, direction) {
    const image = images.get(Asset.Sprites);
    const mainContext = contexts.get(CanvasIds.Main);

    const column = position % Screen.X;
    const row = Math.floor(position / Screen.X);
    const x = Offset.Left + column * cellSize;
    const y = Offset.Top + row * cellSize;

    let spriteX = PlayerSprite.Body;
    if (direction === Direction.Left) spriteX = PlayerSprite.Left;
    if (direction === Direction.Right) spriteX = PlayerSprite.Right;
    if (direction === Direction.Up) spriteX = PlayerSprite.Up;
    if (direction === Direction.Down) spriteX = PlayerSprite.Down;

    mainContext.drawImage(
        image,
        spriteX,
        PlayerSpriteRowY,
        cellSize,
        cellSize,
        x,
        y,
        cellSize,
        cellSize,
    );
}

export function drawScore(score) {
    const scoreString = score.toString();
    const image = images.get(Asset.Sprites);
    const foregroundContext = contexts.get(CanvasIds.Foreground);
    for (let i = 0; i < scoreString.length; i += 1) {
        const digit = parseInt(scoreString[i], 10);
        const x = NumberSprite[digit];
        foregroundContext.drawImage(
            image,
            x,
            TextColor.Grey,
            cellSize,
            cellSize,
            Offset.Left + (8 + i) * cellSize,
            Offset.Top,
            cellSize,
            cellSize,
        );
    }
}

export function drawHighScore(highScore) {
    const highScoreString = highScore.toString();
    const highScoreLength = highScoreString.length;
    const image = images.get(Asset.Sprites);
    const foregroundContext = contexts.get(CanvasIds.Foreground);
    const endColumn = 37;
    const startColumn = endColumn - highScoreLength + 1;

    // Draw HI: label — 4th row (PlayerSpriteRowY), 8th column of sprite sheet
    foregroundContext.drawImage(
        image,
        7 * cellSize,
        PlayerSpriteRowY,
        3 * cellSize,
        cellSize,
        Offset.Left + (startColumn - 3) * cellSize,
        Offset.Top,
        3 * cellSize,
        cellSize,
    );

    for (let i = 0; i < highScoreString.length; i += 1) {
        const digit = parseInt(highScoreString[i], 10);
        const x = NumberSprite[digit];
        foregroundContext.drawImage(
            image,
            x,
            TextColor.Grey,
            cellSize,
            cellSize,
            Offset.Left + (startColumn + i) * cellSize,
            Offset.Top,
            cellSize,
            cellSize,
        );
    }
}
