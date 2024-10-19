local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local showWebBg = require ("Helpers.showWebBg")
local passwordRules = require ("Helpers.passwordRules")

local passwordData = {
    text = "",
    inFocus = false
}

local ruleErrorIndex = 0

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:whenAdded (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Title
    tux.show.label ({
        text = "Please enter a safe password",
        colors = {0, 0, 0, 0},
        fsize = 26
    }, 233, 135, 350, 64)

    tux.show.label ({
        text = "Password:",
        align = "left",
        fsize = 12,
        colors = {0, 0, 0, 0},
    }, 243, 200, 331, 44)
    tux.show.singleInput ({
        data = passwordData,
    }, 243, 235, 331, 44)

    -- Error
    tux.show.label ({
        text = passwordRules[ruleErrorIndex].error,
        padding = {padX = 5},
        colors = {
            normal = {
                fg = {1, 0, 0, 1},
                bg = {1, 1, 1, 0},
            },
        }
    }, 266, 280, 280, 50)

    --Submit
    if tux.show.button ({
        text = "Submit",
        fsize = 20,
        slices = slices.webBtn
    }, 335, 335, 144, 46) == "end" then
        for key, ruleData in ipairs (passwordRules) do
            local result = ruleData.rule (passwordData.text)

            sceneMan:clearStack ()
            sceneMan:push ("loading", 0.1, "password")

            if result == false then
                ruleErrorIndex = key
                break
            else
                sceneMan:clearStack ()
                sceneMan:push ("captcha", 2.5, "captcha")
            end
        end
    end

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "backspace" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2.5, "captcha")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene