local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")

local page = 1
local timer = 90
local showNextButton = false

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Update timer
    if timer > 0 then
        timer = timer - dt
    end

    if page == 1 then
        -- Message
        tux.show.label ({
            text = "Further verification is needed to prove you're human. Please go to our sister site, CoolMathGames.com, and report Franco's first order in Papa's Taco Mia.",
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
            text = "Open",
            fsize = 20,
            slices = slices.webBtn
        }, 335, 450, 144, 46) == "end" then
            -- love.system.openURL ("https://www.coolmathgames.com/0-papas-taco-mia")
            page = 2
        end

    elseif page == 2 then
        -- Gameplay timer
        tux.show.label ({
            text = "Gameplay timer: " .. math.abs (math.ceil (timer)) .. " sec",
            padding = {padX = 15},
            fsize = 16,
            colors = {0, 0, 0, 0},
            align = "left",
        }, 9, 69, 250, 36)

        -- Message
        tux.show.label ({
            text = "What was Franco's first order in Papa's Taco Mia?",
            padding = {padX = 15},
            fsize = 26,
            colors = {
                normal = {
                    fg = {0, 0, 0, 1},
                    bg = {1, 1, 1, 0},
                },
            }
        }, 145, 100, 526, 100)

        -- Answers
        if tux.show.button ({
            text = "Hard shell, chicken, nacho cheese, black beans, lettuce, and guac",
            fsize = 16,
            slices = slices.webBtn,
        }, 255, 225, 307, 50) == "end" then
            if timer > 0 then
                lovelyToasts.show ("Playtime requirement not met")

            else
                lovelyToasts.show ("Wrong, keep playing!", 1)
                timer = timer + 30
            end
        end

        if tux.show.button ({
            text = "Hard shell, beef, sour cream, pinto beans, lettuce, and guac",
            fsize = 16,
            slices = slices.webBtn,
        }, 255, 290, 307, 50) == "end" then
            if timer > 0 then
                lovelyToasts.show ("Playtime requirement not met")

            else
                lovelyToasts.show ("CORRECT!", 1)
                showNextButton = true
            end
        end

        if tux.show.button ({
            text = "Pita shell, beef, sour cream, black beans, pinto beans, lettuce, and guac",
            fsize = 16,
            slices = slices.webBtn,
        }, 255, 355, 307, 50) == "end" then
            if timer > 0 then
                lovelyToasts.show ("Playtime requirement not met")

            else
                lovelyToasts.show ("Wrong, keep playing!", 1)
                timer = timer + 30
            end
        end

        if tux.show.button ({
            text = "Soft shell, beef, sour cream, pinto beans, peppers, and guac",
            fsize = 16,
            slices = slices.webBtn,
        }, 255, 420, 307, 50) == "end" then
            if timer > 0 then
                lovelyToasts.show ("Playtime requirement not met")

            else
                lovelyToasts.show ("Wrong, keep playing!", 1)
                timer = timer + 30
            end
        end
    end

    if showNextButton == true then
        if tux.show.button ({
            text = "Next",
            fsize = 20,
            slices = slices.webBtn
        }, 355, 500, 104, 45) == "end" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2.5, "pinnyIntro")
        end
    end

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2.5, "pinnyIntro")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene