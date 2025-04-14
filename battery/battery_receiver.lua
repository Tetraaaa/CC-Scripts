local api_key = ""

local function get()
    local response = http.get("https://cc.tetraaa.fr?api_key=" .. api_key)
    if response then
        local data = response.readAll()
        response.close()
        return textutils.unserialiseJSON(data)
    else
        -- Retourne nil si la requête a échoué
        return nil
    end
end

local function formatEnergy(value)
    local units = { "FE", "kFE", "MFE", "GFE" }
    local unitIndex = 1

    while value >= 1000 and unitIndex < #units do
        value = value / 1000
        unitIndex = unitIndex + 1
    end

    return string.format("%.2f %s", value, units[unitIndex])
end

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

local monitor = wrap()
term.redirect(monitor)
monitor.setTextScale(1)

-- Fonction pour interpoler entre deux couleurs
local function interpolateColor(ratio)
    local red = math.floor(255 * (1 - ratio))
    local green = math.floor(255 * ratio)
    return colors.combine(
        red > 127 and colors.red or 0,
        green > 127 and colors.lime or 0
    )
end

while true do
    local data = get()
    if data then
        local energy_ratio = data.battery_energy_percentage or 0
        local battery_input = data.battery_input or 0
        local battery_output = data.battery_output or 0

        local net_flow = battery_input - battery_output

        local w, _ = monitor.getSize()
        monitor.clear()

        -- Titre centré
        local title = "Battery Status"
        local titleX = math.floor((w - #title) / 2) + 1
        monitor.setCursorPos(titleX, 1)
        monitor.write(title)

        -- Pourcentage affiché avec énergie actuelle/max en kFE ou MFE
        local energy_percentage = data.battery_energy_percentage * 100
        local current_energy = data.battery_energy_percentage * data.battery_max_energy
        local max_energy = data.battery_max_energy

        monitor.setCursorPos(1, 3)
        monitor.write(string.format(
            "Energy: %.1f%% (%s / %s)",
            energy_percentage,
            formatEnergy(current_energy),
            formatEnergy(max_energy)
        ))

        -- Input et Output (en kFE)
        monitor.setCursorPos(1, 4)
        monitor.write("Input : " .. formatEnergy(battery_input) .. "/t")
        monitor.setCursorPos(1, 5)
        monitor.write("Output : " .. formatEnergy(battery_output) .. "/t")

        -- Net flow avec flèche et couleur
        local flowColor = net_flow >= 0 and colors.lime or colors.red
        local flowArrow = net_flow >= 0 and "▲" or "▼"

        -- Temps restant (charge ou décharge)
        local time_remaining_str = ""
        local max_energy = data.battery_max_energy or 0
        if net_flow > 0 and data.battery_energy_needed and max_energy > 0 then
            local ticks_remaining = data.battery_energy_needed / net_flow
            local seconds_remaining = ticks_remaining / 20
            local hours = math.floor(seconds_remaining / 3600)
            local minutes = math.floor((seconds_remaining % 3600) / 60)
            local seconds = math.floor(seconds_remaining % 60)
            time_remaining_str = string.format(" (%02d:%02d:%02d)", hours, minutes, seconds)
        elseif net_flow < 0 and data.battery_energy_percentage and max_energy > 0 then
            local current_energy = data.battery_energy_percentage * max_energy
            local ticks_remaining = current_energy / -net_flow
            local seconds_remaining = ticks_remaining / 20
            local hours = math.floor(seconds_remaining / 3600)
            local minutes = math.floor((seconds_remaining % 3600) / 60)
            local seconds = math.floor(seconds_remaining % 60)
            time_remaining_str = string.format(" (%02d:%02d:%02d)", hours, minutes, seconds)
        end

        monitor.setTextColor(flowColor)
        monitor.setCursorPos(1, 6)
        monitor.write(string.format("Net Flow: %s/t %s%s", formatEnergy(math.abs(net_flow)), flowArrow, time_remaining_str))
        monitor.setTextColor(colors.white)

        -- Barre de progression (ligne 8)
        local barWidth = w - 2
        local filledWidth = math.floor(energy_ratio * barWidth)
        local color = interpolateColor(energy_ratio)

        monitor.setCursorPos(2, 8)
        for i = 1, barWidth do
            if i <= filledWidth then
                monitor.setBackgroundColor(color)
            else
                monitor.setBackgroundColor(colors.black)
            end
            monitor.write(" ")
        end
        monitor.setBackgroundColor(colors.black) -- reset
    end
    sleep(0.5)
end
