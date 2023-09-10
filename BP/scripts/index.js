import { world, system } from "@minecraft/server";
import { getTagEntities, getTagPlayers, asLine, getScore } from "./api.js";

const overworld = world.getDimension("minecraft:overworld");

world.afterEvents.projectileHit.subscribe(ev => {
    const hitData = ev.getEntityHit();
    if (!hitData || !hitData.entity) return;

    if (ev.projectile.typeId !== "2913:bullet") return;

    const inventory = ev.source.getComponent("minecraft:inventory");
    const item = inventory.container.getItem(ev.source.selectedSlot);

    const diff = ev.location.y - hitData.entity.location.y;

    let head = false;
    if (diff > 1.46) head = true;

    if (hitData.entity.hasTag("ghost")) return;

    if (head) {
        ev.source.addTag("headshot");
        ev.source.runCommandAsync(`playsound effect.headshot @s ~ ~ ~`);
    }
    else if (ev.source.hasTag("headshot")) ev.source.removeTag("headshot");

    hitData.entity.addTag(item.typeId + ev.source.nameTag);
    let result;

    try {
        if (item.typeId === "2913:vandal") {
            if (head) {
                hitData.entity.runCommandAsync(`scoreboard players remove @s health 150`);
            }
            else hitData.entity.runCommandAsync(`scoreboard players remove @s health 40`);
        }

        hitData.entity.runCommandAsync(`execute as @s[scores={health=..0}] as "${ev.source.name}" at @s run function check_kill`);
        hitData.entity.runCommandAsync(`execute at @s[scores={health=..0}] as @p[name="${ev.source.name}",scores={agent=1}] run summon 2913:dummy "soul" ~ ~1 ~`);
        hitData.entity.runCommandAsync(`execute as @s[scores={health=..0},type=!2913:dummy] as @p[name="${ev.source.name}",tag=reyna_super] at @s run scoreboard players set @s reyna_heal 0`);
        hitData.entity.runCommandAsync(`execute as @s[scores={health=..0},type=!2913:dummy] as @p[name="${ev.source.name}",tag=reyna_super] at @s run scoreboard players set @s reyna_super 1`);
        hitData.entity.runCommandAsync(`execute as @s[scores={health=..0},type=!2913:dummy] as @p[name="${ev.source.name}",tag=reyna_super] at @s run playsound reyna.heal2 @s ~ ~ ~`);
        hitData.entity.runCommandAsync(`kill @s[scores={health=..0},type=!player,type=!2913:dummy]`);
        hitData.entity.runCommandAsync(`event entity @s[scores={health=..0},tag=damagable,type=2913:dummy] despawn`);
    } catch {

    }
});

world.afterEvents.projectileHit.subscribe(ev => {
    const hitData = ev.getEntityHit();
    if (!hitData) return;

    if (ev.projectile.typeId !== "2913:detect") return;
    if (hitData.entity.typeId !== "2913:dummy") return;
    if (hitData.entity.hasTag("used")) return;

    const inventory = ev.source.getComponent("minecraft:inventory");
    const item = inventory.container.getItem(ev.source.selectedSlot);

    if (item.typeId === "2913:ghost" && hitData.entity.nameTag === "soul") {
        ev.source.runCommandAsync("scoreboard players set @s reyna_ghost 0");
        hitData.entity.runCommandAsync(`event entity @s despawn`);
        ev.projectile.runCommandAsync(`event entity @s despawn`);
    }

    if (item.typeId === "2913:reyna_heal" && hitData.entity.nameTag === "soul") {
        ev.source.runCommandAsync("scoreboard players set @s reyna_heal 0");
        ev.source.runCommandAsync("playsound reyna.heal2 @s ~ ~ ~");
        ev.source.runCommandAsync("playanimation @s animation.reyna.heal");
        hitData.entity.runCommandAsync("scoreboard players set @s tick 20");
        hitData.entity.addTag(`used`);
        hitData.entity.addTag(`reynaHeal_"${ev.source.name}"`);
        ev.projectile.runCommandAsync(`event entity @s despawn`);
    }
});

system.runInterval(() => {
    const healPlayer = getTagPlayers("reyna_heal");
    healPlayer.forEach((v) => {
        if (v.hasTag("reyna_super")) return;
        const soul = getTagEntities(`reynaHeal_"${v.name}"`);
        if (soul.length < 1) return;

        const pos = JSON.parse(JSON.stringify(soul[0].location));
        pos.y -= 1;
        asLine(pos, [v.location], 50, 0, 2.5, 1, (x, y, z) => {
            v.runCommandAsync(`particle 2913:dark_small ${x} ${y} ${z}`);
        }, () => {
            v.runCommandAsync('scoreboard players set @s reyna_heal 0');
        });
    });
});