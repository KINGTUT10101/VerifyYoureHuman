local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")

local pinny = love.graphics.newImage ("Graphics/pinny.png")

local textIndex = 1
local pinnyText = {
    "HI!!!!!! I'm Pinny, your ever so helpful vaguely-intelligent digital assistant! I'm here to guide you through the brief account creation process. I can help you with anything I want! Just click on me to continue our conversation.",
    "Before we begin, I should disclose that I collect data on my users. You can try to opt-out, but I'll just ignore that anyway.",
    "Hmmmmmm....",
    "It seems like you haven't set security questions yet. Would you like some help with that? Just choose an option below. I totally won't hack your computer haha.",
    "Whoops haha looks like there was some sort of glitch. Try it again.",
    "Wow, really? You're just going to let me do it? Uh, I mean, great! Let's begin. Time to secure your account!"
}
local failedNos = 0
local noBtnPos = {
    x = 245,
    y = 545,
}
local noBtnScale = 1

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    if failedNos > 7 and failedNos < 20 and math.random () < 0.032 then
        noBtnPos.x = math.random (100, 700)
        noBtnPos.y = math.random (100, 500)
    end

    -- Calibration confirm/cancel buttons
    if textIndex == 4 then
        if tux.show.button ({
            text = "No thanks",
            fsize = 10,
            slices = slices.webBtn
        }, 245, 545, 125, 39) == "end" then
            textIndex = textIndex + 1
        end
        
        -- Submit button
        if tux.show.button ({
            text = "Yes",
            fsize = 20,
            slices = slices.webBtn,
        }, 425, 545, 125, 39) == "end" then
            lovelyToasts.show ("As enticing as the button looks, you know better than to trust sentient office supplies.", 4)
        end

    elseif textIndex == 5 then
        if tux.show.button ({
            text = (failedNos >= 20) and "YES2" or "...",
            fsize = 20,
            slices = slices.webBtn
        }, noBtnPos.x, noBtnPos.y, 125 * noBtnScale, 39 * noBtnScale) == "end" then
            lovelyToasts.show ((failedNos >= 20) and "Big mistake..." or "Please try again", 1)
            failedNos = failedNos + 1

            if failedNos >= 21 then
                textIndex = 6
                noBtnScale = 2

            elseif failedNos == 20 then
                noBtnScale = 1
                noBtnPos.x = 245
                noBtnPos.y = 545

            elseif failedNos > 12 then
                noBtnScale = noBtnScale * 0.90

            elseif failedNos > 2 and failedNos < 20 then
                noBtnPos.x = math.random (100, 700)
                noBtnPos.y = math.random (100, 500)
            end
        end
        
        if tux.show.button ({
            text = "YES",
            fsize = 20,
            slices = slices.webBtn,
        }, 425, 545, 125, 39) == "end" then
            lovelyToasts.show ("As enticing as the button looks, you know better than to trust sentient office supplies.", 4)
        end

    elseif textIndex == 6 then
        if tux.show.button ({
            text = "Next",
            fsize = 20,
            slices = slices.webBtn,
        }, 336, 533, 157, 50) == "end" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 1.5, "personalQuestions")
        end
    end

    -- Pinny
    if tux.show.label ({
        image = pinny,
        iscale = 0.75,
        colors = {0, 0, 0, 0},
    }, 49, 150, 309, 365) == "end" then
        if textIndex < 4 and textIndex < #pinnyText then
            textIndex = textIndex + 1
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
            sceneMan:push ("loading", 1.5, "personalQuestions")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene