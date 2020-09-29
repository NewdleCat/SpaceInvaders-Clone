require "particles"
require "enemy"
require "player"

love.graphics.setDefaultFilter('nearest', 'nearest')

------------------------------------------------------------------------------------
--                          COLLISIONS
------------------------------------------------------------------------------------

function checkCollisions(enemies, bullets)
    for i, e in ipairs(enemies) do
        for j, b in ipairs(bullets) do
            if b.y > e.y and b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
            -- if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
                particle_system:spawn(e.x, e.y)

                enemyBullets:enemyFire(e.x + e.width/2, e.y + e.height/2)

                temp = e.x

                table.remove(enemies, i)
                table.remove(bullets, j)

                love.audio.setVolume(0.2)

                -- love.audio.play(enemies_controller.death_sound)

                num = love.math.random(1, 3)
                if num == 1 then
                    love.audio.play(enemies_controller.moan1)
                elseif num == 2 then
                    love.audio.play(enemies_controller.moan2)
                elseif num ==3 then
                    love.audio.play(enemies_controller.moan3)
                end
            end
        end
    end
end

function checkPowerupCollisions()
    for i, p in ipairs(enemyBullets.list) do
        if p.y >= player.y and p.y <= player.y + player.height and p.x > player.x and p.x < player.x + player.width then
            table.remove(enemyBullets.list, i)

            player.lives = player.lives - 1
        end
    end
end
------------------------------------------------------------------------------------
--                          MAIN FUNCTIONS
------------------------------------------------------------------------------------
function love.load()
    love.window.setMode(1024,768)

    pos = 0
    wave = 0
    temp = false

    game_over = false
    game_win = false
    display_level_image = true
    enemy_go_left = false
    enemy_go_right = true
    enemy_fire_pause = 20

    key_buffer = false

    gameLevel = 1

    background_image = love.graphics.newImage('images/background.png')
    gameover_image = love.graphics.newImage('images/gameover.png')
    level1_image = love.graphics.newImage('images/level1.png')
    level2_image = love.graphics.newImage('images/level2.png')
    win_image = love.graphics.newImage('images/win.png')

    enemies_controller.image = love.graphics.newImage('images/sad.png')
    enemies_controller.death_sound = love.audio.newSource('sounds/thud1.wav', "static")
    enemies_controller.moan1 = love.audio.newSource('sounds/zachMoan1.wav', "static")
    enemies_controller.moan2 = love.audio.newSource('sounds/zachMoan2.wav', "static")
    enemies_controller.moan3 = love.audio.newSource('sounds/zachMoan3.wav', "static")

    particle_system.image = love.graphics.newImage('images/sad.png')

    player.fire_sound = love.audio.newSource('sounds/laser.wav', "static")
    player.image = love.graphics.newImage('images/P.png')
end

function love.update(dt)
    particle_system:update(dt)
    particle_system:cleaner()
    player.cooldown = player.cooldown - 1
    
    if love.keyboard.isDown("right") then
        player.x = player.x + 2
    elseif love.keyboard.isDown("left") then
        player.x = player.x - 2
    end

    if love.keyboard.isDown("a") then
        playerFire()
    end

    --Enemy Spawning
    -- spawnLevel(gameLevel, wave)
    -- moveEnemiesDown()
    pos = pos + 100*dt
    wave = pos + 100*dt

    -- ENEMY MOVEMENT
    enemyMovement(wave, gameLevel) -- enemy.lua

    -- win function
    if gameLevel == 3 then
        -- gameLevel = 0
        game_win = true
    end

    if gameLevel == 1 and love.keyboard.isDown("space") and key_buffer == false then
        display_level_image = false
        spawnLevel(gameLevel, wave)
    elseif gameLevel == 2 and love.keyboard.isDown("space") then
        display_level_image = false
        spawnLevel(gameLevel, wave)
    end


    if #enemies_controller.enemies == 0 and display_level_image == false and game_over == false then
        gameLevel = gameLevel + 1
        have_spawned = false
        enemy_go_left = false
        enemy_go_right = true
        display_level_image = true
    end

    --check lost
    for _,e in pairs(enemies_controller.enemies) do
        if e.y >= love.graphics.getHeight() then
            game_over = true
        end
    end

    if player.lives == 0 then
        game_over = true
    end

    -- BULLETS
    for i,b in ipairs(player.bullets) do
        if b.y < -10 then
            table.remove(player.bullets, i)
        end
        b.y = b.y - 5
    end

    -- POWERUPS
    for i,p in ipairs(enemyBullets.list) do
        if p.y > player.y + 100 then
            table.remove(enemyBullets.list, i)
        end
        p.y = p.y + 2
    end

    -- COLLISIONS
    checkCollisions(enemies_controller.enemies, player.bullets)
    checkPowerupCollisions(dt)


    for _,e in pairs(enemies_controller.enemies) do
        num = love.math.random(1, 500)
        if num == 5 and e.cooldown < 0 then
            enemyBullets:enemyFire(e.x + e.width/2, e.y + e.height/2)
            e.cooldown = 800
        end
        e.cooldown = e.cooldown - 1
    end

    --GAME RESET
    if game_over == true then
        enemies_controller:clearEnemies()
        if love.keyboard.isDown("space") then
            enemies_controller:clearEnemies()
            -- enemies_controller:clearEnemies()
            gameLevel = 1
            have_spawned = false
            game_over = false
            player.lives = 3
            enemy_go_left = false
            enemy_go_right = true
            display_level_image = true
            -- spawnLevel(gameLevel, wave)
        end
    end

    if love.keyboard.isDown("space") then
        key_buffer = true
    else
        key_buffer = false
    end

end

function love.draw()
    -- love.graphics.draw(background_image)
    if game_over == true then
        -- love.graphics.print("GAME OVER", 150, 300, 0, 10)
        love.graphics.draw(gameover_image)
        -- return
    elseif game_win == true then
        -- love.graphics.print("WIIIIIIIIN")
        love.graphics.draw(win_image)
        -- return
    end

    if gameLevel == 1 and display_level_image == true then
        love.graphics.draw(level1_image)
    elseif gameLevel == 2 and display_level_image == true then
        love.graphics.draw(level2_image)
    end

    love.graphics.print(#enemies_controller.enemies, 100, 100)

    particle_system:draw() -- PARTICLE SYSTEM

    love.graphics.print(player.lives, player.x - 80, player.y - 30)

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", player.x + 25, player.y, 2, -1000)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 0, 1, 1000)
    love.graphics.rectangle("fill", 1014, 0, 1, 1000)

    love.graphics.setColor(1, 1, 1)
    for _,v in pairs(player.bullets) do
        love.graphics.rectangle("fill", v.x, v.y, 10, 10)
    end

    --PLAYER SPAWN
    -- love.graphics.rectangle("fill", player.x, player.y, 2, 2)
    love.graphics.draw(player.image, player.x, player.y, 0, 1)

    love.graphics.setColor(1, 1, 1)
    for _,e in pairs(enemies_controller.enemies) do -- ENEMY SPAWNER
        love.graphics.draw(enemies_controller.image, e.x, e.y, 0, 1)
    end

    love.graphics.setColor(1, 0, 0)
    for _,p in pairs(enemyBullets.list) do
        love.graphics.rectangle("fill", p.x, p.y, 10, 10)
    end

    love.graphics.setColor(1, 1, 1)
end
