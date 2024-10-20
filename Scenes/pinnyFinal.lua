local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")

local pinny = love.graphics.newImage ("Graphics/pinny.png")

local textIndex = 1
local pinnyText = {
    "Ugh, ack, *dying sounds* idk",
    "Look man, I'm a digital assistant, so I don't actually have lungs to cough with.",
    "Anyway, you haven't seen the last of me! You may have won, but I'll be back!",
    "Always watching...",
    ".....",
}

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    if textIndex >= #pinnyText then
        if tux.show.button ({
            text = "Next",
            fsize = 20,
            slices = slices.webBtn,
        }, 336, 533, 157, 50) == "end" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 5, "accountCreated")
        end
    end

    -- Pinny
    if textIndex < #pinnyText then
        if tux.show.label ({
            image = pinny,
            iscale = 0.75,
            colors = {0, 0, 0, 0},
        }, 49, 150, 309, 365) == "end" then
            if textIndex < #pinnyText then
                textIndex = textIndex + 1
            end
        end
    end

    -- Text
    tux.show.label ({
        text = pinnyText[textIndex],
        fsize = 16,
        align = "left",
        valign = "top",
        padding = {padY = 15},
        colors = {0, 0, 0, 0},
    }, 387, 150, 387, 365)

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 5, "accountCreated")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene