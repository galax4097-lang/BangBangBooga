local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- ==========================================
-- 1. TẠO GIAO DIỆN GUI
-- ==========================================
local pGui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

if pGui:FindFirstChild("PetSimGrindHub") then
    pGui.PetSimGrindHub:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "PetSimGrindHub"
sg.ResetOnSpawn = false
sg.Parent = pGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 250)
mainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = sg
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "💎 PET SIM GRIND HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- ==========================================
-- 2. CÁC NÚT TÍNH NĂNG
-- ==========================================
-- Nút Hút Tiền
local collectBtn = Instance.new("TextButton")
collectBtn.Size = UDim2.new(0.9, 0, 0, 40)
collectBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
collectBtn.Text = "🧲 AUTO COLLECT: OFF"
collectBtn.Font = Enum.Font.GothamBold
collectBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
collectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collectBtn.Parent = mainFrame
Instance.new("UICorner", collectBtn).CornerRadius = UDim.new(0, 6)

-- Nút Pet/Player Speed
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.9, 0, 0, 40)
speedBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
speedBtn.Text = "⚡ DI CHUYỂN NHANH: OFF"
speedBtn.Font = Enum.Font.GothamBold
speedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Parent = mainFrame
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 6)

-- Nút Luck (Nút cảnh báo)
local luckBtn = Instance.new("TextButton")
luckBtn.Size = UDim2.new(0.9, 0, 0, 40)
luckBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
luckBtn.Text = "🍀 TĂNG MAY MẮN (Đọc kỹ)"
luckBtn.Font = Enum.Font.GothamBold
luckBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
luckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
luckBtn.Parent = mainFrame
Instance.new("UICorner", luckBtn).CornerRadius = UDim.new(0, 6)

-- Nút Đóng
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.9, 0, 0, 30)
closeBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
closeBtn.Text = "❌ ĐÓNG GUI"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- 3. LOGIC HOẠT ĐỘNG
-- ==========================================

-- Tính năng 1: Hút tiền (Auto Collect)
local autoCollect = false
collectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    collectBtn.Text = autoCollect and "🧲 AUTO COLLECT: ON" or "🧲 AUTO COLLECT: OFF"
    collectBtn.BackgroundColor3 = autoCollect and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
end)

task.spawn(function()
    while true do
        if autoCollect and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                -- Lấy vị trí rương/tiền bị rớt ra (Orbs). Trong Pet Sim thường lưu ở một folder trong Workspace
                local things = workspace:FindFirstChild("__THINGS")
                if things and things:FindFirstChild("Orbs") then
                    for _, orb in pairs(things.Orbs:GetChildren()) do
                        if orb:IsA("BasePart") then
                            orb.CFrame = player.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
        task.wait(0.2) -- Chạy mỗi 0.2s để tránh giật lag máy
    end
end)

-- Tính năng 2: Di chuyển siêu tốc (Bao gồm người và kéo pet theo)
local speedActive = false
speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.Text = speedActive and "⚡ DI CHUYỂN NHANH: ON" or "⚡ DI CHUYỂN NHANH: OFF"
    speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(100, 100, 100)
end)

runService.Heartbeat:Connect(function()
    if speedActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 60 -- Tốc độ di chuyển nhanh nhưng an toàn, Pet sẽ tự động bay theo người
    elseif not speedActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Tính năng 3: Giải thích về Luck
luckBtn.MouseButton1Click:Connect(function()
    luckBtn.Text = "KHÔNG THỂ HACK LUCK!"
    luckBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    task.wait(2)
    luckBtn.Text = "🍀 TĂNG MAY MẮN (Đọc kỹ)"
    luckBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
end)

-- Đóng GUI
closeBtn.MouseButton1Click:Connect(function()
    autoCollect = false
    speedActive = false
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
    sg:Destroy()
end)
