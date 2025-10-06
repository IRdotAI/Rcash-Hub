-- Script Load Counter START
    if _G.ScriptLoadCount then
        _G.ScriptLoadCount = _G.ScriptLoadCount + 1
    else
        _G.ScriptLoadCount = 1
    end
    print("--------------------------------------------------")
    print("Rcash Hub Script Load Count: #" .. _G.ScriptLoadCount .. " (New Script Running)")
    print("--------------------------------------------------")
-- Script Load Counter END
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

    -- NEW: Auto Pickup Toggle from test.lua
    _G.AutoPickupAll = false

    _G.AutoSellPets = false
    _G.AutoSpinAutumnWheel = false
    _G.AutoClaimChests = false
    
-- Services and Remotes (Centralized for efficiency, matching test.lua style)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local TweenService = game:GetService("TweenService") 
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    local CollectPickupRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup")

-- ====================================================================
-- GLOBAL FUNCTIONS
-- ====================================================================

-- NEW: Auto Collect Pickups function (Robust logic from test.lua)
local function CollectPickups()
    print("[AUTOPICKUP] Pickup loop started.")

    -- Loop runs continuously as long as the global toggle is true
    while _G.AutoPickupAll do
        if Player.Character then
            local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
            
            if not HRP then 
                task.wait(0.5) 
                goto continue_loop -- Skip to the next iteration if HRP is missing
            end

            local CollectiblesChunker = nil
            local Rendered = Workspace:FindFirstChild("Rendered")
            
            if Rendered then
                -- 1. RESILIENT SEARCH: Search for folders with specific names (most robust)
                for _, child in ipairs(Rendered:GetChildren()) do
                    local name = child.Name:lower()
                    if (child:IsA("Folder") or child:IsA("Model")) and 
                       (name:find("collectibles") or name:find("drops") or name:find("pickups")) then
                        CollectiblesChunker = child
                        break
                    end
                end -- FIXED: Changed '}' to 'end' here.

                -- 2. FALLBACK SEARCH: If name search fails, find the folder with the most descendants
                if not CollectiblesChunker then
                    local maxDescendants = 0
                    for _, child in ipairs(Rendered:GetChildren()) do
                        if (child:IsA("Folder") or child:IsA("Model")) then
                            local descendantCount = #child:GetDescendants()
                            -- Assume the folder with many children/descendants is the correct one.
                            if descendantCount > maxDescendants and descendantCount > 10 and #child:GetChildren() > 5 then 
                                maxDescendants = descendantCount
                                CollectiblesChunker = child
                            end
                        end
                    end
                end
            end

            if CollectiblesChunker then
                local collectedCount = 0
                -- Only search descendants of the identified chunker for efficiency
                local items = CollectiblesChunker:GetDescendants() 
                
                local tweenInfo = TweenInfo.new(
                    0.2,            -- Time
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out,
                    0,             
                    false,         
                    0              
                )
                
                for _, collectibleModel in ipairs(items) do
                    
                    local pickupId = collectibleModel:GetAttribute("ID") 
                
                    -- Check for valid pickup structure/ID
                    if type(pickupId) == "string" and string.len(pickupId) > 20 then
                        
                        local collectiblePart = collectibleModel:FindFirstChildOfClass("BasePart", true)
                        
                        -- CRITICAL FIX: Check if the part still exists and is correctly parented
                        if collectiblePart and collectiblePart.Parent == collectibleModel and collectiblePart.Parent.Parent == CollectiblesChunker then 
                            
                            local targetCFrame = HRP.CFrame * CFrame.new(0, 0, 0)
                            
                            -- Use pcall to safely execute the Tween in case the object is destroyed mid-function
                            pcall(function()
                                local tween = TweenService:Create(collectiblePart, tweenInfo, {CFrame = targetCFrame})
                                tween:Play()
                            end)
                            
                            task.wait(0.2) -- Wait for the item to move slightly
                            
                            CollectPickupRemote:FireServer(pickupId)
                            collectedCount = collectedCount + 1
                        end
                    end
                end
                
                if collectedCount > 0 then
                    -- Use the existing console logging function in BGSI if available, otherwise use print
                    if ConsoleLog then ConsoleLog("[FARM] Collected " .. collectedCount .. " pickups via Item Magnet.") end
                end
            end

            task.wait(0.1) -- Short delay before next scan
            ::continue_loop::
        else
            task.wait(0.5) -- Wait longer if character is not present
        end
    end
    print("[AUTOPICKUP] Loop stopped.")
end

-- Existing functions (SellPets, BlowBubbles, etc.)

local function SellPets()
    while _G.AutoSellPets do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("SellPets")
        task.wait(5)
    end
end

local function BlowBubbles()
    while _G.AutoBlowBubbles do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("BlowBubble")
        task.wait(0.3)
    end
end

local function AutoClaimPTR()
    while _G.AutoClaimPTR do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimAllPlaytime")
        task.wait(30)
    end
end

local function AutoMysteryBox()
    while _G.AutoMysteryBox do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("UseGift", "Mystery Box", 25)
        task.wait(0.3)
    end
end

local function AutoClaimChests()
    while _G.AutoClaimChests do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("ClaimAllChests")
        task.wait(30)
    end
end

local function SpinAutumnWheel()
    while _G.AutoSpinAutumnWheel do
        local Remote = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
        Remote.RemoteFunction:InvokeServer("AutumnWheelSpin")
        Remote.RemoteEvent:FireServer("ClaimAutumnWheelSpinQueue")
        task.wait(0.3)
    end
end

local function AutoSeasonEgg()
    while _G.AutoSeasonEgg do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer("HatchSeasonEgg")
        task.wait(1)
    end
end

local function HideHatchAnim()
    if _G.HideHatchAnim then
        local old = hookfunction(game.Players.LocalPlayer.PlayerGui.Hatching.Main.EggContainer.Background.Circle.Circle.Tween.NumberValue.Tween:TweenPlay)
        hookfunction(game.Players.LocalPlayer.PlayerGui.Hatching.Main.EggContainer.Background.Circle.Circle.Tween.NumberValue.Tween:TweenPlay, function(self)
            self.Time = 0.01
            old(self)
        end)
    end
end

local function SpamE()
    while _G.SpamE do
        game:GetService("VirtualUser"):ClickButton2()
        task.wait(0.1)
    end
end


-- Console Logging setup
local ConsoleOutput = {"Console ready. Waiting for script output..."}
local ConsoleUILabel = nil -- Will be set after GUI creation

-- Custom logging function that updates the GUI paragraph
local function ConsoleLog(...)
    local message = table.concat({...}, " ")
    table.insert(ConsoleOutput, message)
    -- Keep only the last 20 messages to prevent memory/performance issues
    if #ConsoleOutput > 20 then
        table.remove(ConsoleOutput, 1)
    end
    if ConsoleUILabel then
        ConsoleUILabel:SetContent(table.concat(ConsoleOutput, "\n"))
    end
    print(message) -- Also print to the native console
end

-- Override global print if needed, but for now just use ConsoleLog internally
function print(...)
    ConsoleLog(...)
end

-- ====================================================================
-- GUI SETUP
-- ====================================================================

-- Tabs
    local FarmTab = Window:MakeTab({
        Name = "Farm",
        PremiumOnly = false
    })

    local HatchTab = Window:MakeTab({
        Name = "Hatch",
        PremiumOnly = false
    })

    local MiscTab = Window:MakeTab({
        Name = "Misc",
        PremiumOnly = false
    })

-- Farm Tab
    FarmTab:AddToggle({
        Name = "Auto Blow Bubbles",
        Default = false,
        Callback = function(Value)
            _G.AutoBlowBubbles = Value
            if Value then task.spawn(BlowBubbles) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Blow Bubbles: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    -- NEW: Auto Collect Pickups Toggle
    FarmTab:AddToggle({
        Name = "Auto Collect Pickups (Item Magnet)",
        Default = false,
        Callback = function(Value)
            _G.AutoPickupAll = Value
            if Value then 
                task.spawn(CollectPickups) -- Start the robust background loop
            end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Collect Pickups: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    FarmTab:AddToggle({
        Name = "Auto Sell Unused Pets",
        Default = false,
        Callback = function(Value)
            _G.AutoSellPets = Value
            if Value then task.spawn(SellPets) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Sell Pets: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    FarmTab:AddToggle({
        Name = "Auto Claim All Chests",
        Default = false,
        Callback = function(Value)
            _G.AutoClaimChests = Value
            if Value then task.spawn(AutoClaimChests) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Claim Chests: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

-- Hatch Tab
    HatchTab:AddToggle({
        Name = "Auto Hatch",
        Default = false,
        Callback = function(Value)
            _G.AutoHatch = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Hatch: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    HatchTab:AddDropdown({
        Name = "Select Egg",
        Default = "N/A",
        Callback = function(Value)
            _G.SelectedEgg = Value
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Selected Egg: " .. Value,
                Time = 3
            })
        end,
        Options = {"Common Egg", "Rare Egg", "Mythic Egg", "Legendary Egg"} -- Add more options as needed
    })

    HatchTab:AddToggle({
        Name = "Auto Click Spam (E)",
        Default = false,
        Callback = function(Value)
            _G.SpamE = Value
            if Value then task.spawn(SpamE) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Spam E: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

    HatchTab:AddToggle({
        Name = "Hide Hatch Animation (Fast Eggs)",
        Default = false,
        Callback = function(Value)
            _G.HideHatchAnim = Value
            -- Restart the hook if enabling
            if Value then task.spawn(HideHatchAnim) end 
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Hide Hatch Anim: "..(Value and "Enabled" or "Disabled"),
                Time = 3
            })
        end
    })

-- Misc Tab
    MiscTab:AddToggle({
        Name = "Auto Claim Playtime Rewards",
        Default = false,
        Callback = function(Value)
            _G.AutoClaimPTR = Value
            if Value then task.spawn(AutoClaimPTR) end
            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "Auto Claim Playtime Rewards: "..(Value and "Enabled" or "Disabled"),
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
