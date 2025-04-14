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
monitor.setTextScale(1.5)

while true do
    local data = get()
    if data then
        local w, _ = monitor.getSize()
        monitor.clear()

        -- Titre centré
        local title = "Fissile Fuel Production"
        local titleX = math.floor((w - #title) / 2) + 1
        monitor.setCursorPos(titleX, 1)
        monitor.write(title)

        -- Récupération des données
        local production = data.fissile_fuel_produced or 0
        local energy_used = data.fissile_fuel_energy_used or 0

        -- Affichage de la production
        monitor.setCursorPos(1, 3)
        monitor.write(string.format("Production : %.1f mb/t", production))

        -- Affichage de l'énergie utilisée (en kFE/t)
        monitor.setCursorPos(1, 4)
        monitor.write(string.format("Energy Used: %.2f kFE/t", energy_used / 1000))

        -- État de la production
        local status = ""
        local color = colors.white

        if production >= 32 then
            status = "Production: Optimal"
            color = colors.lime
        elseif production > 0 then
            status = "Production: Partial"
            color = colors.yellow
        else
            status = "Production: Stopped"
            color = colors.red
        end

        -- Affichage centré du statut
        monitor.setTextColor(color)
        local statusX = math.floor((w - #status) / 2) + 1
        monitor.setCursorPos(statusX, 6)
        monitor.write(status)
        monitor.setTextColor(colors.white) -- reset couleur
    end
    sleep(0.5)
end
