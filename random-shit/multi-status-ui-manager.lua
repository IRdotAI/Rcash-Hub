local StatusContainer = {}
local ActiveKey = nil
local ActiveIndex = 0
local __currentUI = nil

local UI_FONT = Enum.Font.FredokaOne
local UI_POSITION = UDim2.new(0.5, -125, 0.05, 0)
local UI_LOGO_ID = "rbxassetid://114269510951824"

local CURRENCY_EMOJIS = {
    ["Candycorn"] = "🎃", ["Coins"] = "💰", ["Gems"] = "💎", ["Tickets"] = "🎫",
    ["Seashells"] = "🐚", ["Pearls"] = "⚪", ["Leaves"] = "🍁",
    ["Secret"] = "🐶",
    ["Potion"] = "🧪",
    ["Default"] = "✨"
}

local UIManager = {}

local function updateDisplay()
    local keys = {}
    for k in pairs(StatusContainer) do
        if k ~= "__Loader" then
            table.insert(keys, k)
        end
    end
    if #keys == 0 and StatusContainer["__Loader"] then
        table.insert(keys, "__Loader")
    end

    if #keys == 0 and __currentUI then
        __currentUI:Destroy()
        __currentUI = nil
        return
    end

    ActiveIndex = (#keys > 0) and ((ActiveIndex % #keys) + 1) or 1
    ActiveKey = keys[ActiveIndex]
    local data = StatusContainer[ActiveKey]

    local currentCurrency = data.Currency or "Default"
    local emoji = CURRENCY_EMOJIS[currentCurrency] or CURRENCY_EMOJIS.Default

    if not __currentUI then UIManager.Initialize() end

    if __currentUI and __currentUI:FindFirstChild("Frame") then
        local Frame = __currentUI.Frame
        local Label = Frame:FindFirstChild("Label")
        local Icon = Frame:FindFirstChild("Icon")
        local CycleButton = Frame:FindFirstChild("CycleButton")

        if Icon then
             Icon.Image = UI_LOGO_ID
        end

        if Label then
            Label.Text = string.format(
                "%s %s\nStatus: %s",
                emoji, data.Title, data.Status or "Idle"
            )
        end

        if CycleButton and CycleButton:FindFirstChild("TextLabel") then
             CycleButton.TextLabel.Text = string.format("(%d/%d)", ActiveIndex, #keys)
             CycleButton.Visible = #keys > 1
        end
    end
end

function UIManager.Initialize()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")

    if not playerGui or __currentUI then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GlobalStatusUI"
    ScreenGui.DisplayOrder = 999
    -- REMOVED: ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global (Fixes load error)
    ScreenGui.Parent = playerGui
    __currentUI = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.Size = UDim2.new(0, 250, 0, 45)
    Frame.Position = UI_POSITION
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 2
    Frame.ClipsDescendants = true
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(200, 200, 200)
    Stroke.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 50, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextScaled = false
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = UI_FONT
    Label.Parent = Frame

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 5, 0, 2.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = UI_LOGO_ID
    Icon.Parent = Frame

    local CycleButton = Instance.new("TextButton")
    CycleButton.Name = "CycleButton"
    CycleButton.Size = UDim2.new(0, 40, 0, 18)
    CycleButton.Position = UDim2.new(1, -45, 1, -22.5)
    CycleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CycleButton.BorderColor3 = Color3.fromRGB(150, 150, 150)
    CycleButton.BorderSizePixel = 1
    CycleButton.Text = ""
    CycleButton.Font = UI_FONT
    CycleButton.Parent = Frame

    local CycleText = Instance.new("TextLabel")
    CycleText.Name = "TextLabel"
    CycleText.Size = UDim2.new(1, 0, 1, 0)
    CycleText.BackgroundTransparency = 1
    CycleText.TextScaled = true
    CycleText.TextSize = 12
    CycleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleText.Font = UI_FONT
    CycleText.Text = "(1/1)"
    CycleText.Parent = CycleButton

    CycleButton.MouseButton1Click:Connect(updateDisplay)

    updateDisplay()
end

function UIManager.Update(key, currency, title, statusText)
    StatusContainer[key] = {
        Currency = currency,
        Title = title,
        Status = statusText,
        Timestamp = tick()
    }

    if key == ActiveKey or ActiveKey == nil then
        updateDisplay()
    end
end

local function startUp()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then return end

    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

    if playerGui then
        getgenv().UIManager = UIManager
        UIManager:Initialize()
    else
        warn("UIManager: Startup failed. PlayerGui never appeared.")
    end
end

task.spawn(startUp)

