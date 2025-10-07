if game.PlaceId == 85896571713843 then
-- UI Library (Fluent-Renewed)
    local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
    local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
    local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- Window
    local Window = Library:CreateWindow{
        Title = "Rcash Hub 💸 | BGSI",
        SubTitle = "By RdotA",
        TabWidth = 160,
        Size = UDim2.fromOffset(830, 525),
        Resize = true,
        MinSize = Vector2.new(470, 380),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    }

-- Loaded Notification
    Library:Notify{
        Title = "Rcash Hub 💸",
        Content = "Loaded successfully!",
        Duration = 5
    }

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


-- Tabs
    local Tabs = {
        Main = Window:CreateTab{
            Title = "Main",
            Icon = "user"
        },

        Farming = Window:CreateTab{
            Title = "Farming",
            Icon = "leaf"
        },

        Pets = Window:CreateTab{
            Title = "Pets",
            Icon = "paw-print"
        },

        Shop = Window:CreateTab{
            Title = "Shop",
            Icon = "store"
        },
        Misc = Window:CreateTab{
            Title = "Misc",
            Icon = "plus"
        }

        Console = Window:CreateTab{
            Title = "Console",
            Icon = "terminal"
        }

        Settings = Window:CreateTab{
            Title = "Settings",
            Icon = "cog"
        }
    },

-- Main Tab
    Tabs.Main:CreateParagraph("Aligned Paragraph", {
        Title = "Rcash Hub 💸 | BGSI",
        Content = "Supported Games:\n• Bubble Gum Simulator INFINITY\n• More to Come!\n\n• By RdotA",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    })

    Tabs.Main:CreateButton{
        Title = "Discord",
        Description = "Join the Discord server for support, updates, and more!",
        Callback = function()
            setclipboard("https://discord.gg/JQFrBajQxW")
            Library:Notify{
                Title = "Rcash Hub 💸",
                Content = "Discord link copied to clipboard!",
                Duration = 5
            }
        end
    }

    Tabs.Main:CreateButton{
        Title = "Patreon",
        Description = "Support the development of Rcash Hub by becoming a patron!",
        Callback = function()`
            setclipboard("https://www.patreon.com/rdota")
            Library:Notify{
                Title = "Rcash Hub 💸",
                Content = "Patreon link copied to clipboard!",
                Duration = 5
            }
        end
    }

    Tabs.Main:CreateButton{
        Title = "Rejoin",
        Description = "Rejoin the current game server.",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    }

    Tabs.main:CreateButton{
        Title = "Server Hop",
        Description = "Hop to a different server.",
        Callback = function()
            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local Deleted = false
            function TPReturner()
                local Site;
                if foundAnything == "" then
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                else
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                end
                local ID = ""
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                local num = 0;
                for i,v in pairs(Site.data) do
                    local Possible = true
                    ID = tostring(v.id)
                    if tonumber(v.maxPlayers) > tonumber(v.playing) then
                        for _,Existing in pairs(AllIDs) do
                            if num ~= 0 then
                                if ID == Existing then
                                    Possible = false
                                end
                            else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                    AllIDs = {}
                                    num = 1
                                    break
                                end
                            end
                        end
                        if Possible == true then
                            table.insert(AllIDs, ID)
                            wait()
                            pcall(function()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                            end)
                            wait(4)
                        end
                    end
                end
            end
            function Teleport()
                while wait() do
                    pcall(function()
                        TPReturner()
                        if foundAnything == "" then
                            wait(15)
                        end
                    end)
                end
            end
            Teleport()
        end
    }

    Tabs.Main:CreateButton{
        Title = "Server Info",
        Description = "Copy the current server's info to clipboard.",
        Callback = function()
            local ServerInfo = "Place ID: " .. game.PlaceId .. "\nJob ID: " .. game.JobId .. "\nServer Time (UTC): " .. os.date("!*t").hour .. ":" .. os.date("!*t").min .. ":" .. os.date("!*t").sec
            setclipboard(ServerInfo)
            Library:Notify{
                Title = "Rcash Hub 💸",
                Content = "Server info copied to clipboard!",
                Duration = 5
            }
        end
    }

    Tabs.Main:CreateButton{
        Title = "Destroy GUI",
        Description = "Destroy the GUI and unload the script.",
        Callback = function()
            Library.Notify{
                Title = "Rcash Hub 💸",
                Content = "Unloaded successfully!",
                Duration = 5
            }
            Library:Destroy()
        end
    }

    Tabs.Main:CreateButton{
        Title = "Reload GUI",
        Description = "Reload the GUI.",
        Callback = function()
            Library.Notify{
                Title = "Rcash Hub 💸",
                Content = "Reloading...",
                Duration = 5
            }
            Library:Destroy()
            wait(1)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/refs/heads/main/main.lua"))()
        end
    }

-- Farming Tab
    Tabs.Farming:CreateToggle("AutoBlowBubbles", {
        Title = "Auto Blow Bubbles",
        Default = false,
        Description = "Automatically blow bubbles."
    }):OnChanged(function(state)
        _G.AutoBlowBubbles = state
        if state then
            task.spawn(AutoBlowBubbles)
        end
    end)

    Tabs.Farming:CreateToggle("AutoCollectPickups", {
        Title = "Auto Collect Pickups",
        Default = false,
        Description = "Automatically collect all pickups."
    }):OnChanged(function(state)
        _G.AutoPickupAll = state
        if state then
            task.spawn(function()
                while _G.AutoPickupAll do
                    CollectPickups()
                    task.wait(1)
                end
            end)
        end
    end)

    Tabs.Farming:CreateToggle("Auto Complete Obbies (Use Auto Spam E in pets tab)", {
        Title = "Auto Complete Obbies",
        Default = false,
        Description = "Automatically complete obbies."
    }):OnChanged(function(state)
        _G.AutoObby = state
        if state then
            AutoObbyCycle()
        end
    end)

-- Pets Tab

    Tabs.Pets:CreateParagraph("Pets Manager", { 
        Title = "Pets Manager", 
        Content = "Manage your pets with the options below."
    })

    Tabs.Pets:CreateToggle("AutoEquipBest", {
        Title = "Auto Equip Best Pets",
        Default = false,
        Description = "Automatically equip the best pets."
    }):OnChanged(function(state)
        _G.AutoEquipBest = state
        if state then
            task.spawn(AutoEquipBest)
        end
    end)

    Tabs.Pets:CreateToggle("AutoSellPets", {
        Title = "Auto Sell Pets",
        Default = false,
        Description = "Automatically sell all pets."
    }):OnChanged(function(state)
        _G.AutoSellPets = state
        if state then
            task.spawn(AutoSellPets)
        end
    end)

    Tabs.Pets:CreateParagraph("Hatch Manager", { 
        Title = "Hatch Manager", 
        Content = "Manage your hatching with the options below."
    })

    Tabs.Pets:CreateDropdown("EggSelect", {
        Title = "Select Egg",
        Values = {
            "Candle Egg", "Autumn Egg", "Developer Egg", "Infinity Egg", "Common Egg", "Spotted Egg", 
            "Iceshard Egg", "Inferno Egg", "Spikey Egg", "Magma Egg", "Crystal Egg", "Lunar Egg", 
            "Void Egg", "Hell Egg", "Nightmare Egg", "Rainbow Egg", "Showman Egg", "Mining Egg", 
            "Cyber Egg", "Neon Egg", "Chance Egg", "Icy Egg", "Vine Egg", "Lava Egg", 
            "Secret Egg", "Atlantis Egg", "Classic Egg"
        },
        Multi = false,
        Default = 1,
        Description = "Select the egg you want to hatch."
    }):OnChanged(function(val)
        _G.SelectedEgg = val
    end)

    Tabs.Pets:CreateButton{
        Title = "Teleport to Selected Egg",
        Description = "Teleport to the location of the selected egg.",
        Callback = function()
            if _G.SelectedEgg ~= "" then
                TeleportToEgg(_G.SelectedEgg)
            else
                Library:Notify{
                    Title = "Rcash Hub 💸",
                    Content = "Please select an egg first.",
                    Duration = 5
                }
            end
        end
    }

    Tabs.Pets:CreateToggle("AutoHatch", {
        Title = "Auto Hatch",
        Default = false,
        Description = "Automatically hatch the selected egg."
    }):OnChanged(function(state)
        _G.AutoHatch = state
        if state then
            task.spawn(AutoHatch)
        end
    end)

    Tabs.Pets:CreateToggle("Hide Hatch Animation", {
        Title = "Hide Hatch Animation",
        Default = false,
        Description = "Automatically hide the hatch animation."
    }):OnChanged(function(state)
        _G.HideHatchAnim = state
        if state then
            task.spawn(HideHatchAnim)
        end
    end)

    Tabs.Pets:CreateToggle("Spam E Key (For Obby Completion)", {
        Title = "Spam E Key",
        Default = false,
        Description = "Automatically spam the E key."
    }):OnChanged(function(state)
        _G.SpamE = state
        if state then
            task.spawn(SpamEKey)
        end
    end)

-- Shop Tab
    Tabs.Shop:CreateToggle("AutoBuyAutumnShop", {
        Title = "Auto Buy Autumn Shop Items",
        Default = false,
        Description = "Automatically buy items from the autumn shop."
    }):OnChanged(function(state)
        _G.AutoBuyAutumnShop = state
        if state then
            task.spawn(AutoBuyAutumnShop)
        end
    end)

-- Misc Tab
    Tabs.Misc:CreateToggle("AutoClaimPTR", {
        Title = "Auto Claim Playtime Rewards",
        Default = false,
        Description = "Automatically claim playtime rewards."
    }):OnChanged(function(state)
        _G.AutoClaimPTR = state
        if state then
            task.spawn(AutoClaimPTR)
        end
    end)

    Tabs.Misc:CreateToggle("AutoMysteryBox", {
        Title = "Auto Open Mystery Boxes",
        Default = false,
        Description = "Automatically open mystery boxes."
    }):OnChanged(function(state)
        _G.AutoMysteryBox = state
        if state then
            task.spawn(AutoMysteryBox)
        end
    end)

    Tabs.Misc:CreateToggle("AutoSeasonEgg", {
        Title = "Auto Hatch Season Egg",
        Default = false,
        Description = "Automatically hatch the season egg."
    }):OnChanged(function(state)
        _G.AutoSeasonEgg = state
        if state then
            task.spawn(AutoSeasonEgg)
        end
    end)

    Tabs.Misc:CreateToggle("AutoSpinAutumnWheel", {
        Title = "Auto Spin Autumn Wheel",
        Default = false,
        Description = "Automatically spin the autumn wheel."
    }):OnChanged(function(state)
        _G.AutoSpinAutumnWheel = state
        if state then
            task.spawn(SpinAutumnWheel)
        end
    end)

-- Console Tab
    local ConsoleParagraph = Tabs.Console:CreateParagraph("ConsoleOutput", {
        Title = "Console Output",
        Content = table.concat(ConsoleOutput, "\n"),
        TitleAlignment = "Left",
        ContentAlignment = Enum.TextXAlignment.Left
    })

    ConsoleUILabel = ConsoleParagraph
    task.spawn(UpdateConsoleUI)

-- Settings Tab
    Tabs.Settings:CreateParagraph("SettingsInfo", { 
        Title = "Settings", 
        Content = "Manage your settings with the options below."
    })

    

    









-- Save Manager
    SaveManager:SetLibrary(Library)
    InterfaceManager:SetLibrary(Library)

    SaveManager:IgnoreThemeSettings()

    SaveManager:SetIgnoreIndexes{}

    InterfaceManager:SetFolder("RcashHub")
    SaveManager:SetFolder("RcashHub/BGSI")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)


    Window:SelectTab(1)

    Library:Notify{
    Title = "Rcash Hub 💸",
        Content = "The script has been loaded.",
        Duration = 8
    }

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
    SaveManager:LoadAutoloadConfig()
    







end
