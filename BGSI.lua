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

-- Global Variables

    getgenv().Functions = {
        AutoBlowBubbles = false;
        AutoSell = false;
        AutoCollectPickups = false;
        AutoObby = false;

        FasterEggs = false;
        AutoHatchEggs = false;
        SelectedEgg = "";
        AutoSeasonEgg = false;
        SeasonEgg = "";
        AutoEquipBest = false;

        AutoBuyAutumnShop = false;
        AutoBuy

        AutoClaimPlaytimeRewards = false;
        AutoClaimSeasonRewards = false;
        AutoClaimWheelSpin = false;
        AutoClaimChests = false;
        AutoBuyFromMarkets = false;
        AutoOpenMysteryBox = false;
        AutoGenieQuest = false;

        UseGoldenKeys = false;
        UseRoyalKeys = false;
    
        Disable3DRendering = false;
        BlackOutScreen = false;
        FixFPSCap = false;
    };

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

	local function TweenTo(Position, Speed)
	    local CFrameValue = Instance.new("CFrameValue");

	    CFrameValue.Value = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
	        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameValue.Value;
	    end);

	    game:GetService("TweenService"):Create(CFrameValue, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Value = Position}):Play();
	end;

	local function FancyNumberTranslator(FancyNumber)
	    local FancyNumbers = {
	        ["I"] = 1;
	        ["II"] = 2;
	        ["III"] = 3;
	        ["IV"] = 4;
	        ["V"] = 5;
	        ["VI"] = 6;
	    };

	    return FancyNumbers[FancyNumber];
	end;

	local function GetTimerText(Text)
	    local Hour, Minute, Second = string.match(Text, "^(%d+):(%d%d):(%d%d)$");

	    if Hour and Minute and Second then
	        return string.format("%02d:%02d:%02d", tonumber(Hour), tonumber(Minute), tonumber(Second));
	    end;

	    local Minute, Second = string.match(Text, "^(%d+):(%d%d)$");

	    if Minute and Second then
	        return string.format("00:%02d:%02d", tonumber(Minute), tonumber(Second));
	    end;

	    local Second = string.match(Text, "^(%d+)$");

	    if Second then
	        return string.format("00:00:%02d", tonumber(Second));
	    end;

	    return nil;
	end;

	local function CapitalizeTimeUnit(String)
	    local Number, Unit = String:match("^(%d+)%s*(%a+)$");

	    if Number and Unit then
	        Unit = Unit:sub(1, 1):upper() .. Unit:sub(2);
	        return Number .. " " .. Unit;
	    else
	        return String;
	    end;
	end;

	local function FetchRiftEggs(x25)
	    local FoundRiftEggs = {};
	    local Foundx25Eggs = {};

	    for i, v in next, game:GetService("Workspace").Rendered.Rifts:GetChildren() do
	        if not table.find({"golden-chest", "royal-chest", "gift-rift"}, v.Name) then
	            if v.Display.SurfaceGui.Icon.Luck.Text == "x25" then
	                table.insert(Foundx25Eggs, v);
	            else
	                table.insert(FoundRiftEggs, v);
	            end;
	        end;
	    end;
	    
	    if x25 then
	        return Foundx25Eggs;
	    else
	        return FoundRiftEggs;
	    end;
	end;

    function AutoHatch()
        while AutoHatch do
            if SelectedEgg ~= "" then
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchEgg", SelectedEgg,15)
            end
            task.wait(0.3)
        end
    end

    function AutoSeasonEgg()
        while AutoSeasonEgg do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchPowerupEgg", SeasonEgg,6)
            task.wait(0.3)
        end
    end

    function AutoEquipBest()
        while AutoEquipBest do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("EquipBestPets")
            task.wait(5) 
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
            while AutoObby do
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

    function AutoBuyAutumnShop()
        while AutoBuyAutumnShop do
            local Remote = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent
            pcall(function()
                Remote:FireServer("BuyShopItem", "autumnnorm-shop", 1, true)
                Remote:FireServer("BuyShopItem", "autumnnorm-shop", 2, true)
                Remote:FireServer("BuyShopItem", "autumnnorm-shop", 3, true)
            end)
            task.wait(1) 
        end
    end

    function AutoMysteryBox()
        while AutoOpenMysteryBox do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("UseGift","Mystery Box",1)
            task.wait(0.1)
        end
    end

    function AutoClaimPTR()
        while AutoClaimPlaytimeRewards do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimAllPlaytime")
            task.wait(30) 
        end
    end

    function AutoCS()
        while AutoClaimSeasonRewards do
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimSeason")
            task.wait(0.1)
        end
    end

    function SpinAutumnWheel()
        while AutoClaimWheelSpin do
            pcall(function()
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteFunction:InvokeServer("AutumnWheelSpin")
            end)
            pcall(function()
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimAutumnWheelSpinQueue")
            end)
            task.wait(0.3)
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
            OrionLib:Destroy()
            MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "GUI destroyed.",
                Time = 3
            })
        end
    })

    MainTab:AddButton({
        Name = "Reload GUI",
        Callback = function()
            MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Reloading script...",
                Time = 3
            })
            wait(3)
            OrionLib:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/rcashhub/scripts/main/BGSI.lua"))()
        end
    })

-- Farming Tab
    Local FarmingTab = Window:MakeTab({
        Name = "💰 Farming",
        PremiumOnly = false
    })

    FarmingTab:AddToggle({
        Name = "Auto Blow Bubbles",
        Callback = function()
            getgenv().Functions.AutoBlowBubbles = not getgenv().Functions.AutoBlowBubbles
            if getgenv().Functions.AutoBlowBubbles then
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Auto Blow Bubbles enabled.",
                    Time = 3
                })
                while getgenv().Functions.AutoBlowBubbles do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bubble"):WaitForChild("BlowBubble"):InvokeServer()
                    wait(0.1)
                end
            else
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Auto Blow Bubbles disabled.",
                    Time = 3
                })
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Auto Sell",
        Callback = function()
            getgenv().Functions.AutoSell = not getgenv().Functions.AutoSell
            if getgenv().Functions.AutoSell then
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Auto Sell enabled.",
                    Time = 3
                })
                while getgenv().Functions.AutoSell do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAllBubbles"):InvokeServer()
                    wait(1)
                end
            else
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Auto Sell disabled.",
                    Time = 3
                })
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Auto Collect Pickups",
        Callback = function()
            getgenv().Functions.AutoCollectPickups = not getgenv().Functions.AutoCollectPickups
            if getgenv().Functions.AutoCollectPickups then
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Auto Collect Pickups enabled.",
                    Time = 3
                })
                while getgenv().Functions.AutoCollectPickups do
                    CollectPickups()
                    wait(1)
                end
            else
                OrionLib:MakeNotification({
                    Name = "Rcash Hub 💸",
                    Content = "Auto Collect Pickups disabled.",
                    Time = 3
                })
            end
        end
    })

    

-- Initialize GUI
    OrionLib:Init()


end
