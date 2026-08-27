local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local success, Library = pcall(function()
    return loadstring(game:HttpGet(repo .. 'Library.lua'))()
end)

if not success or not Library then
    warn('Не удалось загрузить Library')
    return
end

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
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
local VisualsLeft = Tabs.Visuals:AddLeftGroupbox('ESP')

VisualsLeft:AddToggle('ESPEnabled', {
    Text = 'Enable ESP',
    Default = false,
})

VisualsLeft:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = true,
})

VisualsLeft:AddToggle('NameESP', {
    Text = 'Name ESP',
    Default = true,
})

VisualsLeft:AddToggle('HealthESP', {
    Text = 'Health ESP',
    Default = true,
})

VisualsLeft:AddLabel('ESP Color'):AddColorPicker('ESPColor', {
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
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump and Toggles.InfiniteJump.Value then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Toggles.Noclip and Toggles.Noclip.Value and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA('BasePart') then
                v.CanCollide = false
            end
        end
    end
end)

-- Fly
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

-- ==================== AIMBOT (безопасный) ====================
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

-- ==================== ESP (безопасный) ====================
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
    ESPObjects[plr].Name.Size = 14
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
        if not onScreen then
            data.Box.Visible = false
            data.Name.Visible = false
            continue
        end

        local scale = 2000 / pos.Z
        local w, h = 4 * scale, 6 * scale

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
            data.Name.Position = Vector2.new(pos.X, pos.Y - h/2 - 15)
            data.Name.Color = color
            data.Name.Visible = true
        else
            data.Name.Visible = false
        end
    end
end)

Players.PlayerRemoving:Connect(RemoveESP)

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