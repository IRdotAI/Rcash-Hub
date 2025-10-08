if game.PlaceId == 85896571713843 then
    
    local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

    game:GetService("StarterGui"):SetCore("SendNotification",{
	    Title = "Rcash Hub 💸", -- Obbligatorio
	    Text = "Script Successfully loaded", -- Obbligatorio
	    Icon = "rbxassetid://82088779453504" -- Facoltativo
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
    _G.AutoPickupAll = false
    _G.AutoCollectFreeGifts = false
    _G.AutoOpenDailyRewards = false
    _G.AutoSpinAutumnWheel = false

-- Get Services

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

-- Functions

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





    local function GetRemote(name)
        return ReplicatedStorage.Events:FindFirstChild(name)
    end

    local function FindEggByName(eggName)
        for _, egg in pairs(workspace.Eggs:GetChildren()) do
            if egg.Name == eggName then
                return egg
            end
        end
    end

    local function BlowBubble()
        if GetRemote("BlowBubble") then
            GetRemote("BlowBubble"):FireServer()
        end
    end

    local function DoHatch(egg)
        if GetRemote("Hatch") then
            GetRemote("Hatch"):FireServer(egg)
        end
    end

    local function ClaimFreeGift()
        if GetRemote("ClaimFreeGift") then
            GetRemote("ClaimFreeGift"):FireServer()
        end
    end

    local function OpenDailyReward()
        if GetRemote("OpenDailyReward") then
            GetRemote("OpenDailyReward"):FireServer()
        end
    end

    local function SpinAutumnWheel()
        if GetRemote("SpinAutumnWheel") then
            GetRemote("SpinAutumnWheel"):FireServer()
        end
    end

    local function PickupAll()
        if GetRemote("PickupAll") then
            GetRemote("PickupAll"):FireServer()
        end
    end

    local function AutoBlowBubbles()
        while _G.AutoBlowBubbles do
            BlowBubble()
            task.wait(0.2)
        end
    end

    local function AutoHatch()
        while _G.AutoHatch do
            local egg = FindEggByName(_G.SelectedEgg)
            if egg then
                DoHatch(egg)
            else
                task.wait(1)
            end
            task.wait(0.5)
        end
    end

    local function AutoClaimPTR()
        while _G.AutoClaimPTR do
            if GetRemote("ClaimPTRRewards") then
                GetRemote("ClaimPTRRewards"):FireServer()
            end
            task.wait(5)
        end
    end

    local function AutoMysteryBox()
        while _G.AutoMysteryBox do
            if GetRemote("OpenMysteryBox") then
                GetRemote("OpenMysteryBox"):FireServer()
            end
            task.wait(0.5)
        end
    end

    local function AutoSeasonEgg()
        while _G.AutoSeasonEgg do
            if GetRemote("OpenSeasonEgg") then
                GetRemote("OpenSeasonEgg"):FireServer()
            end
            task.wait(0.5)
        end
    end

    local function AutoCollectFreeGifts()
        while _G.AutoCollectFreeGifts do
            ClaimFreeGift()
            task.wait(10)
        end
    end

    local function AutoOpenDailyRewards()
        while _G.AutoOpenDailyRewards do
            OpenDailyReward()
            task.wait(10)
        end
    end

    local function AutoSpinAutumnWheel()
        while _G.AutoSpinAutumnWheel do
            SpinAutumnWheel()
            task.wait(1)
        end
    end

    local function AutoPickupLoop()
        while true do
            if _G.AutoPickupAll then
                PickupAll()
                task.wait(0.5)
            else
                task.wait(1)
            end
        end
    end

    local function HideHatchAnim()
        if _G.HideHatchAnim then
            local hatch_gui = LocalPlayer.PlayerGui:FindFirstChild("HatchGUI")
            if hatch_gui then
                hatch_gui.Enabled = false
            end
        end
    end

    local function SpamE()
        while _G.SpamE do
            if GetRemote("SpamE") then
                GetRemote("SpamE"):FireServer()
            end
            task.wait(0.1)
        end
    end

-- Main Server

    local win = DiscordLib:Window("Rcash Hub 💸 | BGSI")

    local serv = win:Server("Main", "")

    local info = serv:Channel("Information")

    info:Label("By Rdota")
    info:Seperator()
    info:Label("Supported games:\n• Bubble Gum Simulator Infinity\n• V.1.0")
    

    local sprt = serv:Channel("Support and Help")

    sprt:Label("Join our Discord server for more scripts and help!")

    sprt:Button("Join Discord server", function()
        setclipboard("https://discord.gg/JQFrBajQxW")
        DiscordLib:Notification("Notification", "Link Copied", "Okay!")
    end)

    sprt:Seperator()

    sprt:Label("If you want to support me, you can do it on Patreon which helps\nencorage me to make more scripts!")

    sprt:Button("Patreon", function()
        setclipboard("https://www.patreon.com/RdotA")
        DiscordLib:Notification("Notification", "Link Copied", "Okay!")
    end)

    local srvs = serv:Channel("Server Settings")

    srvs:Button("Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)

    srvs:Button("Server Hop", function()
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
                    game:GetService("StarterGui"):SetCore("SendNotification",{
	                    Title = "Rcash Hub 💸", -- Obbligatorio
	                    Text = "Server Hopping", -- Obbligatorio
	                    Icon = "rbxassetid://82088779453504" -- Facoltativo
                    })
                else
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Rcash Hub 💸", -- Obbligatorio
                        Text = "No available servers found", -- Obbligatorio
                        Icon = "rbxassetid://82088779453504" -- Facoltativo
                    })
    )

    srvs:Button("Server Hop (Low Ping)", function()
        local HttpService = game:GetService("HttpService")
        local Servers = {}
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
            for i, v in pairs(Site.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    num = num + 1
                    Servers[num] = v.id
                end
            end
            if num > 0 then
                ID = Servers[math.random(1, #Servers)]
                AllIDs[#AllIDs + 1] = ID
                wait()
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
            else
                TPReturner()
            end
        end

        function Teleport()
            while wait() do
                pcall(function()
                    TPReturner()
                    if foundAnything ~= "" then
                        TPReturner()
                    end
                end)
            end
        end

        Teleport()
    end)

    
local tgls = serv:Channel("Toggles")

tgls:Toggle("Auto-Farm",false, function(bool)
print(bool)
end)

local sldrs = serv:Channel("Sliders")

local sldr = sldrs:Slider("Slide me!", 0, 1000, 400, function(t)
print(t)
end)

sldrs:Button("Change to 50", function()
sldr:Change(50)
end)

local drops = serv:Channel("Dropdowns")


local drop = drops:Dropdown("Pick me!",{"Option 1","Option 2","Option 3","Option 4","Option 5"}, function(bool)
print(bool)
end)

drops:Button("Clear", function()
drop:Clear()
end)

drops:Button("Add option", function()
drop:Add("Option")
end)

local clrs = serv:Channel("Colorpickers")

clrs:Colorpicker("ESP Color", Color3.fromRGB(255,1,1), function(t)
print(t)
end)

local textbs = serv:Channel("Textboxes")

textbs:Textbox("Gun power", "Type here!", true, function(t)
print(t)
end)

local lbls = serv:Channel("Labels")

lbls:Label("This is just a label.")

local bnds = serv:Channel("Binds")

bnds:Bind("Kill bind", Enum.KeyCode.RightShift, function()
print("Killed everyone!")
end)

serv:Channel("by dawid#7205")


win:Server("Main", "http://www.roblox.com/asset/?id=13060262582")

-- Start the continuous Auto Pickup background loop (waits for _G.AutoPickupAll to be true)
    task.spawn(AutoPickupLoop)

-- Start the Hide Hatch listener
    task.spawn(HideHatchAnim) 

end
