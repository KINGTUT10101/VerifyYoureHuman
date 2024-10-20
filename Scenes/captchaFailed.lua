local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local push = require ("Libraries.push")
local showWebBg = require ("Helpers.showWebBg")

local errorText = "Error 503 - Captcha service unavailable. Failed to verify if user is a bot. Clicking confirm will redirect you to another verification method."

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Error
    tux.show.label ({
        text = errorText,
        padding = {padX = 5},
        fsize = 16,
        colors = {
            normal = {
                fg = {1, 0, 0, 1},
                bg = {1, 1, 1, 0},
            },
        }
    }, 259, 216, 294, 154)

    -- Confirm
    if tux.show.button ({
        text = "Confirm",
        fsize = 20,
        slices = slices.webBtn
    }, 335, 450, 144, 46) == "end" then
        sceneMan:clearStack ()
        sceneMan:push ("loading", 1, "verifyInfo")
    end

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 1, "verifyInfo")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene