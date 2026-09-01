-- modules/stats.lua
return function(ctx)
    local gui = ctx.gui
    local RunService = ctx.RunService
    local bind = ctx.bind

    local clickTimestamps = {}
    local lastTotalClicks = 0
    local sparkHistory = {}
    
    local frameCount = 0
    local fpsAccum = 0
    local Stats_Service = game:GetService("Stats")
    local lastUpdate = os.clock()

    bind(RunService.Heartbeat, function(dt)
        if ctx.destroyed then return end
        frameCount = frameCount + 1
        fpsAccum = fpsAccum + dt

        if ctx.totalClicks > lastTotalClicks then
            local now = os.clock()
            for _ = 1, (ctx.totalClicks - lastTotalClicks) do
                table.insert(clickTimestamps, now)
            end
            lastTotalClicks = ctx.totalClicks
        end

        local now = os.clock()
        if now - lastUpdate >= 0.5 then
            lastUpdate = now

            if fpsAccum > 0 then ctx.fps = math.floor(frameCount / fpsAccum + 0.5) end
            frameCount = 0
            fpsAccum = 0

            local cutoff = now - 1
            local i = 1
            while i <= #clickTimestamps do
                if clickTimestamps[i] < cutoff then
                    table.remove(clickTimestamps, i)
                else
                    i = i + 1
                end
            end
            ctx.actualCPS = #clickTimestamps

            if gui.Sparkline then
                table.insert(sparkHistory, ctx.actualCPS)
                if #sparkHistory > #gui.Sparkline.Bars then table.remove(sparkHistory, 1) end
                for j, cps in ipairs(sparkHistory) do
                    local ratio = math.clamp(cps / gui.Sparkline.Max, 0, 1)
                    local h = ratio > 0 and math.max(2, math.floor(ratio * gui.Sparkline.MaxBar)) or 0
                    gui.Sparkline.Bars[j].Size = UDim2.new(0, gui.Sparkline.Bars[j].Size.X.Offset, 0, h)
                end
                local targetCPS = ctx.interval > 0 and (1 / ctx.interval) or 0
                gui.Sparkline.SetTarget(targetCPS)
            end

            local ok, pingMs = pcall(function() return Stats_Service.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            ctx.ping = ok and math.floor(pingMs + 0.5) or ctx.ping

            gui.Stats.TotalClicksVal.Text = tostring(ctx.totalClicks)
            gui.Stats.ActualCPSVal.Text = tostring(ctx.actualCPS)
            gui.Stats.FPSVal.Text = tostring(ctx.fps)
            gui.Stats.PingVal.Text = tostring(ctx.ping) .. " ms"

            gui.MiniStats.CPSVal.Text = tostring(ctx.actualCPS)
            gui.MiniStats.FPSVal.Text = tostring(ctx.fps)
            gui.MiniStats.PingVal.Text = tostring(ctx.ping)
        end
    end)
end