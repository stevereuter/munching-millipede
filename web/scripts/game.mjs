import {
    clearForeground,
    clearMain,
    drawBackground,
    drawDifficulty,
    drawForeground,
    drawHeart,
    drawHighScore,
    drawObstacle,
    drawPlayer,
    drawScore,
    initContextsAsync,
    Scene,
    Screen,
} from "./draw.mjs";
import {
    clearKeyBuffer,
    Direction,
    getDirectionFromBuffer,
    isFiring,
} from "./keyboard.mjs";
import { getHighScore } from "./storage.mjs";

let difficulty = 2; // default to medium
const SPEED = 150;
let gameTime = 0;
const screen = [];
screen.length = 1000;
/** @type {number[]} */
const path = [];
let direction = Direction.Right;
let heartPosition = -1;
let score = 0;
let scoreCounter = 0;

function drawPlayerPath() {
    for (let i = 0; i < path.length; i += 1) {
        const position = path[i];
        drawPlayer(
            position,
            i === path.length - 1 ? direction : Direction.Stopped,
        );
    }
}

function initPlayer() {
    path.length = 0;
    const start = 1 + 9 * Screen.X;
    const end = start + 3;
    for (let i = start; i <= end; i += 1) {
        path.push(i);
        screen[i] = true;
    }
}

function initScreen() {
    screen.length = 0;
    screen.length = 1000;
    for (let i = 0; i < Screen.X; i += 1) {
        screen[i] = true;
    }
    for (let i = Screen.X; i < screen.length - 1; i += Screen.X) {
        screen[i] = true;
        screen[i - 1] = true;
    }
    for (let i = screen.length - 1 - Screen.X; i < screen.length; i += 1) {
        screen[i] = true;
    }
}

function waitAsync(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

function initIntro() {
    clearForeground();
    clearMain();
    drawBackground(Scene.TitleBackground);
    drawDifficulty(difficulty);
}

async function gameOverAsync() {
    drawForeground(Scene.GameOverForeground);

    // TODO: draw score
    // TODO: save high score to local storage
    await waitAsync(5000);
    initIntro();
    introLoop();
}

function getSafeInput() {
    const input = getDirectionFromBuffer();
    if (direction === Direction.Left && input === Direction.Right) return null;
    if (direction === Direction.Right && input === Direction.Left) return null;
    if (direction === Direction.Up && input === Direction.Down) return null;
    if (direction === Direction.Down && input === Direction.Up) return null;
    return input;
}

function getRandomScreenPosition() {
    const randomIndex = Math.floor(Math.random() * screen.length);
    if (screen[randomIndex]) return;
    return randomIndex;
}

function addNewHeart() {
    if (heartPosition >= 0) return;
    const randomIndex = getRandomScreenPosition();
    if (!randomIndex) return;
    heartPosition = randomIndex;
}

async function createRandomObstaclesAsync(count) {
    do {
        const randomIndex = getRandomScreenPosition();
        if (randomIndex) {
            screen[randomIndex] = true;
            drawObstacle(randomIndex);
            await waitAsync(100);
        }
        count -= 1;
    } while (count > 0);
}

async function gameLoopAsync() {
    const loopStart = Date.now();
    const elapsed = loopStart - gameTime;
    const waitTime = Math.max(0, SPEED - elapsed);
    await waitAsync(waitTime);
    const input = getSafeInput();

    if (input) {
        direction = input;
    }
    const position = path[path.length - 1] + direction;
    console.log("position", position);
    if (screen[position]) {
        gameOverAsync();
        return;
    }
    screen[position] = true;
    path.push(position);
    if (position === heartPosition) {
        score += 10 + difficulty;
        scoreCounter += 1;
        drawScore(score);
        heartPosition = -1;
    } else {
        const tail = path.shift();
        screen[tail] = false;
    }
    addNewHeart();
    clearMain();
    drawPlayerPath();
    drawHeart(heartPosition);
    if (scoreCounter > 0 && scoreCounter % 10 === 0) {
        await createRandomObstaclesAsync(1);
    }

    gameTime = Date.now();
    requestAnimationFrame(gameLoopAsync);
}

async function loadLevel() {
    clearForeground();
    drawBackground(Scene.GameBackground);
    initScreen();
    initPlayer();
    drawPlayerPath();
    // TODO: draw obstacles based on difficulty
    await createRandomObstaclesAsync(difficulty * 10);
    addNewHeart();
    drawHeart(heartPosition);
    clearKeyBuffer();
    // TODO: draw ready set go sequence
    gameTime = Date.now();
    direction = Direction.Right;
    score = 0;
    scoreCounter = 0;
    drawScore(score);
    const highScore = getHighScore();
    drawHighScore(highScore);
    requestAnimationFrame(gameLoopAsync);
}

function introLoop() {
    // intro animation logic goes here
    if (isFiring()) {
        loadLevel();
        return;
    }
    const key = getDirectionFromBuffer();
    if (key === Direction.Up && difficulty < 9) {
        difficulty += 1;
    }
    if (key === Direction.Down && difficulty > 0) {
        difficulty -= 1;
    }
    drawDifficulty(difficulty);

    requestAnimationFrame(introLoop);
}

export async function loadGameAsync() {
    await initContextsAsync();
    // loading screen
    drawBackground(Scene.LoadingBackground);
    await waitAsync(3000);
    initIntro();
    introLoop();
}
