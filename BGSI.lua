if game.PlaceId == 85896571713843 then
    
    local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

    game:GetService("StarterGui"):SetCore("SendNotification",{
	    Title = "Rcash Hub 💸", -- Obbligatorio
	    Text = "Script Successfully loaded", -- Obbligatorio
	    Icon = "rbxassetid://82088779453504" -- Facoltativo
    })


-- Main Server

    local win = DiscordLib:Window("Rcash Hub 💸 | BGSI")

    local serv = win:Server("Main", "")

    local info = serv:Channel("Information")

    info:Label("By Rdota")
    info:Seperator()
    info:Label("Supported games:\n• Bubble Gum Simulator Infinity\n• V.1.0")
    

    local sprt = serv:Channel("Support and Help")

    sprt:Label("Join our Discord server for more scripts and help!")

    sprt:Button("Join Discord server", function()
        setclipboard("https://discord.gg/JQFrBajQxW")
        DiscordLib:Notification("Notification", "Link Copied", "Okay!")
    end)

    sprt:Seperator()

    sprt:Label("If you want to support me, you can do it on Patreon which helps\nencorage me to make more scripts!")

    sprt:Button("Patreon", function()
        setclipboard("https://www.patreon.com/RdotA")
        DiscordLib:Notification("Notification", "Link Copied", "Okay!")
    end)

    local srvs = serv:Channel("Server Settings")

    srvs:Button("Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)

    srvs:Button("Server Hop", function()
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
                    game:GetService("StarterGui"):SetCore("SendNotification",{
	                    Title = "Rcash Hub 💸", -- Obbligatorio
	                    Text = "Server Hopping", -- Obbligatorio
	                    Icon = "rbxassetid://82088779453504" -- Facoltativo
                    })
                else
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Rcash Hub 💸", -- Obbligatorio
                        Text = "No available servers found", -- Obbligatorio
                        Icon = "rbxassetid://82088779453504" -- Facoltativo
                    })
    )

    srvs:Button("Server Hop (Low Ping)", function()
        local HttpService = game:GetService("HttpService")
        local Servers = {}
        local PlaceID = game.PlaceId
        local AllIDs = {}
        local foundAnything = ""
        local actualHour = os.date("!*t").hour
        local Deleted = false

        function TPReturner()
            local Site;
            if foundAnything == "" then
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
            else
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
            end
            local ID = ""
            if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                foundAnything = Site.nextPageCursor
            end
            local num = 0;
            for i, v in pairs(Site.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    num = num + 1
                    Servers[num] = v.id
                end
            end
            if num > 0 then
                ID = Servers[math.random(1, #Servers)]
                AllIDs[#AllIDs + 1] = ID
                wait()
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
            else
                TPReturner()
            end
        end

        function Teleport()
            while wait() do
                pcall(function()
                    TPReturner()
                    if foundAnything ~= "" then
                        TPReturner()
                    end
                end)
            end
        end

        Teleport()
    end)

    
--[[local tgls = serv:Channel("Toggles")

tgls:Toggle("Auto-Farm",false, function(bool)
print(bool)
end)

local sldrs = serv:Channel("Sliders")

local sldr = sldrs:Slider("Slide me!", 0, 1000, 400, function(t)
print(t)
end)

sldrs:Button("Change to 50", function()
sldr:Change(50)
end)

local drops = serv:Channel("Dropdowns")


local drop = drops:Dropdown("Pick me!",{"Option 1","Option 2","Option 3","Option 4","Option 5"}, function(bool)
print(bool)
end)

drops:Button("Clear", function()
drop:Clear()
end)

drops:Button("Add option", function()
drop:Add("Option")
end)

local clrs = serv:Channel("Colorpickers")

clrs:Colorpicker("ESP Color", Color3.fromRGB(255,1,1), function(t)
print(t)
end)

local textbs = serv:Channel("Textboxes")

textbs:Textbox("Gun power", "Type here!", true, function(t)
print(t)
end)

local lbls = serv:Channel("Labels")

lbls:Label("This is just a label.")

local bnds = serv:Channel("Binds")

bnds:Bind("Kill bind", Enum.KeyCode.RightShift, function()
print("Killed everyone!")
end)

serv:Channel("by dawid#7205")


win:Server("Main", "http://www.roblox.com/asset/?id=13060262582")--]]

-- Start the continuous Auto Pickup background loop (waits for _G.AutoPickupAll to be true)
    task.spawn(AutoPickupLoop)

-- Start the Hide Hatch listener
    task.spawn(HideHatchAnim) 

end
