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
    _G.SelectedEgg = ""
    _G.AutoClaimPTR = false
    _G.AutoMysteryBox = false
    _G.AutoSeasonEgg = false
    _G.HideHatchAnim = false
    _G.SpamE = false
    _G.AutoCollectAutumnLeaves = false
    _G.AutoSpinAutumnWheel = false
    _G.AutoBuyAutumnShop = false



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
            task.wait(30) 
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
            task.wait(0.05) 
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.05)
        end
    end

    local FallLeafListenerStarted = false

    function ListenForFallLeafPickups()
        if FallLeafListenerStarted then return end
        FallLeafListenerStarted = true

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local SpawnPickups = ReplicatedStorage.Remotes.Pickups.SpawnPickups
        local CollectPickup = ReplicatedStorage.Remotes.Pickups.CollectPickup
        local Chunker = workspace:WaitForChild("Rendered"):WaitForChild("Chunker")

        task.spawn(function()
            while true do
                if _G.AutoCollectAutumnLeaves then
                    local leafCount = 0

                    for _, model in pairs(Chunker:GetChildren()) do
                        local visual = model:FindFirstChild("Visual")
                        if visual and visual:FindFirstChild("Name") and visual.Name == "Fall Leaf" then
                            CollectPickup:FireServer(model.Name)
                            leafCount += 1
                        end
                    end

                    if leafCount > 0 then
                        print("[🍁] Collected " .. leafCount .. " Fall Leaf pickup(s) from workspace.")
                    end
                end
                task.wait(1)
            end
        end)

        SpawnPickups.OnClientEvent:Connect(function(pickupList)
            if _G.AutoCollectAutumnLeaves then
                for _, pickup in pairs(pickupList) do
                    if pickup.Visual == "Fall Leaf" and pickup.Id then
                        print("[🍁] New Fall Leaf spawned with ID:", pickup.Id)
                        CollectPickup:FireServer(pickup.Id)
                    end
                end
            end
        end)
    end







    function SpinAutumnWheel()
        while _G.AutoSpinAutumnWheel do
            pcall(function()
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteFunction:InvokeServer("AutumnWheelSpin")
            end)
            pcall(function()
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimAutumnWheelSpinQueue")
            end)
            task.wait(0.3)
        end
    end

    function AutoBuyAutumnShop()
        while _G.AutoBuyAutumnShop do
            local Remote = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent
            pcall(function()
                Remote:FireServer("BuyShopItem", "autumnnorm-shop", 1, true)
                Remote:FireServer("BuyShopItem", "autumnnorm-shop", 2, true)
                Remote:FireServer("BuyShopItem", "autumnnorm-shop", 3, true)
            end)
            task.wait(1) 
        end
    end










-- Main Tab
    local MainTab = Window:MakeTab({
        Name = "🏠 Main",
        PremiumOnly = false
    })

    MainTab:AddLabel("By RdotA")

    local supportedSection = MainTab:AddSection({
        Name = "Supported Games"
    })

    supportedSection:AddLabel("• Bubble Gum Simulator INFINITY")
    supportedSection:AddLabel("• More to come soon!")
    supportedSection:AddLabel("• V.1.0")



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
            _G.AutoCollectAutumnLeaves = false
            _G.AutoSpinAutumnWheel = false 
            _G.AutoBuyAutumnShop = false

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
            _G.AutoCollectAutumnLeaves = false
            _G.AutoSpinAutumnWheel = false
            _G.AutoBuyAutumnShop = false


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

    local pickupSection = FarmingTab:AddSection({
        Name = "Auto Pick Up Currency"
    })

    pickupSection:AddToggle({
        Name = "Auto Collect Autumn Leaves",
        Default = false,
        Callback = function(Value)
            _G.AutoCollectAutumnLeaves = Value

            if Value then ListenForFallLeafPickups() end

            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Collect Autumn Leafs: " .. (Value and "Enabled" or "Disabled"),
                Time = 3
            })

            print("[🍁] Auto Collect Autumn Leaves: " .. (Value and "ENABLED" or "DISABLED"))
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
        Name = "Hide Hatch Animation (Broken)",
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

-- Shop Tab
    local ShopTab = Window:MakeTab({
        Name = "🛒 Shop",
        PremiumOnly = false
    })

    ShopTab:AddToggle({
        Name = "Auto Buy Autumn Shop",
        Default = false,
        Callback = function(Value)
            _G.AutoBuyAutumnShop = Value
            if Value then task.spawn(AutoBuyAutumnShop) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Buy Autumn Shop: "..(Value and "Enabled" or "Disabled"),
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

    MiscTab:AddToggle({
        Name = "Auto Spin Autumn Wheel",
        Default = false,
        Callback = function(Value)
            _G.AutoSpinAutumnWheel = Value
            if Value then task.spawn(SpinAutumnWheel) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Spin Autumn Wheel: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })











































































































































-- Start Fall Leaf listener (only once)
    ListenForFallLeafPickups()


-- Initialize GUI
    OrionLib:Init()
end
