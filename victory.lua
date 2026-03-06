local Victory = {}
Victory.__index = Victory

local Background = require('background')
logoImage = love.graphics.newImage("assets/SpaceInvaders_LogoMedium.png")
PixelFont = love.graphics.newFont("assets/font/Pixel2.ttf", 14)

function Victory:new(game)

    Background:loadAssets()
    Background = Background:new()

    local instance = setmetatable({}, Victory)

    instance.game = game

    return instance
end

function Victory:update(dt)
end

function Victory:draw()
    Background:draw()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(logoImage, (love.graphics.getWidth() - logoImage:getWidth()) / 2, 85)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(
        "WIN",
        0,
        200,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "SCORE : " .. self.game.score,
        0,
        250,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "Appuie sur Enter pour rejouer",
        0,
        300,
        love.graphics.getWidth(),
        "center"
    )

end

function Victory:keypressed(key)
    if key == "return" then
        changeState(require("game"):new())
    end
    if key == "escape" then
        love.event.quit()
    end
end

return Victory