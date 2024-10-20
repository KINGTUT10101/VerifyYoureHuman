local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local push = require ("Libraries.push")
local showWebBg = require ("Helpers.showWebBg")

local errorText = "You will need to complete our state-of-the-art Overkill Verify™ system to complete the account creation process."

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
        padding = {padX = 15},
        fsize = 26,
        colors = {
            normal = {
                fg = {0, 0, 0, 1},
                bg = {1, 1, 1, 0},
            },
        }
    }, 145, 191, 526, 209)

    -- Confirm
    if tux.show.button ({
        text = "Confirm",
        fsize = 20,
        slices = slices.webBtn
    }, 335, 450, 144, 46) == "end" then
        sceneMan:clearStack ()
        sceneMan:push ("loading", 1, "verifyLigma")
    end

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 1, "verifyLigma")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene