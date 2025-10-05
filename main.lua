local games = {
    [16510724413] = "",
    [17601705136] = "",
    [17181264920] = "",
    [18138547215] = "",
    [18901165922] = "",
    [85896571713843] = "",
    [126884695634066] = "",
    [127742093697776] = ""
}

local scriptURL = games[game.PlaceId]
if scriptURL then
    loadstring(game:HttpGet(scriptURL))()
else 
    print("Game not supported by Rcash Hub")
end
