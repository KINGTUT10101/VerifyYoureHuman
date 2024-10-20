-- Loads the libraries
local push = require ("Libraries.push")
local sceneMan = require ("Libraries.sceneMan")
local lovelyToasts = require ("Libraries.lovelyToasts")
local tux = require ("Libraries.tux")
local fonts = require ("Helpers.fonts")

-- Declares / initializes the local variables
local showCursorPos = false
local showCursorBox = false
local savedCursorPos = {
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = 0,
}


-- Declares / initializes the global variables
DevMode = true


-- Defines the functions



function love.load ()
    -- Set up Push
    local gameWidth, gameHeight = 800, 600
    local windowWidth, windowHeight = 800, 600
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = {800, 600}

    -- Set up Tux
    tux.utils.setDefaultColors (
        {
            normal = {
                fg = {1, 1, 1, 1},
                bg = {1, 1, 1, 1},
            },
            hover = {
                fg = {1, 1, 1, 1},
                bg = {1, 1, 1, 1},
            },
            held = {
                fg = {1, 1, 1, 1},
                bg = {1, 1, 1, 1},
            },
        }
    )
    tux.utils.registerFont ("glitchedLauncher", "Fonts/RubikGlitch-Regular.ttf")

    -- Load scenes
    sceneMan:newScene ("launcher", require ("Scenes.launcher"))
    sceneMan:newScene ("loading", require ("Scenes.loading"))
    sceneMan:newScene ("email", require ("Scenes.email"))
    sceneMan:newScene ("password", require ("Scenes.password"))
    sceneMan:newScene ("captcha", require ("Scenes.captcha"))
    sceneMan:newScene ("captchaFailed", require ("Scenes.captchaFailed"))
    sceneMan:newScene ("verifyInfo", require ("Scenes.verifyInfo"))
    sceneMan:newScene ("verifyLigma", require ("Scenes.verifyLigma"))
    sceneMan:newScene ("closeAds", require ("Scenes.closeAds"))
    sceneMan:newScene ("tacoMia", require ("Scenes.tacoMia"))
    sceneMan:newScene ("pinnyIntro", require ("Scenes.pinnyIntro"))
    sceneMan:newScene ("personalQuestions", require ("Scenes.personalQuestions"))
    -- sceneMan:newScene ("calibrate", require ("Scenes.calibrate"))

    -- Enter first scene
    sceneMan:push ("tacoMia")
end


function love.update (dt)
    tux.callbacks.update (dt)
    sceneMan:event ("update", dt)
    lovelyToasts.update(dt)

    if DevMode == true then
        local mx, my = push:toGame(love.mouse.getPosition ())

        if love.keyboard.isDown ("1") == true then
            local mx, my = push:toGame(love.mouse.getPosition ())
            savedCursorPos.x1 = mx
            savedCursorPos.y1 = my

        elseif love.keyboard.isDown ("2") == true then
            local mx, my = push:toGame(love.mouse.getPosition ())
            savedCursorPos.x2 = mx
            savedCursorPos.y2 = my
        end
    end
end


function love.draw ()
    push:start()
        local boxW = savedCursorPos.x2 - savedCursorPos.x1
        local boxY = savedCursorPos.y2 - savedCursorPos.y1

        sceneMan:event ("earlyDraw")
        tux.callbacks.draw ()
        sceneMan:event ("draw")
        lovelyToasts.draw()

        -- Show cursor position
        if showCursorPos == true then
            local mx, my = push:toGame(love.mouse.getPosition ())

            love.graphics.setColor ({0, 0, 0, 0.25})
            love.graphics.rectangle ("fill", 700, 0, 100, 55)
            love.graphics.setColor ({1, 1, 1, 1})
            love.graphics.setFont (fonts.default)
            love.graphics.printf (mx .. ", " .. my, 700, 5, 100, "center") -- Mouse position
            love.graphics.printf (savedCursorPos.x1 .. ", " .. savedCursorPos.y1, 700, 20, 100, "center") -- Mouse position
            love.graphics.printf (math.abs (boxW) .. ", " .. math.abs (boxY), 700, 35, 100, "center") -- Mouse position
        end

        if showCursorBox == true then
            love.graphics.setColor ({1, 0, 0, 1})
            love.graphics.rectangle ("fill", savedCursorPos.x1, savedCursorPos.y1, boxW, boxY)
        end
    push:finish()
end


function love.keypressed (key, scancode, isrepeat)
    tux.callbacks.keypressed (key, scancode, isrepeat)
    sceneMan:event ("keypressed", key, scancode, isrepeat)

    -- Dev controls
    if DevMode == true then
        if key == "9" then
            showCursorPos = not showCursorPos

        elseif key == "0" then
            showCursorBox = not showCursorBox

        elseif key == "8" then
            local w = math.abs (savedCursorPos.x2 - savedCursorPos.x1)
            local h = math.abs (savedCursorPos.y2 - savedCursorPos.y1)
            love.system.setClipboardText (savedCursorPos.x1 .. ", " .. savedCursorPos.y1 .. ", " .. w .. ", " .. h)

            lovelyToasts.show ("Rectangle copied!", 1)
            print ("Rectangle copied!")

        elseif key == "7" then
            tux.utils.setDebugMode (not tux.utils.getDebugMode ())
        end
    end
end


function love.textinput (text)
    tux.callbacks.textinput (text)
end