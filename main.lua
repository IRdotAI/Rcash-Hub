local games = {
    [13667319624] = "https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/refs/heads/main/KS.lua",
    [85896571713843] = "https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/refs/heads/main/BGSI.lua",
    [286090429] = "https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/refs/heads/main/ARS.lua",
}

local scriptURL = games[game.PlaceId]
if scriptURL then
    loadstring(game:HttpGet(scriptURL))()
else 
    game:GetService("StarterGui"):SetCore("SendNotification",{
	    Title = "Rcash Hub 💸",
	    Text = "Game not supported by Rcash Hub.",
	    Icon = "rbxassetid://110392278560658"
    })
end





