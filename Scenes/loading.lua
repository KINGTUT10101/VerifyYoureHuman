local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local showWebBg = require ("Helpers.showWebBg")

local scenesToAdd = {}

local spinner = love.graphics.newImage("Graphics/loadSpinner.png", {})
spinner:setFilter ("nearest", "nearest")
local scale = 1
local rotationRad = 0
local rotationPerSec = 3 * math.pi / 2

local loadingText = "Loading"

local loadTimer = 0

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:whenAdded (timer, ...)
    scenesToAdd = {...}
    loadTimer = 0.1 --timer
    loadingText = "Loading"
end

function thisScene:update (dt)
    -- Update timer
    loadTimer = loadTimer - dt
    if loadTimer <= 0 then
        sceneMan:clearStack ()

        for key, value in ipairs (scenesToAdd) do
            sceneMan:push (value)
        end
    end

    -- Update rotationRad
    rotationRad = rotationRad + rotationPerSec * dt

    -- Update loading text
    if math.random () < 0.025 then
        loadingText = loadingText .. "."

        if loadingText == "Loading..." then
            loadingText = "Loading"
        end
    end
    
    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    -- Background
    -- love.graphics.setColor (0.80, 0.90, 0.85, 1)
    -- love.graphics.rectangle ("fill", 0, 0, 800, 600)

    -- Spinner
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.draw (spinner, 400, 250, rotationRad, scale, scale, spinner:getWidth () / 2, spinner:getHeight () / 2)

    -- Loading text
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.printf (loadingText, 400, 425, 200, "center", nil, nil, nil, 100, 100)
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene