table.insert(package.loaders, function(u) return loadstring(http.get(u).readAll()) end)
local utils = require("https://raw.githubusercontent.com/Tetraaaa/CC-Scripts/refs/heads/main/utils.lua")
_G.private = private
local battery = utils.wrap("top")
while true do
    utils.post("energy_percentage", battery.getEnergyFilledPercentage())
    os.sleep(0.5)
end