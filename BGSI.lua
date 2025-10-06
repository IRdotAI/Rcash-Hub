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
    _G.AutoPickupAll = false
    _G.AutoSpinAutumnWheel = false
    _G.AutoBuyAutumnShop = false
    _G.AutoObby = false
    _G.AutoEquipBest = false
    _G.AutoSellPets = false

-- Console Logging Feature Start

    local MaxConsoleLines = 40 -- Max number of logs to display
    local ConsoleOutput = {"[SYSTEM] Console UI initialised. (V5)"} 
    local ConsoleUILabel = nil -- Will hold the reference to the GUI element for updating
    local LogService = game:GetService("LogService")

    -- CRITICAL FIX: Removed the messageType argument as some executors/APIs do not pass it, causing an error.
    -- We will rely on the LogService hook capturing prints and errors, which only pass 'message'.
    local function LogMessage(message)
        local timeStamp = os.date("%H:%M:%S")
        local prefix = "[INFO]" -- Default prefix, as we can't reliably determine the type

        -- Use tostring() to safely handle cases where 'message' might be a table or an object
        local formattedMessage = string.format("[%s] %s %s", timeStamp, prefix, tostring(message))

        -- Add the new message to the start of the array
        table.insert(ConsoleOutput, 1, formattedMessage)

        -- Keep the array trimmed to the maximum line count
        while #ConsoleOutput > MaxConsoleLines do
            table.remove(ConsoleOutput, #ConsoleOutput)
        end
    end

    -- Hook the game's logging service
    LogService.MessageOut:Connect(LogMessage)



    local EggModelMap = {
        ["Candle Egg"] = "Candle Egg",
        ["Autumn Egg"] = "Autumn Egg",
        ["Developer Egg"] = "Rcash_DevEgg_Marker",
        ["Infinity Egg"] = "Infinity Egg", 
        ["Common Egg"] = "Common Egg", 
        ["Spotted Egg"] = "Spotted Egg", 
        ["Iceshard Egg"] = "Iceshard Egg", 
        ["Inferno Egg"] = "Inferno Egg", 
        ["Spikey Egg"] = "Spikey Egg", 
        ["Magma Egg"] = "Magma Egg", 
        ["Crystal Egg"] = "Crystal Egg", 
        ["Lunar Egg"] = "Lunar Egg", 
        ["Void Egg"] = "Void Egg", 
        ["Hell Egg"] = "Hell Egg", 
        ["Nightmare Egg"] = "Nightmare Egg", 
        ["Rainbow Egg"] = "Rainbow Egg", 
        ["Showman Egg"] = "Showman Egg", 
        ["Mining Egg"] = "Mining Egg", 
        ["Cyber Egg"] = "Cyber Egg", 
        ["Neon Egg"] = "Neon Egg", 
        ["Chance Egg"] = "Chance Egg", 
        ["Icy Egg"] = "Icy Egg", 
        ["Vine Egg"] = "Vine Egg", 
        ["Lava Egg"] = "Lava Egg", 
        ["Secret Egg"] = "Secret Egg", 
        ["Atlantis Egg"] = "Atlantis Egg", 
        ["Classic Egg"] = "Classic Egg"
    }

-- Functions

    local function UpdateConsoleUI()
        while true do
            if ConsoleUILabel then
                -- Concatenate the stored messages with newlines (in reverse order for oldest at bottom)
                local consoleText = table.concat(ConsoleOutput, "\n")
            
                -- Safely update the content of the Orion Paragraph/Label
                pcall(function()
                    ConsoleUILabel:set(consoleText)
                end)
            end
            task.wait(0.1) -- Update every 0.1 seconds for real-time viewing
        end
    end

    function AutoBlowBubbles()
        while _G.AutoBlowBubbles do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("BlowBubble")
            task.wait(0.3)
        end
    end

    function AutoHatch()
        while _G.AutoHatch do
            if _G.SelectedEgg ~= "" then
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchEgg",_G.SelectedEgg,6)
            end
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

    function AutoEquipBest()
        while _G.AutoEquipBest do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("EquipBestPets")
            task.wait(5) 
        end
    end

    function HideHatchAnim()
        local player = game.Players.LocalPlayer
        local PlayerGui = player:WaitForChild("PlayerGui")
        
        PlayerGui.ChildAdded:Connect(function(child)

            if _G.HideHatchAnim and child.Name:lower():match("hatch") then
                
                if child.Name == "Hatching" or child.Name:lower():match("hatch") then
                    task.wait(0.01)
                    child:Destroy()
                    print("[PETS] Successfully destroyed hatch animation GUI: " .. child.Name)
                end
            end
        end)
    end

    function SpamEKey()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        while _G.SpamE do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05) 
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.05)
        end
    end


    for i, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
        v:Disable();
    end;

    local function CollectPickups()
        for i, v in next, game:GetService("Workspace").Rendered:GetChildren() do
            if v.Name == "Chunker" then
                for i2, v2 in next, v:GetChildren() do
                    local Part, HasMeshPart = v2:FindFirstChild("Part"), v2:FindFirstChildWhichIsA("MeshPart");
                    local HasStars = Part and Part:FindFirstChild("Stars");
                    local HasPartMesh = Part and Part:FindFirstChild("Mesh");
                    if HasMeshPart or HasStars or HasPartMesh then
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup"):FireServer(v2.Name);
                        v2:Destroy();
                    end;
                end;
            end;
        end;
    end;

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


    local DIFFICULTIES_TO_CYCLE = { "Easy", "Medium", "Hard" }
    local TELEPORT_DELAY = 2.5


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

    function AutoSellPets() 
        while _G.AutoSellPets do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("SellPets")
            task.wait(5)
        end
    end

    function TeleportToEgg(EggName)
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
        local Workspace = game:GetService("Workspace")

        if not HRP then return end

        local TargetModelName = EggModelMap[EggName] or EggName
        local EggModel = nil
    
        if TargetModelName == "Rcash_DevEgg_Marker" then
            local foundEgg = nil
            local closestDistance = math.huge
        
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    if string.find(obj.Name:lower(), "dev", 1, true) or string.find(obj.Name:lower(), "egg", 1, true) then
                        local eggPosition = obj:IsA("Model") and obj:GetPivot().p or obj.Position
                        local distance = (eggPosition - HRP.Position).Magnitude
                    
                        if distance < closestDistance and distance < 1000 then
                            closestDistance = distance
                            foundEgg = obj
                        end
                    end
                end
            end
        
            EggModel = foundEgg
        
        else
        
            -- 1. PRIORITY SEARCH 1: Check the Rendered.Generic path (For Event Eggs)
            local GenericFolder = Workspace:FindFirstChild("Rendered") and Workspace.Rendered:FindFirstChild("Generic")
            if GenericFolder then
                EggModel = GenericFolder:FindFirstChild(TargetModelName) 
            end
        
            -- 2. FALLBACK SEARCH: Search the entire workspace recursively (For World Eggs)
            if not EggModel then
                EggModel = Workspace:FindFirstChild(TargetModelName, true) 
            end
        end


        if EggModel and (EggModel:IsA("Model") or EggModel:IsA("BasePart")) then
            local EggCFrame
            if EggModel:IsA("Model") then
                local PrimaryPart = EggModel.PrimaryPart or EggModel:FindFirstChildOfClass("BasePart") 
                EggCFrame = PrimaryPart and PrimaryPart.CFrame or EggModel:GetPivot()
            else
                EggCFrame = EggModel.CFrame
            end

            HRP.CFrame = EggCFrame * CFrame.new(5, 3, 0) 
        
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Teleported to: " .. EggName,
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Error: Could not find model for **" .. EggName .. "** in the game.",
                Time = 5
            })
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

    FarmTab:AddToggle({
        Name = "Auto Collect Pickups (Item Magnet)",
        Default = false,
        Callback = function(Value)
            _G.AutoPickupAll = Value
            if Value then 
                task.spawn(CollectPickups) -- Starts the loop while _G.AutoPickupAll is true
            end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Collect Pickups: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
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

    local PetsSection = PetsTab:AddSection({
        Name = "Pets Management"
    })

    PetsSection:AddToggle({
        Name = "Auto Equip Best Pets",
        Default = false,
        Callback = function(Value)
            _G.AutoEquipBest = Value
            if Value then task.spawn(AutoEquipBest) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Equip Best Pets: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })
    
    PetsSection:AddToggle({
        Name = "Auto Sell Unused Pets (Requires Auto Equip Best)",
        Default = false,
        Callback = function(Value)
            _G.AutoSellPets = Value
            if Value then task.spawn(AutoSellPets) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Sell Pets: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    local EggsSection = PetsTab:AddSection({
        Name = "Egg Hatching"
    })
    
    EggsSection:AddLabel("Select an egg to teleport, then enable Auto Hatch.")


    local EggCategories = {
        ["World 1 Eggs"] = {"Common Egg", "Spotted Egg", "Iceshard Egg", "Inferno Egg", "Spikey Egg", "Magma Egg", "Crystal Egg", "Lunar Egg", "Void Egg", "Hell Egg", "Nightmare Egg", "Rainbow Egg"},
        ["World 2 Eggs"] = {"Showman Egg", "Mining Egg", "Cyber Egg", "Neon Egg", "Chance Egg"},
        ["World 3 Eggs"] = {"Icy Egg", "Vine Egg", "Lava Egg", "Secret Egg", "Atlantis Egg", "Classic Egg"},
        ["Event Eggs"] = {"Candle Egg", "Autumn Egg", "Developer Egg", "Infinity Egg"}
    }
    
    local AllEggs = {}
    for _, eggList in pairs(EggCategories) do
        for _, eggName in ipairs(eggList) do
            table.insert(AllEggs, eggName)
        end
    end

    EggsSection:AddDropdown({
        Name = "Select Egg to Teleport/Hatch",
        Default = _G.SelectedEgg,
        Options = AllEggs,
        Callback = function(Value)
            _G.SelectedEgg = Value
            TeleportToEgg(Value)
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Selected Egg: "..Value,
                Time = 3
            })
        end
    })


    EggsSection:AddToggle({
        Name = "Auto Hatch Egg",
        Default = false,
        Callback = function(Value)
            _G.AutoHatch = Value
            
            if Value then
                if _G.SelectedEgg ~= "" then
                    TeleportToEgg(_G.SelectedEgg) 
                end
                task.spawn(AutoHatch) 
            end
            
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Hatch: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    EggsSection:AddToggle({
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


    EggsSection:AddToggle({
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

-- Console Tab
    local ConsoleTab = Window:MakeTab({
        Name = "💻 Console",
        PremiumOnly = false
    })

    ConsoleTab:AddLabel("Live Script Output (Mobile Console) - Scrollable:")

    local ConsoleContainer = ConsoleTab:AddParagraph({
        Name = "Script Log Viewer",
        Content = table.concat(ConsoleOutput, "\n"), -- Set initial content
    })

    ConsoleUILabel = ConsoleContainer

-- STARTUP LOGIC
    -- Start the Hide Hatch listener
    task.spawn(HideHatchAnim) 

    -- Start the continuous Auto Pickup background loop (waits for _G.AutoPickupAll to be true)
    task.spawn(AutoPickupAll)

    -- Start the Console UI updating loop
    task.spawn(UpdateConsoleUI)

-- Initialize GUI
    OrionLib:Init()


end
