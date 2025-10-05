local games = {
    [13667319624] = "https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/refs/heads/main/KS.lua",
    [85896571713843] = "https://raw.githubusercontent.com/IRdotAI/Rcash-Hub/refs/heads/main/BGSI.lua",
    [74260430392611] = "",
}

local scriptURL = games[game.PlaceId]
if scriptURL then
    loadstring(game:HttpGet(scriptURL))()
else 
    print("Game not supported by Rcash Hub")
end






