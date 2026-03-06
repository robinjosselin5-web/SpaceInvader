Background = {}
Background.__index = Background

local imageWidth = 64
local imageHeight = 64
local scrollSpeed = 60

function Background.loadAssets()
    Background.imageTop = love.graphics.newImage("assets/SpaceInvaders_Background.png")
    Background.imageMiddle = love.graphics.newImage("assets/SpaceInvaders_BackgroundBuildings.png")
    Background.imageBottom = love.graphics.newImage("assets/SpaceInvaders_BackgroundFloor.png")
end

function Background:new()

    local instance = setmetatable({}, Background)

    instance.screenWidth = love.graphics.getWidth()
    instance.screenHeight = love.graphics.getHeight()  -- AJOUTER CETTE LIGNE

    instance.cols = math.ceil(instance.screenWidth / imageWidth)

    instance.tiles = {}

    instance.visibleRows = 8
    instance.bufferRows = 2
    instance.totalRows = instance.visibleRows + instance.bufferRows

    for y = 0, instance.totalRows - 1 do
        for x = 0, instance.cols - 1 do

            table.insert(instance.tiles,{
                x = x * imageWidth,
                y = (y - instance.bufferRows + 2) * imageHeight
            })

        end
    end

    return instance
end

function Background:update(dt)

    local recycleLimit = imageHeight * (self.visibleRows + 1)

    for _, tile in ipairs(self.tiles) do

        tile.y = tile.y + scrollSpeed * dt

        -- recycler seulement quand la tuile est vraiment sortie
        if tile.y >= recycleLimit then
            tile.y = tile.y - imageHeight * self.totalRows
        end

    end

end
function Background:draw()

    love.graphics.setColor(1,1,1,1)

    -- ciel qui défile
    for _,tile in ipairs(self.tiles) do
        love.graphics.draw(Background.imageTop, tile.x, tile.y)
    end

    -- bâtiments fixes
    for i = 0, self.cols-1 do
        love.graphics.draw(
            Background.imageMiddle,
            i * imageWidth,
            imageHeight * 8
        )
    end

    -- sol fixe
    for y = 9, math.ceil(self.screenHeight / imageHeight) + 2 do
        for i = 0, self.cols - 1 do
            love.graphics.draw(
                Background.imageBottom,
                i * imageWidth,
                y * imageHeight
            )
        end
    end

end

return Background