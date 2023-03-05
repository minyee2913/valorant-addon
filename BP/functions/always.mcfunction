scoreboard objectives add spray dummy
scoreboard objectives add delay dummy
scoreboard objectives add kill dummy
scoreboard objectives add health dummy
scoreboard objectives add killIcon dummy
scoreboard objectives add death dummy
scoreboard objectives add lifetime dummy
scoreboard objectives add tick dummy
scoreboard objectives add tick2 dummy
scoreboard objectives add tick3 dummy
scoreboard objectives add team dummy

scoreboard players remove @a[scores={spray=1..}] spray 1

scoreboard players set @e[type=armor_stand,tag=!health] health 150
tag @e[type=armor_stand,tag=!health] add health

scoreboard players set @a[tag=!health] health 150
tag @a[tag=!health] add health

scoreboard players add @a[tag=killIcon] killIcon 1
title @a[scores={killIcon=1},tag=!headshot] actionbar kill
title @a[scores={killIcon=1},tag=headshot] actionbar HEADSHOT
title @a[scores={killIcon=30..}] actionbar §l
tag @a[scores={killIcon=30..},tag=headshot] remove headshot
tag @a[scores={killIcon=30..}] remove killIcon
scoreboard players reset @a[tag=!killIcon] killIcon

execute as @a[scores={health=..0}] at @s run gamemode spectator
execute as @a[scores={health=..0}] at @s run title @s title §l
execute as @a[scores={health=..0}] at @s run title @s subtitle §l§e디졌다.
execute as @a[scores={health=..0}] at @s run playsound random.hurt @s
execute as @a[scores={health=..0}] at @s run scoreboard players reset @s kill
execute as @a[scores={health=..0}] at @s run tag @s add death
execute as @a[scores={health=..0}] at @s run scoreboard players set @s health 150

scoreboard players add @a[tag=death] death 1
gamemode 2 @a[scores={death=60..}]
effect @a[scores={death=60..}] instant_health 3 255 true
tag @a[scores={death=60..}] remove death
scoreboard players reset @a[tag=!death] death



#leer 14
scoreboard players add @a[tag=leer_shot] tick 1
execute as @a[tag=leer_shot,scores={tick=2}] at @s run playanimation @s animation.reyna.leer_shot
execute as @a[tag=leer_shot,scores={tick=1}] at @s run summon 2913:dummy "leer" ^ ^1 ^1
execute as @a[tag=leer_shot,scores={tick=1}] at @s run scoreboard players operation @e[r=1.5,c=1,tag=!teamed] team = @s team
execute as @a[tag=leer_shot,scores={tick=1}] at @s run tag @e[r=1.5,c=1,tag=!teamed] add teamed
execute as @a[tag=leer_shot,scores={tick=1}] at @s run summon 2913:dummy "leer_target" ^ ^1 ^5
execute as @a[tag=leer_shot,scores={tick=1}] at @s run playsound reyna.leer_shot @a[r=20] ~ ~ ~
execute as @a[tag=leer_shot,scores={tick=20..}] at @s run playanimation @s animation.reyna.leer * 10000000
execute as @a[tag=leer_shot,scores={tick=20..}] at @s run playsound reyna.leer_on @s ~ ~ ~
execute as @a[tag=leer_shot,scores={tick=20..}] at @s run tag @s remove leer_shot

scoreboard players add @e[type=2913:dummy,name="leer"] lifetime 1
scoreboard players add @e[type=2913:dummy,name="leer"] tick 1
scoreboard players add @e[type=2913:dummy,name="leer_target"] lifetime 1
execute as @e[type=2913:dummy,name="leer",scores={lifetime=..10}] at @s run particle 2913:reyna_leer_on ~ ~ ~
execute as @e[type=2913:dummy,name="leer",scores={lifetime=10..,tick=10..}] at @s run particle 2913:reyna_leer ~ ~ ~
scoreboard players set @e[type=2913:dummy,name="leer",scores={lifetime=10..,tick=10..}] tick 0

execute as @e[type=2913:dummy,name="leer",scores={lifetime=10..,team=1}] at @s run scoreboard players set @a[scores={team=2},r=6] leer_hide 0
execute as @e[type=2913:dummy,name="leer",scores={lifetime=10..,team=2}] at @s run scoreboard players set @a[scores={team=1},r=6] leer_hide 0
execute as @e[type=2913:dummy,name="leer",scores={lifetime=..15}] at @s run tp ^ ^ ^0.6 facing @e[c=1,type=2913:dummy,name="leer_target",r=5]
execute as @e[type=2913:dummy,name="leer"] at @s run event entity @e[c=1,type=2913:dummy,name="leer_target",r=0.7] despawn
event entity @e[type=2913:dummy,name="leer_target",scores={lifetime=20..}] despawn
event entity @e[type=2913:dummy,name="leer",scores={lifetime=60..}] despawn

scoreboard objectives add leer_hide dummy
scoreboard players add @a[scores={leer_hide=0..}] leer_hide 1
fog @a[scores={leer_hide=..2}] push 2913:leer leer
fog @a[scores={leer_hide=3..}] remove leer
scoreboard players reset @a[scores={leer_hide=3..}] leer_hide

scoreboard objectives add reyna_ghost dummy
scoreboard players add @a[scores={reyna_ghost=0..}] reyna_ghost 1
execute as @a[scores={reyna_ghost=1}] at @s run playsound reyna.ghost @a[r=25] ~ ~ ~
execute as @a[scores={reyna_ghost=1}] at @s run playanimation @s animation.reyna.ghost
execute as @a[scores={reyna_ghost=1},tag=reyna_super] at @s run particle 2913:dark_dusts ~ ~1 ~
effect @a[scores={reyna_ghost=1..43}] speed 1 1 true
effect @a[scores={reyna_ghost=1..43},tag=reyna_super] invisibility 1 255 true
tag @a[scores={reyna_ghost=1..}] add ghost
tag @a[scores={reyna_ghost=44..}] remove ghost
camerashake add @a[scores={reyna_ghost=3}] 4 0.05 positional
event entity @a[scores={reyna_ghost=3}] become_ghost
event entity @a[scores={reyna_ghost=44..}] become_default
camerashake add @a[scores={reyna_ghost=44..}] 3 0.05 positional
effect @a[scores={reyna_ghost=44..}] speed 0 0 true
effect @a[scores={reyna_ghost=44..},tag=reyna_super] invisibility 0 0 true
execute as @a[scores={reyna_ghost=44..}] at @s run playanimation @s animation.reyna.ghostend
scoreboard players reset @a[scores={reyna_ghost=44..}] reyna_ghost

scoreboard players add @e[type=2913:dummy,name="soul"] tick 1
execute as @e[type=2913:dummy,name="soul"] at @s run particle 2913:dark_dusts ~ ~ ~
event entity @e[type=2913:dummy,name="soul",scores={tick=80..}] despawn

scoreboard objectives add reyna_heal dummy
scoreboard players add @a[scores={reyna_heal=0..}] reyna_heal 1
scoreboard players add @a[scores={reyna_heal=0..,health=..149}] health 2
tag @a[scores={reyna_heal=0..}] add reyna_heal
tag @a[scores={reyna_heal=3..},tag=!reyna_super] remove reyna_heal
scoreboard players reset @a[scores={reyna_heal=3..},tag=!reyna_super] reyna_heal

tag @a[scores={reyna_heal=60..},tag=reyna_super] remove reyna_heal
scoreboard players reset @a[scores={reyna_heal=60..},tag=reyna_super] reyna_heal

scoreboard objectives add reyna_super dummy
scoreboard players add @a[tag=reyna_super] reyna_super 1
execute as @a[scores={reyna_super=1}] at @s run playsound reyna.super @s ~ ~ ~
execute as @a[scores={reyna_super=1}] at @s run playanimation @s animation.reyna.super
execute as @a[scores={reyna_super=1}] at @s positioned ^ ^ ^0.4 run function reyna_super
execute as @a[scores={reyna_super=1..},tag=!ghost] at @s run function reyna_super
tag @a[scores={reyna_super=600..},tag=reyna_super] remove reyna_super
scoreboard players reset @a[scores={reyna_super=0..},tag=!reyna_super] reyna_super

execute as @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand},tag=!jett_smoking] at @s run summon 2913:dummy "jett_smoke" ~ ~1 ~
execute as @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand},tag=!jett_smoking] at @s run summon 2913:dummy "jett_target" ~ ~ ~

execute as @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand},tag=!jett_smoking,scores={team=1}] at @s run tag @e[r=2,type=2913:dummy,name="jett_smoke"] add team1
execute as @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand},tag=!jett_smoking,scores={team=1}] at @s run tag @e[r=2,type=2913:dummy,name="jett_target"] add team1
execute as @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand},tag=!jett_smoking,scores={team=2}] at @s run tag @e[r=2,type=2913:dummy,name="jett_smoke"] add team2
execute as @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand},tag=!jett_smoking,scores={team=2}] at @s run tag @e[r=2,type=2913:dummy,name="jett_target"] add team2
tag @a remove jett_smoking
tag @a[hasitem={item=2913:jett_smoke,location=slot.weapon.mainhand}] add jett_smoking

execute as @a[tag=jett_smoking,scores={team=1}] at @s run tp @e[type=2913:dummy,name="jett_target",tag=team1] ^ ^ ^30
execute as @a[tag=jett_smoking,scores={team=2}] at @s run tp @e[type=2913:dummy,name="jett_target",tag=team2] ^ ^ ^30

execute as @e[type=2913:dummy,name="jett_target",tag=team1] at @s unless entity @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team1] run event entity @s despawn
execute as @e[type=2913:dummy,name="jett_target",tag=team2] at @s unless entity @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team2] run event entity @s despawn


execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team1,scores={tick2=..9}] at @s if entity @e[type=2913:dummy,name="jett_target",tag=team1] run tp ^ ^ ^1 facing @e[type=2913:dummy,name="jett_target",tag=team1,c=1,scores={tick=..9}]
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team2,scores={tick2=..9}] at @s if entity @e[type=2913:dummy,name="jett_target",tag=team2] run tp ^ ^ ^1 facing @e[type=2913:dummy,name="jett_target",tag=team2,c=1,scores={tick=..9}]

execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team1,scores={tick2=10..}] at @s if entity @e[type=2913:dummy,name="jett_target",tag=team1] run tp ^ ^ ^1 facing @e[type=2913:dummy,name="jett_target",tag=team1,c=1,scores={tick=10..}]
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team2,scores={tick2=10..}] at @s if entity @e[type=2913:dummy,name="jett_target",tag=team2] run tp ^ ^ ^1 facing @e[type=2913:dummy,name="jett_target",tag=team2,c=1,scores={tick=10..}]

execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team1] at @s unless entity @e[type=2913:dummy,name="jett_target",tag=team1] run tag @s add free
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team2] at @s unless entity @e[type=2913:dummy,name="jett_target",tag=team2] run tag @s add free
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team1] at @s unless entity @e[type=2913:dummy,name="jett_target",tag=team1] run tp ^ ^ ^1
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed,tag=team2] at @s unless entity @e[type=2913:dummy,name="jett_target",tag=team2] run tp ^ ^ ^1
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed] at @s run particle 2913:white_dusts ~ ~ ~
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed] at @s unless block ^ ^ ^0.4 air run tag @s add placed
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed] at @s unless block ~ ~ ~-0.4 air run tag @s add placed
execute as @e[type=2913:dummy,name="jett_smoke",tag=!placed] at @s unless block ~ ~ ~ air run tag @s add placed

execute as @e[type=2913:dummy,name="jett_smoke",tag=placed] at @s run particle 2913:jett_smoke ~ ~ ~
execute as @e[type=2913:dummy,name="jett_smoke",tag=placed] at @s run particle 2913:jett_smoke_sphere ~ ~ ~

scoreboard players add @e[type=2913:dummy,name="jett_target"] tick 1
scoreboard players add @e[type=2913:dummy,name="jett_smoke",tag=placed] tick 1
scoreboard players add @e[type=2913:dummy,name="jett_smoke",tag=!placed] tick2 1
event entity @e[type=2913:dummy,name="jett_target",scores={tick=150..}] despawn
event entity @e[type=2913:dummy,name="jett_smoke",tag=placed,scores={tick=90..}] despawn
event entity @e[type=2913:dummy,name="jett_smoke",tag=!placed,scores={tick2=150..}] despawn