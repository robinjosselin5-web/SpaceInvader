-- pause.lua
local Pause = {}
Pause.__index = Pause

function Pause:new(game)
    local instance = setmetatable({}, Pause)
    instance.game = game -- on garde la référence du jeu en cours
    return instance
end

function Pause:update(dt)
    -- On ne met PAS game:update(dt)
    -- Donc tout est gelé
end

function Pause:draw()

    -- On dessine le jeu en arrière-plan
    self.game:draw()

    -- Overlay sombre
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)
     love.graphics.printf(
        "PAUSE",
        0,
        250,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "Appuyer sur P pour reprendre",
        0,
        280,
        love.graphics.getWidth(),
        "center"
    )
end

function Pause:keypressed(key)
    if key == "n" then
        changeState(require("game"):new())
    end

    if key == "p" then
        changeState(self.game) -- on retourne au jeu existant
    end

    if key == "escape" then
        love.event.quit()
    end
end

return Pause