local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")
local nft = require ("Helpers.nft")
local rectCollider = require ("Helpers.rectCollider")

local attackMusic = love.audio.newSource ("Audio/Music/LOOP_Amidst the Flames.wav", "stream")
attackMusic:setLooping (true)
attackMusic:setVolume (0.4)

local pinny = love.graphics.newImage ("Graphics/pinny.png")
local pinnyPos = {
    x = 100,
    y = 175,
    w = 100,
    h = 300,
}
local pinnyScale = 0.75
local maxPinnyHealth = 25
local pinnyHealth = maxPinnyHealth

local maxTimer = 30
local timer = maxTimer

nft:reset (500, 300)

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:whenAdded (...)
    lovelyToasts.show ("Now's your chance! Corrupt his mind with popup ads before he hacks you!", 3)
    attackMusic:play ()
    
    pinnyHealth = maxPinnyHealth
    timer = maxTimer
end

function thisScene:update (dt)
    -- Update timer
    if timer > 0 then
        timer = timer - dt

    else
        attackMusic:stop ()
        sceneMan:clearStack ()
        sceneMan:push ("loading", 4, "badEnding")
    end

    nft:show ()

    -- Check if nft is colliding with Pinny
    local pinnyRect = {
        x = pinnyPos.x,
        y = pinnyPos.y,
        w = pinnyPos.w * pinnyScale,
        h = pinnyPos.h * pinnyScale,
    }
    if rectCollider (pinnyRect, nft) == true then
        pinnyHealth = pinnyHealth - 1
        pinnyPos.x = math.random (100, 700)
        pinnyPos.y = math.random (100, 500)
        pinnyScale = pinnyScale * 0.95

        nft:reset (800 - pinnyPos.x, 600 - pinnyPos.y)
    end

    -- Pinny
    if pinnyHealth > 0 then
        tux.show.label ({
            image = pinny,
            iscale = pinnyScale,
            colors = {0, 0, 0, 0},
        }, pinnyPos.x, pinnyPos.y, 100, 300)
    else
        attackMusic:stop ()
        sceneMan:clearStack ()
        sceneMan:push ("loading", 4, "pinnyFinal")
    end

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    -- Pinny health bar
    local barW = 661 * (pinnyHealth / maxPinnyHealth)

    love.graphics.setColor (0.55, 0.55, 0.55, 1)
    love.graphics.rectangle ("fill", 75, 543, 661, 28)
    love.graphics.setColor (1, 0, 0, 1)
    love.graphics.rectangle ("fill", 75, 543, barW, 28)
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("HEALTH", 85, 548)

    -- Pinny hack bar
    barW = 661 * (timer / maxTimer)

    love.graphics.setColor (0.55, 0.55, 0.55, 1)
    love.graphics.rectangle ("fill", 75, 70, 661, 28)
    love.graphics.setColor (0, 1, 0, 1)
    love.graphics.rectangle ("fill", 75, 70, barW, 28)
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("HACK", 85, 70)
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            attackMusic:stop ()
            sceneMan:clearStack ()
            sceneMan:push ("loading", 4, "pinnyFinal")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene