-- config.lua
-- Pengaturan dasar untuk Hybrid Interval Clicker

return {
    -- Pengaturan Jendela Utama
    Window = {
        Title = "Hybrid Interval Clicker",
        Subtitle = "MMKHub UI V2.0 · SILENT CLICK",
        Size = { X = 320, Y = 460 }, -- Lebar 320, Tinggi 460
    },

    -- Pengaturan Hotkey Bawaan
    Keys = {
        ToggleClicker = Enum.KeyCode.F,
        PickPosition = Enum.KeyCode.P,
        HideUI = Enum.KeyCode.K,
    },

    -- Pengaturan Tema Warna
    Theme = {
        bg = Color3.fromRGB(15, 15, 18),
        bg2 = Color3.fromRGB(20, 20, 24),
        panel = Color3.fromRGB(26, 26, 32),
        panel2 = Color3.fromRGB(32, 32, 38),
        text = Color3.fromRGB(240, 240, 245),
        dim = Color3.fromRGB(170, 170, 180),
        faint = Color3.fromRGB(100, 100, 110),
        accent = Color3.fromRGB(0, 170, 255),
        accent2 = Color3.fromRGB(50, 190, 255),
        glow = Color3.fromRGB(0, 150, 255),
        warn = Color3.fromRGB(255, 180, 50),
        danger = Color3.fromRGB(255, 70, 70),
        success = Color3.fromRGB(70, 255, 120),
        divider = Color3.fromRGB(40, 40, 48),  
    },

    -- TAMBAHKAN BAGIAN INI AGAR KOMPONEN MMKHUB TIDAK ERROR
    ComponentDefaults = {
        CornerRadius = UDim.new(0, 10),
        PressScale = 0.97,
    }
}