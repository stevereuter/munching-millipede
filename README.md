# The Munching Millipede

<div align="center">
  <a href="https://steviesaurus-dev.itch.io/the-munching-millipede" target="_blank">
    <img src="assets/millipede-thumbnail.png" alt="The Munching Millipede Cover Art" width="400" style="image-rendering: pixelated;" />
  </a>
  <p><em>Click to get on itch.io</em></p>
</div>

## Introduction

The Munching Millipede is a snake like game originally written for the Commodore 64.
The player controls the direction of the constantly moving millipede around the play area, collecting hearts and avoiding obstacles. For each heart collected, the score is increased and the millipede grows. For every 10 hearts collected a random obstacle may be added to the play area.
This is a single level design where the user just lasts as long as they can.
The title screen include an option to change the difficulty from 0 to 9. These simply add a number of randomly placed obstacles at 10x the difficaulty selected.

See the gameplay here https://youtu.be/2er58e9Nhv0

## Development

The Munching Millipede game is written in Commodore BASIC 2.0 for the Commodore 64.

- developed by Steve
- originally written on the Vice emulater, then later pulled into VSCODE and updated using the VS64 extension.
- artwork created in Aseprite
- brainstorming partners and design guides: April and Isabella

### Building & Releases

Release packaging uses a hybrid process:

- **Manual for C64** (local build tools required)
- **Automated for Web** (GitHub Actions on release publish)

#### C64 Package (Manual)

Run the packaging script from the project root:

```bash
bash package.sh
```

This script will:

- Build the PRG and inject the version from `config.json` during the build
- Create a d64 disk image using VICE's c1541 tool
- Package both the PRG and d64 files into `munching-millipede-vX.X.X.zip`

Output files are created in `c64/build/`.

Requirements:

- VICE tools installed (`c1541`)
- VS64 extension tools available locally (as referenced in `package.sh`)

#### Web Package + Pages (Automated)

Workflow: `.github/workflows/release-web.yml`

Trigger:

- Runs when a GitHub Release is **published**

Behavior:

- Reads version from `config.json`
- Replaces `###VERSION###` in:
    - `web/index.html`
    - `web/scripts/index.mjs`
- Creates a web zip named `<repo>-web-vX.X.X.zip`
- Uploads that zip to the same GitHub Release as an asset
- Deploys the same processed web output to GitHub Pages

GitHub setup required:

- Pages source must be set to **GitHub Actions**
- Actions workflow permissions should allow **Read and write permissions**

#### Release Flow

1. Run `bash package.sh` locally and keep the generated C64 zip.
2. Create/publish a GitHub release and upload the C64 zip asset.
3. The release workflow automatically adds the web zip asset and deploys GitHub Pages.

## History

- the first iteration was very simple and running in about 2 hours (BASIC Vice)
- after that I continued to polish it with an intro screen and selectable level
- then at about 280 lines of code, the fine tuning was getting a little difficult to work with, so I pulled the code out of the disc image and created this repository (VSCODE, VS64)
- I then removed the line numbers and started splitting the code into files, and the speed of the program went up noticeably
- now I'm working on polishing it off and hosting it for others to enjoy, maybe another kid will be inspired to dive in
- I've created issues now for the final finishing touches, but plan to release before I work on those

## License
Code: Licensed under the [MIT License](LICENSE)

Assets: Licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](assets/LICENSE)

Feel free to learn from the code and use it in your own projects. Assets (images, sprites, audio, etc.) and data generated from them may be shared and adapted under the CC BY-NC-SA 4.0 terms — please provide attribution and distribute derivative works under the same license.
