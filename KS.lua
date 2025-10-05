if game.PlaceId == 13667319624 then
--OrionLib 
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

--Window
    local Window = OrionLib:MakeWindow({
        Name = "Rcash Hub 💸 | Knockout Sim",
        HidePremium = true,
        SaveConfig = true,
        IntroText = "Rcash Hub",
        IntroIcon = "rbxassetid://82088779453504",
        ConfigFolder = "RcashConfig",
        Icon = "rbxassetid://82088779453504"
    })

--Tabs
    local MainTab = Window:MakeTab({
        Name = "🏠 Main",
        PremiumOnly = false
    })

    MainTab:AddLabel("By RdotA")

    local supportedSection = MainTab:AddSection({
        Name = "Supported Games"
    })

    supportedSection:AddLabel("• Bubble Gum Simulator INFINITY")
    supportedSection:AddLabel("• Knockout Sim")
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
            _G.AutoBlowBubbles = false
            _G.AutoHatch = false
            _G.AutoCS = false
            _G.AutoClaimPTR = false
            _G.AutoMysteryBox = false
            _G.AutoSeasonEgg = false
            _G.HideHatchAnim = false
            _G.SpamE = false
            _G.AutoCollectAutumnLeaves = false
            _G.AutoSpinAutumnWheel = false 
            _G.AutoBuyAutumnShop = false

            OrionLib:MakeNotification({
                Name = "Rcash Hub 💸",
                Content = "GUI destroyed. All toggles stopped.",
                Time = 3
            })

            OrionLib:Destroy()

        end
    })

    MainTab:AddButton({
        Name = "Reload GUI",
        Callback = function()
            -- Stop all global toggles
            _G.AutoBlowBubbles = false
            _G.AutoHatch = false
            _G.AutoCS = false
            _G.AutoClaimPTR = false
            _G.AutoMysteryBox = false
            _G.AutoSeasonEgg = false
            _G.HideHatchAnim = false
            _G.SpamE = false
            _G.AutoCollectAutumnLeaves = false
            _G.AutoSpinAutumnWheel = false
            _G.AutoBuyAutumnShop = false


            -- Destroy Orion GUI
            if OrionLib then
                OrionLib:Destroy()
            end

            -- Notify player
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rcash Hub 💸",
                Text = "Reloading GUI...",
                Duration = 3
            })

            -- Reload script
            loadstring(game:HttpGet("https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/main/main.lua"))()
        end
    })

--Farming Tab
    local FarmingTab = Window:MakeTab({
        Name = "⚙️ Farming",
        PremiumOnly = false
    })

    FarmingTab:AddButton({
        Name = "Infinite Wins",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local WinGain = ReplicatedStorage.Event.WinGain 
            WinGain:FireServer(
                math.huge
            )
        end
    })
    FarmingTab:AddButton({
        Name = "Infinite Strength",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Train = ReplicatedStorage.Event.Train
            Train:FireServer(
                math.huge
            )
        end
    })
    FarmingTab:AddButton({
        Name = "Gravity power (BEST POWER) FREE",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local BuyPower = ReplicatedStorage.Event.BuyPower
            BuyPower:FireServer(
                "Gravity",
                0
            )
        end
    })
    FarmingTab:AddButton({
        Name = "Inf enchant (FOR THE POWER U HAVE ON)",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Enchanted = ReplicatedStorage.Event.Enchanted
            Enchanted:FireServer(
                0,
                math.huge
            )
        end
    })



