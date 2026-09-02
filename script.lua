local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local assetsRepo = 'https://raw.githubusercontent.com/sardelkovicvova-cell/UE-crack/main/Assets/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Unnamed enhancements - discord.gg enhancements',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Player = Window:AddTab('Player'),
    Visuals = Window:AddTab('Visuals'),
    ESP = Window:AddTab('ESP'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local Lighting = game:GetService('Lighting')
local HttpService = game:GetService('HttpService')
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==================== СКАЧИВАНИЕ АССЕТОВ ====================
local function EnsureFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

local function DownloadFile(url, path)
    if isfile(path) then return true end
    local success, data = pcall(function()
        return game:HttpGet(url)
    end)
    if success and data then
        writefile(path, data)
        return true
    end
    return false
end

EnsureFolder('UE')
EnsureFolder('UE/digits')
EnsureFolder('UE/skybox')

-- Цифры
for i = 0, 9 do
    DownloadFile(assetsRepo .. i .. '.png', 'UE/digits/' .. i .. '.png')
end

-- Скайбоксы (основные)
local skyboxes = {
    ['Aurora'] = {'bk', 'dn', 'ft', 'lf', 'rt', 'up'},
    ['Chill gray'] = {'bk', 'dn', 'ft', 'lf', 'rt', 'up'},
    ['Cyan'] = {'bk', 'dn', 'ft', 'lf', 'rt', 'up'},
    ['Spooky'] = {'bk', 'dn', 'ft', 'lf', 'rt', 'up'},
}

for name, faces in pairs(skyboxes) do
    EnsureFolder('UE/skybox/' .. name)
    for _, face in ipairs(faces) do
        local url = assetsRepo .. 'Skyboxs/' .. name .. '/' .. face .. '.png'
        local path = 'UE/skybox/' .. name .. '/' .. face .. '.png'
        DownloadFile(url, path)
    end
end

print('[UE] Assets downloaded')

-- ==================== MAIN ====================
local LeftGroup = Tabs.Main:AddLeftGroupbox('Combat')

LeftGroup:AddToggle('Aimbot', {
    Text = 'Aimbot',
    Default = false,
}):AddKeyPicker('AimbotKey', {
    Default = 'MB2',
    SyncToggleState = true,
    Mode = 'Hold',
    Text = 'Aimbot',
    NoUI = false,
})

LeftGroup:AddToggle('SilentAim', {
    Text = 'Silent Aim',
    Default = false,
}):AddKeyPicker('SilentAimKey', {
    Default = 'None',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Silent Aim',
    NoUI = false,
})

LeftGroup:AddSlider('AimFov', {
    Text = 'FOV',
    Default = 120,
    Min = 30,
    Max = 400,
    Rounding = 0,
})

LeftGroup:AddToggle('ShowFOV', {
    Text = 'Show FOV',
    Default = true,
})

LeftGroup:AddSlider('AimSmooth', {
    Text = 'Smoothness',
    Default = 6,
    Min = 1,
    Max = 20,
    Rounding = 1,
})

LeftGroup:AddDropdown('AimPart', {
    Values = {'Head', 'HumanoidRootPart', 'Torso'},
    Default = 1,
    Text = 'Aim Part',
})

-- ==================== PLAYER ====================
local PlayerLeft = Tabs.Player:AddLeftGroupbox('Character')

PlayerLeft:AddToggle('InfiniteJump', {
    Text = 'Infinite Jump',
    Default = false,
})

PlayerLeft:AddToggle('Noclip', {
    Text = 'Noclip',
    Default = false,
})

PlayerLeft:AddToggle('Fly', {
    Text = 'Fly',
    Default = false,
})

PlayerLeft:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = 50,
    Min = 20,
    Max = 200,
    Rounding = 0,
})

-- ==================== VISUALS ====================
local VisualsLeft = Tabs.Visuals:AddLeftGroupbox('Damage Numbers')

VisualsLeft:AddToggle('DamageNumbers', {
    Text = 'Enable Damage Numbers',
    Default = true,
})

VisualsLeft:AddLabel('Damage Color'):AddColorPicker('DamageColor', {
    Default = Color3.fromRGB(255, 50, 50),
    Title = 'Damage Color',
})

VisualsLeft:AddSlider('DamageSize', {
    Text = 'Size',
    Default = 1,
    Min = 0.5,
    Max = 2,
    Rounding = 1,
})

local VisualsRight = Tabs.Visuals:AddRightGroupbox('Hit Notifications')

VisualsRight:AddToggle('HitNotify', {
    Text = 'Enable Hit Notifications',
    Default = true,
})

VisualsRight:AddInput('HitText', {
    Default = 'Hit %s for %d',
    Text = 'Text Template',
    Placeholder = 'Hit %s for %d',
})

local SkyGroup = Tabs.Visuals:AddLeftGroupbox('Skybox')

SkyGroup:AddToggle('CustomSkybox', {
    Text = 'Enable Custom Skybox',
    Default = false,
})

SkyGroup:AddDropdown('SkyboxType', {
    Values = {'Aurora', 'Chill gray', 'Cyan', 'Spooky'},
    Default = 1,
    Text = 'Skybox',
})

-- ==================== ESP TAB ====================
local ESPLeft = Tabs.ESP:AddLeftGroupbox('ESP')

ESPLeft:AddToggle('ESPEnabled', {
    Text = 'Enable ESP',
    Default = false,
})

ESPLeft:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = true,
})

ESPLeft:AddToggle('NameESP', {
    Text = 'Name ESP',
    Default = true,
})

ESPLeft:AddToggle('HealthESP', {
    Text = 'Health ESP',
    Default = true,
})

ESPLeft:AddLabel('ESP Color'):AddColorPicker('ESPColor', {
    Default = Color3.fromRGB(255, 50, 50),
    Title = 'ESP Color',
})

-- ==================== UI SETTINGS ====================
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function()
    Library:Unload()
end)

MenuGroup:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightControl',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

MenuGroup:AddToggle('ShowKeybinds', {
    Text = 'Show Keybinds List',
    Default = true,
    Callback = function(Value)
        if Library.KeybindFrame then
            Library.KeybindFrame.Visible = Value
        end
    end
})

-- ==================== PLAYER FUNCTIONS ====================
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump and Toggles.InfiniteJump.Value then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    if Toggles.Noclip and Toggles.Noclip.Value and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA('BasePart') then
                v.CanCollide = false
            end
        end
    end
end)

local flyBV, flyBG
local flying = false

local function StopFly()
    flying = false
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
    if hum then hum.PlatformStand = false end
end

local function StartFly()
    StopFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild('HumanoidRootPart')
    local hum = char:FindFirstChildOfClass('Humanoid')
    if not root or not hum then return end

    flying = true
    hum.PlatformStand = true

    flyBV = Instance.new('BodyVelocity')
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = root

    flyBG = Instance.new('BodyGyro')
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 3000
    flyBG.Parent = root

    task.spawn(function()
        while flying and root and root.Parent do
            local speed = Options.FlySpeed.Value
            local dir = Vector3.zero
            local cf = Camera.CFrame

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

            if dir.Magnitude > 0 then
                dir = dir.Unit * speed
            end

            flyBV.Velocity = dir
            flyBG.CFrame = cf
            task.wait()
        end
        StopFly()
    end)
end

Toggles.Fly:OnChanged(function(val)
    if val then StartFly() else StopFly() end
end)

-- ==================== DAMAGE NUMBERS ====================
local digitImages = {}
for i = 0, 9 do
    local path = 'UE/digits/' .. i .. '.png'
    if isfile(path) then
        digitImages[tostring(i)] = getcustomasset(path)
    end
end

local function CreateDamageNumber(position, damage, color)
    if not Toggles.DamageNumbers.Value then return end

    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    if not onScreen then return end

    local str = tostring(math.floor(damage))
    local size = Options.DamageSize.Value * 28
    local spacing = size * 0.6
    local totalWidth = #str * spacing

    local container = Instance.new('ScreenGui')
    container.Name = 'DamageNumber'
    container.IgnoreGuiInset = true
    container.Parent = game:GetService('CoreGui')

    local startX = screenPos.X - totalWidth / 2
    local startY = screenPos.Y

    local images = {}
    for i = 1, #str do
        local digit = str:sub(i, i)
        local img = Instance.new('ImageLabel')
        img.BackgroundTransparency = 1
        img.Size = UDim2.fromOffset(size, size)
        img.Position = UDim2.fromOffset(startX + (i - 1) * spacing, startY)
        img.Image = digitImages[digit] or ''
        img.ImageColor3 = color or Options.DamageColor.Value
        img.ImageTransparency = 0
        img.ZIndex = 50
        img.Parent = container
        table.insert(images, img)
    end

    -- Анимация появления + подъём + исчезновение (как на видео)
    task.spawn(function()
        local duration = 0.9
        local startTime = tick()

        while tick() - startTime < duration do
            local alpha = (tick() - startTime) / duration
            local yOffset = -alpha * 80
            local fade = alpha > 0.5 and (alpha - 0.5) * 2 or 0

            for i, img in ipairs(images) do
                img.Position = UDim2.fromOffset(startX + (i - 1) * spacing, startY + yOffset)
                img.ImageTransparency = fade
            end
            RunService.RenderStepped:Wait()
        end

        container:Destroy()
    end)
end

-- ==================== HIT NOTIFICATIONS ====================
local function CreateHitNotify(name, damage)
    if not Toggles.HitNotify.Value then return end

    local template = Options.HitText.Value or 'Hit %s for %d'
    local text = string.format(template, tostring(name), math.floor(damage))

    local gui = Instance.new('ScreenGui')
    gui.Name = 'HitNotify'
    gui.IgnoreGuiInset = true
    gui.Parent = game:GetService('CoreGui')

    local frame = Instance.new('Frame')
    frame.Size = UDim2.fromOffset(0, 32)
    frame.Position = UDim2.new(0.5, 0, 0.25, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local accent = Instance.new('Frame')
    accent.Size = UDim2.new(1, 0, 0, 2)
    accent.BackgroundColor3 = Library.AccentColor or Color3.fromRGB(0, 170, 255)
    accent.BorderSizePixel = 0
    accent.Parent = frame

    local label = Instance.new('TextLabel')
    label.Size = UDim2.new(1, -16, 1, -2)
    label.Position = UDim2.fromOffset(8, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local textService = game:GetService('TextService')
    local bounds = textService:GetTextSize(text, 14, Enum.Font.Code, Vector2.new(1000, 50))
    local width = bounds.X + 20

    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.fromOffset(width, 32)
    }):Play()

    task.delay(2.5, function()
        local tween = TweenService:Create(frame, TweenInfo.new(0.25), {
            Size = UDim2.fromOffset(0, 32)
        })
        tween:Play()
        tween.Completed:Wait()
        gui:Destroy()
    end)
end

-- ==================== SKYBOX ====================
local currentSky = nil

local function ApplySkybox(name)
    if currentSky then
        currentSky:Destroy()
        currentSky = nil
    end

    if not Toggles.CustomSkybox.Value then return end

    local folder = 'UE/skybox/' .. name
    if not isfolder(folder) then return end

    local sky = Instance.new('Sky')
    sky.Name = 'UE_Skybox'
    sky.SkyboxBk = getcustomasset(folder .. '/bk.png')
    sky.SkyboxDn = getcustomasset(folder .. '/dn.png')
    sky.SkyboxFt = getcustomasset(folder .. '/ft.png')
    sky.SkyboxLf = getcustomasset(folder .. '/lf.png')
    sky.SkyboxRt = getcustomasset(folder .. '/rt.png')
    sky.SkyboxUp = getcustomasset(folder .. '/up.png')
    sky.Parent = Lighting
    currentSky = sky
end

Toggles.CustomSkybox:OnChanged(function(val)
    if val then
        ApplySkybox(Options.SkyboxType.Value)
    else
        if currentSky then
            currentSky:Destroy()
            currentSky = nil
        end
    end
end)

Options.SkyboxType:OnChanged(function()
    if Toggles.CustomSkybox.Value then
        ApplySkybox(Options.SkyboxType.Value)
    end
end)

-- ==================== AIMBOT ====================
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new('Circle')
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 60
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Transparency = 0.7
end)

local function GetClosest()
    local closest, dist = nil, Options.AimFov.Value
    local mouse = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 then
            local part = plr.Character:FindFirstChild(Options.AimPart.Value) or plr.Character:FindFirstChild('Head')
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if d < dist then
                        closest = part
                        dist = d
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local mouse = UserInputService:GetMouseLocation()

    if FOVCircle then
        FOVCircle.Position = mouse
        FOVCircle.Radius = Options.AimFov.Value
        FOVCircle.Visible = Toggles.ShowFOV.Value and (Toggles.Aimbot.Value or Toggles.SilentAim.Value)
    end

    if Toggles.Aimbot.Value and Options.AimbotKey:GetState() then
        local target = GetClosest()
        if target then
            local pos = Camera:WorldToViewportPoint(target.Position)
            local smooth = math.max(Options.AimSmooth.Value, 1)
            pcall(function()
                mousemoverel((pos.X - mouse.X) / smooth, (pos.Y - mouse.Y) / smooth)
            end)
        end
    end
end)

-- ==================== ESP (ИСПРАВЛЕННЫЙ РАЗМЕР) ====================
local ESPObjects = {}

local function CreateESP(plr)
    if plr == LocalPlayer or ESPObjects[plr] then return end
    local ok, box = pcall(Drawing.new, 'Square')
    if not ok then return end

    ESPObjects[plr] = {
        Box = box,
        Name = Drawing.new('Text'),
    }
    ESPObjects[plr].Box.Thickness = 1
    ESPObjects[plr].Box.Filled = false
    ESPObjects[plr].Name.Size = 13
    ESPObjects[plr].Name.Center = true
    ESPObjects[plr].Name.Outline = true
end

local function RemoveESP(plr)
    if ESPObjects[plr] then
        for _, v in pairs(ESPObjects[plr]) do
            pcall(function() v:Remove() end)
        end
        ESPObjects[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not Toggles.ESPEnabled.Value then
        for _, obj in pairs(ESPObjects) do
            for _, d in pairs(obj) do d.Visible = false end
        end
        return
    end

    local color = Options.ESPColor.Value
    local camPos = Camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if not ESPObjects[plr] then CreateESP(plr) end
        local data = ESPObjects[plr]
        if not data then continue end

        local char = plr.Character
        local root = char and char:FindFirstChild('HumanoidRootPart')
        local hum = char and char:FindFirstChildOfClass('Humanoid')

        if not root or not hum or hum.Health <= 0 then
            data.Box.Visible = false
            data.Name.Visible = false
            continue
        end

        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen or pos.Z <= 0 then
            data.Box.Visible = false
            data.Name.Visible = false
            continue
        end

        -- Нормальный размер через реальное расстояние
        local dist = (root.Position - camPos).Magnitude
        local scale = math.clamp(1800 / math.max(dist, 5), 8, 120)
        local w, h = 3.2 * scale, 5.2 * scale

        if Toggles.BoxESP.Value then
            data.Box.Size = Vector2.new(w, h)
            data.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
            data.Box.Color = color
            data.Box.Visible = true
        else
            data.Box.Visible = false
        end

        if Toggles.NameESP.Value then
            data.Name.Text = plr.Name
            data.Name.Position = Vector2.new(pos.X, pos.Y - h/2 - 14)
            data.Name.Color = color
            data.Name.Visible = true
        else
            data.Name.Visible = false
        end
    end
end)

Players.PlayerRemoving:Connect(RemoveESP)

-- ==================== HIT DETECTION (для damage numbers + hit notify) ====================
local lastHealth = {}

RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass('Humanoid')
            if hum then
                local current = hum.Health
                local previous = lastHealth[plr] or current

                if current < previous and previous - current > 1 then
                    local damage = previous - current
                    local root = plr.Character:FindFirstChild('HumanoidRootPart') or plr.Character:FindFirstChild('Head')
                    if root then
                        CreateDamageNumber(root.Position + Vector3.new(0, 2, 0), damage, Options.DamageColor.Value)
                        CreateHitNotify(plr.Name, damage)
                    end
                end
                lastHealth[plr] = current
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    lastHealth[plr] = nil
end)

-- Theme + Save
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('UnnamedEnhancements')
SaveManager:SetFolder('UnnamedEnhancements/Config')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)
Library:SetWatermark('Unnamed enhancements')

print('Script loaded successfully')
