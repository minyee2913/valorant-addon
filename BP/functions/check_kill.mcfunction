scoreboard players add @s kill 1
execute as @s[scores={kill=1}] run playsound effect.kill_default @s ~ ~ ~ 0.5
execute as @s[scores={kill=2}] run playsound effect.kill_default @s ~ ~ ~ 0.5 1.1
execute as @s[scores={kill=3}] run playsound effect.kill3 @s ~ ~ ~
execute as @s[scores={kill=4}] run playsound effect.kill4 @s ~ ~ ~
execute as @s[scores={kill=5..}] run playsound effect.kill_ace @s ~ ~ ~

scoreboard players set @s[tag=killIcon] killIcon 0
tag @s add killIcon