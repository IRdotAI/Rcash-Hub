if game.PlaceId == 85896571713843 then
    
    -- Load the Discord Library
    local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

    -- Initial load notification
    game:GetService("StarterGui"):SetCore("SendNotification",{
	    Title = "Rcash Hub 💸",
	    Text = "Script Successfully loaded and initialized.",
	    Icon = "rbxassetid://82088779453504"
    })

-- Global Toggles
    _G.AutoBlowBubbles = false
    _G.AutoHatch = false
    _G.AutoCS = false
    _G.SelectedEgg = ""
    _G.AutoClaimPTR = false
    _G.AutoMysteryBox = false
    _G.AutoSeasonEgg = false
    _G.HideHatchAnim = false
    _G.SpamE = false
    _G.AutoCollectPickups = false
    _G.AutoCollectFreeGifts = false
    _G.AutoOpenDailyRewards = false
    _G.AutoSpinAutumnWheel = false
    _G.AutoBuyAutumnShop = false
    _G.AutoEquipBest = false
    _G.AutoSellPets = false
    _G.AutoObby = false


-- Data Tables
    local EggModelMap = {
        ["Candle Egg"] = "Candle Egg",
        ["Autumn Egg"] = "Autumn Egg",
        ["Developer Egg"] = "Rcash_DevEgg_Marker", -- Special search marker
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

    local EggDisplayNames = {}
    for displayName in pairs(EggModelMap) do
        table.insert(EggDisplayNames, displayName)
    end


-- Get Services
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
    local RemoteFunction = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteFunction
    local VirtualInputManager = game:GetService("VirtualInputManager")


-- CORE FUNCTIONS

    function AutoBlowBubbles()
        while _G.AutoBlowBubbles do
            RemoteEvent:FireServer("BlowBubble")
            task.wait(0.3)
        end
    end

    function AutoHatch()
        while _G.AutoHatch do
            if _G.SelectedEgg ~= "" then
                RemoteEvent:FireServer("HatchEgg",_G.SelectedEgg,15) -- Hatch 15 at a time
            end
            task.wait(0.3)
        end
    end

    function AutoEquipBest()
        while _G.AutoEquipBest do
            RemoteEvent:FireServer("EquipBestPets")
            task.wait(5) 
        end
    end

    function AutoSellPets() 
        while _G.AutoSellPets do
            RemoteEvent:FireServer("SellPets")
            task.wait(5)
        end
    end

    function SpamEKey()
        while _G.SpamE do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.001) 
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.001)
        end
    end

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

local function TweenTo(Position, Speed)
    local CFrameValue = Instance.new("CFrameValue");

    CFrameValue.Value = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameValue.Value;
    end);

    game:GetService("TweenService"):Create(CFrameValue, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Value = Position}):Play();
end;
    
    function AutoPickupLoop()
        -- Continuous loop to collect pickups
        while true do
            if _G.AutoPickupAll then
                pcall(CollectPickups)
            end
            task.wait(0.5)
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
                end
            end
        end)
    end

    -- TELEPORT FUNCTION (CRITICAL FIX: Using DiscordLib/StarterGui notifications)
    function TeleportToEgg(EggName)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HRP then return end

        local TargetModelName = EggModelMap[EggName] or EggName
        local EggModel = nil
    
        if TargetModelName == "Rcash_DevEgg_Marker" then
            -- Special logic for Developer Egg (closest match search)
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
            -- Standard search logic
            local GenericFolder = Workspace:FindFirstChild("Rendered") and Workspace.Rendered:FindFirstChild("Generic")
            if GenericFolder then
                EggModel = GenericFolder:FindFirstChild(TargetModelName) 
            end
            if not EggModel then
                EggModel = Workspace:FindFirstChild(TargetModelName, true) 
            end
        end

        if EggModel and (EggModel:IsA("Model") or EggModel:IsA("BasePart")) then
            local EggCFrame
            if EggModel:IsA("Model") then
                EggCFrame = EggModel.PrimaryPart and EggModel.PrimaryPart.CFrame or EggModel:GetPivot()
            else
                EggCFrame = EggModel.CFrame
            end

            HRP.CFrame = EggCFrame * CFrame.new(5, 3, 0) 
        
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rcash Hub 💸",
                Text = "Teleported to: " .. EggName,
                Duration = 3
            })
        else
            DiscordLib:Notification("Rcash Hub 💸", "Error: Could not find model for " .. EggName, "Okay!")
        end
    end
    
    -- MISC FUNCTIONS
    
    function AutoCS()
        while _G.AutoCS do
            RemoteEvent:FireServer("ClaimSeason")
            task.wait(0.5)
        end
    end

    function AutoClaimPTR()
        while _G.AutoClaimPTR do
            RemoteEvent:FireServer("ClaimAllPlaytime")
            task.wait(30) 
        end
    end

    function AutoMysteryBox()
        while _G.AutoMysteryBox do
            RemoteEvent:FireServer("UseGift","Mystery Box",25)
            task.wait(0.3)
        end
    end

    function AutoSeasonEgg()
        while _G.AutoSeasonEgg do
            RemoteEvent:FireServer("HatchPowerupEgg","Season 8 Egg",1)
            task.wait(0.5)
        end
    end

    function SpinAutumnWheel()
        while _G.AutoSpinAutumnWheel do
            pcall(function()
                RemoteFunction:InvokeServer("AutumnWheelSpin")
            end)
            pcall(function()
                RemoteEvent:FireServer("ClaimAutumnWheelSpinQueue")
            end)
            task.wait(0.3)
        end
    end

    function AutoBuyAutumnShop()
        while _G.AutoBuyAutumnShop do
            pcall(function()
                RemoteEvent:FireServer("BuyShopItem", "autumnnorm-shop", 1, true)
                RemoteEvent:FireServer("BuyShopItem", "autumnnorm-shop", 2, true)
                RemoteEvent:FireServer("BuyShopItem", "autumnnorm-shop", 3, true)
            end)
            task.wait(1) 
        end
    end

    -- Obby Functions (Requires LocalData and Obby paths, simplified calls)
    
    local function AutoObbyLoop()
        -- NOTE: Full Auto Obby requires complex pathfinding/cooldown tracking.
        -- This provides the loop but may need refinement for specific game versions.
        while _G.AutoObby do
            DiscordLib:Notification("Rcash Hub 💸", "Auto Obby is running. (Manual Obby logic needed)", "Okay!")
            task.wait(10)
        end
    end

-- DiscordLib UI Setup

    local win = DiscordLib:Window("Rcash Hub 💸 | BGSI")

-- Main Server
    local MainServer = win:Server("Main", "")

    local InfoChannel = MainServer:Channel("Information")
    InfoChannel:Label("By RdotA - V.1.0")
    InfoChannel:Seperator()
    InfoChannel:Label("Supported Game: Bubble Gum Simulator INFINITY")

    local ServerChannel = MainServer:Channel("Server Utilities")
    
    ServerChannel:Button("Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)
    
    ServerChannel:Button("Destroy GUI", function()
        -- Stop all global toggles (CRITICAL for safe destruction)
        for name, value in pairs(_G) do
            if type(value) == "boolean" and name:find("Auto") then
                _G[name] = false
            end
        end
        DiscordLib:Notification("Rcash Hub 💸", "GUI destroyed. All toggles stopped.", "Okay!")
        win:Destroy()
    end)
    
    -- New Support Channel
    local SupportChannel = MainServer:Channel("Support and Help")
    SupportChannel:Label("Links for support and community.")
    SupportChannel:Seperator()
    SupportChannel:Button("Join Discord", function()
        setclipboard("https://discord.gg/JQFrBajQxW")
        DiscordLib:Notification("Rcash Hub 💸", "Discord link copied to clipboard!", "Okay!")
    end)
    SupportChannel:Button("Support on Patreon", function()
        setclipboard("https://patreon.com/RdotA?utm_medium=unknown&utm_source=join_link&utm_campaign=creatorshare_creator&utm_content=copyLink")
        DiscordLib:Notification("Rcash Hub 💸", "Patreon link copied to clipboard!", "Okay!")
    end)


-- Pets Server
    local PetsServer = win:Server("Pets", "")
    
    local ManagementChannel = PetsServer:Channel("Management")

    ManagementChannel:Toggle("Auto Equip Best Pets", false, function(Value)
        _G.AutoEquipBest = Value
        if Value then task.spawn(AutoEquipBest) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Equip Best Pets: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)
    
    ManagementChannel:Toggle("Auto Sell Unused Pets", false, function(Value)
        _G.AutoSellPets = Value
        if Value then task.spawn(AutoSellPets) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Sell Pets: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    local HatchingChannel = PetsServer:Channel("Hatching")
    
    HatchingChannel:Label("Select egg to teleport/hatch.")
    
    -- Dropdown linked to the TeleportToEgg function and _G.SelectedEgg
    HatchingChannel:Dropdown("Select Egg to Teleport/Hatch", EggDisplayNames, function(Value)
        _G.SelectedEgg = Value
        TeleportToEgg(Value)
    end)


    HatchingChannel:Toggle("Auto Hatch Egg", false, function(Value)
        _G.AutoHatch = Value
        
        if Value then
            if _G.SelectedEgg ~= "" then
                TeleportToEgg(_G.SelectedEgg) -- Teleport before starting hatch loop
            end
            task.spawn(AutoHatch) 
        end
        
        DiscordLib:Notification("Rcash Hub 💸", "Auto Hatch: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    HatchingChannel:Toggle("Spam E Key (For Obbies/UI)", false, function(Value)
        _G.SpamE = Value
        if Value then
            task.spawn(SpamEKey)
        end
        DiscordLib:Notification("Rcash Hub 💸", "Spam E: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    HatchingChannel:Toggle("Hide Hatch Animation", false, function(Value)
        _G.HideHatchAnim = Value
        DiscordLib:Notification("Rcash Hub 💸", "Hide Hatch Animation: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

-- Farming Server
    local FarmingServer = win:Server("Farming", "")
    
    local AutoFarmingChannel = FarmingServer:Channel("Auto Farming")
    AutoFarmingChannel:Toggle("Auto Blow Bubbles", false, function(Value)
        _G.AutoBlowBubbles = Value
        if Value then task.spawn(AutoBlowBubbles) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Blow Bubbles: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)
    
    AutoFarmingChannel:Toggle("Auto Collect Pickups (Item Magnet)", false, function(Value)
        DiscordLib:Notification("Rcash Hub 💸", "Auto Collect Pickups: " .. (Value and "Enabled" or "Disabled"), "Okay!")
        _G.AutoCollectPickups = Value;
        task.spawn(function()
            while _G.AutoCollectPickups do
                CollectPickups();
                task.wait(1);
            end;
        end);
    end;)
        
    

    FarmingServer:Channel("Auto Obby"):Toggle("Auto Complete Obbies", false, function(Value)
        _G.AutoObby = Value
        if Value then task.spawn(AutoObbyLoop) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Obbies: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

-- Current Events Server
    local EventsServer = win:Server("Current Events", "")

    -- AUTUMN EVENT Channel (MOVED)
    local AutumnEventChannel = EventsServer:Channel("Autumn Event")
    AutumnEventChannel:Toggle("Auto Spin Autumn Wheel", false, function(Value)
        _G.AutoSpinAutumnWheel = Value
        if Value then task.spawn(SpinAutumnWheel) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Spin Autumn Wheel: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    AutumnEventChannel:Toggle("Auto Buy Autumn Shop", false, function(Value)
        _G.AutoBuyAutumnShop = Value
        if Value then task.spawn(AutoBuyAutumnShop) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Buy Autumn Shop: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

-- Misc Server
    local MiscServer = win:Server("Misc", "")

    -- REWARDS Channel 
    local RewardsChannel = MiscServer:Channel("Rewards")
    RewardsChannel:Toggle("Auto Claim Play Time Rewards", false, function(Value)
        _G.AutoClaimPTR = Value
        if Value then task.spawn(AutoClaimPTR) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Claim Play Time Rewards: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    RewardsChannel:Toggle("Auto Claim Season Rewards", false, function(Value)
        _G.AutoCS = Value
        if Value then task.spawn(AutoCS) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Claim Season: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    -- AUTOMATION Channel 
    local AutomationChannel = MiscServer:Channel("Automation")
    AutomationChannel:Toggle("Auto Open Mystery Box", false, function(Value)
        _G.AutoMysteryBox = Value
        if Value then task.spawn(AutoMysteryBox) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Open Mystery Box: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

    AutomationChannel:Toggle("Auto Hatch Season Egg", false, function(Value)
        _G.AutoSeasonEgg = Value
        if Value then task.spawn(AutoSeasonEgg) end
        DiscordLib:Notification("Rcash Hub 💸", "Auto Hatch Season Egg: " .. (Value and "Enabled" or "Disabled"), "Okay!")
    end)

-- Startup Logic
    -- Start continuous listeners/loops
    task.spawn(HideHatchAnim) 
    task.spawn(AutoPickupLoop) 

end
