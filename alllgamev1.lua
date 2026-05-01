local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

-- ==========================================
-- 1. XÓA BẢNG CŨ VÀ TẠO BẢNG MỚI MƯỢT MÀ
-- ==========================================
local pGui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
if pGui:FindFirstChild("PetSimProHub") then
    pGui.PetSimProHub:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "PetSimProHub"
sg.ResetOnSpawn = false
sg.Parent = pGui

-- Khung chính với hiệu ứng trong suốt ban đầu (để làm hiệu ứng Fade-in)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 1 
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = sg
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Viền phát sáng lấp lánh
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2.5
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainFrame

-- Tiêu đề Rainbow
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "✨ PET SIM PRO GRIND ✨"
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.BackgroundTransparency = 1
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- ==========================================
-- 2. HÀM TẠO NÚT BẤM CÓ HIỆU ỨNG (HOVER)
-- ==========================================
local function createButton(name, posY, baseColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = baseColor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 1
    btn.TextTransparency = 1
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    -- Hiệu ứng khi đưa chuột vào/ra
    btn.MouseEnter:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(baseColor.R * 255 + 30, baseColor.G * 255 + 30, baseColor.B * 255 + 30)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = baseColor}):Play()
    end)
    
    return btn
end

local collectBtn = createButton("🧲 HÚT TIỀN (TRIỆT ĐỂ): OFF", 60, Color3.fromRGB(100, 100, 100))
local petSpeedBtn = createButton("⚡ TỐC ĐỘ PET: OFF", 110, Color3.fromRGB(100, 100, 100))
local closeBtn = createButton("❌ ĐÓNG GIAO DIỆN", 165, Color3.fromRGB(200, 30, 30))

-- ==========================================
-- 3. HIỆU ỨNG KHỞI ĐỘNG (ANIMATIONS)
-- ==========================================
-- Fade in
tweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
tweenService:Create(title, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
tweenService:Create(collectBtn, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
tweenService:Create(petSpeedBtn, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
tweenService:Create(closeBtn, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

-- Hiệu ứng Rainbow cho viền bảng
local hue = 0
runService.RenderStepped:Connect(function()
    hue = hue + 0.005
    if hue >= 1 then hue = 0 end
    stroke.Color = Color3.fromHSV(hue, 1, 1)
    title.TextColor3 = Color3.fromHSV(hue, 0.5, 1)
end)

-- ==========================================
-- 4. LOGIC HOẠT ĐỘNG TRIỆT ĐỂ
-- ==========================================

-- Tính năng 1: HÚT TIỀN BẰNG TOUCH INTEREST (Nhận thẳng vào túi)
local autoCollect = false
collectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    collectBtn.Text = autoCollect and "🧲 HÚT TIỀN (TRIỆT ĐỂ): ON" or "🧲 HÚT TIỀN (TRIỆT ĐỂ): OFF"
    tweenService:Create(collectBtn, TweenInfo.new(0.3), {BackgroundColor3 = autoCollect and Color3.fromRGB(0, 180, 50) or Color3.fromRGB(100, 100, 100)}):Play()
end)

task.spawn(function()
    while true do
        if autoCollect and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            pcall(function()
                local things = workspace:FindFirstChild("__THINGS")
                if things and things:FindFirstChild("Orbs") then
                    for _, orb in pairs(things.Orbs:GetChildren()) do
                        if orb:IsA("BasePart") then
                            -- Kéo CFrame lại gần để hiển thị mượt
                            orb.CFrame = root.CFrame
                            
                            -- ÉP GAME PHẢI NHẬN VA CHẠM (Thu thập thực sự)
                            if firetouchinterest then
                                firetouchinterest(root, orb, 0) -- Bắt đầu chạm
                                firetouchinterest(root, orb, 1) -- Kết thúc chạm
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1) -- Tốc độ quét 10 lần/giây
    end
end)

-- Tính năng 2: PET DI CHUYỂN SIÊU TỐC
local petSpeedActive = false
petSpeedBtn.MouseButton1Click:Connect(function()
    petSpeedActive = not petSpeedActive
    petSpeedBtn.Text = petSpeedActive and "⚡ TỐC ĐỘ PET: BẬT" or "⚡ TỐC ĐỘ PET: TẮT"
    tweenService:Create(petSpeedBtn, TweenInfo.new(0.3), {BackgroundColor3 = petSpeedActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(100, 100, 100)}):Play()
end)

task.spawn(function()
    while true do
        if petSpeedActive then
            pcall(function()
                local things = workspace:FindFirstChild("__THINGS")
                if things and things:FindFirstChild("Pets") then
                    -- Tìm tất cả Pet đang hoạt động
                    for _, pet in pairs(things.Pets:GetChildren()) do
                        -- Can thiệp vào lực kéo vật lý của Pet
                        for _, desc in pairs(pet:GetDescendants()) do
                            if desc:IsA("AlignPosition") then
                                desc.MaxVelocity = 9999 -- Vận tốc tối đa cực lớn
                                desc.Responsiveness = 500 -- Độ nhạy phản hồi tức thời
                            elseif desc:IsA("AlignOrientation") then
                                desc.Responsiveness = 500 -- Xoay mượt mà
                            end
                        end
                    end
                end
            end)
        end
        task.wait(1) -- Quét và buff lại cho Pet mỗi giây (trường hợp bạn đổi pet mới)
    end
end)

-- Nút Đóng Giao Diện
closeBtn.MouseButton1Click:Connect(function()
    autoCollect = false
    petSpeedActive = false
    -- Fade out từ từ rồi xóa bảng
    tweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    for _, obj in pairs(mainFrame:GetChildren()) do
        if obj:IsA("TextButton") or obj:IsA("TextLabel") then
            tweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        end
    end
    task.wait(0.3)
    sg:Destroy()
end)
