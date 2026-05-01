local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local mouse = player:GetMouse()

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "AbuseHub"
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then sg.Parent = player.PlayerGui end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0.8, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = sg
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "BOOGA ABUSE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Parent = frame

-- 1. NÚT TRỌNG LỰC THẤP (Low Gravity)
local gravBtn = Instance.new("TextButton")
gravBtn.Size = UDim2.new(0.9, 0, 0, 40)
gravBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
gravBtn.Text = "TRỌNG LỰC THẤP"
gravBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
gravBtn.Parent = frame

local gravActive = false
gravBtn.MouseButton1Click:Connect(function()
    gravActive = not gravActive
    if gravActive then
        workspace.Gravity = 30 -- Mặc định là 196.2, 30 là rất nhẹ
        gravBtn.Text = "TRỌNG LỰC: NHẸ"
    else
        workspace.Gravity = 196.2
        gravBtn.Text = "TRỌNG LỰC THẤP"
    end
end)

-- 2. NÚT XUYÊN TƯỜNG (Noclip)
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.9, 0, 0, 40)
noclipBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
noclipBtn.Text = "XUYÊN TƯỜNG (OFF)"
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
noclipBtn.Parent = frame

local noclipActive = false
noclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    noclipBtn.Text = noclipActive and "XUYÊN TƯỜNG (ON)" or "XUYÊN TƯỜNG (OFF)"
end)

runService.Stepped:Connect(function()
    if noclipActive and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. CLICK TP (Giữ Ctrl + Click)
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 40)
tpBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
tpBtn.Text = "CTRL + CLICK TP"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
tpBtn.Parent = frame

mouse.Button1Down:Connect(function()
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
        end
    end
end)

-- NÚT ĐÓNG
local close = Instance.new("TextButton")
close.Size = UDim2.new(0.9, 0, 0, 30)
close.Position = UDim2.new(0.05, 0, 0.85, 0)
close.Text = "DỪNG HẾT"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.Parent = frame
close.MouseButton1Click:Connect(function()
    workspace.Gravity = 196.2
    noclipActive = false
    sg:Destroy()
end)
