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

local periph = wrap()

local peripheralType = "cable"
if periph.getOutputCapacity then
    peripheralType = "isotopic_centrifuge"
end

while true do
    local data
    if peripheralType == "cable" then
        data = {
            fissile_fuel_energy_used = periph.getNeeded()/2.5,
        }
    elseif peripheralType == "isotopic_centrifuge" then
        data = {
            fissile_fuel_produced = periph.getOutputCapacity() - periph.getOutputNeeded(),
        }
    end

    post(data)
    os.sleep(0.5)
end