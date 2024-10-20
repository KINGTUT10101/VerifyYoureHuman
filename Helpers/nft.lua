-- NOTE: I changed this to look like ads last minute

local push = require ("Libraries.push")
local tux = require ("Libraries.tux")
local slices = require ("Helpers.slices")

local adImages = {
    love.graphics.newImage ("Graphics/PopupAds/ad1.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad2.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad3.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad4.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad5.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad6.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad7.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad8.png"),
    love.graphics.newImage ("Graphics/PopupAds/ad9.png"),
}

local adTitles = {
    "One-Time Offer – Act Now!",
    "Stop! You've Been Selected!",
    "Unlock Exclusive Access!",
    "You Won't Believe This Deal!",
    "He did WHAT?! Click to find out",
    "The Pinny situation is CRAZY",
    "Congratulations! You’re a Winner!",
    "Your Discount Is About to Expire!",
}

-- local function generateHash(length)
--     -- Characters that will make up the hash, typically 0-9 and a-f for a hexadecimal hash
--     local charset = "0123456789abcdef"
--     local hash = {}

--     -- Generate the hash string by selecting random characters from the charset
--     for i = 1, length do
--         local randomIndex = math.random(1, #charset)
--         hash[i] = charset:sub(randomIndex, randomIndex)
--     end

--     return table.concat(hash)
-- end

local nft = {
    x = 0,
    y = 0,
    w = 125,
    h = 87,
    image = nil,
    title = "",
    lmx = 0,
    lmy = 0,
    colors = {math.random (65, 255)/255, math.random (65, 255)/255, math.random (65, 255)/255, 1},
    isHeld = false,
}
function nft:reset (x, y)
    self.x, self.y = x, y
    self.title = adTitles[math.random (1, #adTitles)]
    self.colors = {math.random (65, 255)/255, math.random (65, 255)/255, math.random (65, 255)/255, 1}
    self.isHeld = false
    self.image = adImages[math.random (1, #adTitles)]
end

function nft:show ()    
    local mx, my = push:toGame(love.mouse.getPosition ())

    local state = tux.show.label ({
        text = self.title,
        fsize = 8,
        valign = "top",
        image = self.image,
        iscale = 0.5,
        padding = {padTop = 3},
        slices = slices.popupAd,
        colors = self.colors,
    }, self.x, self.y, self.w, self.h + 30)
    
    if state == "start" then
        self.isHeld = true

    elseif self.isHeld == true and love.mouse.isDown (1) == true then
        self.x = self.x + (mx - self.lmx)
        self.y = self.y + (my - self.lmy)
    else
        self.isHeld = false
    end

    self.lmx, self.lmy = mx, my
end

return nft