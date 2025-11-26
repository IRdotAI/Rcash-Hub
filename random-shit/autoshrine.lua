local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent

-- Configuration Check
local Config = getgenv().RdotAshrineConfig
if not Config then
    error("[AutoShrines] Configuration (getgenv().RdotAshrineConfig) not found. Exiting.")
end

-- Shared Variables
local WaitTime = Config.ThresholdSeconds or 60 
_G.AutoBubbleShrine = true
_G.AutoDreamerShrine = true

-- Status Tracking Variables for the Display
local NextRenewalTime = os.time()
local CurrentShrineStatus = "Initializing"

-- ===================================
-- 1. NOTIFICATION FUNCTIONS
-- ===================================
local function ShowStartupNotification()
    StarterGui:SetCore("SendNotification", {
        Title = "RdotA Random Shit",
        Text = "Auto shrines loaded.",
        Icon = "rbxassetid://114269510951824", 
        Duration = 5,
    })
end

local function ShowNotEnoughItemsNotification(itemName)
    StarterGui:SetCore("SendNotification", {
        Title = "RdotA Shrine Error ❌",
        Text = string.format("Not enough %s! Skipping renewal attempt.", itemName),
        Icon = "rbxassetid://114269510951824", 
        Duration = 5,
    })
end

-- ===================================
-- 2. INVENTORY CHECK (PLACEHOLDER)
-- ===================================
local function HasEnoughItems(itemName, amount)
    -- ⚠️ ACTION REQUIRED: REPLACE THIS LOGIC!
    -- This is a placeholder function. You must replace 'return true' with code 
    -- that reads the game's inventory to check if the player has 'amount' of 'itemName'.
    
    -- Example structure if you were checking a value in the Player object:
    -- if itemName == "Coins" and LocalPlayer.Data.Coins.Value < amount then
    --     return false
    -- end

    return true -- Currently assumes you always have enough items.
end

-- ===================================
-- 3. GUI Setup and Status Function
-- ===================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoShrineStatusGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "ShrineStatusLabel"
StatusLabel.Parent = ScreenGui

-- TextLabel Properties (Fixed height to 24px)
StatusLabel.Size = UDim2.new(1, 0, 0, 24)
StatusLabel.Position = UDim2.new(0.5, 0, 0, 0)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0) 
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.FredokaOne
StatusLabel.TextScaled = true
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextStrokeTransparency = 0 

local function UpdateStatus(status_type)
    NextRenewalTime = os.time() + WaitTime
    CurrentShrineStatus = status_type
    print(string.format("[AutoShrines] Status Updated: %s (Next check in %d seconds)", status_type, WaitTime))
end

local function StatusDisplayLoop(textLabel)
    UpdateStatus(CurrentShrineStatus) 
    
    while task.wait(0.1) do
        local TimeRemaining = math.max(0, NextRenewalTime - os.time())
        local TimeString = string.format("%02d:%02d", math.floor(TimeRemaining / 60), math.floor(TimeRemaining % 60))
        
        local Emoji = ""
        local StatusText = ""

        if TimeRemaining > 0 then
            if CurrentShrineStatus == "Bubble" then
                Emoji = "🫧"
                StatusText = "Bubble Shrine Renewal in: " .. TimeString
            elseif CurrentShrineStatus == "Dreamer" then
                Emoji = "✨"
                StatusText = "Dreamer Shrine Renewal in: " .. TimeString
            else
                Emoji = "⏳"
                StatusText = "Next Shrine Check in: " .. TimeString
            end
        else
            Emoji = "🔄"
            StatusText = "Attempting Shrine Renewal..."
        end

        textLabel.Text = Emoji .. " " .. StatusText
    end
end

-- ===================================
-- 4. Auto Shrine Logic (with Inventory Check)
-- ===================================

local function AutoBubbleShrineFunction()
    local PotionName = Config.BubblePotionName
    local DonateAmount = Config.BubbleDonateAmount
    local PotionTier = Config.BubblePotionTier
    
    while _G.AutoBubbleShrine do
        pcall(function()
            -- CHECK: Not enough items
            if not HasEnoughItems(PotionName, DonateAmount) then
                ShowNotEnoughItemsNotification(PotionName)
                return 
            end

            -- ACTION: Items available, fire remote
            if RemoteEvent then
                RemoteEvent:FireServer("ShrineDonate", "Bubble", PotionName, PotionTier, DonateAmount)
                UpdateStatus("Bubble")
            else
                print("Error: RemoteEvent not found for Bubble Shrine.")
            end
        end)
        
        task.wait(WaitTime) 
    end
end

local function AutoDreamerShrineFunction()
    local DonateAmount = Config.DreamDonateAmount
    local PreferExact100Fish = Config.PreferExact100Fish
    
    while _G.AutoDreamerShrine do
        pcall(function()
            -- CHECK: Not enough items (Assuming item name is "Fish")
            if not HasEnoughItems("Fish", DonateAmount) then
                ShowNotEnoughItemsNotification("Fish")
                return 
            end
            
            -- ACTION: Items available, fire remote
            if RemoteEvent then
                RemoteEvent:FireServer("ShrineDonate", "Dreamer", DonateAmount, PreferExact100Fish)
                UpdateStatus("Dreamer") 
            else
                print("Error: RemoteEvent not found for Dreamer Shrine.")
            end
        end)
        
        task.wait(WaitTime) 
    end
end


-- 5. Final Initialization Sequence
ShowStartupNotification()
task.spawn(StatusDisplayLoop, StatusLabel)

if _G.AutoBubbleShrine then
    task.spawn(AutoBubbleShrineFunction)
end

if _G.AutoDreamerShrine then
    task.spawn(AutoDreamerShrineFunction)
end
