local currentState

function love.load()
    love.window.setMode(448, 704, {resizable=false, vsync=0, minwidth=448, minheight=704})
    love.graphics.setDefaultFilter("nearest", "nearest")
    currentState = require("menu"):new()
end

function love.update(dt)
    currentState:update(dt)
end

function love.draw()
    currentState:draw()
end

function love.keypressed(key)
    if currentState.keypressed then
        currentState:keypressed(key)
    end
end

function changeState(newState)
    currentState = newState
end




