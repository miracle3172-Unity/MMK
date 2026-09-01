-- config.lua
-- Pengaturan dasar untuk Hybrid Interval Clicker

return {
    -- Pengaturan Jendela Utama
    Window = {
        Title = "Hybrid Interval Clicker",
        Subtitle = "LYRAHUB UI V2.0 · SILENT CLICK",
        Size = { X = 320, Y = 460 }, -- Lebar 320, Tinggi 460
    },

    -- Pengaturan Hotkey Bawaan (Bisa diubah langsung di dalam game nanti)
    Keys = {
        ToggleClicker = Enum.KeyCode.F, -- Tombol Start/Stop
        PickPosition = Enum.KeyCode.P,  -- Tombol untuk memilih target di layar
        HideUI = Enum.KeyCode.K,        -- Tombol untuk menyembunyikan/menampilkan menu
    },

    -- Pengaturan Tema Warna (Dark Theme dengan aksen Biru)
    Theme = {
        bg = Color3.fromRGB(15, 15, 18),       -- Latar belakang utama (Sangat gelap)
        bg2 = Color3.fromRGB(20, 20, 24),      -- Gradasi latar belakang
        panel = Color3.fromRGB(26, 26, 32),    -- Warna panel dasar
        panel2 = Color3.fromRGB(32, 32, 38),   -- Warna kartu/kotak input
        text = Color3.fromRGB(240, 240, 245),  -- Warna teks utama (Putih terang)
        dim = Color3.fromRGB(170, 170, 180),   -- Warna teks sekunder (Abu-abu)
        faint = Color3.fromRGB(100, 100, 110), -- Warna teks pudar (Abu-abu gelap)
        
        -- Warna Aksen (Bisa Anda ganti kode RGB-nya jika ingin warna lain)
        accent = Color3.fromRGB(0, 170, 255),  -- Biru utama (seperti di screenshot)
        accent2 = Color3.fromRGB(50, 190, 255),-- Biru terang (untuk hover/teks tebal)
        glow = Color3.fromRGB(0, 150, 255),    -- Efek bayangan/glow biru
        
        -- Warna Indikator Status
        warn = Color3.fromRGB(255, 180, 50),   -- Kuning peringatan
        danger = Color3.fromRGB(255, 70, 70),  -- Merah tanda berhenti/error
        success = Color3.fromRGB(70, 255, 120),-- Hijau tanda berjalan lancar
        
        -- Garis pembatas
        divider = Color3.fromRGB(40, 40, 48),  
    }
}