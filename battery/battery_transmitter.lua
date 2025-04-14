local api_key = ""

local function get_first_peripheral()
    local peripherals = peripheral.getNames()
    if #peripherals > 0 then
        return peripherals[1]
    end
    return nil
end

local function wrap(name)
    if name == nil then
        local first_peripheral = get_first_peripheral()
        if first_peripheral ~= nil then
            return peripheral.wrap(first_peripheral)
        end
        return term
    else
        if peripheral.isPresent(name) then
            return peripheral.wrap(name)
        else
            return term
        end
    end
end

local function post(data)
    http.post(
        "https://cc.tetraaa.fr?api_key=" .. api_key,
        textutils.serialiseJSON(data),
        { ["Content-Type"] = "application/json" }
    )
end

local battery = wrap()

while true do
    local data = {
        battery_energy_percentage = battery.getEnergyFilledPercentage(),
        battery_input = battery.getLastInput() / 2.5,
        battery_output = battery.getLastOutput() / 2.5,
        battery_energy_needed = battery.getEnergyNeeded() / 2.5,
        battery_max_energy = battery.getMaxEnergy() / 2.5,
    }

    post(data)
    os.sleep(0.5)
end