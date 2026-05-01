local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

-- 1. TẠO GUI CYBER NEON
local sg = Instance.new("ScreenGui")
sg.Name = "TSB_Ultimate"
sg.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 350)
main.Position = UDim2.new(0.5, -150, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Parent = main

-- Hiệu ứng chạy màu RGB mượt
task.spawn(function()
    while task.wait() do
        local hue = tick() % 4 / 4
        stroke.Color = Color3.fromHSV(hue, 0.8, 1)
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "TSB: ULTIMATE ABUSE"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = main

-- 2. HÀM TẠO NÚT BẤM HIỆU ỨNG CAO CẤP
local function createToggle(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        tweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundColor3 = active and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(25, 25, 30),
            TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        }):Play()
    end)
end

-- 3. LOGIC CHIẾN ĐẤU (AIM - NÉ - DASH)

-- A. DASH LIÊN TỤC (INFINITE DASH)
createToggle("⚡ DASH LIÊN TỤC (Q)", 60, function(state)
    _G.InfDash = state
    task.spawn(function()
        while _G.InfDash do
            pcall(function()
                -- Xóa mọi dấu vết của Cooldown lướt
                if player.Character:FindFirstChild("DashCooldown") then
                    player.Character.DashCooldown:Destroy()
                end
            end)
            task.wait(0.01)
        end
    end)
end)

-- B. AIMLOCK CHUẨN XÁC (DỰA TRÊN CAMERA)
createToggle("🎯 AIMLOCK (TỰ HƯỚNG ĐỊCH)", 120, function(state)
    _G.Aimlock = state
    runService.RenderStepped:Connect(function()
        if _G.Aimlock then
            local closest = nil
            local shortestDist = math.huge
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = p.Character.HumanoidRootPart.Position
                    local dist = (player.Character.HumanoidRootPart.Position - pos).Magnitude
                    if dist < shortestDist and dist < 50 then -- Tầm Aim 50 studs
                        shortestDist = dist
                        closest = p
                    end
                end
            end
            if closest then
                -- Quay camera và nhân vật về phía địch
                local targetPos = closest.Character.HumanoidRootPart.Position
                player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, Vector3.new(targetPos.X, player.Character.HumanoidRootPart.Position.Y, targetPos.Z))
            end
        end
    end)
end)

-- C. TỰ ĐỘNG NÉ (AUTO DODGE / EVADE)
createToggle("🛡️ TỰ ĐỘNG NÉ (AUTO EVADE)", 180, function(state)
    _G.AutoEvade = state
    runService.Heartbeat:Connect(function()
        if _G.AutoEvade and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            -- Kiểm tra nếu nhân vật rơi vào trạng thái bị choáng hoặc bị bắt combo
            if hum and (hum:GetState() == Enum.HumanoidStateType.StrafingNoPhysics or hum.PlatformStand) then
                -- Simulate lướt về phía sau để thoát combo đấy
                local dashFolder = player.Character:FindFirstChild("Communicate")
                if dashFolder then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                end
            end
        end
    end)
end)

-- Nút Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Parent = main
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() sg:Destroy() end)
