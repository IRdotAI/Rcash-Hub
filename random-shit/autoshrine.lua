-- ==============================================================================
--                       STANDALONE AUTO SHRINES SCRIPT
-- ==============================================================================
-- Includes the auto-shrine logic, a live status display GUI, and a startup 
-- game notification.
-- ==============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui") -- Service needed for notifications
local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent

-- Configuration Check (Must be set by your config loader script)
local Config = getgenv().RdotAshrineConfig
if not Config then
    error("[AutoShrines] Configuration (getgenv().RdotAshrineConfig) not found. Please ensure your config script runs first. Exiting.")
end

-- Shared Variables
local WaitTime = Config.ThresholdSeconds or 60 -- Interval between renewal attempts
_G.AutoBubbleShrine = true
_G.AutoDreamerShrine = true

-- Status Tracking Variables for the Display
local NextRenewalTime = os.time() -- Tracks the timestamp for the next renewal
local CurrentShrineStatus = "Initializing" -- Tracks which shrine was last successfully renewed/attempted

-- ===================================
-- 1. STARTUP NOTIFICATION
-- ===================================
local function ShowStartupNotification()
    -- Uses StarterGui:SetCore to display a standard game notification.
    StarterGui:SetCore("SendNotification", {
        Title = "RdotA Random Shit",
        Text = "Auto shrines loaded.",
        Icon = "rbxassetid://114269510951824", -- Your provided asset ID
        Duration = 5, -- Show for 5 seconds
    })
end

-- ===================================
-- 2. GUI Setup and Status Function
-- ===================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoShrineStatusGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "ShrineStatusLabel"
StatusLabel.Parent = ScreenGui

-- TextLabel Properties
StatusLabel.Size = UDim2.new(1, 0, 0, 36)
-- Center Top Position (X=50% - Width/2, Y=0)
StatusLabel.Position = UDim2.new(0.5, 0, 0, 0)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0) 
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.FredokaOne
StatusLabel.TextScaled = true
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextStrokeTransparency = 0 -- Gives better visibility

-- Function to reset the timer and update the status type
local function UpdateStatus(status_type)
    NextRenewalTime = os.time() + WaitTime
    CurrentShrineStatus = status_type
    print(string.format("[AutoShrines] Status Updated: %s (Next check in %d seconds)", status_type, WaitTime))
end

-- ===================================
-- 3. Timer/Display Loop
-- ===================================
local function StatusDisplayLoop(textLabel)
    -- Initialize the timer visually
    UpdateStatus(CurrentShrineStatus) 
    
    while task.wait(0.1) do
        local TimeRemaining = math.max(0, NextRenewalTime - os.time())
        local TimeString = string.format("%02d:%02d", math.floor(TimeRemaining / 60), math.floor(TimeRemaining % 60))
        
        local Emoji = ""
        local StatusText = ""

        if TimeRemaining > 0 then
            -- Active Countdown
            if CurrentShrineStatus == "Bubble" then
                Emoji = "🫧"
                StatusText = "Bubble Shrine Renewal in: " .. TimeString
            elseif CurrentShrineStatus == "Dreamer" then
                Emoji = "✨"
                StatusText = "Dreamer Shrine Renewal in: " .. TimeString
            else -- Initializing or Shared Countdown
                Emoji = "⏳"
                StatusText = "Next Shrine Check in: " .. TimeString
            end
        else
            -- Timer expired, awaiting renewal call
            Emoji = "🔄"
            StatusText = "Attempting Shrine Renewal..."
        end

        textLabel.Text = Emoji .. " " .. StatusText
    end
end

-- ===================================
-- 4. Auto Shrine Logic (Modified to call UpdateStatus)
-- ===================================

local function AutoBubbleShrineFunction()
    local PotionName = Config.BubblePotionName
    local PotionTier = Config.BubblePotionTier
    local DonateAmount = Config.BubbleDonateAmount
    
    while _G.AutoBubbleShrine do
        -- Only attempt to fire if the timer has expired or is close to zero
        if os.time() >= NextRenewalTime or CurrentShrineStatus ~= "Bubble" then
            pcall(function()
                if RemoteEvent then
                    -- Fire the server event to activate the Bubble Shrine
                    RemoteEvent:FireServer("ShrineDonate", "Bubble", PotionName, PotionTier, DonateAmount)
                    UpdateStatus("Bubble") -- Reset timer and set status on successful fire
                else
                    print("Error: RemoteEvent not found for Bubble Shrine.")
                end
            end)
        end
        
        task.wait(1) -- Check every 1 second
    end
end

local function AutoDreamerShrineFunction()
    local DonateAmount = Config.DreamDonateAmount
    local PreferExact100Fish = Config.PreferExact100Fish
    
    while _G.AutoDreamerShrine do
        -- Only attempt to fire if the timer has expired or is close to zero
        if os.time() >= NextRenewalTime or CurrentShrineStatus ~= "Dreamer" then
            pcall(function()
                if RemoteEvent then
                    -- Fire the server event to activate the Dreamer Shrine
                    RemoteEvent:FireServer("ShrineDonate", "Dreamer", DonateAmount, PreferExact100Fish)
                    UpdateStatus("Dreamer") -- Reset timer and set status on successful fire
                else
                    print("Error: RemoteEvent not found for Dreamer Shrine.")
                end
            end)
        end
        
        task.wait(1) -- Check every 1 second
    end
end


-- 5. Final Initialization Sequence
-- Show the notification first
ShowStartupNotification()

-- Start the status display
task.spawn(StatusDisplayLoop, StatusLabel)

-- Start the auto shrine loops
if _G.AutoBubbleShrine then
    task.spawn(AutoBubbleShrineFunction)
end

if _G.AutoDreamerShrine then
    task.spawn(AutoDreamerShrineFunction)
end
