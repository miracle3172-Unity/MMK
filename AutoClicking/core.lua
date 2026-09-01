-- SilentAutoclick/core.lua
return function(gui, config)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local lp = Players.LocalPlayer
    local mouse = lp:GetMouse()
    local THEME = gui.Theme

    local ctx = {}
    ctx.gui = gui
    ctx.config = config
    ctx.THEME = THEME
    ctx.lp = lp
    ctx.mouse = mouse
    ctx.Players = Players
    ctx.UserInputService = UserInputService
    ctx.RunService = RunService

    ctx.destroyed = false
    ctx.running = false
    ctx.mode = "cursor" 
    ctx.fixedX = nil
    ctx.fixedY = nil
    ctx.minimized = false
    ctx.hideUI = false
    ctx.draggingUI = false

    ctx.toggleKey = config.Keys.ToggleClicker
    ctx.pickKey = config.Keys.PickPosition
    ctx.hideKey = config.Keys.HideUI

    -- Konfigurasi Interval (Detik)
    ctx.intervalsList = { 0.02, 0.1, 1, 5, 10, 30, 60, 300 }
    ctx.interval = 5 
    ctx.remainingTime = ctx.interval
    ctx.nextExecutionTimestamp = 0

    -- Statistik
    ctx.totalClicks = 0
    ctx.actualCPS = 0
    ctx.fps = 0
    ctx.ping = 0
    ctx.connections = {}

    local function bind(signal, fn)
        local c = signal:Connect(fn)
        table.insert(ctx.connections, c)
        return c
    end
    ctx.bind = bind

    local VIM = (pcall(function() return cloneref(game:GetService("VirtualInputManager")) end))
        and cloneref(game:GetService("VirtualInputManager"))
        or game:GetService("VirtualInputManager")
    ctx.VIM = VIM

    local useVIM = pcall(function()
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
    ctx.useVIM = useVIM

    local function silentClick(x, y)
        if useVIM then
            VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
            VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
        else
            pcall(function()
                local cx, cy = mouse.X, mouse.Y
                mousemoveabs(x, y)
                mouse1press()
                mouse1release()
                mousemoveabs(cx, cy)
            end)
        end
    end
    ctx.silentClick = silentClick

    local function resolvePosition()
        if ctx.mode == "fixed" then
            if ctx.fixedX and ctx.fixedY then
                return ctx.fixedX, ctx.fixedY
            end
            return nil, nil
        end
        return mouse.X, mouse.Y
    end
    ctx.resolvePosition = resolvePosition

    -- Callback Aksi Utama
    ctx.callback = function()
        local x, y = resolvePosition()
        if x and y then
            silentClick(x, y)
            ctx.totalClicks = ctx.totalClicks + 1
        end
    end

    local function updateSchedulerUI()
        local keyName = tostring(ctx.toggleKey):gsub("Enum.KeyCode.", "")
        if ctx.running then
            gui.StatusLbl.Text = "Status: RUNNING"
            gui.StatusLbl.TextColor3 = THEME.success
            gui.ToggleBtn.SetText("Stop [" .. keyName .. "]")
            gui.ToggleBtn.SetColor(THEME.danger)
        else
            gui.StatusLbl.Text = "Status: IDLE"
            gui.StatusLbl.TextColor3 = THEME.danger
            gui.ToggleBtn.SetText("Start [" .. keyName .. "]")
            gui.ToggleBtn.SetColor(THEME.accent)
        end

        gui.MethodLbl.Text = useVIM and "Mode: Silent Click" or "Mode: Fallback"
        gui.MethodLbl.TextColor3 = useVIM and THEME.success or THEME.warn
        gui.MiniStats.StatusVal.Text = ctx.running and "ON" or "OFF"
        gui.MiniStats.StatusVal.TextColor3 = ctx.running and THEME.success or THEME.danger

        if gui.IntervalLbl then
            gui.IntervalLbl.Text = string.format("Interval: %g sec", ctx.interval)
        end
        if gui.IntervalBox and not gui.IntervalBox:IsFocused() then
            gui.IntervalBox.Text = tostring(ctx.interval)
        end

        if gui.CountdownLbl then
            if ctx.running then
                gui.CountdownLbl.Text = string.format("Next: %.1fs", math.max(0, ctx.remainingTime))
            else
                gui.CountdownLbl.Text = "Next: Paused"
            end
        end

        if ctx.mode == "fixed" then
            gui.PosLbl.Visible = true
            if ctx.fixedX and ctx.fixedY then
                gui.PosLbl.Text = string.format("Target: (%d, %d)", ctx.fixedX, ctx.fixedY)
                gui.PosLbl.TextColor3 = THEME.success
            else
                gui.PosLbl.Text = "Target: Not set (press P)"
                gui.PosLbl.TextColor3 = THEME.warn
            end
        else
            gui.PosLbl.Visible = false
        end
    end
    ctx.updateSchedulerUI = updateSchedulerUI

    local function toggleScheduler()
        if ctx.mode == "fixed" then
            local x, y = resolvePosition()
            if not x or not y then
                gui.PosLbl.Text = "Hover target and press P first"
                gui.PosLbl.TextColor3 = THEME.warn
                return
            end
        end
        ctx.running = not ctx.running
        if ctx.running then
            ctx.nextExecutionTimestamp = os.clock() + ctx.interval
            ctx.remainingTime = ctx.interval
        end
        updateSchedulerUI()
    end
    ctx.toggleScheduler = toggleScheduler

    local function destroyAll()
        ctx.destroyed = true
        ctx.running = false
        for _, c in ipairs(ctx.connections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(ctx.connections)
        pcall(function() gui.ScreenGui:Destroy() end)
    end
    ctx.destroyAll = destroyAll
    _G.__SilentAutoclick_Destroy = destroyAll

    return ctx
end