-- modules/clicker.lua
return function(ctx)
    local gui = ctx.gui
    local bind = ctx.bind
    local RunService = ctx.RunService

    local INTERVALS = ctx.intervalsList

    local function ratioToInterval(ratio)
        local idx = math.clamp(math.floor(ratio * (#INTERVALS - 1) + 0.5) + 1, 1, #INTERVALS)
        return INTERVALS[idx]
    end

    local function intervalToRatio(val)
        local closestIdx, minDiff = 1, math.huge
        for i, v in ipairs(INTERVALS) do
            local diff = math.abs(v - val)
            if diff < minDiff then
                minDiff = diff; closestIdx = i
            end
        end
        return (closestIdx - 1) / (#INTERVALS - 1)
    end

    if gui.IntervalSlider and gui.IntervalSlider.SetValue then
        pcall(function() gui.IntervalSlider.SetValue(intervalToRatio(ctx.interval)) end)
    end

    gui.ModeDropdown.OnSelected(function(item)
        ctx.mode = (item == "Fixed Position") and "fixed" or "cursor"
        ctx.updateSchedulerUI()
    end)

    bind(gui.ToggleBtn.Instance.MouseButton1Click, ctx.toggleScheduler)
    gui.KeybindBtn.OnChanged(function(key)
        ctx.toggleKey = key
        ctx.updateSchedulerUI()
    end)

    gui.IntervalSlider.OnChanged(function(ratio)
        ctx.interval = ratioToInterval(ratio)
        if ctx.running then
            ctx.nextExecutionTimestamp = os.clock() + ctx.interval
            ctx.remainingTime = ctx.interval
        end
        ctx.updateSchedulerUI()
    end)

    if gui.IntervalBox then
        bind(gui.IntervalBox.FocusLost, function()
            local num = tonumber(gui.IntervalBox.Text)
            if num and num > 0 then
                ctx.interval = num
                if ctx.running then
                    ctx.nextExecutionTimestamp = os.clock() + ctx.interval
                    ctx.remainingTime = ctx.interval
                end
                if gui.IntervalSlider and gui.IntervalSlider.SetValue then
                    pcall(function() gui.IntervalSlider.SetValue(intervalToRatio(num)) end)
                end
            else
                gui.IntervalBox.Text = tostring(ctx.interval)
            end
            ctx.updateSchedulerUI()
        end)
    end

    bind(RunService.Heartbeat, function()
        if ctx.destroyed or not ctx.running then return end
        local now = os.clock()
        ctx.remainingTime = ctx.nextExecutionTimestamp - now

        if ctx.remainingTime <= 0 then
            pcall(ctx.callback)
            ctx.nextExecutionTimestamp = now + ctx.interval
            ctx.remainingTime = ctx.interval
        end
        ctx.updateSchedulerUI()
    end)

    ctx.updateSchedulerUI()
end