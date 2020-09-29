player = {}
player.x = 500
player.y = 700
player.width = 60
player.height = 60
player.speed = 8
player.shootMode = "normal"
player.powerupCooldown = 0
player.bullets = {}
player.cooldown = 0
player.lives = 3


function playerFire()
    if player.cooldown <= 0 then
        love.audio.play(player.fire_sound)
        player.cooldown = 60
        bullet = {}
        bullet.x = player.x + 21
        bullet.y = player.y
        table.insert(player.bullets, bullet)
    end
end
