local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local showWebBg = require ("Helpers.showWebBg")
local questions = require ("Helpers.questions")

local pinny = love.graphics.newImage ("Graphics/pinny.png")

local questionIndex = 1

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Questions
    tux.show.label ({
        text = questions[questionIndex].question,
        fsize = 22,
        align = "left",
        colors = {0, 0, 0, 0},
        padding = {padX = 5}
    }, 409, 136, 358, 125)

    -- Answers
    for i = 1, 4 do
        if tux.show.button ({
            text = questions[questionIndex].answers[i],
            align = "left",
            fsize = 16,
            padding = {padX = 15},
            slices = slices.webBtn
        }, 409, 265 + (i - 1) * 65, 358, 50) == "end" then
            lovelyToasts.show (questions[questionIndex].response, 2, "top")

            questionIndex = questionIndex + 1

            if questionIndex > #questions then
                questionIndex = 1
                sceneMan:clearStack ()
                sceneMan:push ("loading", 3, "pinnyEvil")
            else
                sceneMan:clearStack ()
                sceneMan:push ("loading", 1, "personalQuestions")
            end
        end
    end

    -- Pinny
    tux.show.label ({
        image = pinny,
        iscale = 0.75,
        colors = {0, 0, 0, 0},
    }, 49, 150, 309, 365)


    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 3, "pinnyEvil")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene