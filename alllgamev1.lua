local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")

-- GUI Giao diện
local sg = Instance.new("ScreenGui")
sg.Name = "PetSimHub"
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then sg.Parent = player.PlayerGui end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 180)
main.Position = UDim2.new(0.5, -110, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
main.Draggable = true
main.Active = true
main.Parent = sg
Instance.new("UICorner", main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "🐾 PET SIM UTILITY"
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = main

-- 1. NÚT AUTO COLLECT ORBS (Hút tiền)
local collectBtn = Instance.new("TextButton")
collectBtn.Size = UDim2.new(0.9, 0, 0, 45)
collectBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
collectBtn.Text = "HÚT TIỀN: OFF"
collectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
collectBtn.Parent = main
Instance.new("UICorner", collectBtn)

local collecting = false
collectBtn.MouseButton1Click:Connect(function()
    collecting = not collecting
    collectBtn.Text = collecting and "HÚT TIỀN: ON" or "HÚT TIỀN: OFF"
end)

-- Vòng lặp hút tiền
task.spawn(function()
    while true do
        if collecting then
            pcall(function()
                -- Đường dẫn Orbs có thể thay đổi tùy bản update, thường ở workspace
                local orbs = workspace:FindFirstChild("ActiveOrbs") 
                if orbs then
                    for _, orb in pairs(orbs:GetChildren()) do
                        if orb:IsA("BasePart") then
                            orb.CFrame = player.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- 2. NÚT HOVERBOARD SPEED (Ván bay siêu tốc)
local vánBtn = Instance.new("TextButton")
vánBtn.Size = UDim2.new(0.9, 0, 0, 45)
vánBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
vánBtn.Text = "SIÊU VÁN BAY"
vánBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
vánBtn.Parent = main
Instance.new("UICorner", vánBtn)

vánBtn.MouseButton1Click:Connect(function()
    -- Lạm dụng việc thay đổi WalkSpeed nhưng chỉ khi đang dùng ván
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 150 -- Tốc độ ván bay cực nhanh
    end
end)
