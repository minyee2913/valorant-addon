scoreboard players add @s spray 2
scoreboard players add @s delay 1

event entity @s[scores={delay=1}] 2913:bullet_default
execute as @s[scores={delay=1}] at @s run playanimation @s animation.vandal.shoot
execute as @s[scores={delay=1}] at @s run playsound vandal.shoot @a[r=20] ~ ~ ~
execute as @s[scores={delay=1,spray=..6}] at @s run tp ~ ~ ~ ~ ~-0.3
execute as @s[scores={delay=1,spray=7..}] at @s run tp ~ ~ ~ ~ ~-1
scoreboard players set @s[scores={delay=2..}] delay 0