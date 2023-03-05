import { world } from "@minecraft/server"

const queue = [];
let currentTick = 0;

export function addTask(delay, task, repeat) {
    let tick = currentTick + delay;
    let id = Math.round(Math.random() * 9000) + 1000;

    if (delay === 0) {
        task(null, id);
    }

    queue.push({
        tick: tick,
        delay: delay,
        id: id,
        task: task,
        repeat: repeat
    });

    return id;
}

export function deleteTask(id) {
    const task = queue.find((v) => v.id === id);
    if (task) {
        queue.splice(queue.indexOf(task), 1);
    }
}

world.events.tick.subscribe(() => {
    currentTick++

    let taskList = queue.filter((v) => v.tick === currentTick);
    if (taskList.length > 0) {
        for (let task of taskList) {
            task.task(task.repeat, task.id);

            if (task.repeat === undefined || task.repeat <= 0) queue.splice(queue.indexOf(task), 1);
            else {
                task.repeat--;
                task.tick = currentTick + task.delay;
            }
        }
    }
});