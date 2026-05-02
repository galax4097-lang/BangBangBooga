local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình ESP
local ESP_SETTINGS = {
    FillColor = Color3.fromRGB(255, 0, 0), -- Màu bên trong (Đỏ)
    OutlineColor = Color3.fromRGB(255, 255, 255), -- Màu viền (Trắng)
    FillTransparency = 0.5, -- Độ trong suốt bên trong
    OutlineTransparency = 0, -- Độ trong suốt viền
}

-- Hàm tạo ESP cho một người chơi
local function CreateESP(player)
    -- Không tạo ESP cho bản thân
    if player == LocalPlayer then return end

    local function ApplyHighlight(character)
        -- Đợi nhân vật tải xong
        local rootPart = character:WaitForChild("HumanoidRootPart", 10)
        if not rootPart then return end

        -- Xóa Highlight cũ nếu có
        if character:FindFirstChild("ESPHighlight") then
            character.ESPHighlight:Destroy()
        end

        -- Tạo Highlight mới
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = ESP_SETTINGS.FillColor
        highlight.OutlineColor = ESP_SETTINGS.OutlineColor
        highlight.FillTransparency = ESP_SETTINGS.FillTransparency
        highlight.OutlineTransparency = ESP_SETTINGS.OutlineTransparency
        highlight.Adornee = character
        highlight.Parent = character
    end

    -- Chạy hàm khi nhân vật xuất hiện
    if player.Character then
        ApplyHighlight(player.Character)
    end
    player.CharacterAdded:Connect(ApplyHighlight)
end

-- Kích hoạt ESP cho tất cả người chơi hiện tại
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

-- Đợi người chơi mới tham gia để thêm ESP
Players.PlayerAdded:Connect(CreateESP)

-- Hiệu ứng đổi màu Rainbow (Tùy chọn - Xóa đoạn này nếu muốn giữ màu cố định)
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        ESP_SETTINGS.FillColor = Color3.fromHSV(hue, 1, 1)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight.FillColor = ESP_SETTINGS.FillColor
            end
        end
    end
end)

print("✅ ESP Highlight đã được kích hoạt!")
