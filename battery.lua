local utils = require("https://raw.githubusercontent.com/Tetraaaa/CC-Scripts/refs/heads/main/utils.lua")
_G.private = private
local battery = utils.wrap("top")

local function main()
    while true do
        utils.post("energy_percentage", battery.getEnergyFilledPercentage())
        os.sleep(0.5)
    end
end

return { main = main }