local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local slices = require ("Helpers.slices")
local tux = require ("Libraries.tux")
local showWebBg = require ("Helpers.showWebBg")

local function isValidEmail(email)
    -- Basic pattern for email validation
    local pattern = "^[%w.]+@%w+%.%w+$"
    
    -- Check if the email matches the pattern
    if string.match(email, pattern) then
        return true
    else
        return false
    end
end

local function insertRandomCharacter(inputStr)
    -- Define a string of characters to randomly pick from
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
    
    -- Generate a single random character from the string of characters
    local charPos = math.random(1, #chars)
    local randomChar = chars:sub(charPos, charPos)
    
    -- Generate a random position to insert the character into the string
    local randomPos = math.random(1, #inputStr + 1) -- +1 to allow inserting at the end

    -- Insert the random character at the random position
    local newStr = inputStr:sub(1, randomPos - 1) .. randomChar .. inputStr:sub(randomPos)
    
    return newStr
end

local emailData = {
    text = "",
    inFocus = false
}
local confirmEmailData = {
    text = "",
    inFocus = false
}

local emailError = ""
local wrongEmailRetries = 3

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:whenAdded (...)
    local args = {...}
    
    tux.utils.setDefaultColors (
        {
            normal = {
                fg = {0, 0, 0, 1},
                bg = {1, 1, 1, 1},
            },
            hover = {
                fg = {0, 0, 0, 1},
                bg = {1, 1, 1, 1},
            },
            held = {
                fg = {0, 0, 0, 1},
                bg = {1, 1, 1, 1},
            },
        }
    )
end

function thisScene:update (dt)
    tux.show.label ({
        text = "Please enter and confirm your email",
        colors = {0, 0, 0, 0},
        fsize = 26
    }, 233, 135, 350, 64)

    tux.show.label ({
        text = "Email:",
        align = "left",
        fsize = 12,
        colors = {0, 0, 0, 0},
    }, 243, 200, 331, 44)
    tux.show.singleInput ({
        data = emailData,
    }, 243, 235, 331, 44)

    tux.show.label ({
        text = "Confirm email:",
        align = "left",
        fsize = 12,
        colors = {0, 0, 0, 0},
    }, 243, 300, 331, 44)
    tux.show.singleInput ({
        data = confirmEmailData,
    }, 243, 335, 331, 44)

    tux.show.label ({
        text = emailError,
        padding = {padX = 5},
        colors = {
            normal = {
                fg = {1, 0, 0, 1},
                bg = {1, 1, 1, 0},
            },
        }
    }, 266, 398, 280, 38)

    if tux.show.button ({
        text = "Submit",
        fsize = 20,
        slices = slices.webBtn
    }, 335, 444, 144, 46) == "end" then
        if isValidEmail (emailData.text) == false then
            emailError = "Provided email is invalid!"

            sceneMan:clearStack ()
            sceneMan:push ("loading", 0.1, "email")

        elseif emailData.text ~= confirmEmailData.text then
            emailError = "Emails do not match! Try checking for spelling errors"

            sceneMan:clearStack ()
            sceneMan:push ("loading", 0.1, "email")

        elseif wrongEmailRetries > 0 then
            if wrongEmailRetries == 3 then
                emailError = "Emails do not match! Try checking for spelling errors"
            elseif wrongEmailRetries == 2 then
                emailError = "Emails do not match! Get rid of the spelling errors"
            elseif wrongEmailRetries == 1 then
                emailError = "Emails do not match! Seriously, how stupid are you?"
            end

            -- Insert intentional errors
            confirmEmailData.text = insertRandomCharacter (confirmEmailData.text)

            wrongEmailRetries = wrongEmailRetries - 1

            sceneMan:clearStack ()
            sceneMan:push ("loading", 0.1, "email")

        else
            sceneMan:clearStack ()
            sceneMan:push ("loading", 1.5, "password")
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
            sceneMan:push ("loading", 1.5, "password")
        end
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene