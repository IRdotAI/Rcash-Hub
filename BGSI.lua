if game.PlaceId == 85896571713843 then

--Library
    -- Using the library specified in the original script: dawid-scripts/UI-Libs
    local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

--Window
    local win = DiscordLib:Window(
        "Rcash Hub",                  -- Window Title
        "rbxassetid://82088779453504" 
    )

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
    local ConsoleOutput = {"[SYSTEM] Console UI initialised. (V1.01)"} 
    local ConsoleUILabel = nil -- Will hold the reference to the GUI element for updating
    local LogService = game:GetService("LogService")

    local function LogMessage(message)
        local timeStamp = os.date("%H:%M:%S")
        local prefix = "[INFO]" 

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
                -- Concatenate the stored messages with newlines 
                local consoleText = table.concat(ConsoleOutput, "\n")
            
                -- Safely update the content of the Label (using :set() for this library)
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
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchEgg",_G.SelectedEgg,15)
            end
            task.wait(0.3)
        end
    end

    function AutoCS()
        while _G.AutoCS do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimSeason")
            task.wait(0.1)
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
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchPowerupEgg","Season 8 Egg",1)
            task.wait(0.1)
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
            task.wait(0.001) 
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.001)
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

    function AutoPickupLoop()
        while _G.AutoPickupAll do
            CollectPickups()
            task.wait(0.1)
        end
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
        
            -- Using OrionLib/DiscordLib Notification style
            DiscordLib:Notification("Rcash Hub 💸", "Teleported to: " .. EggName, "Success!")
        else
            DiscordLib:Notification("Rcash Hub 💸", "Error: Could not find model for **" .. EggName .. "** in the game.", "Error!")
        end
    end


-- UI Construction (DiscordLib Structure: Window -> Tab -> Group -> Component)

-- Main Tab
    local tab_main = win:Tab("Main")

    local group_info = tab_main:Group("General Information")

    group_info:Label("By Rdota")
    group_info:Label("Supported Games:\n • Bubble Gum Simulator INFINITY\n • More to come...\n •V1.01")

    group_info:Button("Discord",function()
        setclipboard("https://discord.gg/JQFrBajQxW")
        DiscordLib:Notification("Rcash Hub 💸", "Discord link copied to clipboard!", "Okay!")
    end)

    group_info:Button("Patreon",function()
        setclipboard("https://www.patreon.com/cw/RdotA")
        DiscordLib:Notification("Rcash Hub 💸", "Patreon link copied to clipboard!", "Okay!")
    end)

    group_info:Button("Rejoin Server",function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)

    group_info:Button("Server Hop",function()
        local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        if x and x.data and #x.data > 0 then
            local y = {}
            for i,v in pairs(x.data) do
                if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                    y[#y+1] = v.id
                end
            end
            if #y > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, y[math.random(1, #y)])
            else
                DiscordLib:Notification("Rcash Hub 💸", "No available servers found. Try again.", "Okay!")
            end
        else
            DiscordLib:Notification("Rcash Hub 💸", "Failed to retrieve server list. Try again.", "Okay!")
        end
    end)

    group_info:Button("Destroy GUI",function()
        DiscordLib:Notification("Rcash Hub 💸", "GUI Destroyed. Re-execute script to re-open.", "Okay!")
        DiscordLib:Destroy()
    end)

    group_info:Button("Reload UI",function()
        if DiscordLib then
            DiscordLib:Destroy()
        end
        DiscordLib:Notification("Rcash Hub 💸", "UI Reloaded.", "Okay!")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/main/main.lua"))()
    end)

-- Automation Tab
    local tab_auto = win:Tab("Automation")
    
    -- Auto Hatching Group
    local group_hatch = tab_auto:Group("Auto Hatching")

    group_hatch:Toggle("Auto Hatch", _G.AutoHatch, function(v)
        _G.AutoHatch = v
        if v then
            task.spawn(AutoHatch)
        end
    end)

    group_hatch:Dropdown("Select Egg", EggModelMap, _G.SelectedEgg, function(v)
        _G.SelectedEgg = v
        DiscordLib:Notification("Rcash Hub 💸", "Selected Egg: " .. v, "Info!")
    end)
    
    group_hatch:Toggle("Hide Hatch Animation", _G.HideHatchAnim, function(v)
        _G.HideHatchAnim = v
    end)
    
    group_hatch:Toggle("Auto Season Egg", _G.AutoSeasonEgg, function(v)
        _G.AutoSeasonEgg = v
        if v then
            task.spawn(AutoSeasonEgg)
        end
    end)
    
    -- Pet Utility Group
    local group_pets = tab_auto:Group("Pet Utility")

    group_pets:Toggle("Auto Equip Best Pets", _G.AutoEquipBest, function(v)
        _G.AutoEquipBest = v
        if v then
            task.spawn(AutoEquipBest)
        end
    end)

    group_pets:Toggle("Auto Sell Pets", _G.AutoSellPets, function(v)
        _G.AutoSellPets = v
        if v then
            task.spawn(AutoSellPets)
        end
    end)

    -- Item & Currency Group
    local group_items = tab_auto:Group("Item/Currency")

    group_items:Toggle("Auto Blow Bubbles", _G.AutoBlowBubbles, function(v)
        _G.AutoBlowBubbles = v
        if v then
            task.spawn(AutoBlowBubbles)
        end
    end)

    group_items:Toggle("Auto Pickup All", _G.AutoPickupAll, function(v)
        _G.AutoPickupAll = v
        if v then
            task.spawn(AutoPickupLoop)
        end
    end)

    group_items:Toggle("Auto Claim Playtime Rewards", _G.AutoClaimPTR, function(v)
        _G.AutoClaimPTR = v
        if v then
            task.spawn(AutoClaimPTR)
        end
    end)

    group_items:Toggle("Auto Claim Season Rewards", _G.AutoCS, function(v)
        _G.AutoCS = v
        if v then
            task.spawn(AutoCS)
        end
    end)

    group_items:Toggle("Auto Use Mystery Box (25x)", _G.AutoMysteryBox, function(v)
        _G.AutoMysteryBox = v
        if v then
            task.spawn(AutoMysteryBox)
        end
    end)

-- Event/World Tab
    local tab_event = win:Tab("Events/World")

    local group_event = tab_event:Group("Autumn Event")

    group_event:Toggle("Auto Spin Autumn Wheel", _G.AutoSpinAutumnWheel, function(v)
        _G.AutoSpinAutumnWheel = v
        if v then
            task.spawn(SpinAutumnWheel)
        end
    end)

    group_event:Toggle("Auto Buy Autumn Shop Items", _G.AutoBuyAutumnShop, function(v)
        _G.AutoBuyAutumnShop = v
        if v then
            task.spawn(AutoBuyAutumnShop)
        end
    end)

    local group_world = tab_event:Group("World")

    group_world:Toggle("Spam 'E' Key", _G.SpamE, function(v)
        _G.SpamE = v
        if v then
            task.spawn(SpamEKey)
        end
    end)

    group_world:Toggle("Auto Obby Cycle", _G.AutoObby, function(v)
        _G.AutoObby = v
        if v then
            task.spawn(AutoObbyCycle)
        end
    end)

    local group_teleport = tab_event:Group("Egg Teleports")

    -- Teleport buttons using the TeleportToEgg function
    for EggName, _ in pairs(EggModelMap) do
        group_teleport:Button("TP to "..EggName, function()
            TeleportToEgg(EggName)
        end)
    end
    
-- Console Tab (New Feature)
    local tab_console = win:Tab("Console")
    local group_log = tab_console:Group("System Log Output")

    -- Create the Label and store its reference for the update loop
    ConsoleUILabel = group_log:Label(table.concat(ConsoleOutput, "\n"))


-- Start background loops 
task.spawn(UpdateConsoleUI)
task.spawn(HideHatchAnim)
task.spawn(AutoPickupLoop)
task.spawn(AutoHatch)
task.spawn(AutoBlowBubbles)
task.spawn(AutoCS)
task.spawn(AutoClaimPTR)
task.spawn(AutoMysteryBox)
task.spawn(AutoSeasonEgg)
task.spawn(SpamEKey)
task.spawn(SpinAutumnWheel)
task.spawn(AutoBuyAutumnShop)
task.spawn(AutoObbyCycle)
task.spawn(AutoEquipBest)
task.spawn(AutoSellPets)


end
