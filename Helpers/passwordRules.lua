local orangeRetries = 2
local heIsComing = false

local passwordRules = {
    [0] = {
        error = "",
        rule = function () return true end,
    },
    {
        error = "Password must be at least 8 characters long.",
        rule = function(password)
            return #password >= 8
        end
    },
    {
        error = "Password must contain at least one uppercase letter.",
        rule = function(password)
            return password:match("%u") ~= nil
        end
    },
    {
        error = "Password must contain at least one lowercase letter.",
        rule = function(password)
            return password:match("%l") ~= nil
        end
    },
    {
        error = "Password must contain at least one digit.",
        rule = function(password)
            return password:match("%d") ~= nil
        end
    },
    {
        error = "Password cannot contain spaces.",
        rule = function(password)
            return not password:match("%s")
        end
    },
    {
        error = 'Password cannot be "password", you idiot.',
        rule = function(password)
            return password:lower() ~= "password"
        end
    },
    {
        error = "Password must include at least one palindrome of 3 or more characters.",
        rule = function(password)
            for i = 1, #password do
                for j = i + 2, #password do
                    local substring = password:sub(i, j)
                    if substring == substring:reverse() then
                        return true
                    end
                end
            end
            return false
        end
    },
    {
        error = "Password must contain at least 3 consecutive vowels.",
        rule = function(password)
            return password:match("[aeiouAEIOU][aeiouAEIOU][aeiouAEIOU]") ~= nil
        end
    },
    {
        error = "Password must contain at least 3 consecutive vowels preceded by an eight and not proceeded by an A.",
        rule = function(password)
            return password:match("[8][aeiouAEIOU][aeiouAEIOU][eiouEIOU]") ~= nil
        end
    },
    {
        error = "Password cannot contain any numbers divisible by 3.",
        rule = function(password)
            for digit in password:gmatch("%d") do
                if tonumber(digit) ~= 0 and tonumber(digit) % 3 == 0 then
                    return false
                end
            end
            return true
        end
    },
    {
        error = 'HE IS COMING',
        rule = function(password)
            if heIsComing == false then
                heIsComing = true
                return false
            else
                return true
            end
        end
    },
    {
        error = "Password must have more numbers than letters.",
        rule = function(password)
            local num_count = 0
            local letter_count = 0
            for char in password:gmatch(".") do
                if char:match("%d") then
                    num_count = num_count + 1
                elseif char:match("%a") then
                    letter_count = letter_count + 1
                end
            end
            return num_count > letter_count
        end
    },
    {
        error = "Password must be at most 14 characters long.",
        rule = function(password)
            print (#password)
            return #password <= 14
        end
    },
    {
        error = "Password cannot have more than 3 of the same character overall.",
        rule = function(password)
            -- Create a table to count character occurrences
            local char_count = {}
            for char in password:gmatch(".") do
                char_count[char] = (char_count[char] or 0) + 1
                if char_count[char] > 3 then
                    return false -- Return false if any character appears more than 3 times
                end
            end
            return true -- Return true if all characters appear 3 times or fewer
        end
    },
    {
        error = "Password must include a color name (e.g., red, blue, green).",
        rule = function(password)
            local colors = {"red", "blue", "green", "yellow", "orange", "purple", "pink", "brown", "black", "white"}
            for _, color in ipairs(colors) do
                if password:lower():find(color) then
                    return true
                end
            end
            return false
        end
    },
    {
        error = "Password must rhyme with 'orange'.",
        rule = function(password)
            if orangeRetries >= 2 then
                orangeRetries = orangeRetries - 1
                return false
            end
        end
    },
    {
        error = "lol jk just try it again",
        rule = function(password)
            if orangeRetries == 1 then
                orangeRetries = orangeRetries - 1
                return false
            end
        end
    },
}

return passwordRules