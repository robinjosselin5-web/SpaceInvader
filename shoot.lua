-- =====================================================
-- Fonction utilitaire interne
-- Clamp : force une valeur à rester entre min et max
-- Utilisée pour la collision cercle / rectangle
-- =====================================================
function clamp(value, min, max)
    if value < min then 
        return min
    elseif value > max then 
        return max 
    else 
        return value 
    end
end

Shoot = {}
Shoot.__index = Shoot

local SPEED = 400
local SIZE = 3

function Shoot:loadAssets(assets)
    Img = {}
    Img.w = 16
    Img.h = 16
    Img.assets = assets
    local sw, sh = assets:getDimensions()
    Img.quad = love.graphics.newQuad(32,32, Img.w, Img.h, sw, sh)
end

function Shoot:new(player)

    local instance = setmetatable({}, Shoot)

    instance.x = player.x + player.w/2
    instance.y = player.y
    instance.radius = SIZE
    instance.speed = SPEED

    return instance
end

function Shoot:update(dt)

    self.y = self.y - self.speed * dt
        
end

function Shoot:checkCollision(object)     

    -- On trouve le point du rectangle le plus proche
    -- du centre du cercle
    local closestX = clamp(self.x, object.x, object.x + object.hitBoxW)
    local closestY = clamp(self.y, object.y, object.y + object.hitBoxH)

    -- Vecteur entre le centre du cercle
    -- et ce point
    local dx = self.x - closestX
    local dy = self.y - closestY

    -- Collision si distance² <= rayon²
    if dx * dx + dy * dy <= self.radius * self.radius then
        return true
    end
end

function Shoot:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Img.assets, Img.quad, self.x - Img.w/2, self.y)
end

return Shoot
