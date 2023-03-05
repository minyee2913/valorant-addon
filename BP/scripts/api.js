import { world } from "@minecraft/server";
import { addTask } from "./onTick.js";

const overworld = world.getDimension("minecraft:overworld");
const scoreboard = world.scoreboard;

export function getTagEntities(tag) {
    const tags = [];
    if (typeof tag === "string") {
        tags.push(tag);
    } else {
        tags.push(...tag);
    }

    return Array.from(overworld.getEntities({ tags: tags }));
}

export function getTagPlayers(tag) {
    const tags = [];
    if (typeof tag === "string") {
        tags.push(tag);
    } else {
        tags.push(...tag);
    }
    return Array.from(overworld.getPlayers({ tags: tags }));
}

export function getScore(entity, objectiveId, defaultValue = 0) {
    try {
        return scoreboard.getObjective(objectiveId).getScore(entity.scoreboard);
    } catch {
        return defaultValue;
    }
};

export function runParticle(particle, x, y, z) {
    return runWorldCommand(`particle ${particle} ${x} ${y} ${z}`);
}

export function runWorldCommand(command) {
    return overworld.runCommandAsync(command);
}

export class CustomLocation {
    constructor(x, y, z, multiplier = 1) {
        this.x = x * multiplier / 100
        this.y = y * multiplier / 100
        this.z = z * multiplier / 100
    }

    equals(location) {
        return this.x === location.x && this.y === location.y && this.z === location.z
    }
}

export class LineData {
    constructor(pos1, pos2) {
        this.pos1 = pos1
        this.pos2 = pos2

        let xDiff = pos1.x - pos2.x
        let yDiff = pos1.y - pos2.y
        let zDiff = pos1.z - pos2.z

        this.dist = Math.sqrt((Math.abs(xDiff) ** 2) + (Math.abs(yDiff) ** 2) + (Math.abs(zDiff) ** 2))
        this.xDiff = (xDiff / this.dist)
        this.yDiff = (yDiff / this.dist)
        this.zDiff = (zDiff / this.dist)
    }

    getDiff(multiplier) {
        return new CustomLocation(this.xDiff, this.yDiff, this.zDiff, multiplier)
    }
}

export function showLineParticles(pos1, pos2_array, particle, multiplier, delayMultiplier, particlePerDelay, yOffset, onEnd) {
    let tasks = [];

    pos2_array.forEach((pos2, ii) => {
        const line = new LineData(pos1, pos2);
        let diff = line.getDiff(multiplier)
        let increaseCount = Math.ceil(line.dist) * Math.round(100 / multiplier)

        for (let i = 0; i <= increaseCount; i++) {
            if (i === increaseCount) {
                let delay = Math.floor((i - 1) * delayMultiplier / particlePerDelay)
                tasks.push(addTask(delay + 1, () => onEnd(ii)));
                continue;
            }
            let executable = () => runParticle(particle, pos1.x - (diff.x * i), pos1.y - (diff.y * i) + yOffset, pos1.z - (diff.z * i));
            let delay = Math.floor(i * delayMultiplier / particlePerDelay);

            tasks.push(addTask(delay, executable));
        }
    });

    return tasks;
}

export function asLine(pos1, pos2_array, multiplier, delayMultiplier, particlePerDelay, yOffset, onLine, onEnd) {
    let tasks = [];

    pos2_array.forEach((pos2) => {
        const line = new LineData(pos1, pos2);
        let diff = line.getDiff(multiplier)
        let increaseCount = Math.ceil(line.dist) * Math.round(100 / multiplier)

        for (let i = 0; i <= increaseCount; i++) {
            if (i === increaseCount) {
                let delay = Math.floor((i - 1) * delayMultiplier / particlePerDelay)
                tasks.push(addTask(delay + 1, onEnd));
                continue;
            }
            let executable = () => onLine(pos1.x - (diff.x * i), pos1.y - (diff.y * i) + yOffset, pos1.z - (diff.z * i));
            let delay = Math.floor(i * delayMultiplier / particlePerDelay);

            tasks.push(addTask(delay, executable));
        }
    });

    return tasks;
}