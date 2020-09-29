enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemyBullets = {}
enemyBullets.list = {}

have_spawned = false

-- function enemies_controller:spawnEnemy(x, y)
--     enemy = {}
--     enemy.x = x
--     enemy.y = y
--
--     enemy.width = 60
--     enemy.height = 60
--
--     enemy.bullets = {}
--     enemy.cooldown = 20
--     enemy.speed = 0.2
--     table.insert(self.enemies,enemy)
-- end

function lerp(a,b,t) 
    return a * (1-t) + b * t 
end

function quadin(a, b, t) 
    return lerp(a, b, t * t) 
end

function quad_in_out(a, b, t)
    if t <= 0.5 then
        return quadin(a, b, t*2) - (b-a)/2 -- scale by 2/0.5
    else
        return quadin(a, b, (1 - t)*2) + (b-a)/2 -- reverse and offset by 0.5
    end
end

function enemyBullets:enemyFire(x, y)
    pup = {}
    pup.x = x
    pup.y = y
    table.insert(enemyBullets.list, pup)
end

function enemies_controller:spawnEnemy(x, y, ival)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.xBase = x
    enemy.yBase = y
    enemy.ival = ival

    enemy.width = 60
    enemy.height = 60
    enemy.cooldown = 1000

    enemy.bullets = {}
    enemy.speed = 0.2
    table.insert(self.enemies,enemy)
end

function enemies_controller:clearEnemies()

    while (#enemies_controller.enemies ~= 0) do
        for i,e in pairs(enemies_controller.enemies) do
            table.remove(enemies_controller.enemies, i)
        end
    end

end

function enemyMovement(wave, gameLevel)
    for _,e in pairs(enemies_controller.enemies) do
        if e.x + e.width >= 1014 then
            enemy_go_right = false
            enemy_go_left = true
            for _,e in pairs(enemies_controller.enemies) do
                e.y = e.y + 30
                e.x = e.x - 30
            end
        elseif e.x <= 10 then
            enemy_go_right = true
            enemy_go_left = false
            for _,e in pairs(enemies_controller.enemies) do
                e.y = e.y + 30
                e.x = e.x + 30
            end
        end

        if enemy_go_right == true then
            e.x = e.x + 1 * e.speed
        elseif enemy_go_left == true then
            e.x = e.x - 1 * e.speed
        end

        if gameLevel == 2 then
            e.x = e.xBase + math.cos((wave/120) - e.ival) * 100
            e.y = e.yBase + math.sin((wave/120) - e.ival) * 100

            e.x = e.x + 100 * e.speed
        end

    end
end

function moveEnemiesDown()
    for _,e in pairs (enemies_controller.enemies) do
        for i = 0, 400, 1 do
            if e.y < 200 then
                e.y = quad_in_out(e.y, e.y + 2, 0.5)

            end


        end
    end
end

function spawnLevel(gameLevel, wave)

    if gameLevel == 1 and have_spawned == false then
        -- enemies_controller:spawnEnemy(400, 400, 0)

        for i=0, 10, 1 do
            enemies_controller:spawnEnemy((i * 70) + 30, 100)
            enemies_controller:spawnEnemy((i * 70) + 30, 170)
        end
        have_spawned = true
    elseif gameLevel == 2 and have_spawned == false then
        -- for i = 0, 10 do
        for i = 0, 1100, 100 do
            enemies_controller:spawnEnemy(250 + math.cos((wave/120) - i)*100, 200 + math.sin((wave/120) - i)*100, i)
        end

        for i = 0, 1100, 100 do
            enemies_controller:spawnEnemy(450 + math.cos((wave/120) - i)*100, 200 + math.sin((wave/120) - i)*100, i)
        end

        for i = 0, 1100, 100 do
            enemies_controller:spawnEnemy(650 + math.cos((wave/120) - i)*100, 200 + math.sin((wave/120) - i)*100, i)
        end

        have_spawned = true
    end


end
