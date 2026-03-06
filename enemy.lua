local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, assets)

    local instance = setmetatable({}, Enemy)

    instance.x = x
    instance.y = y
    instance.w = 32
    instance.h = 32
    instance.hitBoxW = 32 * 0.8
    instance.centerHitBoxW = (32 - 32 * 0.8) / 2
    instance.hitBoxH = 32 * 0.4
    instance.centerHitBoxH = (32 - 32 * 0.4) / 2

    instance.assets = assets
    local sw, sh = assets:getDimensions()
    instance.quad = love.graphics.newQuad(0, 0, 16, 16, sw, sh)

    return instance
end

function Enemy:draw()
    love.graphics.draw(self.assets, self.quad, self.x, self.y, 0, 2, 2)
    if debug then
        love.graphics.rectangle("line", self.x + self.centerHitBoxW, self.y + self.centerHitBoxH, self.hitBoxW, self.hitBoxH)
    end
end

return Enemy