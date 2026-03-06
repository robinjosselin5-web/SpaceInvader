local isMoving = true

-- Création de la classe Fleet
-- Cette classe va gérer TOUTE la flotte d'ennemis
local Fleet = {}
Fleet.__index = Fleet

-- On importe la classe Enemy pour créer les ennemis
local Enemy = require("enemy")

-- ==============================
-- CONSTRUCTEUR
-- ==============================

function Fleet:new(assets)

    -- Création de l'objet Fleet
    local instance = setmetatable({}, Fleet)

    -- Tableau qui va contenir tous les ennemis
    instance.enemies = {}

    -- Direction de déplacement de la flotte
    -- 1 = droite
    -- -1 = gauche
    instance.direction = 1

    -- Timer pour contrôler la vitesse du mouvement
    instance.timer = 0

    -- Temps entre chaque déplacement
    instance.delay = 0.4

    -- Distance horizontale parcourue à chaque mouvement
    instance.step = 32

    -- Distance verticale lorsque la flotte descend
    instance.drop = 32

    -- ==============================
    -- CREATION DES ENNEMIS
    -- ==============================

    -- On crée une ligne de 10 ennemis
    for i = 1, 10 do
        for a = 1, 3 do
            -- table.insert ajoute un ennemi dans le tableau
            -- i * 32 espace les ennemis horizontalement
            table.insert(instance.enemies, Enemy:new(i * 32, 128 + (40 * a), assets))
        end
    end

    return instance
end


-- ==============================
-- UPDATE
-- ==============================

function Fleet:update(dt)

    if debug then
        return
    end

    -- On réduit le timer avec le temps écoulé
    self.timer = self.timer - dt

    -- Quand le timer atteint 0
    -- on déclenche un mouvement de la flotte
    if self.timer <= 0 then

        -- Variable qui indique si on touche un mur
        local hitWall = false

        -- On vérifie chaque ennemi
        for _, enemy in ipairs(self.enemies) do

            -- Position du prochain mouvement
            local nextX = enemy.x + self.step * self.direction

            -- Si le prochain mouvement dépasse l'écran
            if nextX < 0 or nextX + enemy.w > love.graphics.getWidth() then

                -- On signale qu'on touche un mur
                hitWall = true
                break
            end

        end


        -- ==============================
        -- SI ON TOUCHE UN MUR
        -- ==============================

        if hitWall then

            -- On inverse la direction
            self.direction = -self.direction

            -- Tous les ennemis descendent
            for _, enemy in ipairs(self.enemies) do
                enemy.y = enemy.y + self.drop
            end

        else

            -- ==============================
            -- SINON ON AVANCE NORMALEMENT
            -- ==============================

            for _, enemy in ipairs(self.enemies) do
                enemy.x = enemy.x + self.step * self.direction
            end

        end

        -- On réinitialise le timer
        self.timer = self.delay

    end
end


-- ==============================
-- DRAW
-- ==============================

function Fleet:draw()

    -- On dessine tous les ennemis
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end

end


return Fleet