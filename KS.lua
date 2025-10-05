-- Converted to OrionLib format
-- Note: OrionLib must be loaded separately for this code to run.

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Window Setup (Using default OrionLib features for simplicity)
local Window = OrionLib:MakeWindow({
    Name = "Knockout Sim | Pompomsaturin",
    HidePremium = true,
    SaveConfig = true,
    IntroText = "Knockout Sim",
    Icon = "rbxassetid://82088779453504" -- Placeholder icon
})

-- Initial Notification
OrionLib:MakeNotification({
    Name = "DEPSO is TUFF M8!",
    Content = "Alright",
    Time = 3
})

-- Tab Setup
local main = Window:MakeTab({
    Name = "Main",
    PremiumOnly = false
})

-- Add the original script's core functionality as OrionLib buttons

main:AddButton({
    Name = "Infinite Wins",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local WinGain = ReplicatedStorage.Event.WinGain 
        WinGain:FireServer(
            math.huge
        )
        OrionLib:MakeNotification({ -- Added notification for user feedback
            Name = "Success",
            Content = "Infinite Wins Fired!",
            Time = 3
        })
    end,
    Description = "Literally gives you infinite wins."
})

main:AddButton({
    Name = "Infinite Strength",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Train = ReplicatedStorage.Event.Train
        Train:FireServer(
            math.huge
        )
        OrionLib:MakeNotification({ -- Added notification for user feedback
            Name = "Success",
            Content = "Infinite Strength Fired!",
            Time = 3
        })
    end,
    Description = "Literally gives you infinite strength."
})

main:AddButton({
    Name = "Gravity power (BEST POWER) FREE",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BuyPower = ReplicatedStorage.Event.BuyPower
        BuyPower:FireServer(
            "Gravity",
            0
        )
        OrionLib:MakeNotification({ -- Added notification for user feedback
            Name = "Success",
            Content = "Gravity Power Fired!",
            Time = 3
        })
    end,
    Description = "Gives you the best 'power' in the game for free.."
})

main:AddButton({
    Name = "Inf enchant (FOR THE POWER U HAVE ON)",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Enchanted = ReplicatedStorage.Event.Enchanted
        Enchanted:FireServer(
            0,
            math.huge
        )
        OrionLib:MakeNotification({ -- Added notification for user feedback
            Name = "Success",
            Content = "Infinite Enchant Fired!",
            Time = 3
        })
    end,
    Description = "Infinite enchant thingy, no clue what this is called."
})
