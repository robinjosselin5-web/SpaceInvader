-- menu.lua
local Menu = {}
Menu.__index = Menu

local Background = require('background')
logoImage = love.graphics.newImage("assets/SpaceInvaders_LogoMedium.png")
PixelFont = love.graphics.newFont("assets/font/Pixel2.ttf", 14)

function Menu:new()

    Background:loadAssets()
    Background = Background:new()

    return setmetatable({}, Menu)
end

function Menu:update(dt)
    Background:update(dt)
end

function Menu:draw()
    
    Background:draw()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(logoImage, (love.graphics.getWidth() - logoImage:getWidth()) / 2, 85)
    love.graphics.setColor(1,1,1,1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(PixelFont)
    love.graphics.printf(
        "MENU",
        0,
        250,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "Enter pour jouer",
        0,
        280,
        love.graphics.getWidth(),
        "center"
    )

end

function Menu:keypressed(key)
    if key == "return" then
        changeState(require("game"):new())
    end
    if key == "escape" then
        love.event.quit()
    end
end

return Menu