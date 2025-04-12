--One-liner à ajouter au startup pour permettre le chargement des scripts via http

local utils = (table.insert(package.loaders, function(u) return loadstring(http.get(u).readAll()) end) and require("https://raw.githubusercontent.com/Tetraaaa/CC-Scripts/main/utils.lua"))
