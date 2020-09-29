particle_system = {}
particle_system.list = {}

function particle_system:spawn(x, y)
    local ps = {}
    ps.x = x
    ps.y = y
    ps.stopped = false
    ps.timer = 100
    ps.delete_timer = 200
    ps.ps = love.graphics.newParticleSystem(particle_system.image, 32)
    ps.ps:setParticleLifetime(0.18, 0.18)
    -- ps.ps:setParticleLifetime(1, 1)
    ps.ps:setEmissionRate(30)
    ps.ps:setSizes(0.3)
    ps.ps:setLinearAcceleration(-10000, -10000, 10000, 10000)
    -- ps.ps:setEmissionArea("uniform", 0, 0, 0, false)
    -- ps.ps:setRadialAcceleration(5000)
    ps.ps:setSpeed(10)
    ps.ps:setColors(1, 1, 1, 1)
    -- ps.ps:setSpread(10)
    ps.ps:setAreaSpread("uniform", 10, 10)
    table.insert(particle_system.list, ps)
    table.insert(particle_system.list, ps)
    table.insert(particle_system.list, ps)
end

function particle_system:draw()
    for _, v in pairs(particle_system.list) do
        love.graphics.draw(v.ps, v.x + 30, v.y + 30)
    end
end

function particle_system:update(dt)
    for _, v in pairs(particle_system.list) do
        v.timer = v.timer - 1

        if v.timer <= 0 then
            v.delete_timer = v.delete_timer - 1
        end

        v.ps:update(dt)
    end
end

function particle_system:cleaner()
    for i, v in ipairs(particle_system.list) do
        if v.timer <= 0 then
            -- table.remove(particle_system.list, i)
            -- v.ps:setSpeed(10)
            v.ps:stop()
        end

        if v.delete_timer <= 0 then
            table.remove(particle_system.list, i)
        end
    end
end
