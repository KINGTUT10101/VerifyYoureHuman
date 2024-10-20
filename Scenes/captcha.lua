local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local push = require ("Libraries.push")
local showWebBg = require ("Helpers.showWebBg")
local cursorInArea = require ("Helpers.cursorInArea")

local father = love.graphics.newImage ("Graphics/Captcha/father.png")
local warPlans = love.graphics.newImage ("Graphics/Captcha/warPlans.png")
local joeMamasHouse = love.graphics.newImage ("Graphics/Captcha/joeMamasHouse.png")
local dread = love.graphics.newImage ("Graphics/Captcha/dread.png")

local captchas = {
    {
        image = father,
        text = "Click all squares containing three-times divorced fathers of five kids.",
        squares = {
            {1, 3},
            {2, 3},
        }
    },
    {
        image = warPlans,
        text = "Click all squares containing secret military beach invasions.",
        squares = {
            {1, 2},
            {2, 2},
            {2, 3},
            {2, 4},
        }
    },
    {
        image = joeMamasHouse,
        text = "Click all squares containing where I was last night.",
        squares = {
            {1, 2},
            {2, 2},
            {1, 3},
            {2, 3},
            {1, 1},
            {1, 4},
        }
    },
    {
        image = dread,
        text = "Click all squares containing existential dread.",
        squares = {
            {1, 2},
            {2, 2},
            {1, 3},
            {2, 3},
        }
    },
}
local captchaIndex = 1
local errorText = ""

local grid = {}
local gridPos = {
    x = 400,
    y = 350,
    w = 480,
    h = 270
}
local function resetGrid ()
    grid = {}

    for i = 1, 2 do
        grid[i] = {}
        for j = 1, 4 do
            grid[i][j] = false
        end
    end
end

function thisScene:load (...)
    resetGrid ()
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Title
    tux.show.label ({
        text = captchas[captchaIndex].text,
        colors = {0, 0, 0, 0},
        fsize = 20
    }, 233, 115, 350, 100)

    -- Error
    tux.show.label ({
        text = errorText,
        padding = {padX = 5},
        colors = {
            normal = {
                fg = {1, 0, 0, 1},
                bg = {1, 1, 1, 0},
            },
        }
    }, 251, 496, 292, 38)

    -- Reset button
    if tux.show.button ({
        text = "Reset",
        fsize = 20,
        slices = slices.webBtn
    }, 245, 545, 125, 39) == "end" then
        resetGrid ()
    end
    
    -- Submit button
    if tux.show.button ({
        text = "Submit",
        fsize = 20,
        slices = slices.webBtn
    }, 425, 545, 125, 39) == "end" then
        -- Check if the selected squares are correct
        local allCorrect = true
        for key, value in ipairs (captchas[captchaIndex].squares) do
            local x, y = value[1], value[2]

            if grid[x][y] == false then
                allCorrect = false
                break
            end

            grid[x][y] = false
        end

        for j = 1, 2 do
            for i = 1, 4 do
                if grid[j][i] == true then
                    allCorrect = false
                    break
                end
            end
        end

        if allCorrect == true then
            errorText = ""
            captchaIndex = captchaIndex + 1
            if captchaIndex > #captchas then
                sceneMan:clearStack ()
                sceneMan:push ("loading", 2.5, "captchaFailed")
            else
                sceneMan:clearStack ()
                sceneMan:push ("loading", 1.5, "captcha")
            end
        else
            resetGrid ()
            errorText = "Please try again!"

            sceneMan:clearStack ()
            sceneMan:push ("loading", 1, "captcha")
        end
    end

    showWebBg (0, 0, 800, 600)
end

function thisScene:draw ()
    -- Render image
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.draw (captchas[captchaIndex].image, gridPos.x, gridPos.y, nil, nil, nil, gridPos.w / 2, gridPos.h / 2)

    -- Render grid
    local startX = gridPos.x - (gridPos.w / 2)
    local startY = gridPos.y - (gridPos.h / 2)
    local tileW = gridPos.w / 4
    local tileH = gridPos.h / 2
    local mx, my = push:toGame(love.mouse.getPosition ())

    for j = 1, 2 do
        for i = 1, 4 do
            -- Render squares
            if grid[j][i] == true then
                love.graphics.setColor (0, 0, 0, 0.45)
                love.graphics.rectangle ("fill", (i - 1) * tileW + startX, (j - 1) * tileH + startY, tileW, tileH)
                love.graphics.setColor (0, 0, 1, 1)
                love.graphics.rectangle ("line", (i - 1) * tileW + startX, (j - 1) * tileH + startY, tileW, tileH)
            else
                love.graphics.setColor (1, 0, 0, 1)
                love.graphics.rectangle ("line", (i - 1) * tileW + startX, (j - 1) * tileH + startY, tileW, tileH)
            end
            
            -- Check for mouse clicks
            if cursorInArea (mx, my, (i - 1) * tileW + startX, (j - 1) * tileH + startY, tileW, tileH) == true then
                if love.mouse.isDown (1) == true then
                    grid[j][i] = true
                end
            end
        end
    end
end

function thisScene:keypressed (key, scancode, isrepeat)
    if DevMode == true then
        if key == "delete" then
            sceneMan:clearStack ()
            sceneMan:push ("loading", 2.5, "captchaFailed")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene