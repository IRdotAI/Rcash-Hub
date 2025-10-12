-- Load up WindUI like a boss
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Create the main window, keepin' it fresh
local Window = WindUI:CreateWindow({
    Title = "Obby Slayer Hub ??",
    Icon = "wind",  -- Whatever icon vibes with you
    Size = Vector2.new(500, 350)  -- Clean size
})

-- Add a tab for the obby grind
local MainTab = Window:Tab({
    Title = "Auto Farms",
    Icon = "robot"  -- Lookin' slick
})

-- Section for obby controls
local ObbySection = MainTab:Section({
    Title = "Auto Obby & Chest Collector",
    Desc = "Toggle to crush obbies and grab chests"
})

-- Set the global toggle var
_G.AutoObby = false

-- The toggle to rule it all
ObbySection:Toggle({
    Title = "Enable Auto Obby",
    Value = false,  -- Starts off
    Callback = function(state)
        _G.AutoObby = state
        if state then
            WindUI:Notify({
                Title = "Obby Mode",
                Content = "Auto Obby & Chests fired up! Let?s roll ??",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Obby Mode",
                Content = "Auto Obby chilled out. Paused ??",
                Duration = 3
            })
        end
    end
})

-- Original script, now with toggle control
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
    if not _G.AutoObby then return end  -- Bail if toggled off
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

    local startTime = os.clock()
    while os.clock() - startTime < 30 and _G.AutoObby do
        RemoteEvent:FireServer("ClaimObbyChest")
        task.wait(0.7)
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if not _G.AutoObby then continue end  -- Skip if toggled off
        local character = LocalPlayer.Character
        local playerData = LocalData:Get()
        if not character or not character.PrimaryPart or not playerData or not playerData.ObbyCooldowns then
            continue
        end
        local initialPosition = character.PrimaryPart.CFrame
        local completedAnObbyInCycle = false
        for _, difficulty in ipairs(DIFFICULTIES_TO_CYCLE) do 
            if not _G.AutoObby then break end  -- Bail if toggled off mid-cycle
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
        if not playerData or not playerData.ObbyCooldowns then continue end
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
