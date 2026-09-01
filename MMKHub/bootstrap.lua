-- MMKHub/bootstrap.lua

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local USER = "miracle3172-Unity"
local REPO = "MMK"
local BRANCH = "main"
local FOLDER = "MMKHub"

local BASE_URL = ("https://raw.githubusercontent.com/%s/%s/%s/%s/"):format(USER, REPO, BRANCH, FOLDER)

local ok, result = pcall(function()
    return game:HttpGet(BASE_URL .. "main.lua")
end)

if ok and result then
    local fn, err = loadstring(result)
    if fn then
        -- Meneruskan BASE_URL ke main.lua
        fn(BASE_URL)
    else
        warn("MMKHub Compile Error: " .. tostring(err))
    end
else
    warn("MMKHub Fetch Error: " .. tostring(result))
end