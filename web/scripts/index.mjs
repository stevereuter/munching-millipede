import { getImageAsync } from "./asset.mjs";
import { drawBackground } from "./draw.mjs";

const background = await getImageAsync("c64-screens.png");

drawBackground(background);
