-- ===================================
-- Core Logic & Setup
-- ===================================

local Config = getgenv().RdotAdeleteConfig or {} 
local AUTO_DELETE = true -- Hardcoded to true

local function cleanConfigList(list)
    local cleaned = {}
    if type(list) == "table" then
        for _, item in ipairs(list) do
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


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Network = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent -- Used for DeletePet event
local LocalData = require(ReplicatedStorage.Client.Framework.Services.LocalData)
local PetsModule = require(ReplicatedStorage.Shared.Data.Pets)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")


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

-- Only set up UI if deletion is configured (otherwise, it will just show the warning text)
if not IS_CONFIGURED then
    local warningMessage = "❌ NO RARITIES OR PETS CHOSEN TO KEEP"
    StarterGui:SetCore("SendNotification", {
        Title = "RdotA Config Warning";
        Text = "Auto Delete is active but nothing is configured to be kept. Please check RdotAdeleteConfig.";
        Icon = "rbxassetid://" .. logoAssetId;
        Duration = 8;
    })
    return
end


-- ===================================
-- 2. Status Bar Setup
-- ===================================

local UI_HEIGHT = 20
local FRAME_HEIGHT = 25 
local UI_WIDTH_SCALE = 0.8 -- 80% width

local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name = "RdotA_AutoDeleteStatus"
SCREEN_GUI.IgnoreGuiInset = true 
SCREEN_GUI.Parent = PlayerGui

local CONTAINER_FRAME = Instance.new("Frame")
CONTAINER_FRAME.Size = UDim2.new(UI_WIDTH_SCALE, 0, 0, FRAME_HEIGHT)
CONTAINER_FRAME.Position = UDim2.new(0.5, 0, 0, 0) 
CONTAINER_FRAME.AnchorPoint = Vector2.new(0.5, 0)
CONTAINER_FRAME.BackgroundTransparency = 1
CONTAINER_FRAME.Parent = SCREEN_GUI

-- Main Status Text Label
local STATUS_LABEL = Instance.new("TextLabel")
STATUS_LABEL.Name = "RarityStatus"
STATUS_LABEL.Size = UDim2.new(1, 0, 0, UI_HEIGHT) 
STATUS_LABEL.Position = UDim2.new(0, 0, 0, 0)
STATUS_LABEL.BackgroundTransparency = 1
STATUS_LABEL.TextColor3 = Color3.fromRGB(255, 255, 255)
STATUS_LABEL.TextScaled = true
STATUS_LABEL.Font = Enum.Font.FredokaOne
STATUS_LABEL.TextStrokeTransparency = 0 
STATUS_LABEL.Text = "❌ Auto Delete Active" -- Initial text
STATUS_LABEL.ZIndex = 2
STATUS_LABEL.Parent = CONTAINER_FRAME

-- Progress Bar Background 
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
-- Utility Functions (Adapted from your logic)
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
-- Auto Delete Core Loop (Based on your improved structure)
-- ===================================

local function AutoDeleteUnkeptRarityPets()
    local playerData = LocalData:Get()
    if not playerData or not playerData.Pets then
        return
    end

    local equippedPetIds = getTeamPetIds()
    
    local petsToDelete = {}
    local totalAmountToDelete = 0
    local petToDeleteRarity = nil
    
    -- 1. PRE-SCAN: Build the list of pets to delete and calculate the constant total amount
    for _, petData in ipairs(playerData.Pets) do
        -- Check 1: Must not be equipped
        -- Check 2: Must not be locked (Critical safety feature)
        if equippedPetIds[petData.Id] or petData.Locked then
            continue
        end

        local keep, rarity = shouldKeep(petData, equippedPetIds)
        
        if petData.Id and not keep then
            local amountToDelete = petData.Amount or 1
            
            table.insert(petsToDelete, {
                Id = petData.Id,
                Amount = amountToDelete,
                Rarity = rarity
            })
            totalAmountToDelete = totalAmountToDelete + amountToDelete
        end
    end

    -- 2. MAIN LOOP: Perform deletions and update UI
    local deletedCount = 0
    
    if totalAmountToDelete > 0 then
        STATUS_LABEL.Text = ("❌ Starting Deletion (Total: %d pets)"):format(totalAmountToDelete)

        for _, petInfo in ipairs(petsToDelete) do
            -- Update the displayed rarity
            if petInfo.Rarity and petInfo.Rarity ~= petToDeleteRarity then
                petToDeleteRarity = petInfo.Rarity
            end

            -- Fire the server to delete the pet (using pet stack amount)
            Network:FireServer("DeletePet", petInfo.Id, petInfo.Amount, false)
            
            deletedCount = deletedCount + petInfo.Amount 
            task.wait(0.1) -- Throttle remote calls

            -- Update the progress bar and status text 
            local progress = deletedCount / totalAmountToDelete
            
            PROGRESS_BAR_FILL:TweenSize(
                UDim2.new(progress, 0, 1, 0),
                "Out", 
                "Quad", 
                0.1, 
                true
            )

            -- Update the status text with the correct, constant total
            local rarityText = petToDeleteRarity and ("Deleting: " .. petToDeleteRarity) or "Processing..."
            STATUS_LABEL.Text = ("❌ %s (Progress: %d/%d)"):format(rarityText, deletedCount, totalAmountToDelete)
        end
    end
    
    -- 3. RESET UI after completion or if no pets were found
    if STATUS_LABEL then
        STATUS_LABEL.Text = "❌ Auto Delete Active"
    end
    PROGRESS_BAR_FILL:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.5, true)
end

-- ===================================
-- Background Execution Loop
-- ===================================

task.spawn(function()
    while true do
        if AUTO_DELETE and IS_CONFIGURED then
            AutoDeleteUnkeptRarityPets()
        end
        -- Wait a few seconds before checking the inventory and deleting again
        task.wait(2) 
    end
end)
