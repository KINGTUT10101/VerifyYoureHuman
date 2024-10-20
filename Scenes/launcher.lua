local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local scaleToSize = require ("Helpers.layout").scaleToSize
local slices = require ("Helpers.slices")

local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")

local kt_pfp = love.graphics.newImage("Graphics/kt_pfp.png")

local launcherTheme = love.audio.newSource ("Audio/Music/We_Stand_Together.wav", "stream")
launcherTheme:setLooping (true)
launcherTheme:setVolume (0.4)

local backgroundImgs = {}
local backgroundIndex = 1
local panDirection = {
    x = math.random (-10, 10),
    y = math.random (-10, 10),
}
local backgroundPos = {
    x = -100,
    y = -200,
}

local maxTimer = 10 -- Time between background imgs in seconds
local backgroundTimer = maxTimer

function thisScene:load (...)
    local dirItems = love.filesystem.getDirectoryItems ("Graphics/Promo")
    for k, v in pairs (dirItems) do
        backgroundImgs[k] = love.graphics.newImage ("Graphics/Promo/" .. v)
    end
end

function thisScene:whenAdded (...)
    launcherTheme:play ()
end

function thisScene:whenRemoved (...)
    launcherTheme:stop ()
end

function thisScene:update (dt)
    backgroundTimer = backgroundTimer - dt

    -- Switch background and reset timer
    if backgroundTimer <= 0 then
        backgroundTimer = maxTimer

        backgroundIndex = backgroundIndex + 1
        if backgroundIndex > #backgroundImgs then
            backgroundIndex = 1
        end

        panDirection.x = math.random (-10, 10)
        panDirection.y = math.random (-10, 10)
        backgroundPos.x = -100
        backgroundPos.y = -200
    end

    -- Update camera position
    backgroundPos.x = backgroundPos.x + panDirection.x * dt
    backgroundPos.y = backgroundPos.x + panDirection.y * dt

    -- Launcher UI
    -- Play button
    if tux.show.button ({
        text = "PLAY",
        slices = slices.launcherBtn,
        colors = {0.60, 0.60, 0.60, 1},
        font = "glitchedLauncher",
        fsize = 22,
    }, 30, 162, 188, 50) == "end" then
        lovelyToasts.show ("Please sign in first!", 2)
    end

    if tux.show.button ({
        text = "SIGN UP",
        slices = slices.launcherBtn,
        font = "glitchedLauncher",
        fsize = 22,
    }, 30, 222, 188, 50) == "end" then
        sceneMan:clearStack ()
        sceneMan:push ("loading", 1.5, "email")
    end

    -- PFP logo
    tux.show.label ({
        image = kt_pfp,
        iscale = 0.30,
        colors = {1, 1, 1, 0},
    }, 32, 327, 186, 172)

    -- Version
    tux.show.label ({
        text = "v1.28.3e",
        valign = "bottom",
        padding = {padBottom = 3},
        colors = {1, 1, 1, 0}
    }, 13, 546, 223, 40)
    
    -- Background
    tux.show.label ({
        text = "Overkill Ops",
        valign = "top",
        padding = {padTop = 20},
        slices = slices.launcherLbl,
        colors = {1, 1, 1, 0.95},
        font = "glitchedLauncher",
        fsize = 40,
    }, 0, 0, 250, 600)
end

function thisScene:earlyDraw ()
    -- Render background
    local currBackground = backgroundImgs[backgroundIndex]
    love.graphics.draw (currBackground, backgroundPos.x, backgroundPos.y, nil, scaleToSize (currBackground:getWidth (), currBackground:getHeight (), 1000, 1000))
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene