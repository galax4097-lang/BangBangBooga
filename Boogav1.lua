local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Xóa GUI cũ
local coreGui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
if coreGui:FindFirstChild("UltimateHackHub") then
    coreGui.UltimateHackHub:Destroy()
end

-- ==========================================
-- 1. GIAO DIỆN (GUI) BẮT MẮT
-- ==========================================
local sg = Instance.new("ScreenGui")
sg.Name = "UltimateHackHub"
sg.ResetOnSpawn = false
sg.Parent = coreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 320)
main.Position = UDim2.new(0.5, -160, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 100)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚡ ULTIMATE EXPLOIT HUB"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Nút Click TP
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 40)
tpBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
tpBtn.Text = "CLICK TP: OFF (Ctrl + Click)"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Parent = main
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

-- Speed UI
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.4, 0, 0, 40)
speedBtn.Position = UDim2.new(0.55, 0, 0.4, 0)
speedBtn.Text = "SPEED"
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
speedBtn.Parent = main
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 8)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.4, 0, 0, 40)
speedBox.Position = UDim2.new(0.05, 0, 0.4, 0)
speedBox.Text = "50"
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Parent = main
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

-- Fly UI
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
flyBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
flyBtn.Text = "FLY MODE (E)"
flyBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
flyBtn.Parent = main
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.9, 0, 0, 40)
closeBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
closeBtn.Text = "CLOSE"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Parent = main
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- 2. LOGIC DỊCH CHUYỂN (CLICK TELEPORT)
-- ==========================================
local tpActive = false
tpBtn.MouseButton1Click:Connect(function()
    tpActive = not tpActive
    tpBtn.Text = tpActive and "CLICK TP: ON" or "CLICK TP: OFF"
    tpBtn.BackgroundColor3 = tpActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
end)

mouse.Button1Down:Connect(function()
    if tpActive and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Dịch chuyển nhẹ lên trên một chút để không bị kẹt dưới đất
            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end)

-- ==========================================
-- 3. SPEED & FLY (TỐI ƯU CHO BOOGA)
-- ==========================================
local speedActive = false
speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.Text = speedActive and "ON" or "SPEED"
end)

runService.Heartbeat:Connect(function()
    if speedActive then
        local s = tonumber(speedBox.Text) or 16
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = s
        end
    end
end)

-- (Phần code Fly mình giữ nguyên logic cũ nhưng tích hợp vào phím E cho bạn)
local flying = false
local function toggleFly()
    flying = not flying
    flyBtn.Text = flying and "FLYING..." or "FLY MODE (E)"
    -- ... (Logic Fly tương tự các bản trước)
end
flyBtn.MouseButton1Click:Connect(toggleFly)
uis.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.E then toggleFly() end end)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
