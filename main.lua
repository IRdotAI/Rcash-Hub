if game.PlaceId == 85896571713843 then
-- Load Orion GUI
    local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

-- Create main window
    local Window = OrionLib:MakeWindow({
        Name = "Rcash Hub 💸 | BGSI",
        HidePremium = false,
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
    _G.AutoObby = false
    _G.WebhookURL = ""
    _G.WebhookPing = false
    _G.WebhookUsername = ""
    _G.WebhookMinRarity = "Common"




-- Functions
    function AutoBlowBubbles()
        while _G.AutoBlowBubbles do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("BlowBubble")
            task.wait(0.3)
        end
    end

    function AutoHatch()
        while _G.AutoHatch do
            if _G.SelectedEgg == "" then
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Please select an egg first!",
                    Time = 3
                })
                return
            end

            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Network = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent

            Network:FireServer("HatchEgg", _G.SelectedEgg, 6)
            task.wait(0.3)
        end
    end

    local Player = game.Players.LocalPlayer
    local Inventory = Player:WaitForChild("Inventory")

    if not Inventory:FindFirstChild("WebhookListener") then
        local marker = Instance.new("BoolValue")
        marker.Name = "WebhookListener"
        marker.Parent = Inventory

        Inventory.ChildAdded:Connect(function(pet)
            local rarity = pet:FindFirstChild("Rarity") and pet.Rarity.Value or "Unknown"
            local rarities = {"Common","Unique","Rare","Epic","Legendary","Secret","Infinity"}
            local minIndex = table.find(rarities, _G.WebhookMinRarity) or 1
            local petIndex = table.find(rarities, rarity) or 0
            if petIndex >= minIndex then
                sendWebhook(pet.Name, rarity)
            end
        end)
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


    local ENABLED = true
    local DIFFICULTIES_TO_CYCLE = { "Easy", "Medium", "Hard" }
    local TELEPORT_DELAY = 2.5

    if not ENABLED then return end

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer

    local LocalData = require(ReplicatedStorage.Client.Framework.Services.LocalData)
    local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
    local ObbysFolder = Workspace.Obbys
    local ObbyTeleports = Workspace.Worlds["Seven Seas"].Areas["Classic Island"].Obbys

    local function teleportTo(target)
        local character = LocalPlayer.Character
        if not character or not target then return end
        local targetCFrame
        if typeof(target) == "CFrame" then
            targetCFrame = target
        elseif target:IsA("BasePart") then
            targetCFrame = target.CFrame
        elseif target:IsA("Model") then
            targetCFrame = target:GetPivot()
        end
        if targetCFrame then
            character:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
        end
    end

    local function runObbyCycle(difficulty)
        print("Starting obby: " .. difficulty)
        local teleportPart = ObbyTeleports:FindFirstChild(difficulty) 
            and ObbyTeleports[difficulty]:FindFirstChild("Portal") 
            and ObbyTeleports[difficulty].Portal:FindFirstChild("Part")
        local completePart = ObbysFolder:FindFirstChild(difficulty) and ObbysFolder[difficulty]:FindFirstChild("Complete")
        if not teleportPart or not completePart then
            return
        end
        teleportTo(teleportPart)
        task.wait(0.5)
        RemoteEvent:FireServer("StartObby", difficulty)
        task.wait(TELEPORT_DELAY)
        teleportTo(completePart)
        task.wait(0.5)
        RemoteEvent:FireServer("CompleteObby")
        task.wait(0.5)
        RemoteEvent:FireServer("ClaimObbyChest")
        task.wait(2)
    end

    function AutoObbyCycle()
        task.spawn(function()
            while _G.AutoObby do
                local character = LocalPlayer.Character
                local playerData = LocalData:Get()
                if not character or not character.PrimaryPart or not playerData or not playerData.ObbyCooldowns then
                    task.wait(1)
                    continue
                end
                local initialPosition = character.PrimaryPart.CFrame
                local completedAnObbyInCycle = false
                for _, difficulty in ipairs(DIFFICULTIES_TO_CYCLE) do
                    local cooldownEndTime = playerData.ObbyCooldowns[difficulty] or 0
                    if os.time() >= cooldownEndTime then
                        runObbyCycle(difficulty)
                        completedAnObbyInCycle = true
                        task.wait(3)
                        playerData = LocalData:Get()
                        if not playerData or not playerData.ObbyCooldowns then break end
                    end
                end
                if completedAnObbyInCycle then
                    teleportTo(initialPosition)
                end
                playerData = LocalData:Get()
                if not playerData or not playerData.ObbyCooldowns then
                    task.wait(1)
                    continue
                end
                local nextAvailableTime = math.huge
                for _, difficulty in ipairs(DIFFICULTIES_TO_CYCLE) do
                    local cooldownEndTime = playerData.ObbyCooldowns[difficulty] or 0
                    if cooldownEndTime > os.time() and cooldownEndTime < nextAvailableTime then
                        nextAvailableTime = cooldownEndTime
                    end
                end
                if nextAvailableTime ~= math.huge then
                    local timeToWait = nextAvailableTime - os.time()
                    if timeToWait > 0 then
                        print("All obbies are on cooldown. Next check in " .. timeToWait .. " seconds.")
                        task.wait(timeToWait)
                    end
                end
            end
        end)
    end

    local HttpService = game:GetService("HttpService")

    function sendWebhook(petName, petRarity)
        if _G.WebhookURL == "" then return end
        local content = ""
        if _G.WebhookPing and _G.WebhookUsername ~= "" then
            content = string.format("<@%s> hatched a %s [%s]!", _G.WebhookUsername, petName, petRarity)
        else
            content = string.format("%s hatched a %s [%s]!", _G.WebhookUsername ~= "" and _G.WebhookUsername or "Someone", petName, petRarity)
        end
        local data = { content = content }
        pcall(function()
            HttpService:PostAsync(_G.WebhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)
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
        Name = "Copy Discord Link",
        Callback = function()
            setclipboard("https://discord.gg/JQFrBajQxW")
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Discord invite copied to clipboard!",
                Time = 3
            })
        end
    })

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

    local World1Section = FarmingTab:AddSection({
        Name = "World 1"
    })

    local World2Section = FarmingTab:AddSection({
        Name = "World 2"
    })

    local World3Section = FarmingTab:AddSection({
        Name = "World 3"
    })

    World3Section:AddToggle({
        Name = "Auto Complete Obbies (Use Auto Spam E in pets tab)",
        Default = false,
        Callback = function(Value)
            _G.AutoObby = Value
            if Value then AutoObbyCycle() end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Obbies: "..(Value and "Enabled" or "Disabled"),
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





-- Webhooks Tab
    local WebhooksTab = Window:MakeTab({
        Name = "🌐 Webhooks",
        PremiumOnly = false
    })

    WebhooksTab:AddLabel("Set up Discord webhooks for pet hatching notifications.")

    WebhooksTab:AddTextbox({
        Name = "Webhook URL",
        Default = _G.WebhookURL,
        TextDisappear = false,
        Callback = function(Value)
            _G.WebhookURL = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Webhook URL set.",
                Time = 3
            })
        end
    })

    WebhooksTab:AddTextbox({
        Name = "Username (for mentions)",
        Default = _G.WebhookUsername,
        TextDisappear = false,
        Callback = function(Value)
            _G.WebhookUsername = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Webhook Username set.",
                Time = 3
            })
        end
    })

    WebhooksTab:AddDropdown({
        Name = "Minimum Rarity to Notify",
        Default = _G.WebhookMinRarity,
        Options = {"Common", "Unique", "Rare", "Epic", "Legendary", "Secret", "Infinity"},
        Callback = function(Value)
            _G.WebhookMinRarity = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Webhook Minimum Rarity set to "..Value,
                Time = 3
            })
        end
    })

    WebhooksTab:AddToggle({
        Name = "Ping on Notification",
        Default = _G.WebhookPing,
        Callback = function(Value)
            _G.WebhookPing = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Webhook Ping: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    WebhooksTab:AddButton({
        Name = "Test Webhook",
        Callback = function()
            sendWebhook("TestPet", "Legendary")
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Test webhook sent!",
                Time = 3
            })
        end
    })





























































































































-- Start Fall Leaf listener (only once)
    ListenForFallLeafPickups()


-- Initialize GUI
    OrionLib:Init()
end
