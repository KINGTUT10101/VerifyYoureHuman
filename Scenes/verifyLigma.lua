local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local push = require ("Libraries.push")
local showWebBg = require ("Helpers.showWebBg")

local infoStage = 0 -- 0 = not viewed, 1 = first page, 2 = second page, 3 = confirm screen

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    if infoStage == 0 then
        -- Info button
        if tux.show.button ({
            text = "Info",
            fsize = 20,
            slices = slices.webBtn
        }, 335, 450, 144, 46) == "end" then
            infoStage = 1
        end

    elseif infoStage == 1 then
        -- Info modal
        tux.show.label ({
            text = "Info",
            fsize = 28,
            valign = "top",
            colors = {0, 0, 0, 0},
        }, 146, 109, 515, 305)

        tux.show.label ({
            text = "Residents of the Suggoneise Territories are not legally eligible to participate in our verification system.",
            fsize = 20,
            slices = slices.webLbl,
            colors = {0.75, 0.75, 0.75, 1},
        }, 146, 109, 515, 305)

        -- Next button
        if tux.show.button ({
            text = "More",
            fsize = 20,
            slices = slices.webBtn
        }, 335, 450, 144, 46) == "end" then
            infoStage = 2
        end

    elseif infoStage == 2 then
        -- Info modal
        tux.show.label ({
            text = "Info",
            fsize = 28,
            valign = "top",
            colors = {0, 0, 0, 0},
        }, 146, 109, 515, 305)

        tux.show.label ({
            text = "Also, Suggoneise nuts lol",
            fsize = 20,
            slices = slices.webLbl,
            colors = {0.75, 0.75, 0.75, 1},
        }, 146, 109, 515, 305)

        -- Next button
        if tux.show.button ({
            text = "Done",
            fsize = 20,
            slices = slices.webBtn
        }, 335, 450, 144, 46) == "end" then
            infoStage = 3
        end

    elseif infoStage == 3 then
        -- Info button
        if tux.show.button ({
            text = "Info",
            fsize = 20,
            slices = slices.webBtn
        }, 245, 545, 125, 39) == "end" then
            infoStage = 1
        end
        
        -- Confirm button
        if tux.show.button ({
            text = "!(yesn't)",
            fsize = 20,
            slices = slices.webBtn
        }, 425, 545, 125, 39) == "end" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 5, "closeAds")
        end
    end

    tux.show.label ({
        text = "Do you reside in the Suggoneise Territories?",
        padding = {padX = 15},
        fsize = 26,
        colors = {
            normal = {
                fg = {0, 0, 0, 1},
                bg = {1, 1, 1, 0},
            },
        }
    }, 145, 191, 526, 209)

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 1, "closeAds")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene