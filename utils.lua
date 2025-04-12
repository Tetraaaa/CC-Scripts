local function cls()
    term.clear()
    term.setCursorPos(1, 1)
end

local function write_center(text)
    local x, y = term.getCursorPos()
    local width, height = term.getSize()
    term.setCursorPos(math.floor((width - #text) / 2) + 1, y)
    term.write(text)
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

local function get(key)
    local data = http.get("https://cc.tetraaa.fr?api_key=" .. private.api_key).readAll()
    return textutils.unserialise(data)[key]
end

local function post(key, value)
    http.post("https://cc.tetraaa.fr?api_key=" .. private.api_key, textutils.serialise({ [key] = value }), { ["Content-Type"] = "application/json" })
end


return { cls = cls, write_center = write_center, wrap = wrap, get = get, post = post }
