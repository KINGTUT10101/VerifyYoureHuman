local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local scaleToSize = require ("Helpers.layout").scaleToSize
local slices = require ("Helpers.slices")

local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")

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

function thisScene:delete (...)
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
    -- Error
    tux.show.label ({
        text = "Error 503: Server Unavailable",
        valign = "top",
        fsize = 22,
        padding = {padTop = 35},
        colors = {1, 1, 1, 0}
    }, 201, 128, 417, 323)

    -- Details
    tux.show.label ({
        text = "Our servers are currently down for scheduled maintenance.\n\nEstimated Downtime: 72 hours\n\nError Code: MAINT_503",
        valign = "top",
        fsize = 16,
        padding = {padTop = 70, padX = 25},
        colors = {1, 1, 1, 0}
    }, 201, 128, 417, 323)
    
    -- Background
    tux.show.label ({
        text = "Overkill Ops",
        valign = "top",
        padding = {padTop = 5},
        slices = slices.launcherLbl,
        colors = {1, 1, 1, 0.95},
        font = "glitchedLauncher",
        fsize = 30,
    }, 201, 128, 417, 323)
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