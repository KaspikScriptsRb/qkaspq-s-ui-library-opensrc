--// ANTI-WALKSPEED AND ANTI-JUMPPOWER
for i,b in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if b.Name == " " then
        b:Destroy()
    end
end

for i,lc2 in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if lc2:IsA("LocalScript") and (string.match(lc2.Name, "1") or string.match(lc2.Name, "2") or string.match(lc2.Name, "3") or string.match(lc2.Name, "4") or string.match(lc2.Name, "5") or string.match(lc2.Name, "6") or string.match(lc2.Name, "7") or string.match(lc2.Name, "8") or string.match(lc2.Name, "9")) then
        lc2:Destroy()
    end
end

for i,lc in pairs(game.Players.LocalPlayer.PlayerGui.Start:GetChildren()) do
    if lc:IsA("LocalScript") and (string.match(lc.Name, "1") or string.match(lc.Name, "2") or string.match(lc.Name, "3") or string.match(lc.Name, "4") or string.match(lc.Name, "5") or string.match(lc.Name, "6") or string.match(lc.Name, "7") or string.match(lc.Name, "8") or string.match(lc.Name, "9")) then
        lc:Destroy()
    end
end

for i,c in pairs(game.Players.LocalPlayer.PlayerGui.Start:GetChildren()) do
    if c.Name == "CheckPlayerW" then
        c:Destroy()
    end
end

for i,z in pairs(game.StarterGui.Start:GetChildren()) do
    if z.Name == "CheckPlayerW" then
        z:Destroy()
    end
end

for _, v in pairs(game.StarterPlayer.StarterCharacterScripts:GetDescendants()) do
    if v.Name == " " then
        v:Destroy()
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    for i,char in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if char.Name == " " then
            char:Destroy()
        end
    end
end)

-- Ball: Spectate и Size (перемещено ниже инициализации BallGroup)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "Tps Freemium",
    SubTitle = "by ???",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {
    Credits = Window:AddTab("Credits", "award"),
    Reacts  = Window:AddTab("Reacts", "zap"),
    Ball    = Window:AddTab("Ball", "activity"),
    Render  = Window:AddTab("Render", "eye"),
    Reach   = Window:AddTab("Reach", "ruler"),
    Misc    = Window:AddTab("Misc", "settings")
}

local ReactsGroup = Tabs.Reacts:AddLeftGroupbox("BETA")
local BallGroup   = Tabs.Ball:AddLeftGroupbox("Ball Physics")
local RenderGroup = Tabs.Render:AddLeftGroupbox("ESP")
local RenderVisuals = Tabs.Render:AddRightGroupbox("Visuals")

-- Players ESP
do
    local espEnabled = false
    local espFolder = nil
    local conns = {}

    local function getTeamColor(plr)
        local t = plr.Team
        if t and t.Name then
            local n = t.Name:lower()
            if n:find("blue") then return Color3.fromRGB(0,140,255) end
            if n:find("red") then return Color3.fromRGB(255,70,70) end
        end
        return Color3.fromRGB(255,255,255)
    end

    local function ensureFolder()
        if espFolder and espFolder.Parent then return espFolder end
        espFolder = Instance.new("Folder")
        espFolder.Name = "PlayersESP"
        espFolder.Parent = workspace
        return espFolder
    end

    local function makeBillboard(plr, char)
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local gui = Instance.new("BillboardGui")
        gui.Name = "PE_"..plr.Name
        gui.Size = UDim2.fromOffset(160, 42)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = hrp
        gui.Parent = ensureFolder()

        -- Чёрный фрейм-контейнер по дизайну
        local box = Instance.new("Frame")
        box.Name = "Box"
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.Position = UDim2.fromScale(0.5, 0.5)
        box.Size = UDim2.fromOffset(160, 38)
        box.BackgroundColor3 = Color3.fromRGB(10,10,10)
        box.BackgroundTransparency = 0.15
        box.BorderSizePixel = 0
        box.Parent = gui
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(30,30,30)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = box
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = box

        local flag = Instance.new("Frame")
        flag.Name = "Flag"
        flag.Size = UDim2.fromOffset(10, 22)
        flag.Position = UDim2.fromOffset(8, 8)
        flag.BorderSizePixel = 0
        flag.BackgroundColor3 = getTeamColor(plr)
        flag.Parent = box

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "Name"
        nameLbl.BackgroundTransparency = 1
        nameLbl.Size = UDim2.fromOffset(100, 38)
        nameLbl.Position = UDim2.fromOffset(24, 0)
        nameLbl.TextColor3 = Color3.new(1,1,1)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 14
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextYAlignment = Enum.TextYAlignment.Center
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.Text = plr.Name
        nameLbl.Parent = box

        local distLbl = Instance.new("TextLabel")
        distLbl.Name = "Dist"
        distLbl.BackgroundTransparency = 1
        distLbl.Size = UDim2.fromOffset(56, 38)
        distLbl.Position = UDim2.new(1, -60, 0, 0)
        distLbl.TextColor3 = Color3.fromRGB(230,230,230)
        distLbl.Font = Enum.Font.GothamSemibold
        distLbl.TextSize = 13
        distLbl.TextXAlignment = Enum.TextXAlignment.Right
        distLbl.TextYAlignment = Enum.TextYAlignment.Center
        distLbl.Text = "[0m]"
        distLbl.Parent = box
        return gui
    end

    local function removeBillboard(plr)
        if not espFolder then return end
        local g = espFolder:FindFirstChild("PE_"..plr.Name)
        if g then g:Destroy() end
    end

    local function attach(plr)
        if plr == game.Players.LocalPlayer then return end
        local function onChar(char)
            removeBillboard(plr)
            if espEnabled then makeBillboard(plr, char) end
        end
        if plr.Character then onChar(plr.Character) end
        table.insert(conns, plr.CharacterAdded:Connect(onChar))
        table.insert(conns, plr.CharacterRemoving:Connect(function() removeBillboard(plr) end))
    end

    local function clearAll()
        if espFolder then espFolder:Destroy() espFolder = nil end
        for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
    end

    local rsConn
    RenderGroup:AddToggle("PlayersESP", { Text = "ESP Players", Default = false })
    Toggles.PlayersESP:OnChanged(function(v)
        espEnabled = v and true or false
        if not espEnabled then
            if rsConn then rsConn:Disconnect() rsConn=nil end
            clearAll()
            return
        end
        ensureFolder()
        for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do attach(plr) end
        table.insert(conns, game:GetService("Players").PlayerAdded:Connect(attach))
        table.insert(conns, game:GetService("Players").PlayerRemoving:Connect(function(plr) removeBillboard(plr) end))

        rsConn = game:GetService("RunService").RenderStepped:Connect(function()
            if not espFolder then return end
            for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= game:GetService("Players").LocalPlayer then
                    local g = espFolder:FindFirstChild("PE_"..plr.Name)
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if (not g or not g.Parent) and hrp then
                        makeBillboard(plr, char)
                        g = espFolder:FindFirstChild("PE_"..plr.Name)
                    end
                    if not g or not hrp then continue end
                    local dist = (hrp.Position - (game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position or hrp.Position)).Magnitude
                    local box = g:FindFirstChild("Box") or g
                    local nameLbl = box and box:FindFirstChild("Name")
                    local distLbl = box and box:FindFirstChild("Dist")
                    if nameLbl then nameLbl.Text = plr.Name end
                    if distLbl then distLbl.Text = string.format("[%dm]", dist and math.floor(dist+0.5) or 0) end
                    local flag = box and box:FindFirstChild("Flag")
                    if flag then flag.BackgroundColor3 = getTeamColor(plr) end
                end
            end
        end)
    end)
end

-- Ball: Spectate и Size (после инициализации BallGroup)
do
    local cam = workspace.CurrentCamera
    local restoreSubject
    BallGroup:AddToggle("BallSpectate", { Text = "Spectate Ball", Default = false, Tooltip = "Камера следует за мячом" })
    Toggles.BallSpectate:OnChanged(function(v)
        local sys = workspace:FindFirstChild("TPSSystem")
        local ball = sys and sys:FindFirstChild("TPS")
        if v and ball then
            if cam then
                if not restoreSubject then restoreSubject = cam.CameraSubject end
                cam.CameraSubject = ball
            end
        else
            if cam and restoreSubject then cam.CameraSubject = restoreSubject end
            restoreSubject = nil
        end
    end)
end

-- Credits (самая верхняя вкладка)
do
    local CreditsLeft = Tabs.Credits:AddLeftGroupbox("Info")
    CreditsLeft:AddLabel("Creator:???")
    CreditsLeft:AddLabel("Freemium Version")
    CreditsLeft:AddLabel("Version 1.0")

    local CreditsRight = Tabs.Credits:AddRightGroupbox("Best Config")
    CreditsRight:AddLabel("2-3 Leg Reach")
    CreditsRight:AddLabel("ImprovedHitRegistration")
    CreditsRight:AddLabel("100 +- LVL")
    CreditsRight:AddLabel("0-0.2 Clumsy")
end

-- Misc
local MiscGP = Tabs.Misc:AddLeftGroupbox("Unlock Gamepasses")
local MiscChanger = Tabs.Misc:AddRightGroupbox("Changer")
local MiscSettings = Tabs.Misc:AddLeftGroupbox("Settings")

-- Unlock Gamepasses (заглушки/флаги локально)
MiscGP:AddToggle("GP_BlueFlame", { Text = "Get Blue Flame", Default = false })
Toggles.GP_BlueFlame:OnChanged(function(v)
    -- из tps.lua: меняем элементы GUI и FValue
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer.PlayerGui.Start.GamePassMenu.Items.BlueFlame
        pg.Tick.Visible = v and true or false
        pg.BlueFlame.Style = v and "RobloxRoundButton" or "RobloxRoundDefaultButton"
        game:GetService("Players").LocalPlayer.PlayerGui.Start.PowerShot.Image = v and "rbxassetid://5366457711" or "rbxassetid://1595877615"
        game:GetService("Players").LocalPlayer.Backpack.FValue.Value = v and 2 or 1
    end)
end)
MiscGP:AddToggle("GP_FastCD", { Text = "Get Faster Cooldown", Default = false })
Toggles.GP_FastCD:OnChanged(function(v)
    -- из tps.lua: уменьшаем кулдаун и отмечаем галочкой
    pcall(function()
        local root = game:GetService("Players").LocalPlayer.PlayerGui.Start
        root.GamePassMenu.Items.Cooldown.Tick.Visible = v and true or false
        root.GamePassMenu.Items.Cooldown.Cooldown.Style = v and "RobloxRoundButton" or "RobloxRoundDefaultButton"
        root.PowerShot.PowerValue.Value = v and 30 or 60
    end)
end)
MiscGP:AddButton("Unlock Celebrations", function()
    -- из tps.lua: открываем все паки и активируем селекты
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer.PlayerGui.Start
        local items = pg.GamePassMenu.Items
        local function onPack(i)
            local n = "CelebrationPack"..tostring(i)
            if items:FindFirstChild(n) then
                items[n].Tick.Visible = true
                items[n][n].Style = "RobloxRoundButton"
            end
        end
        for i=1,5 do onPack(i) end
        local cs = pg.Celebrations.CelebrationsSelect
        for i=1,5 do
            local b = cs["Package"..tostring(i)] and cs["Package"..tostring(i)].Button
            if b then b.Visible = false end
        end
        local function enable(sf)
            local node = cs:FindFirstChild(sf)
            if node then node.Active = true; node.Selectable = true; if node:FindFirstChild("Script") then node.Script.Disabled = false end end
        end
        for _,sf in ipairs({"SF04","SF05","SF06","SF07","SF08","SF09","SF10","SF11","SF12","SF13","SF14","SF15","SF16","SF17","SF18"}) do
            enable(sf)
        end
    end)
end)

-- Changer: Level / XP (пытаемся менять leaderstats)
MiscChanger:AddInput("MiscLevel", { Text = "Level", Default = "0", Placeholder = "число" })
Options.MiscLevel:OnChanged(function()
    local Targets = tonumber(Options.MiscLevel.Value)
    if not Targets then return end
    -- хук уровня как в tps.lua: подмена Value у объектов Level/PPLevel
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local old_index = mt.__index
        mt.__index = function(a,b)
            if tostring(a) == "PPLevel" or tostring(a) == "Level" then
                if tostring(b) == "Value" then
                    return Targets
                end
            end
            return old_index(a,b)
        end
    end)
end)
MiscChanger:AddInput("MiscXP", { Text = "XP", Default = "0", Placeholder = "число" })
Options.MiscXP:OnChanged(function()
    local num = tonumber(Options.MiscXP.Value)
    if not num then return end
    local lp = game.Players.LocalPlayer
    local ls = lp:FindFirstChild("leaderstats")
    if ls then
        local xp = ls:FindFirstChild("XP") or ls:FindFirstChild("Exp")
        if xp and xp.Value ~= num then pcall(function() xp.Value = num end) end
    end
end)

-- Settings: Clumsy, FOV, Fake Ping
local clumsyFactor = 0
MiscSettings:AddInput("MiscClumsy", { Text = "Clumsy (ping x)", Default = "0", Placeholder = "0..0.5" })
Options.MiscClumsy:OnChanged(function()
    local num = tonumber(Options.MiscClumsy.Value)
    if not num then return end
    clumsyFactor = math.max(0, tonumber(string.format("%.3f", num)) or 0)
end)

MiscSettings:AddSlider("MiscFOV", { Text = "Change FOV", Default = 70, Min = 40, Max = 120, Rounding = 1 })
Options.MiscFOV:OnChanged(function(v)
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = v end
end)

local fakePingEnabled, fakePingMs, fakePingJitter = false, 80, 0.05
MiscSettings:AddToggle("MiscFakePing", { Text = "Fake Ping", Default = false, Tooltip = "Реалистичный фейк-пинг" })
Toggles.MiscFakePing:OnChanged(function(v) fakePingEnabled = v and true or false end)
-- прямой Replication Lag (как в tps.lua)
MiscSettings:AddInput("MiscReplLag", { Text = "Replication Lag (sec)", Default = "0", Placeholder = "0.00..0.10" })
Options.MiscReplLag:OnChanged(function()
    local v = tonumber(Options.MiscReplLag.Value)
    if v then pcall(function() settings():GetService("NetworkSettings").IncomingReplicationLag = v end) end
end)
MiscSettings:AddInput("MiscFakePingMs", { Text = "Ping (ms)", Default = "80", Placeholder = "миллисекунды" })
Options.MiscFakePingMs:OnChanged(function()
    local num = tonumber(Options.MiscFakePingMs.Value)
    if num then fakePingMs = math.max(0, math.floor(num + 0.5)) end
end)
MiscSettings:AddInput("MiscFakePingJit", { Text = "Jitter %", Default = "5", Placeholder = "0..30" })
Options.MiscFakePingJit:OnChanged(function()
    local num = tonumber(Options.MiscFakePingJit.Value)
    if num then fakePingJitter = math.max(0, math.min(0.5, num/100)) end
end)

-- безопасный вызов тачей (исправляет attempt to call a nil value, когда нет firetouchinterest)
local function fireTouchSafe(p1, p2)
    if fakePingEnabled then
        local base = (fakePingMs or 0) / 1000
        local jitter = (fakePingJitter or 0.05)
        local mul = 1 + (clumsyFactor or 0)
        local r = (math.random() * 2 - 1) * jitter -- -j..+j
        local delay = math.max(0, base * (1 + r) * mul)
        if delay > 0 then task.wait(delay) end
    end
    if typeof(firetouchinterest) == "function" then
        pcall(firetouchinterest, p1, p2, 0)
        pcall(firetouchinterest, p1, p2, 1)
        return true
    end
    if typeof(firetouchtransmitter) == "function" then
        pcall(firetouchtransmitter, p1, p2)
        return true
    end
    return false
end

-- Reach tab: Leg/Head/Ball
local ReachGroupLeft  = Tabs.Reach:AddLeftGroupbox("Leg Reach")
local HeadReachGroup  = Tabs.Reach:AddRightGroupbox("Head Reach")
local BallReachGroup  = Tabs.Reach:AddRightGroupbox("Ball Reach")

local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function ensureChar()
    local c = lp and lp.Character or nil
    local h = c and c:FindFirstChildOfClass("Humanoid") or nil
    return c, h
end

local function makeBox(color)
    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.Massless = true
    p.Transparency = 1
    p.Size = Vector3.new(1,1,1)
    p.Name = "ReachIndicator"
    p.Parent = workspace

    -- Контурный бокс (проволочный) поверх всего
    local bha = Instance.new("BoxHandleAdornment")
    bha.Color3 = color
    bha.Transparency = 0.3
    bha.AlwaysOnTop = true
    bha.ZIndex = 5
    bha.Adornee = p
    bha.Size = p.Size
    bha.Visible = true
    bha.Parent = p

    -- Доп. выделение с тонкими линиями
    local sb = Instance.new("SelectionBox")
    sb.Color3 = color
    sb.LineThickness = 0.05
    sb.SurfaceColor3 = color
    sb.SurfaceTransparency = 0.85
    sb.Adornee = p
    sb.Visible = true
    sb.Parent = p

    return p
end

local legBox, headBox, ballBox
local legConn, headConn, ballConn

local function reachGetBallPart()
    local sys = workspace:FindFirstChild("TPSSystem")
    local tps = sys and sys:FindFirstChild("TPS")
    if tps and tps:IsA("BasePart") then return tps end
    if tps and tps:IsA("Model") then
        if tps.PrimaryPart then return tps.PrimaryPart end
        for _,d in ipairs(tps:GetDescendants()) do
            if d:IsA("BasePart") then return d end
        end
    end
    if sys then
        for _,d in ipairs(sys:GetDescendants()) do
            if d:IsA("BasePart") and (string.find(d.Name:lower(), "tps") or string.find(d.Name:lower(), "ball")) then
                return d
            end
        end
        for _,d in ipairs(sys:GetDescendants()) do
            if d:IsA("BasePart") then return d end
        end
    end
    return nil
end

local function setBoxVisible(box, visible)
    if not box then return end
    local bha = box:FindFirstChildOfClass("BoxHandleAdornment")
    if bha then bha.Visible = visible end
    local sb = box:FindFirstChildOfClass("SelectionBox")
    if sb then sb.Visible = visible end
end

local function updateBoxVisual(box)
    if not box then return end
    local bha = box:FindFirstChildOfClass("BoxHandleAdornment")
    if bha then bha.Size = box.Size end
    local sb = box:FindFirstChildOfClass("SelectionBox")
    if sb then sb.Adornee = box end
end

-- Leg Reach controls
local legEnabled = false
local legX, legY, legZ = 0, 0, 0
ReachGroupLeft:AddToggle("LegReachToggle", { Text = "Enable Leg Reach", Default = false })
ReachGroupLeft:AddToggle("LegReachShow", { Text = "Show Hitbox", Default = true })
Toggles.LegReachShow:OnChanged(function(v)
    setBoxVisible(legBox, v and true or false)
end)
Toggles.LegReachToggle:OnChanged(function(v)
    legEnabled = v and true or false
    if v then
        if not legBox then legBox = select(1, makeBox(Color3.fromRGB(0,255,120))) end
        setBoxVisible(legBox, Toggles.LegReachShow.Value)
        if legConn then legConn:Disconnect() end
        legConn = RS.Heartbeat:Connect(function()
            local c = lp.Character; if not c or not legBox then return end
            local rl = c:FindFirstChild("Right Leg") or c:FindFirstChild("RightLowerLeg") or c:FindFirstChild("RightFoot")
            local ll = c:FindFirstChild("Left Leg")  or c:FindFirstChild("LeftLowerLeg")  or c:FindFirstChild("LeftFoot")
            local pos
            if rl and ll then pos = (rl.Position + ll.Position)/2 elseif rl then pos = rl.Position elseif ll then pos = ll.Position end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not pos and hrp then pos = hrp.Position - Vector3.new(0,2,0) end
            if pos then
                legBox.CFrame = CFrame.new(pos)
                legBox.Size = Vector3.new(math.max(1, legX*2), math.max(1, legY*2), math.max(1, legZ*2))
                updateBoxVisual(legBox)
            end
            -- функционал из tps.lua: проверка достижимости по XYZ и безопасные касания ногами
            local ball = reachGetBallPart()
            if ball and hrp then
                local delta = hrp.Position - ball.Position
                if math.abs(delta.X) <= legX and math.abs(delta.Y) <= legY and math.abs(delta.Z) <= legZ then
                    if rl then fireTouchSafe(rl, ball) end
                    if ll then fireTouchSafe(ll, ball) end
                end
            end
        end)
    else
        if legConn then legConn:Disconnect(); legConn = nil end
        if legBox and legBox.Parent then legBox:Destroy(); end
        legBox = nil
    end
end)
ReachGroupLeft:AddSlider("LegReachX", { Text = "X", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.LegReachX:OnChanged(function(v) legX = v end)
ReachGroupLeft:AddSlider("LegReachY", { Text = "Y", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.LegReachY:OnChanged(function(v) legY = v end)
ReachGroupLeft:AddSlider("LegReachZ", { Text = "Z", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.LegReachZ:OnChanged(function(v) legZ = v end)
ReachGroupLeft:AddSlider("LegReachSync", { Text = "Sync (XYZ)", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.LegReachSync:OnChanged(function(v) legX=v; legY=v; legZ=v end)

-- Head Reach controls
local headEnabled = false
local headX, headY, headZ = 0,0,0
HeadReachGroup:AddToggle("HeadReachToggle", { Text = "Enable Head Reach", Default = false })
HeadReachGroup:AddToggle("HeadReachShow", { Text = "Show Hitbox", Default = true })
Toggles.HeadReachShow:OnChanged(function(v)
    setBoxVisible(headBox, v and true or false)
end)
Toggles.HeadReachToggle:OnChanged(function(v)
    headEnabled = v and true or false
    if v then
        if not headBox then headBox = select(1, makeBox(Color3.fromRGB(120,180,255))) end
        setBoxVisible(headBox, Toggles.HeadReachShow.Value)
        if headConn then headConn:Disconnect() end
        headConn = RS.Heartbeat:Connect(function()
            local c = lp.Character; if not c or not headBox then return end
            local head = c:FindFirstChild("Head")
            if head then
                headBox.CFrame = head.CFrame
                headBox.Size = Vector3.new(math.max(1, headX*2), math.max(1, headY*2), math.max(1, headZ*2))
                updateBoxVisual(headBox)
            end
            -- Проверка Head->Ball и касание головой
            local ball = reachGetBallPart()
            if head and ball then
                local delta = head.Position - ball.Position
                if math.abs(delta.X) <= headX and math.abs(delta.Y) <= headY and math.abs(delta.Z) <= headZ then
                    fireTouchSafe(head, ball)
                end
            end
        end)
    else
        if headConn then headConn:Disconnect(); headConn = nil end
        if headBox and headBox.Parent then headBox:Destroy(); end
        headBox = nil
    end
end)
HeadReachGroup:AddSlider("HeadReachX", { Text = "X", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.HeadReachX:OnChanged(function(v) headX = v end)
HeadReachGroup:AddSlider("HeadReachY", { Text = "Y", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.HeadReachY:OnChanged(function(v) headY = v end)
HeadReachGroup:AddSlider("HeadReachZ", { Text = "Z", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.HeadReachZ:OnChanged(function(v) headZ = v end)
HeadReachGroup:AddSlider("HeadReachSync", { Text = "Sync (XYZ)", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.HeadReachSync:OnChanged(function(v) headX=v; headY=v; headZ=v end)

-- Ball Reach controls
local ballEnabled = false
local ballX, ballY, ballZ = 0,0,0
BallReachGroup:AddToggle("BallReachToggle", { Text = "Enable Ball Reach", Default = false })
BallReachGroup:AddToggle("BallReachShow", { Text = "Show Hitbox", Default = true })
Toggles.BallReachShow:OnChanged(function(v)
    setBoxVisible(ballBox, v and true or false)
end)
Toggles.BallReachToggle:OnChanged(function(v)
    ballEnabled = v and true or false
    if v then
        if not ballBox then ballBox = select(1, makeBox(Color3.fromRGB(80,255,80))) end
        setBoxVisible(ballBox, Toggles.BallReachShow.Value)
        if ballConn then ballConn:Disconnect() end
        ballConn = RS.Heartbeat:Connect(function()
            local sys = workspace:FindFirstChild("TPSSystem")
            local ball = sys and sys:FindFirstChild("TPS")
            if ball and ballBox then
                ballBox.CFrame = ball.CFrame
                ballBox.Size = Vector3.new(math.max(1, ballX*2), math.max(1, ballY*2), math.max(1, ballZ*2))
                updateBoxVisual(ballBox)
            end
            -- Проверка Body->Ball и касание корнем
            local c = lp.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local ballPart = reachGetBallPart()
            if hrp and ballPart then
                local delta = hrp.Position - ballPart.Position
                if math.abs(delta.X) <= ballX and math.abs(delta.Y) <= ballY and math.abs(delta.Z) <= ballZ then
                    fireTouchSafe(hrp, ballPart)
                end
            end
        end)
    else
        if ballConn then ballConn:Disconnect(); ballConn = nil end
        if ballBox and ballBox.Parent then ballBox:Destroy(); end
        ballBox = nil
    end
end)
BallReachGroup:AddSlider("BallReachX", { Text = "X", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.BallReachX:OnChanged(function(v) ballX = v end)
BallReachGroup:AddSlider("BallReachY", { Text = "Y", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.BallReachY:OnChanged(function(v) ballY = v end)
BallReachGroup:AddSlider("BallReachZ", { Text = "Z", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.BallReachZ:OnChanged(function(v) ballZ = v end)
BallReachGroup:AddSlider("BallReachSync", { Text = "Sync (XYZ)", Default = 0, Min = 0, Max = 50, Rounding = 1 })
Options.BallReachSync:OnChanged(function(v) ballX=v; ballY=v; ballZ=v end)

-- Ball: Legacy Physics / Old Collision
local BallLegacyGroup = Tabs.Ball:AddRightGroupbox("Legacy Physics")
local oldCollConn
BallLegacyGroup:AddToggle("OldCollBall", { Text = "Old Collision Ball", Tooltip = "Принудительно включает коллизию и стандартные физсвойства мяча", Default = false })
Toggles.OldCollBall:OnChanged(function(Value)
    if Value then
        if oldCollConn then oldCollConn:Disconnect() end
        oldCollConn = game:GetService("RunService").Heartbeat:Connect(function()
            local sys = workspace:FindFirstChild("TPSSystem")
            local ball = sys and sys:FindFirstChild("TPS")
            if not ball or not ball:IsA("BasePart") then return end
            ball.CanCollide = true
            ball.CanTouch = true
            ball.Massless = false
            pcall(function() ball.CollisionGroupId = 0 end)
            pcall(function() ball.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5) end)
        end)
    else
        if oldCollConn then oldCollConn:Disconnect(); oldCollConn = nil end
    end
end)

-- Player tab: Steal Avatar (только визуал)
local PlayerTab = Window:AddTab("Player", "user")
local PlayerGroup = PlayerTab:AddLeftGroupbox("Avatar")
PlayerGroup:AddInput("StealAvatarName", { Text = "Steal Avatar", Default = "", Placeholder = "Exact username" })
PlayerGroup:AddButton("Apply", function()
    local nameOpt = Options.StealAvatarName and Options.StealAvatarName.Value or ""
    if type(nameOpt) ~= "string" or #nameOpt == 0 then return end
    task.spawn(function()
        local Players = game:GetService("Players")
        local ok, userId = pcall(function() return Players:GetUserIdFromNameAsync(nameOpt) end)
        if not ok or not userId then return end
        local ok2, targetDesc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
        if not ok2 or not targetDesc then return end
        local lp = Players.LocalPlayer
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        -- Не трогаем риг (R6/R15) и анимации пользователя — оставляем как есть
        local ok3, curDesc = pcall(function() return hum:GetAppliedDescription() end)
        if ok3 and curDesc then
            targetDesc.WalkAnimation = curDesc.WalkAnimation
            targetDesc.RunAnimation = curDesc.RunAnimation
            targetDesc.IdleAnimation = curDesc.IdleAnimation
            targetDesc.JumpAnimation = curDesc.JumpAnimation
            targetDesc.FallAnimation = curDesc.FallAnimation
            targetDesc.SwimAnimation = curDesc.SwimAnimation
            targetDesc.ClimbAnimation = curDesc.ClimbAnimation
            pcall(function()
                targetDesc.Emotes = curDesc.Emotes
                targetDesc.EquippedEmotes = curDesc.EquippedEmotes
            end)
        end
        pcall(function() hum:ApplyDescription(targetDesc) end)
    end)
end)

-- Удалены старые методы ZZ/ZZZ/ZZZZ/Air/Inf React



local forceTouchConnection
local ballReactConnection
local improveConn
local gkConn
local function onHeartbeat()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    local ball = workspace.TPSSystem:FindFirstChild("TPS")
    if not ball then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local distance = (root.Position - ball.Position).magnitude

    if distance < 3 then -- не увеличиваем reach; ближе к "естественной" зоне касания
        local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg")
        local leftLeg  = character:FindFirstChild("Left Leg")  or character:FindFirstChild("LeftLowerLeg")

        if rightLeg then fireTouchSafe(rightLeg, ball) end
        if leftLeg then  fireTouchSafe(leftLeg,  ball) end

        -- Лёгкая поддержка скорости: только когда мяч медленный, без перфектного контроля
        local phys = ball:FindFirstChild("Physic")
        if phys then
            local bv = phys:FindFirstChild("BodyVelocity")
            if bv then
                local v = ball.Velocity
                local speed = v.Magnitude
                if speed > 0 then
                    if speed < 25 then
                        -- небольшое усиление, ограниченное
                        local target = v.Unit * math.min(28, math.max(15, speed * 1.06))
                        bv.Velocity = target
                    end
                end
            end
        end
    end
end

ReactsGroup:AddToggle("BallReact", { Text = "Ball React", Tooltip = "Улучшенная регистрация касаний без увеличения дальности", Default = false })
Toggles.BallReact:OnChanged(function(Value)
    if Value then
        ballReactConnection = game:GetService("RunService").Heartbeat:Connect(onHeartbeat)
    else
        if ballReactConnection then
            ballReactConnection:Disconnect()
            ballReactConnection = nil
        end
    end
end)

-- Force Touch удалён по просьбе пользователя

local function startImproveHitRegistration()
    if improveConn then return end
    local tpsSystem = workspace:FindFirstChild("TPSSystem")
    if not tpsSystem then return end
    local ball = tpsSystem:FindFirstChild("TPS")
    if not ball then return end
    improveConn = ball.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local dir = (ball.Position - hrp.Position)
            if dir.Magnitude > 0 then
                ball.Velocity = dir.Unit * 50
            end
        end
    end)
end

local function stopImproveHitRegistration()
    if improveConn then improveConn:Disconnect(); improveConn = nil end
end

ReactsGroup:AddToggle("ImproveHitRegistration", { Text = "Improve Hit Registration", Tooltip = "Улучшенная регистрация удара по мячу", Default = false })
Toggles.ImproveHitRegistration:OnChanged(function(Value)
    if Value then
        startImproveHitRegistration()
    else
        stopImproveHitRegistration()
    end
end)

-- Ball Physic Prediction: сплошная зелёная 3D линия (Beam)
local predFolder
local predConn
local predMarkers = {} -- невидимые якорные Part с Attachment для Beam
local predBeams = {}
local ballAttach -- Attachment на самом мяче, чтобы линия начиналась прямо от него
local predCircle -- 3D круг места приземления
local showLandingCircle = true
local predBill -- Billboard с иконкой и таймером
local showTrajectoryLine = false -- по умолчанию линия отскоков выключена
-- ground direction удалён по просьбе пользователя
local function ensurePredFolder()
    if predFolder and predFolder.Parent then return predFolder end
    predFolder = Instance.new("Folder")
    predFolder.Name = "BallPrediction"
    predFolder.Parent = workspace
    return predFolder
end

local function clearPrediction()
    if predConn then predConn:Disconnect(); predConn = nil end
    for _,b in ipairs(predBeams) do b:Destroy() end
    predBeams = {}
    for _,p in ipairs(predMarkers) do p:Destroy() end
    predMarkers = {}
    ballAttach = nil
    if predCircle then predCircle:Destroy(); predCircle = nil end
    if predBill then predBill:Destroy(); predBill = nil end
    -- удалены сущности ground direction
    if predFolder then predFolder:Destroy(); predFolder = nil end
end

local function createMarkers(count)
    if not showTrajectoryLine then return end
    local folder = ensurePredFolder()
    for i=1,count do
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.CastShadow = false
        part.Size = Vector3.new(0.2,0.2,0.2)
        part.Transparency = 1 -- скрываем точки
        part.Name = "PredAnchor" .. i
        part.Parent = folder
        local att = Instance.new("Attachment")
        att.Name = "A"
        att.Parent = part
        predMarkers[i] = part
    end
    -- создаём зелёные Beams: первый сегмент от мяча к первой точке, далее между точками
    for i=1,(count-1) do
        local beam = Instance.new("Beam")
        beam.Attachment0 = predMarkers[i].A
        beam.Attachment1 = predMarkers[i+1].A
        beam.Color = ColorSequence.new(Color3.fromRGB(80, 255, 80))
        beam.Width0 = 0.16
        beam.Width1 = 0.16
        beam.Transparency = NumberSequence.new(0)
        beam.LightEmission = 0
        beam.FaceCamera = false
        beam.Parent = ensurePredFolder()
        table.insert(predBeams, beam)
    end
end

local function setPredictionEnabled(enabled)
    if not enabled then
        clearPrediction()
        return
    end
    if predConn then return end
    if showTrajectoryLine and #predMarkers == 0 then createMarkers(30) end
    predConn = game:GetService("RunService").RenderStepped:Connect(function()
        local tpsSystem = workspace:FindFirstChild("TPSSystem")
        if not tpsSystem then return end
        local ball = tpsSystem:FindFirstChild("TPS")
        if not ball then return end
        -- анти-залипание: если линия выключена, гарантированно чистим маркеры/бимы
        if not showTrajectoryLine then
            if #predBeams > 0 then for _,b in ipairs(predBeams) do b:Destroy() end predBeams = {} end
            if #predMarkers > 0 then for _,p in ipairs(predMarkers) do p:Destroy() end predMarkers = {} end
        end
        -- Attachment на мяче, чтобы линия начиналась прямо от него
        if not ballAttach or not ballAttach.Parent or ballAttach.Parent ~= ball then
            ballAttach = ball:FindFirstChild("PredBallAttachment")
            if not ballAttach then
                ballAttach = Instance.new("Attachment")
                ballAttach.Name = "PredBallAttachment"
                ballAttach.Parent = ball
            end
            ensureHeadBeam()
        end

        -- итеративная симуляция с отскоками от поверхности
        local pos = ball.Position
        local vel = ball.AssemblyLinearVelocity or ball.Velocity
        local gravity = Vector3.new(0, -workspace.Gravity, 0)
        local step = 0.06
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { ball, predFolder, game.Players.LocalPlayer.Character }

        local landingPos = nil
        local landingTime = nil
        local tAccum = 0
        if showTrajectoryLine then
            for i, marker in ipairs(predMarkers) do
                marker.CFrame = CFrame.new(pos)
                -- следующий шаг
                local nextVel = vel + gravity * step
                local delta = (vel + nextVel) * 0.5 * step
                local result = workspace:Raycast(pos, delta, params)
                if result then
                    pos = result.Position + result.Normal * 0.05
                    local n = result.Normal
                    -- отражение скорости относительно нормали
                    vel = vel - 2 * vel:Dot(n) * n
                    -- затухание/трение
                    vel = vel * 0.6
                    vel = Vector3.new(vel.X * 0.98, vel.Y, vel.Z * 0.98)
                    if not landingPos and n.Y > 0.6 then
                        landingPos = result.Position
                        landingTime = tAccum
                    end
                else
                    pos = pos + delta
                    vel = nextVel
                end
                tAccum += step
            end
        else
            -- без линии отскоков: считаем только первую точку приземления
            local maxTime = 3
            while tAccum < maxTime do
                local nextVel = vel + gravity * step
                local delta = (vel + nextVel) * 0.5 * step
                local result = workspace:Raycast(pos, delta, params)
                if result then
                    local n = result.Normal
                    if n.Y > 0.6 then
                        landingPos = result.Position
                        landingTime = tAccum
                        break
                    else
                        -- для стен продолжаем, слегка гася скорость
                        pos = result.Position + n * 0.05
                        vel = vel - 2 * vel:Dot(n) * n
                        vel = vel * 0.6
                    end
                else
                    pos = pos + delta
                    vel = nextVel
                end
                tAccum += step
            end
        end

        -- обновить/создать круг приземления
        if showLandingCircle and landingPos then
            if not predCircle or not predCircle.Parent then
                predCircle = Instance.new("Part")
                predCircle.Name = "BallLandingCircle"
                predCircle.Shape = Enum.PartType.Cylinder
                predCircle.Anchored = true
                predCircle.CanCollide = false
                predCircle.CanTouch = false
                predCircle.CanQuery = false
                predCircle.CastShadow = false
                predCircle.Material = Enum.Material.Neon
                predCircle.Color = Color3.fromRGB(80, 255, 80)
                predCircle.Transparency = 0.2
                predCircle.Parent = ensurePredFolder()
            end
            local baseRadius = (ball.Size and ball.Size.X and (ball.Size.X/2)) or 2.2
            local thickness = 0.12
            predCircle.Size = Vector3.new(baseRadius * 2, thickness, baseRadius * 2)
            predCircle.CFrame = CFrame.new(landingPos) * CFrame.Angles(math.rad(90), 0, 0)
            predCircle.Transparency = 0.2

            -- Billboard с иконкой и таймером
            if not predBill or not predBill.Parent then
                predBill = Instance.new("BillboardGui")
                predBill.Name = "BallLandingInfo"
                predBill.AlwaysOnTop = true
                predBill.Size = UDim2.new(0, 120, 0, 36)
                predBill.StudsOffset = Vector3.new(0, 1.6, 0)
                predBill.Adornee = predCircle
                local container = Instance.new("Frame")
                container.Name = "Container"
                container.Size = UDim2.new(1, 0, 1, 0)
                container.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
                container.BackgroundTransparency = 0.15
                container.BorderSizePixel = 0
                container.Parent = predBill
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = container
                local padding = Instance.new("UIPadding")
                padding.PaddingLeft = UDim.new(0, 8)
                padding.PaddingRight = UDim.new(0, 8)
                padding.Parent = container
                local layout = Instance.new("UIListLayout")
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                layout.VerticalAlignment = Enum.VerticalAlignment.Center
                layout.Padding = UDim.new(0, 6)
                layout.Parent = container
                -- Иконка: смайлик таймера
                local icon = Instance.new("TextLabel")
                icon.Name = "Icon"
                icon.BackgroundTransparency = 1
                icon.Size = UDim2.new(0, 18, 0, 18)
                icon.Text = "⏱"
                icon.TextColor3 = Color3.fromRGB(255,255,255)
                icon.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                icon.TextSize = 16
                icon.Parent = container
                -- Таймер
                local lbl = Instance.new("TextLabel")
                lbl.Name = "Timer"
                lbl.BackgroundTransparency = 1
                lbl.Size = UDim2.new(1, -28, 1, 0)
                lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.TextSize = 13
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = "0.00s"
                lbl.Parent = container
                predBill.Parent = ensurePredFolder()
            end
            local timerLabel = predBill:FindFirstChild("Container") and predBill.Container:FindFirstChild("Timer")
            local tval = tonumber(landingTime) or 0
            if timerLabel then
                if tval > 0.001 then
                    timerLabel.Text = string.format("%.2fs", tval)
                    predBill.Enabled = true
                else
                    predBill.Enabled = false
                end
            else
                predBill.Enabled = false
            end
        else
            if predCircle then predCircle.Transparency = 1 end
            if predBill then predBill.Enabled = false end
        end

        -- ground direction отключён
    end)
end

BallGroup:AddToggle("BallPrediction", { Text = "Ball Physic Prediction", Tooltip = "Показывает 3D линию траектории мяча", Default = false })
Toggles.BallPrediction:OnChanged(function(Value)
    setPredictionEnabled(Value)
end)
BallGroup:AddToggle("BallTrajectoryLine", { Text = "Trajectory Line", Tooltip = "Показывать линию отскоков (полная траектория)", Default = false })
Toggles.BallTrajectoryLine:OnChanged(function(Value)
    showTrajectoryLine = Value and true or false
    -- при смене настройки пересоздаём маркеры/линии
    if not showTrajectoryLine then
        for _,b in ipairs(predBeams) do b:Destroy() end; predBeams = {}
        for _,p in ipairs(predMarkers) do p:Destroy() end; predMarkers = {}
    else
        -- включили: если предиктор активен — создаём маркеры и головной сегмент
        if predConn then
            if #predMarkers == 0 then createMarkers(30) end
            -- убедимся, что есть ballAttach
            local sys = workspace:FindFirstChild("TPSSystem")
            local ball = sys and sys:FindFirstChild("TPS")
            if ball then
                if not ballAttach or ballAttach.Parent ~= ball then
                    ballAttach = ball:FindFirstChild("PredBallAttachment")
                    if not ballAttach then
                        ballAttach = Instance.new("Attachment")
                        ballAttach.Name = "PredBallAttachment"
                        ballAttach.Parent = ball
                    end
                end
                ensureHeadBeam()
            end
        end
    end
end)
-- Ground Direction убран
BallGroup:AddToggle("BallLandingCircle", { Text = "Landing Circle", Tooltip = "Показывать 3D круг точки приземления", Default = true })
Toggles.BallLandingCircle:OnChanged(function(Value)
    showLandingCircle = Value and true or false
    if not showLandingCircle and predCircle then predCircle.Transparency = 1 end
    if not showLandingCircle and predBill then predBill.Enabled = false end
end)

-- Reduce Ball Delay: уменьшение сетевой задержки для мяча
local reduceConn
ReactsGroup:AddToggle("ReduceDelay", { Text = "Reduce Ball Delay", Tooltip = "Снижает задержку репликации: ReplicationFocus и радиус симуляции", Default = false })
Toggles.ReduceDelay:OnChanged(function(Value)
    if Value then
        -- попытка поднять радиусы симуляции (если эксплойт поддерживает sethiddenproperty)
        pcall(function()
            if typeof(sethiddenproperty) == "function" then
                local lp = game.Players.LocalPlayer
                sethiddenproperty(lp, "SimulationRadius", 1000)
                sethiddenproperty(lp, "MaximumSimulationRadius", 1000)
            end
        end)
        if reduceConn then reduceConn:Disconnect() end
        reduceConn = game:GetService("RunService").Heartbeat:Connect(function()
            local sys = workspace:FindFirstChild("TPSSystem")
            local ball = sys and sys:FindFirstChild("TPS")
            if ball then
                local lp = game.Players.LocalPlayer
                local rf = lp:FindFirstChild("ReplicationFocus")
                if not rf then
                    local obj = Instance.new("ObjectValue", lp)
                    obj.Name = "ReplicationFocus"
                    obj.Value = ball
                else
                    rf.Value = ball
                end
            end
        end)
    else
        if reduceConn then reduceConn:Disconnect(); reduceConn = nil end
        local lp = game.Players.LocalPlayer
        if lp:FindFirstChild("ReplicationFocus") then
            lp.ReplicationFocus:Destroy()
        end
        -- не трогаем скрытые свойства обратно, чтобы не крашить; они временные
    end
end)

-- GK React: регистрирует сейвы корпусом и отталкивает мяч при пролёте рядом
ReactsGroup:AddToggle("GKReact", { Text = "GK React", Tooltip = "Голкипер: надёжная регистрация сейвов", Default = false })
Toggles.GKReact:OnChanged(function(Value)
    if Value then
        if gkConn then gkConn:Disconnect() end
        gkConn = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end
            local ball = workspace.TPSSystem and workspace.TPSSystem:FindFirstChild("TPS") or nil
            if not ball then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            local dist = (hrp.Position - ball.Position).Magnitude
            if dist < 4 then
                if torso then fireTouchSafe(torso, ball) end
                -- если мяч летит на игрока — отразить от корпуса
                local toPlayer = (hrp.Position - ball.Position)
                local v = ball.Velocity
                if toPlayer.Magnitude > 0 then
                    local approach = v:Dot(toPlayer.Unit)
                    if approach > 0 then
                        local newV = toPlayer.Unit * math.max(30, v.Magnitude * 0.8)
                        ball.Velocity = newV
                    end
                end
            end
        end)
    else
        if gkConn then gkConn:Disconnect(); gkConn = nil end
    end
end)

-- Render: Ball ESP и Distance
local ballESPEnabled = false
local ballESPConn
local ballBillboard
local showESPDist = true

local function destroyBallESP()
    if ballESPConn then ballESPConn:Disconnect(); ballESPConn = nil end
    if ballBillboard then ballBillboard:Destroy(); ballBillboard = nil end
end

local function createBallESP(ball)
    destroyBallESP()
    local adornee = ball
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Vexus_BallESP"
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 110, 0, 38)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.ResetOnSpawn = false
    local frame = Instance.new("Frame")
    frame.Name = "Container"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 5); corner.Parent = frame
    local padding = Instance.new("UIPadding"); padding.PaddingLeft = UDim.new(0, 6); padding.PaddingRight = UDim.new(0, 6); padding.Parent = frame
    local layout = Instance.new("UIListLayout"); layout.FillDirection = Enum.FillDirection.Vertical; layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.VerticalAlignment = Enum.VerticalAlignment.Center; layout.Parent = frame
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.BorderSizePixel = 0
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    nameLabel.Text = "Ball"
    nameLabel.TextScaled = false
    nameLabel.TextSize = 12
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextTransparency = 0
    nameLabel.TextStrokeTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.LayoutOrder = 1
    nameLabel.Parent = frame
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistanceLabel"
    distLabel.BackgroundTransparency = 1
    distLabel.BorderSizePixel = 0
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    distLabel.Text = "0 studs"
    distLabel.TextScaled = false
    distLabel.TextSize = 11
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextTransparency = 0
    distLabel.TextStrokeTransparency = 1
    distLabel.TextXAlignment = Enum.TextXAlignment.Center
    distLabel.TextYAlignment = Enum.TextYAlignment.Center
    distLabel.LayoutOrder = 2
    distLabel.Parent = frame
    billboard.Parent = adornee
    ballBillboard = billboard
    ballESPConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not ballESPEnabled then return end
        local lp = game.Players.LocalPlayer
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local dLbl = ballBillboard.Container:FindFirstChild("DistanceLabel")
        if dLbl then dLbl.Visible = showESPDist end
        if hrp and dLbl and ball and ball.Parent then
            local d = (ball.Position - hrp.Position).Magnitude
            dLbl.Text = string.format("%d studs", math.floor(d + 0.5))
        end
    end)
end

local function toggleBallESP(state)
    ballESPEnabled = state
    if state then
        local sys = workspace:FindFirstChild("TPSSystem")
        local ball = sys and sys:FindFirstChild("TPS")
        if ball then createBallESP(ball) end
    else
        destroyBallESP()
    end
end

RenderGroup:AddToggle("BallESP", { Text = "Ball ESP", Tooltip = "Подсветка мяча с названием и дистанцией", Default = false })
Toggles.BallESP:OnChanged(function(Value)
    toggleBallESP(Value)
end)

-- Показ/скрытие дистанции в ESP
RenderGroup:AddToggle("BallESPDistance", { Text = "Distance", Tooltip = "Показывать дистанцию в ESP", Default = true })
Toggles.BallESPDistance:OnChanged(function(Value)
    showESPDist = Value and true or false
end)

-- Render → Visuals: Sky/Ball Color, Custom Ball Texture
do
    local Lighting = game:GetService("Lighting")
    local function setSkyColor(c)
        if not Lighting then return end
        pcall(function()
            Lighting.Ambient = c
            Lighting.OutdoorAmbient = c
            Lighting.ColorShift_Top = c
            Lighting.ColorShift_Bottom = c
        end)
    end
    RenderVisuals:AddLabel("Sky Color"):AddColorPicker("SkyColor", { Default = Color3.fromRGB(128,128,128) })
    Options.SkyColor:OnChanged(function()
        setSkyColor(Options.SkyColor.Value)
    end)

    local function getBallPart()
        local sys = workspace:FindFirstChild("TPSSystem")
        local tps = sys and sys:FindFirstChild("TPS")
        if tps and tps:IsA("BasePart") then return tps end
        if tps and tps:IsA("Model") then
            if tps.PrimaryPart then return tps.PrimaryPart end
            for _,d in ipairs(tps:GetDescendants()) do
                if d:IsA("BasePart") then return d end
            end
        end
        if sys then
            for _,d in ipairs(sys:GetDescendants()) do
                if d:IsA("BasePart") and (string.find(d.Name:lower(), "tps") or string.find(d.Name:lower(), "ball")) then
                    return d
                end
            end
            for _,d in ipairs(sys:GetDescendants()) do
                if d:IsA("BasePart") then return d end
            end
        end
        return nil
    end
    local function setBallColor(c)
        local ball = getBallPart()
        if ball and ball:IsA("BasePart") then pcall(function() ball.Color = c end) end
    end
    RenderVisuals:AddLabel("Ball Color"):AddColorPicker("BallColor", { Default = Color3.fromRGB(80,255,80) })
    Options.BallColor:OnChanged(function()
        setBallColor(Options.BallColor.Value)
    end)
    local ballColorConn
    RenderVisuals:AddToggle("LockBallColor", { Text = "Lock Ball Color", Default = false })
    Toggles.LockBallColor:OnChanged(function(v)
        if v then
            if ballColorConn then ballColorConn:Disconnect() end
            ballColorConn = game:GetService("RunService").Heartbeat:Connect(function()
                setBallColor(Options.BallColor.Value)
            end)
        else
            if ballColorConn then ballColorConn:Disconnect(); ballColorConn = nil end
        end
    end)

    local function clearBallTextures()
        local ball = getBallPart(); if not ball then return end
        for _,ch in ipairs(ball:GetChildren()) do
            if ch:IsA("Decal") or ch:IsA("SurfaceAppearance") or ch:IsA("Texture") then ch:Destroy() end
        end
    end
    local function applyBallDecal(textureId)
        local ball = getBallPart(); if not ball then return end
        if tonumber(textureId) then textureId = "rbxassetid://" .. tostring(textureId) end
        local faces = {Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right, Enum.NormalId.Top, Enum.NormalId.Bottom}
        if ball:IsA("MeshPart") then
            for _,f in ipairs(faces) do
                local t = Instance.new("Texture")
                t.Texture = textureId
                t.Face = f
                t.StudsPerTileU = 5
                t.StudsPerTileV = 5
                t.Parent = ball
            end
        else
            for _,f in ipairs(faces) do
                local d = Instance.new("Decal")
                d.Texture = textureId
                d.Face = f
                d.Parent = ball
            end
        end
    end
    RenderVisuals:AddInput("BallTextureId", { Text = "Custom Ball Texture", Default = "", Placeholder = "Decal ID or rbxassetid://id" })
    RenderVisuals:AddButton("Apply Texture", function()
        local val = Options.BallTextureId and Options.BallTextureId.Value or ""
        if type(val) ~= "string" or #val == 0 then return end
        clearBallTextures(); applyBallDecal(val)
    end)
    RenderVisuals:AddButton("Delete Ball Texture", function()
        clearBallTextures()
    end)
end
