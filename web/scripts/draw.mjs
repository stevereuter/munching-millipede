/** @type {CanvasRenderingContext2D} */
const backgroundContext = document
    .getElementById("game-background")
    .getContext("2d");

/** @type {CanvasRenderingContext2D} */
const foregroundContext = document
    .getElementById("game-foreground")
    .getContext("2d");

/** @type {CanvasRenderingContext2D} */
const mainContext = document.getElementById("game-main").getContext("2d");

/**
 * @description draws background image
 * @param {HTMLImageElement} image
 * @param {number} screen
 */
export function drawBackground(image, screen = 0) {
    const sectionWidth = image.width / 7;
    const x = screen * sectionWidth;
    backgroundContext.drawImage(
        image,
        x,
        0,
        sectionWidth,
        image.height,
        0,
        0,
        384,
        272,
    );
}
