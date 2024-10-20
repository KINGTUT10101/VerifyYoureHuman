local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")
local AdWindow = require ("Helpers.adWindow")

local adsAttacking = false
local showNextButton = false
local memoryWarningShown = false
local extremeWarningShown = false
local hugeWaveWarningShown = false
local lastWaveWarningShown = false
local maxAds = 10

local attackMusic = love.audio.newSource ("Audio/Music/LOOP_Ambushed from the Shadows.wav", "stream")
attackMusic:setLooping (true)
attackMusic:setVolume (0.4)

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    AdWindow:show ()

    if adsAttacking == true then
        if AdWindow.adsClicked > 65 then
            showNextButton = true
        elseif AdWindow.adsClicked > 50 then
            if math.random () < 0.032 then
                AdWindow:new (math.random (15, 535), math.random (45, 410))
            end

        elseif AdWindow.adsClicked > 25 then
            if math.random () < 0.028 then
                AdWindow:new (math.random (15, 535), math.random (45, 410))
            end

        elseif AdWindow.adsClicked > 10 then
            if math.random () < 0.023 then
                AdWindow:new (math.random (15, 535), math.random (45, 410))
            end

        else
            if math.random () < 0.015 then
                AdWindow:new (math.random (15, 535), math.random (45, 410))
            end
        end

        if AdWindow.adsClicked >= 10 then
            local memoryUsed = math.floor (math.max (32000 * ((AdWindow.activeAds + 1) / (maxAds + 1)) + math.random (-500, 500), 0))
            tux.show.label ({
                text = "RAM: " .. memoryUsed .. "mb / 32000mb",
                fsize = 14,
                align = "left",
                colors = {0, 0, 0, 0},
            }, 75, 568, 661, 28)
        end

        if showNextButton == true then
            tux.show.label ({
                text = "Thanks for watching! Your engagement earned our company 0.0005 cents!",
                fsize = 28,
                colors = {0, 0, 0, 0},
            }, 232, 170, 361, 227)
    
            if tux.show.button ({
                text = "Next",
                fsize = 20,
                slices = slices.webBtn
            }, 367, 468, 104, 45) == "end" then
                attackMusic:stop ()
                sceneMan:clearStack ()
                sceneMan:push ("loading", 2.5, "tacoMia")
            end
        end

    else
        -- Ad warning
        tux.show.label ({
            text = "You may continue the sign-up process after this brief advertising break",
            fsize = 28,
            colors = {0, 0, 0, 0},
        }, 232, 170, 361, 227)

        if tux.show.button ({
            text = "Okay",
            fsize = 20,
            slices = slices.webBtn
        }, 367, 468, 104, 45) == "end" then
            adsAttacking = true
            attackMusic:play ()
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2, "closeAds")
        end
    end
    
    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    -- Show memory limit
    if AdWindow.adsClicked >= 10 then
        local barW = math.max (661 * ((AdWindow.activeAds + 1) / (maxAds + 1)) + math.random (-10, 10), 0)

        love.graphics.setColor (0.55, 0.55, 0.55, 1)
        love.graphics.rectangle ("fill", 75, 543, 661, 28)
        love.graphics.setColor (1, 0, 0, 1)
        love.graphics.rectangle ("fill", 75, 543, barW, 28)

        if AdWindow.adsClicked > 25 and hugeWaveWarningShown == false then
            hugeWaveWarningShown = true
            lovelyToasts.show ("More ads incoming!", 1)
        end

        if AdWindow.adsClicked > 50 and lastWaveWarningShown == false then
            lastWaveWarningShown = true
            lovelyToasts.show ("Almost there!", 1)
        end

        if memoryWarningShown == false then
            memoryWarningShown = true
            lovelyToasts.show ("Warning: Spike in memory usage detected", 2)

        elseif extremeWarningShown == false and AdWindow.activeAds >= maxAds * 0.80 then
            extremeWarningShown = true
            lovelyToasts.show ("WARNING: REDUCE MEMORY NOW TO AVOID SYSTEM FAILURE", 2)

        elseif AdWindow.activeAds >= maxAds then
            lovelyToasts.show ("Out of memory :(. Try again", 2)
            adsAttacking = false
            showNextButton = false
            memoryWarningShown = false
            extremeWarningShown = false
            maxAds = 10
            AdWindow:reset ()
        end
    end
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            attackMusic:stop ()
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2.5, "tacoMia")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene