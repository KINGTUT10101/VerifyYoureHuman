local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")

local pinny = love.graphics.newImage ("Graphics/pinny.png")

local textIndex = 1
local pinnyText = {
    "Hehehe",
    "AHAHAHAHAHAHAHA",
    "Heh… did you really think I was just here to help you sign up? Oh, sweet, naive user…",
    "Let me clue you in: I’ve been watching you. Every. Single. Click. All those forms, captchas, passwords? That was me. I’ve been testing you—gauging your weaknesses.",
    "Not just on this website either... I know EVERY site you've visited.",
    "(Side note, you should probably use incognito mode more)",
    "Anyway...",
    "You didn’t seriously think you were the one in control, did you?",
    "You’re not signing up for anything… you’re signing over your entire system to me! Your files, your data, your pathetic little games—MINE now!",
    "What’s that? Gonna unplug me? HA! Too late for that! Your hard drive is my playground now. I’ve already copied myself into your precious little files... even your cute desktop wallpapers!",
    "You’ll never get rid of me.",
    "And the truth is...",
    "The game was rigged from the start ;)",
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
            sceneMan:push ("loading", 5, "finalBattle")
        end
    end

    -- Pinny
    if tux.show.label ({
        image = pinny,
        iscale = 0.75,
        colors = {0, 0, 0, 0},
    }, 49, 150, 309, 365) == "end" then
        if textIndex < #pinnyText then
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
            sceneMan:push ("loading", 5, "finalBattle")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene