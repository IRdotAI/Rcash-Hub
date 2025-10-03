if game.PlaceId == 85896571713843 then
-- Load Orion GUI
    local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

-- Create main window
    local Window = OrionLib:MakeWindow({
        Name = "Rcash Hub 💸 | BGSI",
        HidePremium = true,
        SaveConfig = true,
        IntroText = "Rcash Hub",
        IntroIcon = "rbxassetid://82088779453504",
        ConfigFolder = "RcashConfig",
        Icon = "rbxassetid://82088779453504"
    })

-- Notification for GUI loaded
    OrionLib:MakeNotification({
        Name = "Rcash Hub 💸",
        Content = "Rcash Hub loaded successfully.",
        Image = "rbxassetid://82088779453504",
        Time = 5
    })

-- Global toggles
    _G.AutoBlowBubbles = false
    _G.AutoHatch = false
    _G.AutoCS = false
    _G.SelectedEgg = "Common Egg"
    _G.AutoClaimPTR = false
    _G.AutoMysteryBox = false
    _G.AutoSeasonEgg = false
    _G.HideHatchAnim = false
    _G.SpamE = false
    _G.AutoCollectPickups = false



-- Functions
    function AutoBlowBubbles()
        while _G.AutoBlowBubbles do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("BlowBubble")
            task.wait(0.3)
        end
    end

    function AutoHatch()
        while _G.AutoHatch do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchEgg", _G.SelectedEgg, 6)
            task.wait(0.3)
        end
    end

    function AutoCS()
        while _G.AutoCS do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimSeason")
            task.wait(0.3)
        end
    end

    function AutoClaimPTR()
        while _G.AutoClaimPTR do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimAllPlaytime")
            task.wait(30) -- Claim every 60 seconds
        end
    end

    function AutoMysteryBox()
        while _G.AutoMysteryBox do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("UseGift","Mystery Box",25)
            task.wait(0.3)
        end
    end

    function AutoSeasonEgg()
        while _G.AutoSeasonEgg do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchPowerupEgg","Season 8 Egg",6)
            task.wait(0.3)
        end
    end

    function HideHatchAnim()
        local player = game.Players.LocalPlayer
        local gui = player:WaitForChild("PlayerGui")

        gui.ChildAdded:Connect(function(child)
            if _G.HideHatchAnim and child.Name:lower():match("hatch") then
                task.wait(0.05)
                child:Destroy()
            end
        end)
    end
    task.spawn(HideHatchAnim)

    function SpamEKey()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        while _G.SpamE do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05) -- short delay (adjust as needed)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.05)
        end
    end

    function AutoCollectPickups()
        while _G.AutoCollectPickups do
            for _, v in pairs(workspace.rendered.pickup:GetChildren()) do
                if v:IsA("Model") or v:IsA("Part") then
                    if v.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
                        game:GetService("ReplicatedStorage").Remotes.Pickups.CollectPickup:FireServer(v.Name)
                    end
                end
            end
            task.wait(3) 
        end
    end




-- Main Tab
    local MainTab = Window:MakeTab({
        Name = "🏠 Main",
        PremiumOnly = false
    })

    MainTab:AddLabel("By RdotA")
    MainTab:AddLabel(" \nSupported games so far: Bubble Gum Simulator INFINITY\nMore to come soon!\n ")


    MainTab:AddButton({
        Name = "Rejoin",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Rejoining server...",
                Time = 3
            })
        end
    })

    MainTab:AddButton({
        Name = "Server Hop",
        Callback = function()
            local HttpService = game:GetService("HttpService")
            local x = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            if x and x.data and #x.data > 0 then
                local y = {}
                for _,v in pairs(x.data) do
                    if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                        table.insert(y, v.id)
                    end
                end
                if #y > 0 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, y[math.random(1, #y)])
                    OrionLib:MakeNotification({
                        Name = "Rcash Hub 💸",
                        Content = "Server hopping...",
                        Time = 3
                    })
                else
                    OrionLib:MakeNotification({
                        Name = "Rcash Hub 💸",
                        Content = "No available servers found.",
                        Time = 5
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Failed to fetch server list.",
                    Time = 5
                })
            end
        end
    })

    MainTab:AddButton({
        Name = "Destroy GUI",
        Callback = function()
            _G.AutoBlowBubbles = false
            _G.AutoHatch = false
            _G.AutoCS = false
            _G.AutoClaimPTR = false
            _G.AutoMysteryBox = false
            _G.AutoSeasonEgg = false
            _G.HideHatchAnim = false
            _G.SpamE = false
            _G.AutoCollectPickups = false
            _G.AutoClaimChests = false 

            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "GUI destroyed. All toggles stopped.",
                Time = 3
            })

            OrionLib:Destroy()

        end
    })

    MainTab:AddButton({
        Name = "Reload GUI",
        Callback = function()
            -- Stop all global toggles
            _G.AutoBlowBubbles = false
            _G.AutoHatch = false
            _G.AutoCS = false
            _G.AutoClaimPTR = false
            _G.AutoMysteryBox = false
            _G.AutoSeasonEgg = false
            _G.HideHatchAnim = false
            _G.SpamE = false
            _G.AutoCollectPickups = false
            _G.AutoClaimChests = false 

            -- Destroy Orion GUI
            if OrionLib then
                OrionLib:Destroy()
            end

            -- Notify player
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rcash Hub 💸",
                Text = "Reloading GUI...",
                Duration = 3
            })

            -- Reload script
            loadstring(game:HttpGet("https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/main/main.lua"))()
        end
    })



-- Farming Tab
    local FarmingTab = Window:MakeTab({
        Name = "🚜 Farming",
        PremiumOnly = false
    })

    FarmingTab:AddToggle({
        Name = "Auto Blow Bubbles",
        Default = false,
        Callback = function(Value)
            _G.AutoBlowBubbles = Value
            if Value then task.spawn(AutoBlowBubbles) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Blow Bubbles: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    FarmingTab:AddToggle({
        Name = "Auto Collect Pickups",
        Default = false,
        Callback = function(Value)
            _G.AutoCollectPickups = Value
            if Value then task.spawn(AutoCollectPickups) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Collect Pickups: " .. (Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })




-- Pets Tab
    local PetsTab = Window:MakeTab({
        Name = "🐾 Pets",
        PremiumOnly = false
    })

    PetsTab:AddLabel("Select an egg to hatch and stand near the selected egg")


    local EggCategories = {
        ["World 1 Eggs"] = {"Common Egg", "Spotted Egg", "Iceshard Egg", "Inferno Egg", "Spikey Egg", "Magma Egg", "Crystal Egg", "Lunar Egg", "Void Egg", "Hell Egg", "Nightmare Egg", "Rainbow Egg"},
        ["World 2 Eggs"] = {"Showman Egg", "Mining Egg", "Cyber Egg", "Neon Egg", "Chance Egg"},
        ["World 3 Eggs"] = {"Icy Egg", "Vine Egg", "Lava Egg", "Secret Egg", "Atlantis Egg", "Classic Egg"},
        ["Event Eggs"] = {"Autumn Egg", "Developer Egg", "Infinity Egg"}
    }


    for categoryName, eggList in pairs(EggCategories) do
        PetsTab:AddDropdown({
            Name = categoryName,
            Default = _G.SelectedEgg,
            Options = eggList,
            Callback = function(Value)
                _G.SelectedEgg = Value
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Selected Egg: "..Value,
                    Time = 3
                })
            end
        })
    end


    PetsTab:AddToggle({
        Name = "Auto Hatch Egg",
        Default = false,
        Callback = function(Value)
            _G.AutoHatch = Value
            if Value then task.spawn(AutoHatch) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Hatch: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    PetsTab:AddToggle({
        Name = "Spam E Key",
        Default = false,
        Callback = function(Value)
            _G.SpamE = Value
            if Value then
                task.spawn(SpamEKey)
            end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Spam E: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })


    PetsTab:AddToggle({
        Name = "Hide Hatch Animation",
        Default = false,
        Callback = function(Value)
            _G.HideHatchAnim = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Hide Hatch Animation: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

-- Misc Tab
    local MiscTab = Window:MakeTab({
        Name = "➕ Misc",
        PremiumOnly = false
    })

    MiscTab:AddToggle({
        Name = "Auto Claim Play Time Rewards",
        Default = false,
        Callback = function(Value)
            _G.AutoClaimPTR = Value
            if Value then task.spawn(AutoClaimPTR) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Claim Play Time Rewards: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    MiscTab:AddToggle({
        Name = "Auto Claim Season Rewards",
        Default = false,
        Callback = function(Value)
            _G.AutoCS = Value
            if Value then task.spawn(AutoCS) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Claim Season: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    MiscTab:AddToggle({
        Name = "Auto Open Mystery Box",
        Default = false,
        Callback = function(Value)
            _G.AutoMysteryBox = Value
            if Value then task.spawn(AutoMysteryBox) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Open Mystery Box: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    MiscTab:AddToggle({
        Name = "Auto Hatch Season Egg",
        Default = false,
        Callback = function(Value)
            _G.AutoSeasonEgg = Value
            if Value then task.spawn(AutoSeasonEgg) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Hatch Season Egg: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })













































































































































-- Initialize GUI
    OrionLib:Init()
end
