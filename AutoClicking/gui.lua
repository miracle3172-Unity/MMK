-- SilentAutoclick/gui.lua
return function(config, components)
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    local shared = components.shared
    local THEME = config.Theme
    -- Override tinggi UI agar muat untuk layout baru yang lebih rapi
    local W, H = config.Window.Size.X, 460 

    if _G.__SilentAutoclick_Destroy then pcall(_G.__SilentAutoclick_Destroy) end
    _G.__SilentAutoclick_Destroy = nil

    local view = {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "IntervalClicker_GUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end
    view.ScreenGui = ScreenGui

    local function label(opts)
        local l = Instance.new("TextLabel")
        l.Size = opts.Size or UDim2.new(0, 200, 0, 20)
        l.Position = opts.Position or UDim2.new(0, 0, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = opts.Text or ""
        l.TextColor3 = opts.Color or THEME.text
        l.Font = opts.Font or Enum.Font.Gotham
        l.TextSize = opts.TextSize or 12
        l.TextXAlignment = opts.TextXAlignment or Enum.TextXAlignment.Left
        l.TextYAlignment = opts.TextYAlignment or Enum.TextYAlignment.Center
        if opts.Visible ~= nil then l.Visible = opts.Visible end
        l.Parent = opts.Parent
        return l
    end

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(W, H)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = THEME.bg
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    shared.corner(Main, UDim.new(0, 12))
    shared.stroke(Main, THEME.divider, 1, 0.45)
    shared.glow(Main, THEME.glow, 4, 0.92)
    view.Main = Main
    view.Shadow = shared.shadow(Main)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 48)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = Main

    local logo = Instance.new("Frame")
    logo.Size = UDim2.fromOffset(10, 10)
    logo.Position = UDim2.fromOffset(16, 19)
    logo.BackgroundColor3 = THEME.accent
    logo.Parent = TopBar
    shared.corner(logo, UDim.new(1, 0))

    local TopBarTitle = label({ Parent = TopBar, Text = "Hybrid Interval Clicker", Position = UDim2.fromOffset(34, 10), Size = UDim2.fromOffset(220, 22), TextSize = 14, Font = Enum.Font.GothamBold, Color = THEME.accent2 })
    label({ Parent = TopBar, Text = "LYRAHUB UI V2.0", Position = UDim2.fromOffset(34, 30), Size = UDim2.fromOffset(240, 12), TextSize = 7, Color = THEME.faint, Font = Enum.Font.GothamBold })

    local minBtn = components.button({ Parent = Main, Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(W - 76, 10), Text = "—", TextSize = 13, Color = THEME.panel2, TextColor = THEME.text, HoverColor = THEME.accent2, CornerRadius = UDim.new(0, 8), Glow = false })
    local closeBtn = components.button({ Parent = Main, Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(W - 40, 10), Text = "✕", TextSize = 12, Color = Color3.fromRGB(64, 28, 34), TextColor = THEME.danger, HoverColor = Color3.fromRGB(96, 38, 46), CornerRadius = UDim.new(0, 8), Glow = false })
    view.MinBtn = minBtn.Instance
    view.CloseBtn = closeBtn.Instance

    local DragHit = Instance.new("TextButton")
    DragHit.Size = UDim2.new(1, 0, 0, 48)
    DragHit.BackgroundTransparency = 1
    DragHit.Text = ""
    DragHit.Parent = Main
    view.DragHit = DragHit

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.fromOffset(0, 48)
    divider.BackgroundColor3 = THEME.divider
    divider.BorderSizePixel = 0
    divider.Parent = Main

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -24, 1, -68)
    Content.Position = UDim2.new(0, 12, 0, 56)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    view.StatusLbl = label({ Parent = Content, Text = "Status: IDLE", Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 20), TextSize = 15, Font = Enum.Font.GothamBold, Color = THEME.danger })
    view.MethodLbl = label({ Parent = Content, Text = "Mode: -", Position = UDim2.fromOffset(0, 20), Size = UDim2.new(1, 0, 0, 12), TextSize = 10, Color = THEME.warn })

    view.ModeDropdown = components.dropdown({ Parent = Content, Size = UDim2.fromOffset(230, 30), Position = UDim2.fromOffset(0, 40), Items = { "Follow Cursor", "Fixed Position" }, Default = "Follow Cursor", ItemHeight = 26 })
    view.PosLbl = label({ Parent = Content, Text = "Target: Not set", Position = UDim2.fromOffset(0, 74), Size = UDim2.new(1, 0, 0, 12), TextSize = 10, Color = THEME.dim, Visible = false })

    -- Interval Row UI
    view.IntervalLbl = label({ Parent = Content, Text = "Interval: 5 sec", Position = UDim2.fromOffset(0, 95), Size = UDim2.fromOffset(110, 14), TextSize = 11, Font = Enum.Font.GothamBold, Color = THEME.text })
    
    view.IntervalBox = Instance.new("TextBox")
    view.IntervalBox.Size = UDim2.fromOffset(60, 24)
    view.IntervalBox.Position = UDim2.fromOffset(170, 90)
    view.IntervalBox.BackgroundColor3 = THEME.panel2
    view.IntervalBox.TextColor3 = THEME.accent2
    view.IntervalBox.Font = Enum.Font.GothamBold
    view.IntervalBox.TextSize = 11
    view.IntervalBox.Text = "5"
    view.IntervalBox.ClearTextOnFocus = false
    view.IntervalBox.BorderSizePixel = 0
    view.IntervalBox.Parent = Content
    shared.corner(view.IntervalBox, UDim.new(0, 6))
    shared.stroke(view.IntervalBox, THEME.divider, 1, 0.5)

    view.IntervalSlider = components.slider({ Parent = Content, Size = UDim2.fromOffset(230, 6), Position = UDim2.fromOffset(0, 122), Default = 0.5 })
    view.CountdownLbl = label({ Parent = Content, Text = "Next: 5.0s", Position = UDim2.fromOffset(0, 136), Size = UDim2.new(1, 0, 0, 20), TextSize = 13, Font = Enum.Font.GothamBold, Color = THEME.accent2 })

    -- Stats & Sparkline Frame
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, 0, 0, 150)
    StatsFrame.Position = UDim2.fromOffset(0, 166)
    StatsFrame.BackgroundColor3 = THEME.panel
    StatsFrame.BackgroundTransparency = 0.5
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = Content
    shared.corner(StatsFrame, UDim.new(0, 10))
    shared.stroke(StatsFrame, THEME.divider, 1, 0.5)

    local StatsGrid = Instance.new("Frame")
    StatsGrid.Size = UDim2.new(1, 0, 0, 94)
    StatsGrid.BackgroundTransparency = 1
    StatsGrid.Parent = StatsFrame
    local gridLayout = Instance.new("UIGridLayout", StatsGrid)
    gridLayout.CellSize = UDim2.new(0.5, -4, 0, 40)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 6)
    local gridPad = Instance.new("UIPadding", StatsGrid)
    gridPad.PaddingTop = UDim.new(0, 8)
    gridPad.PaddingLeft = UDim.new(0, 8)
    gridPad.PaddingRight = UDim.new(0, 8)

    local function makeStatCard(title)
        local card = Instance.new("Frame")
        card.BackgroundColor3 = THEME.panel2
        card.BorderSizePixel = 0
        card.Parent = StatsGrid
        shared.corner(card, UDim.new(0, 6))
        label({ Parent = card, Text = title, Position = UDim2.fromOffset(6, 4), Size = UDim2.new(1, -12, 0, 10), TextSize = 8, Color = THEME.faint, Font = Enum.Font.GothamBold })
        return label({ Parent = card, Text = "0", Position = UDim2.fromOffset(6, 16), Size = UDim2.new(1, -12, 0, 20), TextSize = 13, Font = Enum.Font.GothamBold })
    end

    view.Stats = {
        TotalClicksVal = makeStatCard("TOTAL CLICKS"),
        ActualCPSVal = makeStatCard("ACTUAL CPS"),
        FPSVal = makeStatCard("FPS"),
        PingVal = makeStatCard("PING")
    }

    -- Wide Sparkline Graph
    local SparklineCanvas = Instance.new("Frame")
    SparklineCanvas.Size = UDim2.new(1, -16, 0, 42)
    SparklineCanvas.Position = UDim2.new(0, 8, 0, 100)
    SparklineCanvas.BackgroundColor3 = THEME.panel2
    SparklineCanvas.BorderSizePixel = 0
    SparklineCanvas.ClipsDescendants = true
    SparklineCanvas.Parent = StatsFrame
    shared.corner(SparklineCanvas, UDim.new(0, 6))

    local TargetLine = Instance.new("Frame")
    TargetLine.Size = UDim2.new(1, 0, 0, 1)
    TargetLine.AnchorPoint = Vector2.new(0, 1)
    TargetLine.BackgroundColor3 = THEME.warn
    TargetLine.BorderSizePixel = 0
    TargetLine.ZIndex = 3
    TargetLine.Parent = SparklineCanvas
    local function setTargetLine(cps)
        local ratio = math.clamp((tonumber(cps) or 0) / 100, 0, 1)
        TargetLine.Position = UDim2.new(0, 0, 1, -2 - ratio * 38)
    end

    local sparkBars = {}
    local barStep = (W - 24 - 16) / 60
    local barWidth = math.max(2, math.floor(barStep) - 1)
    for i = 1, 60 do
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, barWidth, 0, 0)
        bar.AnchorPoint = Vector2.new(0, 1)
        bar.Position = UDim2.new(0, math.floor((i - 1) * barStep), 1, -2)
        bar.BackgroundColor3 = THEME.accent
        bar.BorderSizePixel = 0
        bar.Parent = SparklineCanvas
        shared.corner(bar, UDim.new(0, 2))
        sparkBars[i] = bar
    end
    view.Sparkline = { Bars = sparkBars, Max = 100, MaxBar = 38, SetTarget = setTargetLine }

    -- Bottom Controls
    view.ToggleBtn = components.button({ Parent = Content, Size = UDim2.fromOffset(190, 36), Position = UDim2.fromOffset(0, 330), Text = "Start [F]", TextSize = 12, Color = THEME.accent, HoverColor = THEME.accent2, Glow = false })
    view.KeybindBtn = components.keybind({ Parent = Content, Size = UDim2.fromOffset(122, 36), Position = UDim2.fromOffset(202, 330), Default = config.Keys.ToggleClicker })
    view.HintLbl = label({ Parent = Content, Text = "P: pick target · K: hide UI", Position = UDim2.fromOffset(0, 372), Size = UDim2.new(1, 0, 0, 12), TextSize = 9, Color = THEME.faint })

    -- Minimized Panel (No Changes)
    local MinimizedPanel = Instance.new("Frame")
    MinimizedPanel.Size = UDim2.fromOffset(240, 62)
    MinimizedPanel.Position = UDim2.fromOffset(20, 20)
    MinimizedPanel.BackgroundColor3 = THEME.bg
    MinimizedPanel.BorderSizePixel = 0
    MinimizedPanel.Visible = false
    MinimizedPanel.Parent = ScreenGui
    shared.corner(MinimizedPanel, UDim.new(0, 10))
    shared.stroke(MinimizedPanel, THEME.accent, 1, 0.4)
    view.MinimizedPanel = MinimizedPanel

    view.MiniHeader = label({ Parent = MinimizedPanel, Text = "Hybrid Clicker", Position = UDim2.fromOffset(8, 4), Size = UDim2.new(1, -28, 0, 16), TextSize = 10, Color = THEME.accent2, Font = Enum.Font.GothamBold })
    view.ExpandBtn = components.button({ Parent = MinimizedPanel, Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(240 - 24, 3), Text = "▢", TextSize = 11, Color = THEME.panel2, TextColor = THEME.dim, CornerRadius = UDim.new(0, 5), Glow = false }).Instance

    local MiniCardsRow = Instance.new("Frame")
    MiniCardsRow.Size = UDim2.new(1, -16, 0, 34)
    MiniCardsRow.Position = UDim2.fromOffset(8, 24)
    MiniCardsRow.BackgroundTransparency = 1
    MiniCardsRow.Parent = MinimizedPanel
    local MiniListLayout = Instance.new("UIListLayout", MiniCardsRow)
    MiniListLayout.FillDirection = Enum.FillDirection.Horizontal
    MiniListLayout.Padding = UDim.new(0, 4)

    local function makeMiniCard(title)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 53, 1, 0)
        card.BackgroundColor3 = THEME.panel2
        card.BorderSizePixel = 0
        card.Parent = MiniCardsRow
        shared.corner(card, UDim.new(0, 6))
        label({ Parent = card, Text = title, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 0, 10), TextSize = 8, Color = THEME.dim, TextXAlignment = Enum.TextXAlignment.Center })
        return label({ Parent = card, Text = "-", Position = UDim2.fromOffset(2, 13), Size = UDim2.new(1, -4, 0, 16), TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center })
    end

    view.MiniStats = {
        StatusVal = makeMiniCard("STATUS"),
        CPSVal = makeMiniCard("CPS"),
        FPSVal = makeMiniCard("FPS"),
        PingVal = makeMiniCard("PING"),
    }

    view.Theme = THEME
    view.Toast = components.toast
    return view
end