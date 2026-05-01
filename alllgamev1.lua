local player = game:GetService("Players").LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Xóa bảng cũ nếu nó đang tồn tại để reset
if pGui:FindFirstChild("TestGui") then
    pGui.TestGui:Destroy()
end

-- 1. TẠO SCREEN GUI
local sg = Instance.new("ScreenGui")
sg.Name = "TestGui"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999 -- Đảm bảo nó hiện trên cùng các layer khác
sg.Parent = pGui

-- 2. KHUNG CHÍNH (Sẽ hiện ở giữa màn hình)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true -- Bạn có thể cầm chuột kéo nó đi
frame.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- 3. TIÊU ĐỀ (Để bạn biết là nó đã chạy)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ĐÃ KÍCH HOẠT GUI ✅"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
title.Parent = frame
Instance.new("UICorner", title)

-- 4. NÚT TEST TỐC ĐỘ
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 40)
btn.Position = UDim2.new(0.1, 0, 0.5, 0)
btn.Text = "CHẠY NHANH (X50)"
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.Parent = frame
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 50
        btn.Text = "ĐANG BẬT SPEED!"
    end
end)

print("GUI đã được gửi vào PlayerGui của bạn!")
