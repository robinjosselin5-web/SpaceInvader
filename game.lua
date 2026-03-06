local Game = {}
Game.__index = Game

-- DEBUG
debug = true

-- Import des classes
local Background = require('background')
local Player = require('player')
local Shoot = require("shoot")
local Fleet = require("fleet")

-- Load assets
local assets = love.graphics.newImage("assets/SpaceInvaders.png")

PlayerAssets = assets
local sw, sh = assets:getDimensions()
PlayerQuad = love.graphics.newQuad(64, 0, 16, 16, sw, sh)
logoImage = love.graphics.newImage("assets/SpaceInvaders_LogoMedium.png")

-- Variable Player
local PLAYERWIDTH = 32
local dx, dy = 0, 0

function Game:new()

    -- gestion assets
    Background:loadAssets()
    Background = Background:new()
    Shoot:loadAssets(assets)
    PixelFont = love.graphics.newFont("assets/font/Pixel2.ttf", 14)

    -- Création de l'instance Game
    local instance = setmetatable({}, Game)
    
    
    -- Player
    instance.player = Player:new(love.graphics.getWidth() / 2 - 8, love.graphics.getHeight() - 180, PLAYERWIDTH, 32, assets)
    instance.life = 3
    instance.score = 0
    instance.wave = 1
    print('success import Player')

    -- Shoot
    instance.shoot = {}
    print('success import shoot')

    -- Fleet enemy
    instance.fleet = Fleet:new(assets)
    print('success import fleet enemy')

    return instance
end

function Game:update(dt)

    -- ================= PLAYER ==================

    -- MOUVEMENT

    -- Limite screen X
    if self.player.x - self.player.centerHitBoxW >= love.graphics.getWidth() - PLAYERWIDTH then
        self.player.x = love.graphics.getWidth() - PLAYERWIDTH + self.player.centerHitBoxW
    end
    if self.player.x + self.player.centerHitBoxW < 0 then
        self.player.x = 0 - self.player.centerHitBoxW 
    end
    -- Limite screen Y
    if self.player.y > love.graphics.getHeight() - PLAYERWIDTH + self.player.centerHitBoxH then
        self.player.y = love.graphics.getHeight() - PLAYERWIDTH + self.player.centerHitBoxH
    end
    if self.player.y + self.player.centerHitBoxH < 0 then
        self.player.y = 0 - self.player.centerHitBoxH
    end

    -- Input mouvement sur X
    if love.keyboard.isDown("d") then
        dx = 1
    elseif love.keyboard.isDown("q") then
        dx = -1
    else
        dx = 0
    end

    -- Input mouvement sur Y
    if love.keyboard.isDown("z") then
        dy = -1
    elseif love.keyboard.isDown("s") then
        dy = 1
    else
        dy = 0
    end

    -- Gameover 
    if self.life <= 0 then
        changeState(require("gameover"):new(self))
    end

    self.player:update(dt, dx, dy)

    -- ================= SHOOT ===================

    for i = #self.shoot, 1, -1 do

        self.shoot[i]:update(dt)

        for a = #self.fleet.enemies, 1, -1 do
            local enemy = self.fleet.enemies[a]

            if self.shoot[i]:checkCollision(enemy) then
                table.remove(self.fleet.enemies, a)
                table.remove(self.shoot, i)
                self.score = self.score + 1

                break -- IMPORTANT CAR C'EST LE BUG QUI ARRIVE DE TEMPS EN TEMPS
            end
            if self.shoot[i].y < 0 then
                table.remove(self.shoot, i)
                break
            end
        end


    end

    -- =============== FLEET ENEMY ===============
    self.fleet:update(dt)

    if #self.fleet.enemies == 0 then
        changeState(require("victory"):new(self))
    end

    -- =============== COLLISION PLAY/ENEMY ===============
    for i = #self.fleet.enemies, 1, -1 do
        if checkCollisionPlayer(self.player, self.fleet.enemies[i]) then

            table.remove(self.fleet.enemies, i)
            self.life = self.life - 1
            print('Life : '..self.life)
            break
        end
    end
    
    Background:update(dt)
    -- ================= QUITTER =================
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
end

function Game:draw()

    
    -- DRAW BACKGROUND
    Background:draw()

    -- UI 
    -- Rectangle (top)
    love.graphics.setColor(0,0.16,0.25,1)
    love.graphics.rectangle("fill", 52, 32, love.graphics.getWidth() - 104, 66)
    
    -- Border of rectangle (top)
    love.graphics.setColor(0.37,0.50,0.34,1)
    love.graphics.rectangle("line", 50, 30, love.graphics.getWidth() - 100, 70)

    love.graphics.setColor(0.95,1,0.74,1)
    love.graphics.rectangle("line", 52, 32, love.graphics.getWidth() - 104, 66)

    love.graphics.setColor(0.37,0.50,0.34,1)
    love.graphics.rectangle("line", 54, 34, love.graphics.getWidth() - 108, 62)

    love.graphics.setColor(0.95,1,0.74,1)
    love.graphics.setFont(PixelFont)
    love.graphics.print("lives", 68, 38)

    for i = 1, self.life do
        love.graphics.draw(PlayerAssets, PlayerQuad, 26 + 26 * i, 56, 0, 2, 2)
    end


    love.graphics.print("Score : "..self.score, love.graphics.getWidth() - 180, 38)
    love.graphics.print("Wave : "..self.wave, love.graphics.getWidth() - 180, 56)
    love.graphics.print("Coins : ", love.graphics.getWidth() - 180, 74)

    love.graphics.setColor(1,1,1,0.5)
    love.graphics.draw(logoImage, (love.graphics.getWidth() - logoImage:getWidth()) / 2, 85)
    love.graphics.setColor(1,1,1,1)

    -- DRAW PLAYER
    self.player:draw()

    -- DRAW SHOOT
    for _, shoot in ipairs(self.shoot) do
        shoot:draw()
    end

    -- DRAW FLEET
    self.fleet:draw()


end

function Game:keypressed(key)

    -- ================= SHOOT =================
    if key == "space" then
        table.insert(self.shoot, Shoot:new(self.player))
    end

    -- ================= DEBUG =================
    if key == "f12" then
        if debug == false then
            debug = true
        elseif debug == true then
            debug = false
        end
    end

    -- Pause
    if key == "p" then
        changeState(require("pause"):new(self))
    end
end

----------------------------------------------------------------
-- COLLISION AABB (RECTANGLE / RECTANGLE)
----------------------------------------------------------------
function checkCollisionPlayer(a, b)

    if a.x + a.centerHitBoxW + a.hitBoxW < b.x + b.centerHitBoxW then return false end
    if a.x + a.centerHitBoxW > b.x + b.centerHitBoxW + b.hitBoxW then return false end
    if a.y + a.centerHitBoxH + a.hitBoxH < b.y + b.centerHitBoxH then return false end
    if a.y + a.centerHitBoxH > b.y + b.centerHitBoxH + b.hitBoxH then return false end

    return true
end


return Game