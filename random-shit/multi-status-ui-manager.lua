getgenv().EquipConfig = {
    Enabled = true,
    SelectedCurrency = "Coins",
    MAX_TEAM_SIZE = 8
}

getgenv().WebhookConfig = {
    Enabled = true,
    PRIVATE_WEBHOOK_URL = "",
    ENABLE_DISCORD_PING = false,
    DISCORD_USER_ID = ""
}

getgenv().PotionConfig = {
    Enabled = true,
    AutoCraft = false,
    AutoUse = true,
    PotionsToUse = {"Coins", "Lucky"},
    UseTiers = {"1", "2"},
    UseAmountPerPotion = 100,
    UseDelay = 1
}

local GITHUB_BASE = "https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/main/"

local function loadScript(url)
    local content = nil
    local success, result = pcall(game.HttpGet, game, url)
    if success and result then content = result else warn("Failed to retrieve " .. url .. ": " .. tostring(result)) end
    if content then 
        local success, err = pcall(loadstring(content))
        if not success then warn("Execution error for " .. url .. ": " .. tostring(err)) end
        return success
    end
    return false
end

if not loadScript(GITHUB_BASE .. "shared/multi-status-ui-manager.lua") then 
    error("FATAL: UI Manager failed to load.") 
end
print("UI Manager Loaded Successfully.")

local SCRIPTS = {
    {Config = getgenv().EquipConfig, Path = "logic/equip_best.lua"},
    {Config = getgenv().WebhookConfig, Path = "logic/webhook_monitor.lua"},
    {Config = getgenv().PotionConfig, Path = "logic/auto_potions.lua"},
}

for _, scriptData in ipairs(SCRIPTS) do
    if scriptData.Config.Enabled then
        loadScript(GITHUB_BASE .. scriptData.Path)
    end
end

local UIManager = getgenv().UIManager
if UIManager then UIManager:Update("__Loader", "Default", "Hub Loader", "Scripts initialized.") end

