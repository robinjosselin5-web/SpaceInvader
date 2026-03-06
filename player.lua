local Player = {}
Player.__index = Player


function Player:new(x, y, w, h, assets)
    local instance = setmetatable({}, Player)

    instance.x = x 
    instance.y = y
    instance.w = w
    instance.h = h
    instance.hitBoxW = (w * 0.4)
    instance.centerHitBoxW = (w - w * 0.4) / 2 + 1
    instance.hitBoxH = (h * 0.6)
    instance.centerHitBoxH = (h - h * 0.6) / 2

    instance.speed = 300
    instance.directionX = 0
    instance.directionY = 0

    instance.assets = assets
    local sw, sh = assets:getDimensions()
    instance.quad = love.graphics.newQuad(64, 0, 16, 16, sw, sh)

    return instance
end

function Player:update(dt, dx, dy)
    

    -- Gestion mouvement player
    local u = math.sqrt(dx * dx + dy * dy)
    if u > 0 then
        dx = dx / u
        dy = dy / u
    end

    self.x = self.x + dx * self.speed * dt
    self.y = self.y + dy * self.speed * dt

end

function Player:draw()
    love.graphics.draw(self.assets, self.quad, self.x, self.y, 0, 2, 2)  
    if debug then
        love.graphics.rectangle("line", self.x + self.centerHitBoxW, self.y + self.centerHitBoxH, self.hitBoxW, self.hitBoxH)
    end
end

return Player