import { world, EntityDamageCause, Player, MinecraftEffectTypes } from "@minecraft/server";
import { getTagEntities, getScore, getTagPlayers, asLine } from "./api.js";

const overworld = world.getDimension("minecraft:overworld");

world.events.projectileHit.subscribe(ev => {
    if (!ev.entityHit) return;

    if (ev.projectile.typeId !== "2913:bullet") return;

    const inventory = ev.source.getComponent("minecraft:inventory");
    const item = inventory.container.getItem(ev.source.selectedSlot);

    const diff = ev.location.y - ev.entityHit.entity.location.y;

    let head = false;
    if (diff > 1.46) head = true;

    if (ev.entityHit.entity.hasTag("ghost")) return;

    if (head) {
        ev.source.addTag("headshot");
        ev.source.runCommandAsync(`playsound effect.headshot @s ~ ~ ~`);
    }
    else if (ev.source.hasTag("headshot")) ev.source.removeTag("headshot");

    ev.entityHit.entity.addTag(item.typeId + ev.source.nameTag);
    let result;

    if (item.typeId === "2913:vandal") {
        if (head) {
            ev.entityHit.entity.runCommandAsync(`scoreboard players remove @s health 150`);
        }
        else ev.entityHit.entity.runCommandAsync(`scoreboard players remove @s health 40`);
    }

    ev.entityHit.entity.runCommandAsync(`execute as @s[scores={health=..0}] as "${ev.source.name}" at @s run function check_kill`);
    ev.entityHit.entity.runCommandAsync(`execute at @s[scores={health=..0}] as @p[name="${ev.source.name}",scores={agent=1}] run summon 2913:dummy "soul" ~ ~1 ~`);
    ev.entityHit.entity.runCommandAsync(`execute as @s[scores={health=..0},type=!2913:dummy] as @p[name="${ev.source.name}",tag=reyna_super] at @s run scoreboard players set @s reyna_heal 0`);
    ev.entityHit.entity.runCommandAsync(`execute as @s[scores={health=..0},type=!2913:dummy] as @p[name="${ev.source.name}",tag=reyna_super] at @s run scoreboard players set @s reyna_super 1`);
    ev.entityHit.entity.runCommandAsync(`execute as @s[scores={health=..0},type=!2913:dummy] as @p[name="${ev.source.name}",tag=reyna_super] at @s run playsound reyna.heal2 @s ~ ~ ~`);
    ev.entityHit.entity.runCommandAsync(`kill @s[scores={health=..0},type=!player,type=!2913:dummy]`);
    ev.entityHit.entity.runCommandAsync(`event entity @s[scores={health=..0},tag=damagable,type=2913:dummy] despawn`);
});

world.events.projectileHit.subscribe(ev => {
    if (!ev.entityHit) return;

    if (ev.projectile.typeId !== "2913:detect") return;
    if (ev.entityHit.entity.typeId !== "2913:dummy") return;
    if (ev.entityHit.entity.hasTag("used")) return;

    const inventory = ev.source.getComponent("minecraft:inventory");
    const item = inventory.container.getItem(ev.source.selectedSlot);

    if (item.typeId === "2913:ghost" && ev.entityHit.entity.nameTag === "soul") {
        ev.source.runCommandAsync("scoreboard players set @s reyna_ghost 0");
        ev.entityHit.entity.runCommandAsync(`event entity @s despawn`);
        ev.projectile.runCommandAsync(`event entity @s despawn`);
    }

    if (item.typeId === "2913:reyna_heal" && ev.entityHit.entity.nameTag === "soul") {
        ev.source.runCommandAsync("scoreboard players set @s reyna_heal 0");
        ev.source.runCommandAsync("playsound reyna.heal2 @s ~ ~ ~");
        ev.source.runCommandAsync("playanimation @s animation.reyna.heal");
        ev.entityHit.entity.runCommandAsync("scoreboard players set @s tick 20");
        ev.entityHit.entity.addTag(`used`);
        ev.entityHit.entity.addTag(`reynaHeal_"${ev.source.name}"`);
        ev.projectile.runCommandAsync(`event entity @s despawn`);
    }
});

world.events.tick.subscribe(ev => {
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