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

local AdWindow = {
    tracker = {},
    w = 250,
    h = 175,
    adsClicked = 0,
    activeAds = 0,
}

function AdWindow:new (x, y)
    local newObj = {
        x = x,
        y = y,
        w = self.w,
        h = self.h,
        image = adImages[math.random (1, #adImages)],
        title = adTitles[math.random (1, #adTitles)],
        index = #self.tracker + 1,
        active = true,
    }

    self.tracker[#self.tracker+1] = newObj
end

function AdWindow:reset ()
    self.tracker = {}
    self.adsClicked = 0
    self.activeAds = 0
end

function AdWindow:show ()
    self.activeAds = 0

    for key, adObj in ipairs (self.tracker) do
        if adObj.active == true then
            self.activeAds = self.activeAds + 1
            
            -- Close button
            if tux.show.label ({
                text = "X",
                fsize = 20,
                colors = {
                    normal = {
                        fg = {1, 0, 0, 1},
                        bg = {0, 0, 0, 0},
                    },
                }
            }, adObj.x, adObj.y, 30, 30) == "end" then
                adObj.active = false
                self.adsClicked = self.adsClicked + 1
            end

            -- Background
            tux.show.label ({
                text = adObj.title,
                fsize = 11,
                valign = "top",
                image = adObj.image,
                padding = {padTop = 3},
                slices = slices.popupAd,
            }, adObj.x, adObj.y, adObj.w, adObj.h + 30)
        end
    end
end

return AdWindow