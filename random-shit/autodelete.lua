-- ===================================
-- Core Logic & Setup
-- ===================================

local Config = getgenv().RdotAdeleteConfig or {} 
local AUTO_DELETE = true 

local function cleanConfigList(list)
    local cleaned = {}
    if type(list) == "table" then
        for _, item in ipairs(list) do
            -- Only include non-empty strings
            if type(item) == "string" and item:len() > 0 then
                table.insert(cleaned, item)
            end
        end
    end
    return cleaned
end

-- Read and clean configuration lists
local KEEP_TEAM = Config.KEEP_TEAM or false
local KEEP_PETS = cleanConfigList(Config.KEEP_PETS)
local KEEP_RARITIES = cleanConfigList(Config.KEEP_RARITIES)

-- Check if *anything* is configured to be kept
local IS_CONFIGURED = #KEEP_PETS > 0 or #KEEP_RARITIES > 0 or KEEP_TEAM


local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
local LocalData = require(ReplicatedStorage.Client.Framework.Services.LocalData)
local PetsModule = require(ReplicatedStorage.Shared.Data.Pets)
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")


-- ===================================
-- 1. Roblox Notification on Load
-- ===================================

local logoAssetId = 114269510951824

StarterGui:SetCore("SendNotification", {
    Title = "RdotA Random Shit";
    Text = "Auto Delete loaded.";
    Icon = "rbxassetid://" .. logoAssetId;
    Duration = 5;
})

-- ===================================
-- 2. Status Bar Setup (Centered, Smaller Progress Bar)
-- ===================================

local UI_HEIGHT = 20
local FRAME_HEIGHT = 25 
local UI_WIDTH_SCALE = 0.8 -- 80% width

local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name = "RdotA_AutoDeleteStatus"
SCREEN_GUI.IgnoreGuiInset = true 
SCREEN_GUI.Parent = PlayerGui

local CONTAINER_FRAME = Instance.new("Frame")
CONTAINER_FRAME.Size = UDim2.new(UI_WIDTH_SCALE, 0, 0, FRAME_HEIGHT) -- 80% width
CONTAINER_FRAME.Position = UDim2.new(0.5, 0, 0, 0) -- Center top
CONTAINER_FRAME.AnchorPoint = Vector2.new(0.5, 0) -- Pivot at center top
CONTAINER_FRAME.BackgroundTransparency = 1
CONTAINER_FRAME.Parent = SCREEN_GUI

-- Main Status Text Label (full width of container)
local STATUS_LABEL = Instance.new("TextLabel")
STATUS_LABEL.Name = "RarityStatus"
STATUS_LABEL.Size = UDim2.new(1, 0, 0, UI_HEIGHT) 
STATUS_LABEL.Position = UDim2.new(0, 0, 0, 0)
STATUS_LABEL.BackgroundTransparency = 1
STATUS_LABEL.TextColor3 = Color3.fromRGB(255, 255, 255)
STATUS_LABEL.TextScaled = true
STATUS_LABEL.Font = Enum.Font.FredokaOne
STATUS_LABEL.TextStrokeTransparency = 0 
STATUS_LABEL.Text = IS_CONFIGURED and "❌ Auto Delete Active" or "❌ NO RARITIES OR PETS CHOSEN TO KEEP"
STATUS_LABEL.ZIndex = 2
STATUS_LABEL.Parent = CONTAINER_FRAME

-- Progress Bar Background (Small bar, full width of container)
local PROGRESS_BAR_BG = Instance.new("Frame")
PROGRESS_BAR_BG.Size = UDim2.new(1, 0, 0, 2) -- Very Small Bar Height
PROGRESS_BAR_BG.Position = UDim2.new(0, 0, 0, UI_HEIGHT)
PROGRESS_BAR_BG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PROGRESS_BAR_BG.BorderSizePixel = 0
PROGRESS_BAR_BG.Parent = CONTAINER_FRAME

-- Progress Bar Fill
local PROGRESS_BAR_FILL = Instance.new("Frame")
PROGRESS_BAR_FILL.Size = UDim2.new(0, 0, 1, 0)
PROGRESS_BAR_FILL.Position = UDim2.new(0, 0, 0, 0)
PROGRESS_BAR_FILL.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
PROGRESS_BAR_FILL.BorderSizePixel = 0
PROGRESS_BAR_FILL.Parent = PROGRESS_BAR_BG


-- ===================================
-- Utility Functions
-- ===================================

local function getTeamPetIds()
    local ids = {}
    local data = LocalData:Get()
    if not data then return ids end
    local equippedTeamIndex = data.TeamEquipped
    if not equippedTeamIndex then return ids end
    local team = data.Teams and data.Teams[equippedTeamIndex]
    if not team or not team.Pets then return ids end
    for _, id in ipairs(team.Pets) do
        ids[id] = true
    end
    return ids
end

local function shouldKeep(pet, teamSet)
    if #KEEP_PETS > 0 then
        for _, name in ipairs(KEEP_PETS) do
            if pet.Name == name then
                return true
            end
        end
    end
    
    local petRarity = nil
    if PetsModule then
        local info = PetsModule[pet.Name]
        if info then
            petRarity = info.Rarity
            if #KEEP_RARITIES > 0 then
                for _, rarity in ipairs(KEEP_RARITIES) do
                    if info.Rarity == rarity then
                        return true
                    end
                end
            end
        end
    end

    if KEEP_TEAM and teamSet[pet.Id] then
        return true
    end
    
    return false, petRarity 
end

-- ===================================
-- Main Loop (Heartbeat) - FIXED PROGRESS LOGIC
-- ===================================

RunService.Heartbeat:Connect(function()
    
    if not IS_CONFIGURED then
        STATUS_LABEL.Text = "❌ NO RARITIES OR PETS CHOSEN TO KEEP"
        PROGRESS_BAR_FILL:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.5, true)
        return 
    end
    
    local data = LocalData:Get()
    if data and data.Pets then
        local teamSet = getTeamPetIds()
        local petsList = data.Pets
        
        local petsToProcess = {} -- List of pets that are eligible for deletion (e.g., all Common pets)
        local petToDeleteRarity = nil
        
        -- PRE-SCAN: Identify all pets that WILL be deleted to get a constant total count.
        for _, pet in ipairs(petsList) do
            local keep, _ = shouldKeep(pet, teamSet)
            if pet.Id and not keep then
                table.insert(petsToProcess, pet)
            end
        end
        
        local totalPetsToDelete = #petsToProcess -- THIS IS THE CONSTANT TOTAL (RIGHT SIDE)
        local deletedCount = 0 -- Increments for the left side of the progress
        
        -- If no pets are eligible for deletion, exit early and reset status
        if totalPetsToDelete == 0 then
             if STATUS_LABEL then
                STATUS_LABEL.Text = "❌ Auto Delete Active (No pets to delete)"
            end
            PROGRESS_BAR_FILL:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.5, true)
            return
        end


        -- MAIN LOOP: Delete the pets and update progress
        for i, pet in ipairs(petsToProcess) do
            local _, rarity = shouldKeep(pet, teamSet) -- Get rarity for display
            
            -- Delete the pet
            Network:FireServer("DeletePet", pet.Id, 1, false)
            
            deletedCount = deletedCount + 1 -- LEFT SIDE INCREMENTS
            task.wait(0.1) 

            -- Update the displayed rarity
            if rarity and rarity ~= petToDeleteRarity then
                petToDeleteRarity = rarity
            end
            
            -- Update the progress bar and status text after each deletion
            local progress = deletedCount / totalPetsToDelete
            
            PROGRESS_BAR_FILL:TweenSize(
                UDim2.new(progress, 0, 1, 0),
                "Out", 
                "Quad", 
                0.1, 
                true
            )

            -- Update the status text with the correct, constant total
            local rarityText = petToDeleteRarity and ("Deleting: " .. petToDeleteRarity) or "Processing..."
            STATUS_LABEL.Text = ("❌ %s (Progress: %d/%d)"):format(rarityText, deletedCount, totalPetsToDelete)
        end
        
        -- Reset the status bar appearance after the loop finishes
        if STATUS_LABEL then
            STATUS_LABEL.Text = "❌ Auto Delete Active"
        end
        PROGRESS_BAR_FILL:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.5, true)
    end
end)
