-- bootstrap.lua
-- Tiny loader: fetches main.lua (and everything else) from GitHub

-- 1. Anti-Lag: Tunggu sampai engine game selesai memuat map dan asset
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- 2. Konfigurasi GitHub Pribadi
local USER = "miracle3172-Unity"
local REPO = "AutoClicker"
local BRANCH = "main"

-- URL mengarah langsung ke root repository Anda
local BASE_URL = ("https://raw.githubusercontent.com/%s/%s/%s/"):format(USER, REPO, BRANCH)

local function fetch(url, name)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not result or result == "404: Not Found" or result == "Not Found" then
        error("Failed to fetch " .. tostring(name) .. " from " .. tostring(url))
    end
    return result
end

local function compile(source, name)
    local fn, err = loadstring(source)
    if not fn then
        error("Failed to compile " .. tostring(name) .. ": " .. tostring(err))
    end
    return fn
end

-- Pass BASE_URL as vararg so main.lua receives it via `...`
local mainChunk = compile(fetch(BASE_URL .. "main.lua", "main.lua"), "main.lua")
mainChunk(BASE_URL)