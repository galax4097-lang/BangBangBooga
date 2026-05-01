local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Tạo GUI Giao diện
local sg = Instance.new("ScreenGui")
sg.Name = "AoTR_Elite"
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then sg.Parent = player.PlayerGui end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 300)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚔️ AoT REVOLUTION HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Hàm tạo Nút nhanh
local function createButton(name, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = main
    Instance.new("UICorner", btn)
    return btn
end

local infGasBtn = createButton("INF GAS & BLADES", 60, Color3.fromRGB(0, 120, 215))
local speedBtn = createButton("ODM SPEED: OFF", 115, Color3.fromRGB(130, 0, 180))
local espBtn = createButton("TITAN ESP", 170, Color3.fromRGB(0, 150, 80))
local closeBtn = createButton("CLOSE", 240, Color3.fromRGB(150, 0, 0))

-- ==========================================
-- LOGIC LẠM DỤNG CƠ CHẾ
-- ==========================================

-- 1. Infinite Gas & Blades (Hệ thống thường lưu ở Client-side folder)
local infActive = false
infGasBtn.MouseButton1Click:Connect(function()
    infActive = not infActive
    infGasBtn.Text = infActive and "INF: ACTIVE" or "INF GAS & BLADES"
    
    task.spawn(function()
        while infActive do
            -- Tìm kiếm các giá trị Gas trong PlayerData (tên có thể thay đổi tùy Update)
            local stats = player:FindFirstChild("PlayerData") or player:FindFirstChild("Stats")
            if stats then
                local gas = stats:FindFirstChild("Gas")
                local durability = stats:FindFirstChild("BladeDurability")
                if gas then gas.Value = 100 end
                if durability then durability.Value = 100 end
            end
            task.wait(1)
        end
    end)
end)

-- 2. ODM Speed Boost (Nhân vận tốc khi đu dây)
local speedActive = false
local multiplier = 2 -- Gấp đôi tốc độ bay

speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.Text = speedActive and "ODM SPEED: ON" or "ODM SPEED: OFF"
end)

runService.Heartbeat:Connect(function()
    if speedActive and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        -- Chỉ tăng tốc khi người chơi đang thực sự di chuyển (đang đu dây)
        if root and root.Velocity.Magnitude > 10 then
            root.Velocity = root.Velocity * Vector3.new(1.05, 1, 1.05) -- Tăng dần gia tốc
        end
    end
end)

-- 3. Titan ESP (Nhìn xuyên thấu)
espBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetChildren()) do
        -- Kiểm tra nếu là Titan (thường nằm trong folder Titans hoặc có tên chứa "Titan")
        if v:IsA("Model") and (v.Name:find("Titan") or v:FindFirstChild("Nape")) then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = v
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
