local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local library = {} -- Hệ thống tối ưu hóa

-- 1. TẠO GIAO DIỆN NEON VIP
local sg = Instance.new("ScreenGui")
sg.Name = "PetSimUltra"
sg.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 280)
main.Position = UDim2.new(0.5, -150, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Viền Neon đổi màu cực mạnh
local glow = Instance.new("UIStroke")
glow.Thickness = 4
glow.Color = Color3.fromRGB(0, 255, 255)
glow.Parent = main

-- Hiệu ứng Rainbow cho viền
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        glow.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "🚀 ULTRA PET EXPLOIT 🚀"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = main

-- 2. HÀM TẠO NÚT BẤM HIỆU ỨNG NHẤP NHÁY
local function createVipBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Parent = main
    local corner = Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        -- Hiệu ứng nảy nút
        btn:TweenSize(UDim2.new(0.85, 0, 0, 45), "Out", "Quad", 0.1, true)
        task.wait(0.1)
        btn:TweenSize(UDim2.new(0.9, 0, 0, 50), "Out", "Quad", 0.1, true)
    end)
end

-- 3. LOGIC SIÊU CẤP
-- Thu thập triệt để bằng cách lừa hệ thống tập tin (Remote Bypass)
createVipBtn("HÚT TẤT CẢ (INSTANT)", 60, function(state)
    _G.Collect = state
    task.spawn(function()
        while _G.Collect do
            pcall(function()
                -- Thay vì đợi chạm, chúng ta gửi tín hiệu nhặt thẳng lên Server
                local orbs = workspace.__THINGS.Orbs:GetChildren()
                for i, v in pairs(orbs) do
                    v.CFrame = player.Character.HumanoidRootPart.CFrame
                    -- Một số bản Pet Sim dùng Remote để nhặt
                    game:GetService("ReplicatedStorage").Network:FindFirstChild("Orbs_Collect"):FireServer({v.Name})
                end
            end)
            task.wait()
        end
    end)
end)

-- Tốc độ Pet bằng cách xóa giới hạn Drag (Lực kéo)
createVipBtn("PET SIÊU TỐC (NO DELAY)", 120, function(state)
    _G.PetSpeed = state
    task.spawn(function()
        while _G.PetSpeed do
            pcall(function()
                local petFolder = workspace.__THINGS.Pets:GetChildren()
                for _, pet in pairs(petFolder) do
                    for _, val in pairs(pet:GetDescendants()) do
                        if val:IsA("BodyPosition") or val:IsA("AlignPosition") then
                            val.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                            val.P = 1e6 -- Độ cứng của lực kéo
                            val.D = 0   -- Xóa bỏ lực cản
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

createVipBtn("TỰ ĐỘNG PHÁ RƯƠNG (AREA)", 180, function(state)
    _G.AutoFarm = state
    task.spawn(function()
        while _G.AutoFarm do
            pcall(function()
                -- Tìm vật phẩm gần nhất và bắt pet tấn công
                local coins = workspace.__THINGS.Coins:GetChildren()
                for _, pet in pairs(workspace.__THINGS.Pets:GetChildren()) do
                    -- Gửi lệnh tấn công trực tiếp (tên Remote có thể thay đổi)
                    game:GetService("ReplicatedStorage").Network.JoinCoin:FireServer(coins[1].Name, {pet.Name})
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- Nút đóng
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Parent = main
close.MouseButton1Click:Connect(function() sg:Destroy() end)
