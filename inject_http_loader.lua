local function http_loader(module_uri)
    local module_text = http.get(module_uri).readAll()
    return loadstring(module_text)
end

table.insert(package.loaders, http_loader)