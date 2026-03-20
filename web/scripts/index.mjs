import { getImageAsync } from "./asset.mjs";
import { drawBackground } from "./draw.mjs";

const [backgroundImage, spritesImage] = await Promise.all([
    getImageAsync("c64-screens.png"),
    getImageAsync("web-sprites.png"),
]);
// loading screen
drawBackground(backgroundImage, 0);
