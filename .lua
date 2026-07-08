_qkaspq_store = _qkaspq_store or {}
if _qkaspq_store.connections then
	for _, conn in ipairs(_qkaspq_store.connections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
end
_qkaspq_store.connections = {}
local function regConn(conn)
	table.insert(_qkaspq_store.connections, conn)
	return conn
end
_qkaspq_store.Modules = _qkaspq_store.Modules or {}
_qkaspq_store.ActiveTab = _qkaspq_store.ActiveTab or 1
_qkaspq_store.Open = _qkaspq_store.Open or true
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local ac = Color3.fromRGB(255, 255, 255)
local ac2 = Color3.fromRGB(160, 160, 160)
local MOD_ICON = "rbxassetid://16000149927"
local BIND_ICON = "rbxassetid://11738672671"
local cl = {}
cl.bg = Color3.fromRGB(14, 14, 14)
cl.topbar = Color3.fromRGB(22, 22, 22)
cl.card = Color3.fromRGB(22, 22, 22)
cl.field = Color3.fromRGB(32, 32, 32)
cl.text = Color3.fromRGB(230, 230, 235)
cl.dim = Color3.fromRGB(140, 140, 150)
cl.dark = Color3.fromRGB(80, 80, 90)
cl.sep = Color3.fromRGB(40, 40, 45)
cl.tog_off = Color3.fromRGB(48, 48, 48)
cl.check = Color3.fromRGB(40, 40, 40)
cl.tab_sel = Color3.fromRGB(30, 30, 35)

local themes = {
	Default = {
		ac = Color3.fromRGB(255, 255, 255),
		ac2 = Color3.fromRGB(160, 160, 160),
		bg = Color3.fromRGB(14, 14, 14),
		topbar = Color3.fromRGB(22, 22, 22),
		card = Color3.fromRGB(22, 22, 22),
		field = Color3.fromRGB(32, 32, 32),
		tog_off = Color3.fromRGB(48, 48, 48),
		check = Color3.fromRGB(40, 40, 40),
	},
	Amethyst = {
		ac = Color3.fromRGB(160, 110, 255),
		ac2 = Color3.fromRGB(200, 180, 255),
		bg = Color3.fromRGB(15, 12, 20),
		topbar = Color3.fromRGB(22, 18, 30),
		card = Color3.fromRGB(22, 18, 30),
		field = Color3.fromRGB(30, 26, 40),
		tog_off = Color3.fromRGB(48, 48, 54),
		check = Color3.fromRGB(40, 40, 46),
	},
	Cyberpunk = {
		ac = Color3.fromRGB(254, 204, 34),
		ac2 = Color3.fromRGB(255, 225, 120),
		bg = Color3.fromRGB(12, 12, 12),
		topbar = Color3.fromRGB(18, 18, 18),
		card = Color3.fromRGB(18, 18, 18),
		field = Color3.fromRGB(28, 28, 28),
		tog_off = Color3.fromRGB(44, 44, 44),
		check = Color3.fromRGB(36, 36, 36),
	},
	Aquamarine = {
		ac = Color3.fromRGB(80, 220, 200),
		ac2 = Color3.fromRGB(160, 240, 230),
		bg = Color3.fromRGB(14, 18, 20),
		topbar = Color3.fromRGB(20, 26, 28),
		card = Color3.fromRGB(20, 26, 28),
		field = Color3.fromRGB(30, 38, 40),
		tog_off = Color3.fromRGB(48, 54, 56),
		check = Color3.fromRGB(40, 46, 48),
	},
	Ruby = {
		ac = Color3.fromRGB(240, 80, 80),
		ac2 = Color3.fromRGB(255, 150, 150),
		bg = Color3.fromRGB(16, 14, 14),
		topbar = Color3.fromRGB(24, 20, 20),
		card = Color3.fromRGB(24, 20, 20),
		field = Color3.fromRGB(36, 30, 30),
		tog_off = Color3.fromRGB(54, 48, 48),
		check = Color3.fromRGB(46, 40, 40),
	},
	Sapphire = {
		ac = Color3.fromRGB(80, 140, 255),
		ac2 = Color3.fromRGB(150, 190, 255),
		bg = Color3.fromRGB(10, 12, 18),
		topbar = Color3.fromRGB(16, 20, 28),
		card = Color3.fromRGB(16, 20, 28),
		field = Color3.fromRGB(24, 30, 40),
		tog_off = Color3.fromRGB(38, 44, 56),
		check = Color3.fromRGB(32, 38, 48),
	}
}
local themeList = {"Default", "Amethyst", "Cyberpunk", "Aquamarine", "Ruby", "Sapphire"}

local recolorRegistry = {
	ac = {},
	ac2 = {},
	bg = {},
	topbar = {},
	card = {},
	field = {},
	tog_off = {},
	check = {}
}

local function registerRecolor(obj, property, colorKey)
	if not recolorRegistry[colorKey] then return end
	table.insert(recolorRegistry[colorKey], {obj = obj, prop = property})
	pcall(function()
		obj[property] = cl[colorKey] or ac
	end)
end

local currentThemeName = "Amethyst"
local function applyTheme(themeName)
	local theme = themes[themeName]
	if not theme then return end
	currentThemeName = themeName
	ac = theme.ac
	ac2 = theme.ac2
	cl.bg = theme.bg
	cl.topbar = theme.topbar
	cl.card = theme.card
	cl.field = theme.field
	cl.tog_off = theme.tog_off
	cl.check = theme.check

	if bgImage then
		if theme.bg_image then
			bgImage.Image = theme.bg_image
			bgImage.ImageTransparency = theme.bg_image_transparency or 0.3
			bgImage.Visible = true
		else
			bgImage.Visible = false
		end
	end

	for colorKey, items in pairs(recolorRegistry) do
		local targetColor = theme[colorKey] or cl[colorKey]
		if targetColor then
			for _, item in ipairs(items) do
				pcall(function()
					item.obj[item.prop] = targetColor
				end)
			end
		end
	end
	if buildBindsList then pcall(buildBindsList) end
	if updateArrayList then pcall(updateArrayList) end
	if updateMusicGui then pcall(updateMusicGui) end
	if triggerBindRefresh then pcall(triggerBindRefresh) end
end

local transparencyRegistry = {}
local currentTransparencyValue = 0
local function registerTransparency(obj, baseAlpha)
	table.insert(transparencyRegistry, {obj = obj, baseAlpha = baseAlpha or 0})
	pcall(function()
		obj.BackgroundTransparency = math.clamp(baseAlpha + (1 - baseAlpha) * currentTransparencyValue, 0, 1)
	end)
end

local function applyTransparency(value)
	currentTransparencyValue = math.clamp(value, 0, 0.8)
	for _, item in ipairs(transparencyRegistry) do
		pcall(function()
			local tVal = currentTransparencyValue
			if item.obj ~= main and item.obj.Name ~= "Sidebar" and item.obj.Name ~= "ZenithWatermark" and item.obj.Name ~= "Notify" then
				tVal = currentTransparencyValue * 0.4
			end
			item.obj.BackgroundTransparency = math.clamp(item.baseAlpha + (1 - item.baseAlpha) * tVal, 0, 1)
		end)
	end
end
local profFrame, profName, profSub, profAvatar
local function tw(obj, props, t)
	local info = TweenInfo.new(t or 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local tween = TS:Create(obj, info, props)
	tween:Play()
	return tween
end
local function rnd(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = p
end
local function stk(p, col, th)
	local s = Instance.new("UIStroke")
	s.Enabled = false
	s.Parent = p
	return s
end
local function pad(p, t, b, l, r)
	local pd = Instance.new("UIPadding")
	pd.PaddingTop = UDim.new(0, t or 0)
	pd.PaddingBottom = UDim.new(0, b or 0)
	pd.PaddingLeft = UDim.new(0, l or 0)
	pd.PaddingRight = UDim.new(0, r or 0)
	pd.Parent = p
end
local function makeResizable(frame)
	local minSize = Vector2.new(400, 300)
	local function makeHandle(anchor, pos)
		local handle = Instance.new("TextButton")
		handle.Size = UDim2.new(0, 15, 0, 15)
		handle.Position = pos
		handle.AnchorPoint = anchor
		handle.BackgroundTransparency = 1
		handle.Text = ""
		handle.Parent = frame
		local active = false
		local dragStart
		local startSize
		local startPos
		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				active = true
				dragStart = input.Position
				startSize = frame.AbsoluteSize
				startPos = frame.Position
			end
		end)
		regConn(UIS.InputChanged:Connect(function(input)
			if active and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				local newW = startSize.X
				local newH = startSize.Y
				local newPosX = startPos.X.Offset
				local newPosY = startPos.Y.Offset
				if anchor.X == 1 then
					newW = math.max(minSize.X, startSize.X + delta.X)
				else
					newW = math.max(minSize.X, startSize.X - delta.X)
					newPosX = startPos.X.Offset + (startSize.X - newW)
				end
				if anchor.Y == 1 then
					newH = math.max(minSize.Y, startSize.Y + delta.Y)
				else
					newH = math.max(minSize.Y, startSize.Y - delta.Y)
					newPosY = startPos.Y.Offset + (startSize.Y - newH)
				end
				frame.Size = UDim2.new(0, newW, 0, newH)
				frame.Position = UDim2.new(startPos.X.Scale, newPosX, startPos.Y.Scale, newPosY)
			end
		end))
		regConn(UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				active = false
			end
		end))
	end
	makeHandle(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0))
	makeHandle(Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))
	makeHandle(Vector2.new(0, 1), UDim2.new(0, 0, 1, 0))
	makeHandle(Vector2.new(1, 1), UDim2.new(1, 0, 1, 0))
end
local function makeDraggable(frame)
	local dragInput
	local dragStart
	local startPos
	local dragging = false
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	regConn(game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end))
end
local _qkaspq = {}
_qkaspq.currentLanguage = "ENG"
_qkaspq.translations = {
	RU = {
		tab_Combat = "Бой",
		tab_Movement = "Движение",
		tab_Visuals = "Визуалы",
		tab_Misc = "Misc",
		tab_Settings = "Settings",
		mod_Notify = "Уведомления",
		mod_MusicGUI = "Музыкальный плеер",
		mod_Arraylist = "Список модулей",
		mod_TargetHud = "HUD цели",
		mod_Language = "Язык интерфейса",
		desc_Notify = "Отображает всплывающие уведомления при действиях.",
		desc_MusicGUI = "Отображает плеер с музыкой.",
		desc_Arraylist = "Отображает список включенных модулей на экране.",
		desc_TargetHud = "Отображает HUD текущей цели во время боя.",
		desc_Language = "Выберите язык интерфейса.",
		opt_Duration = "Длительность",
		opt_Volume = "Громкость",
		opt_Sound = "Звук Уведомления",
		opt_Location = "Расположение",
		opt_TestSound = "Протестировать Звук",
		opt_TargetSelection = "Выбор цели"
	},
	ENG = {
		tab_Combat = "Combat",
		tab_Movement = "Movement",
		tab_Visuals = "Visuals",
		tab_Misc = "Misc",
		tab_Settings = "Settings",
		mod_Notify = "Notifications",
		mod_MusicGUI = "Music Player",
		mod_Arraylist = "Module List",
		mod_TargetHud = "Target HUD",
		mod_Language = "Interface Language",
		desc_Notify = "Displays popup notifications on actions.",
		desc_MusicGUI = "Displays a music player GUI.",
		desc_Arraylist = "Displays active modules on the screen.",
		desc_TargetHud = "Displays the current target's HUD in combat.",
		desc_Language = "Choose interface language.",
		opt_Duration = "Duration",
		opt_Volume = "Volume",
		opt_Sound = "Notification Sound",
		opt_Location = "Location",
		opt_TestSound = "Test Sound",
		opt_TargetSelection = "Target Selection"
	}
}
function _qkaspq:updateLanguage()
	local lang = _qkaspq.currentLanguage or "RU"
	local t = self.translations[lang]
	if not t then
		return
	end
	self.tabNamesRu = {
		Combat = t.tab_Combat,
		Movement = t.tab_Movement,
		Visuals = t.tab_Visuals,
		Misc = t.tab_Misc,
		Settings = t.tab_Settings
	}
	self:SetModuleLabel("Settings", "Notify", t.mod_Notify)
	self:SetModuleLabel("Settings", "Music GUI", t.mod_MusicGUI)
	self:SetModuleLabel("Settings", "Arraylist", t.mod_Arraylist)
	self:SetModuleLabel("Settings", "Target Hud", t.mod_TargetHud)
	self:SetModuleLabel("Settings", "Client Language", t.mod_Language)
	self:SetOptionLabel("Settings", "Notify", "Длительность", t.opt_Duration)
	self:SetOptionLabel("Settings", "Notify", "Громкость", t.opt_Volume)
	self:SetOptionLabel("Settings", "Notify", "Звук Уведомления", t.opt_Sound)
	self:SetOptionLabel("Settings", "Notify", "Расположение", t.opt_Location)
	self:SetOptionLabel("Settings", "Notify", "Протестировать Звук", t.opt_TestSound)
	for i, tab in ipairs(self.tabDefs) do
		if self.tabBtns[i] then
			self.tabBtns[i].lbl.Text = self.tabNamesRu[tab.id] or tab.id
		end
	end
end
_qkaspq.tabDefs = {}
_qkaspq.tabBtns = {}
_qkaspq.columns = {}
_qkaspq.activeCards = {}
_qkaspq.tabNamesRu = {
	Combat = "Combat",
	Movement = "Movement",
	Visuals = "Visuals",
	Misc = "Misc",
	Settings = "Settings"
}
local wmText
local wmTime
local wmFps
local Playlist
local bgImage
local main
_qkaspq.Init = function(self, titleText, toggleKey, subtitleText, iconId)
	if type(titleText) == "table" then
		local opts = titleText
		titleText = opts.Title or opts.title
		toggleKey = opts.ToggleKey or opts.toggleKey or opts.Key or opts.key
		subtitleText = opts.Subtitle or opts.subtitle
		iconId = opts.Icon or opts.icon or opts.IconId or opts.iconId
	end
	titleText = titleText or "Zenith Client"
	_qkaspq_store.ToggleKey = toggleKey or Enum.KeyCode.RightShift
	_qkaspq_store.TitleText = titleText
	_qkaspq_store.SubtitleText = subtitleText or "Grow a Garden 2"
	_qkaspq_store.IconId = iconId or MOD_ICON
	if game:GetService("CoreGui"):FindFirstChild("ZenithGUI") then
		game:GetService("CoreGui"):FindFirstChild("ZenithGUI"):Destroy()
	end
	gui = Instance.new("ScreenGui")
	gui.Name = "ZenithGUI"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	local targetParent
	if typeof(gethui) == "function" then
		targetParent = gethui()
	else
		local success, coreGui = pcall(game.GetService, game, "CoreGui")
		targetParent = success and coreGui or lp:WaitForChild("PlayerGui")
	end
	gui.Parent = targetParent

	local wmFrame = Instance.new("Frame")
	wmFrame.Name = "ZenithWatermark"
	wmFrame.AnchorPoint = Vector2.new(0.5, 0)
	wmFrame.Position = UDim2.new(0.5, 0, 0, -100)
	wmFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	wmFrame.BorderSizePixel = 0
	wmFrame.AutomaticSize = Enum.AutomaticSize.XY
	wmFrame.Visible = false
	wmFrame.Parent = gui

	main = Instance.new("CanvasGroup")
	main.Size = UDim2.new(0, 680, 0, 480)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = gui
	registerRecolor(main, "BackgroundColor3", "bg")
	registerTransparency(main, 0)
	rnd(main, 12)

	bgImage = Instance.new("ImageLabel")
	bgImage.Name = "ThemeBGImage"
	bgImage.Size = UDim2.new(1, 0, 1, 0)
	bgImage.BackgroundTransparency = 1
	bgImage.ScaleType = Enum.ScaleType.Crop
	bgImage.Image = ""
	bgImage.ImageTransparency = 1
	bgImage.Visible = false
	bgImage.ZIndex = 0
	bgImage.Parent = main

	mainScale = Instance.new("UIScale")
	mainScale.Scale = 1
	mainScale.Parent = main

	local resizeHandle = Instance.new("ImageButton")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.Size = UDim2.new(0, 14, 0, 14)
	resizeHandle.Position = UDim2.new(1, -14, 1, -14)
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.Image = "rbxassetid://9748425718"
	resizeHandle.ImageColor3 = Color3.fromRGB(150, 150, 150)
	resizeHandle.ImageTransparency = 0.5
	resizeHandle.ZIndex = 10
	resizeHandle.Parent = main

	local rDragging = false
	local rDragStart, rStartSize
	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			rDragging = true
			rDragStart = input.Position
			rStartSize = main.Size
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					rDragging = false
				end
			end)
		end
	end)

	regConn(UIS.InputChanged:Connect(function(input)
		if rDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - rDragStart
			local newW = math.clamp(rStartSize.X.Offset + delta.X, 480, 950)
			local newH = math.clamp(rStartSize.Y.Offset + delta.Y, 350, 700)
			main.Size = UDim2.new(0, newW, 0, newH)
		end
	end))

	local sidebarFrame = Instance.new("Frame")
	sidebarFrame.Name = "Sidebar"
	sidebarFrame.Size = UDim2.new(0, 180, 1, 0)
	sidebarFrame.BorderSizePixel = 0
	sidebarFrame.Parent = main
	registerRecolor(sidebarFrame, "BackgroundColor3", "topbar")
	registerTransparency(sidebarFrame, 0.05)

	local logoIcon = Instance.new("ImageLabel")
	logoIcon.Size = UDim2.new(0, 24, 0, 24)
	logoIcon.Position = UDim2.new(0, 14, 0, 14)
	logoIcon.BackgroundTransparency = 1
	logoIcon.Image = _qkaspq_store.IconId
	logoIcon.ScaleType = Enum.ScaleType.Fit
	logoIcon.Parent = sidebarFrame
	registerRecolor(logoIcon, "ImageColor3", "ac")

	local mainTitle = Instance.new("TextLabel")
	mainTitle.Size = UDim2.new(1, -54, 0, 14)
	mainTitle.Position = UDim2.new(0, 46, 0, 12)
	mainTitle.BackgroundTransparency = 1
	mainTitle.Text = _qkaspq_store.TitleText
	mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainTitle.TextSize = 12
	mainTitle.Font = Enum.Font.MontserratBold
	mainTitle.TextXAlignment = Enum.TextXAlignment.Left
	mainTitle.Parent = sidebarFrame

	local mainSubtitle = Instance.new("TextLabel")
	mainSubtitle.Size = UDim2.new(1, -54, 0, 10)
	mainSubtitle.Position = UDim2.new(0, 46, 0, 25)
	mainSubtitle.BackgroundTransparency = 1
	mainSubtitle.Text = _qkaspq_store.SubtitleText
	mainSubtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	mainSubtitle.TextSize = 9
	mainSubtitle.Font = Enum.Font.MontserratBold
	mainSubtitle.TextXAlignment = Enum.TextXAlignment.Left
	mainSubtitle.Parent = sidebarFrame
	registerRecolor(mainSubtitle, "TextColor3", "ac2")

	local sidebarSep = Instance.new("Frame")
	sidebarSep.Size = UDim2.new(1, -28, 0, 1)
	sidebarSep.Position = UDim2.new(0, 14, 0, 48)
	sidebarSep.BorderSizePixel = 0
	sidebarSep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarSep.BackgroundTransparency = 0.9
	sidebarSep.Parent = sidebarFrame
	rnd(sidebarSep, 1)

	local tabScroll = Instance.new("ScrollingFrame")
	tabScroll.Size = UDim2.new(1, 0, 1, -135)
	tabScroll.Position = UDim2.new(0, 0, 0, 54)
	tabScroll.BackgroundTransparency = 1
	tabScroll.BorderSizePixel = 0
	tabScroll.ScrollBarThickness = 0
	tabScroll.Parent = sidebarFrame

	local tabListLay = Instance.new("UIListLayout")
	tabListLay.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLay.Padding = UDim.new(0, 4)
	tabListLay.Parent = tabScroll
	pad(tabScroll, 0, 0, 12, 12)

	profFrame = Instance.new("Frame")
	profFrame.Size = UDim2.new(1, -24, 0, 65)
	profFrame.Position = UDim2.new(0, 12, 1, -77)
	profFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	profFrame.BorderSizePixel = 0
	profFrame.Visible = false
	profFrame.Parent = sidebarFrame
	registerRecolor(profFrame, "BackgroundColor3", "field")
	registerTransparency(profFrame, 0.1)
	rnd(profFrame, 6)
	stk(profFrame, Color3.fromRGB(36, 36, 42))

	profAvatar = Instance.new("ImageLabel")
	profAvatar.Size = UDim2.new(0, 30, 0, 30)
	profAvatar.Position = UDim2.new(0, 10, 0, 8)
	profAvatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	profAvatar.BorderSizePixel = 0
	profAvatar.Parent = profFrame
	rnd(profAvatar, 15)
	pcall(function()
		profAvatar.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)

	profName = Instance.new("TextLabel")
	profName.Size = UDim2.new(1, -52, 0, 14)
	profName.Position = UDim2.new(0, 46, 0, 8)
	profName.BackgroundTransparency = 1
	profName.Text = (lp.DisplayName ~= "" and lp.DisplayName ~= lp.Name) and lp.DisplayName or lp.Name
	profName.TextColor3 = Color3.fromRGB(255, 255, 255)
	profName.TextSize = 11
	profName.Font = Enum.Font.MontserratBold
	profName.TextXAlignment = Enum.TextXAlignment.Left
	profName.TextTruncate = Enum.TextTruncate.AtEnd
	profName.Parent = profFrame

	profSub = Instance.new("TextLabel")
	profSub.Size = UDim2.new(1, -52, 0, 11)
	profSub.Position = UDim2.new(0, 46, 0, 21)
	profSub.BackgroundTransparency = 1
	profSub.Text = "Premium User"
	profSub.TextColor3 = Color3.fromRGB(150, 150, 150)
	profSub.TextSize = 9
	profSub.Font = Enum.Font.MontserratBold
	profSub.TextXAlignment = Enum.TextXAlignment.Left
	profSub.Parent = profFrame
	registerRecolor(profSub, "TextColor3", "ac2")

	local sessionText = Instance.new("TextLabel")
	sessionText.Size = UDim2.new(1, -20, 0, 12)
	sessionText.Position = UDim2.new(0, 10, 0, 43)
	sessionText.BackgroundTransparency = 1
	sessionText.Text = "Session 00:00 — 60 FPS"
	sessionText.TextColor3 = Color3.fromRGB(110, 110, 120)
	sessionText.TextSize = 9
	sessionText.Font = Enum.Font.MontserratBold
	sessionText.TextXAlignment = Enum.TextXAlignment.Left
	sessionText.Parent = profFrame

	local startTime = os.clock()
	local frameCount = 0
	local lastUpdate = os.clock()
	local fpsVal = 60
	regConn(game:GetService("RunService").RenderStepped:Connect(function()
		frameCount = frameCount + 1
		local now = os.clock()
		if now - lastUpdate >= 0.5 then
			fpsVal = math.floor(frameCount / (now - lastUpdate))
			frameCount = 0
			lastUpdate = now
		end
		local duration = os.clock() - startTime
		local mins = math.floor(duration / 60)
		local secs = math.floor(duration % 60)
		sessionText.Text = string.format("Session %02d:%02d — %d FPS", mins, secs, fpsVal)
	end))

	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -180, 1, 0)
	contentArea.Position = UDim2.new(0, 180, 0, 0)
	contentArea.BorderSizePixel = 0
	contentArea.Parent = main
	registerRecolor(contentArea, "BackgroundColor3", "bg")
	registerTransparency(contentArea, 0)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.Size = UDim2.new(1, 0, 0, 48)
	topbar.BackgroundTransparency = 1
	topbar.BorderSizePixel = 0
	topbar.Parent = contentArea

	local activeTabTitle = Instance.new("TextLabel")
	activeTabTitle.Size = UDim2.new(0, 200, 1, 0)
	activeTabTitle.Position = UDim2.new(0, 16, 0, 0)
	activeTabTitle.BackgroundTransparency = 1
	activeTabTitle.Text = "Combat"
	activeTabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	activeTabTitle.TextSize = 14
	activeTabTitle.Font = Enum.Font.MontserratBold
	activeTabTitle.TextXAlignment = Enum.TextXAlignment.Left
	activeTabTitle.Parent = topbar

	local searchFrame = Instance.new("Frame")
	searchFrame.Size = UDim2.new(0, 180, 0, 24)
	searchFrame.Position = UDim2.new(1, -240, 0.5, -12)
	searchFrame.BorderSizePixel = 0
	searchFrame.Parent = topbar
	rnd(searchFrame, 5)
	registerRecolor(searchFrame, "BackgroundColor3", "field")

	local searchIcon = Instance.new("ImageLabel")
	searchIcon.Size = UDim2.new(0, 12, 0, 12)
	searchIcon.Position = UDim2.new(0, 6, 0.5, -6)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Image = "rbxassetid://112780490255100"
	searchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
	searchIcon.ScaleType = Enum.ScaleType.Fit
	searchIcon.Parent = searchFrame

	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, -26, 1, 0)
	searchBox.Position = UDim2.new(0, 22, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.Text = ""
	searchBox.PlaceholderText = "Search..."
	searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	searchBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
	searchBox.TextSize = 11
	searchBox.Font = Enum.Font.MontserratBold
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.Parent = searchFrame

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -40, 0.5, -12)
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	closeBtn.TextSize = 10
	closeBtn.Font = Enum.Font.MontserratBold
	closeBtn.Parent = topbar
	rnd(closeBtn, 5)
	registerRecolor(closeBtn, "BackgroundColor3", "field")


	closeBtn.MouseButton1Click:Connect(function()
		_qkaspq_store.Open = false
		tw(mainScale, {Scale = 0.88}, 0.25)
		tw(main, {GroupTransparency = 1}, 0.25)
		task.delay(0.25, function()
			if not _qkaspq_store.Open then
				main.Visible = false
			end
		end)
	end)

	local topbarSep = Instance.new("Frame")
	topbarSep.Size = UDim2.new(1, -32, 0, 1)
	topbarSep.Position = UDim2.new(0, 16, 0, 47)
	topbarSep.BorderSizePixel = 0
	topbarSep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topbarSep.BackgroundTransparency = 0.9
	topbarSep.Parent = topbar
	rnd(topbarSep, 1)

	local dragging, dragStart, startPos
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	regConn(UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end))

	columnsGroup = Instance.new("CanvasGroup")
	columnsGroup.Size = UDim2.new(1, 0, 1, -54)
	columnsGroup.Position = UDim2.new(0, 0, 0, 50)
	columnsGroup.BackgroundTransparency = 1
	columnsGroup.BorderSizePixel = 0
	columnsGroup.Parent = contentArea

	colScroll = Instance.new("ScrollingFrame")
	colScroll.Size = UDim2.new(1, 0, 1, 0)
	colScroll.BackgroundTransparency = 1
	colScroll.BorderSizePixel = 0
	colScroll.ScrollBarThickness = 0
	colScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	colScroll.Parent = columnsGroup

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local activeTabIdx = _qkaspq_store.ActiveTab or 1
		local wasFocused = searchBox:IsFocused()
		pcall(function()
			loadTab(activeTabIdx, searchBox.Text)
		end)
		if wasFocused then
			task.spawn(function()
				searchBox:CaptureFocus()
			end)
		end
	end)

	tooltip = Instance.new("CanvasGroup")
	tooltip.Name = "ZenithTooltip"
	tooltip.AnchorPoint = Vector2.new(0.5, 0)
	tooltip.BackgroundColor3 = cl.field
	tooltip.BorderSizePixel = 0
	tooltip.AutomaticSize = Enum.AutomaticSize.XY
	tooltip.Visible = false
	tooltip.Parent = gui
	registerRecolor(tooltip, "BackgroundColor3", "field")
	registerTransparency(tooltip, 0.1)
	rnd(tooltip, 6)
	stk(tooltip, Color3.fromRGB(36, 36, 42))
	pad(tooltip, 6, 6, 10, 10)

	local ttLay = Instance.new("UIListLayout")
	ttLay.FillDirection = Enum.FillDirection.Horizontal
	ttLay.VerticalAlignment = Enum.VerticalAlignment.Center
	ttLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
	ttLay.Padding = UDim.new(0, 8)
	ttLay.Parent = tooltip

	ttIcon = Instance.new("ImageLabel")
	ttIcon.Size = UDim2.new(0, 14, 0, 14)
	ttIcon.BackgroundTransparency = 1
	ttIcon.Image = MOD_ICON
	ttIcon.ImageColor3 = ac
	ttIcon.ScaleType = Enum.ScaleType.Fit
	ttIcon.Parent = tooltip

	ttText = Instance.new("TextLabel")
	ttText.BackgroundTransparency = 1
	ttText.TextColor3 = Color3.fromRGB(200, 200, 205)
	ttText.TextSize = 11
	ttText.Font = Enum.Font.MontserratBold
	ttText.Size = UDim2.new(0, 0, 0, 14)
	ttText.AutomaticSize = Enum.AutomaticSize.X
	ttText.Parent = tooltip

	local function updateTooltipPos()
		tooltip.Position = UDim2.new(
			main.Position.X.Scale,
			main.Position.X.Offset,
			main.Position.Y.Scale,
			main.Position.Y.Offset + (250 * mainScale.Scale) + 12
		)
	end
	main:GetPropertyChangedSignal("Position"):Connect(updateTooltipPos)
	tooltip:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateTooltipPos)
	mainScale:GetPropertyChangedSignal("Scale"):Connect(updateTooltipPos)

	bindsWin = Instance.new("CanvasGroup")
	bindsWin.Size = UDim2.new(0, 220, 0, 40)
	bindsWin.AnchorPoint = Vector2.new(0.5, 0.5)
	bindsWin.Position = UDim2.new(0.85, 0, 0.35, 0)
	bindsWin.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	bindsWin.BorderSizePixel = 0
	bindsWin.ClipsDescendants = true
	bindsWin.Visible = false
	bindsWin.Parent = gui
	rnd(bindsWin, 12)
	stk(bindsWin, Color3.fromRGB(36, 36, 42))
	registerRecolor(bindsWin, "BackgroundColor3", "bg")

	bindsScale = Instance.new("UIScale")
	bindsScale.Scale = 1
	bindsScale.Parent = bindsWin

	local bindsTopbar = Instance.new("Frame")
	bindsTopbar.Size = UDim2.new(1, 0, 0, 36)
	bindsTopbar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
	bindsTopbar.BorderSizePixel = 0
	bindsTopbar.Parent = bindsWin
	registerRecolor(bindsTopbar, "BackgroundColor3", "topbar")

	bindsTopSep = Instance.new("Frame")
	bindsTopSep.Size = UDim2.new(1, 0, 0, 1)
	bindsTopSep.Position = UDim2.new(0, 0, 1, -1)
	bindsTopSep.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
	bindsTopSep.BorderSizePixel = 0
	bindsTopSep.Parent = bindsTopbar

	local bindsTitleIcon = Instance.new("ImageLabel")
	bindsTitleIcon.Size = UDim2.new(0, 14, 0, 14)
	bindsTitleIcon.Position = UDim2.new(0, 12, 0.5, -7)
	bindsTitleIcon.BackgroundTransparency = 1
	bindsTitleIcon.Image = BIND_ICON
	bindsTitleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	bindsTitleIcon.ScaleType = Enum.ScaleType.Fit
	bindsTitleIcon.Parent = bindsTopbar

	local bindsTitle = Instance.new("TextLabel")
	bindsTitle.Size = UDim2.new(1, -40, 1, 0)
	bindsTitle.Position = UDim2.new(0, 32, 0, 0)
	bindsTitle.BackgroundTransparency = 1
	bindsTitle.Text = "Binds"
	bindsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	bindsTitle.TextSize = 12
	bindsTitle.Font = Enum.Font.MontserratBold
	bindsTitle.TextXAlignment = Enum.TextXAlignment.Left
	bindsTitle.Parent = bindsTopbar

	local bDragging, bDragStart, bStartPos
	bindsTopbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			bDragging = true
			bDragStart = input.Position
			bStartPos = bindsWin.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					bDragging = false
				end
			end)
		end
	end)
	regConn(UIS.InputChanged:Connect(function(input)
		if bDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - bDragStart
			bindsWin.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + d.X, bStartPos.Y.Scale, bStartPos.Y.Offset + d.Y)
		end
	end))

	bindsScroll = Instance.new("ScrollingFrame")
	bindsScroll.Size = UDim2.new(1, 0, 1, -37)
	bindsScroll.Position = UDim2.new(0, 0, 0, 37)
	bindsScroll.BackgroundTransparency = 1
	bindsScroll.BorderSizePixel = 0
	bindsScroll.ScrollBarThickness = 0
	bindsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	bindsScroll.Parent = bindsWin

	bindsListLay = Instance.new("UIListLayout")
	bindsListLay.SortOrder = Enum.SortOrder.LayoutOrder
	bindsListLay.Padding = UDim.new(0, 6)
	bindsListLay.Parent = bindsScroll
	pad(bindsScroll, 8, 8, 8, 8)

	notifyContainer = Instance.new("Frame")
	notifyContainer.Name = "ZenithNotifications"
	notifyContainer.Size = UDim2.new(0, 280, 1, -100)
	notifyContainer.Position = UDim2.new(1, -20, 1, -80)
	notifyContainer.AnchorPoint = Vector2.new(1, 1)
	notifyContainer.BackgroundTransparency = 1
	notifyContainer.BorderSizePixel = 0
	notifyContainer.Parent = gui

	notifyListLay = Instance.new("UIListLayout")
	notifyListLay.FillDirection = Enum.FillDirection.Vertical
	notifyListLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifyListLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notifyListLay.Padding = UDim.new(0, 8)
	notifyListLay.Parent = notifyContainer

	local settingsTab, settingsIdx
	for idx, tab in ipairs(self.tabDefs) do
		if tab.id == "Settings" then
			settingsTab = tab
			settingsIdx = idx
			break
		end
	end
	if settingsTab then
		table.remove(self.tabDefs, settingsIdx)
		table.insert(self.tabDefs, settingsTab)
	end

	local function showTooltip(descText, modActive)
		ttIcon.ImageColor3 = modActive and ac or cl.dim
		ttText.Text = descText or "Описание отсутствует."
		if currentTtTween then
			currentTtTween:Cancel()
		end
		tooltip.Visible = true
		tooltip.GroupTransparency = 1
		currentTtTween = TS:Create(tooltip, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			GroupTransparency = currentTransparencyValue
		})
		currentTtTween:Play()
	end

	local function hideTooltip()
		if currentTtTween then
			currentTtTween:Cancel()
		end
		currentTtTween = TS:Create(tooltip, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			GroupTransparency = 1
		})
		currentTtTween:Play()
		task.delay(0.15, function()
			if tooltip.GroupTransparency == 1 then
				tooltip.Visible = false
			end
		end)
	end

	self.tabBtns = {}
	self.tabBtns = {}
	for i, tab in ipairs(self.tabDefs) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 36)
		btn.BackgroundTransparency = 1
		btn.Text = ""
		btn.LayoutOrder = i
		btn.Parent = tabScroll
		rnd(btn, 6)

		local btnSc = Instance.new("UIScale")
		btnSc.Scale = 1
		btnSc.Parent = btn

		local contentFrame = Instance.new("Frame")
		contentFrame.Size = UDim2.new(1, 0, 1, 0)
		contentFrame.BackgroundTransparency = 1
		contentFrame.Parent = btn

		local btnLay = Instance.new("UIListLayout")
		btnLay.FillDirection = Enum.FillDirection.Horizontal
		btnLay.VerticalAlignment = Enum.VerticalAlignment.Center
		btnLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
		btnLay.Padding = UDim.new(0, 10)
		btnLay.Parent = contentFrame
		pad(contentFrame, 0, 0, 10, 10)

		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 16, 0, 16)
		icon.BackgroundTransparency = 1
		icon.Image = tab.icon
		icon.ImageColor3 = cl.dim
		icon.ScaleType = Enum.ScaleType.Fit
		icon.Parent = contentFrame

		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Text = self.tabNamesRu[tab.id] or tab.id
		lbl.TextColor3 = cl.dim
		lbl.TextSize = 12
		lbl.Font = Enum.Font.MontserratBold
		lbl.Size = UDim2.new(1, -26, 0, 14)
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = contentFrame

		self.tabBtns[i] = {btn = btn, icon = icon, lbl = lbl, sc = btnSc}

		btn.MouseEnter:Connect(function()
			if _qkaspq_store.ActiveTab ~= i then
				tw(btn, {BackgroundTransparency = 0.95, BackgroundColor3 = ac}, 0.12)
				tw(icon, {ImageColor3 = ac}, 0.12)
				tw(lbl, {TextColor3 = ac}, 0.12)
			end
		end)
		btn.MouseLeave:Connect(function()
			if _qkaspq_store.ActiveTab ~= i then
				tw(btn, {BackgroundTransparency = 1}, 0.12)
				tw(icon, {ImageColor3 = cl.dim}, 0.12)
				tw(lbl, {TextColor3 = cl.dim}, 0.12)
			end
		end)
	end

	local function recreateColumns()
		for k, _ in pairs(self.activeCards) do
			if string.match(k, "_main$") then
				self.activeCards[k] = nil
			end
		end
		for _, child in pairs(colScroll:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		self.columns = {}
		for i = 1, 2 do
			local col = Instance.new("Frame")
			col.Size = UDim2.new(0.5, -12, 1, 0)
			col.Position = UDim2.new(i == 1 and 0 or 0.5, i == 1 and 8 or 4, 0, 0)
			col.BackgroundTransparency = 1
			col.Parent = colScroll
			local lay = Instance.new("UIListLayout")
			lay.SortOrder = Enum.SortOrder.LayoutOrder
			lay.Padding = UDim.new(0, 8)
			lay.Parent = col
			pad(col, 8, 8, 0, 0)
			self.columns[i] = col
		end
	end

	local function updateScrollCanvasSize()
		local maxH = 0
		for _, col in ipairs(self.columns or {}) do
			local h = 16
			for _, ch in pairs(col:GetChildren()) do
				if ch:IsA("Frame") then
					h = h + ch.Size.Y.Offset + 8
				end
			end
			if h > maxH then
				maxH = h
			end
		end
		colScroll.CanvasSize = UDim2.new(0, 0, 0, maxH)
	end


	local function triggerBindRefresh()
		if buildBindsList then
			pcall(buildBindsList)
		end
		for _, refresh in pairs(self.activeCards) do
			pcall(refresh)
		end
		if updateArrayList then
			pcall(updateArrayList)
		end
	end
	local NOTIFY_SOUNDS = {
		["Default"] = "rbxassetid://103421304020039",
		["Telegram"] = "rbxassetid://91271439961236",
		["iPhone"] = "rbxassetid://93707490272210",
		["Misc"] = "rbxassetid://225320558",
		["Windows 11"] = "rbxassetid://82130248702656",
	}
	getNotifySettings = function()
		local notifyMod
		for _, mod in ipairs(_qkaspq_store.Modules["Settings"] or {}) do
			if mod.name == "Notify" then
				notifyMod = mod
				break
			end
		end
		if not notifyMod then
			return true, 3, "rbxassetid://103421304020039", 0.5, "Right"
		end
		local enabled = notifyMod.on
		local duration = 3
		local soundId = "rbxassetid://103421304020039"
		local volume = 0.5
		local location = "Right"
		for _, opt in ipairs(notifyMod.opts or {}) do
			if opt.label == "Duration" or opt.label == "Длительность" then
				duration = opt.value
			elseif opt.label == "Notification Sound" or opt.label == "Звук Уведомления" or opt.label == "Sound" or opt.label == "Звук" then
				soundId = NOTIFY_SOUNDS[opt.value] or "rbxassetid://103421304020039"
			elseif opt.label == "Volume" or opt.label == "Громкость" then
				volume = opt.value / 100
			elseif opt.label == "Location" or opt.label == "Расположение" then
				location = opt.value
			end
		end
		return enabled, duration, soundId, volume, location
	end
	function self:Notify(text, icon)
		local enabled
		local duration
		local soundId
		local volume
		local location
		enabled, duration, soundId, volume, location = getNotifySettings()
		if not enabled then
			return
		end
		task.spawn(function()
			pcall(function()
				local s = Instance.new("Sound")
				s.SoundId = soundId
				s.Volume = volume
				s.Parent = game:GetService("SoundService")
				s:Play()
				s.Ended:Connect(function()
					s:Destroy()
				end)
			end)
			local parent = notifyContainer
			local isCursor = (location == "Курсор")
			if isCursor then
				local mousePos = UIS:GetMouseLocation()
				local cursorFrame = Instance.new("Frame")
				cursorFrame.Name = "ZenithCursorNotify"
				cursorFrame.Size = UDim2.new(0, 280, 0, 36)
				cursorFrame.Position = UDim2.new(0, mousePos.X + 12, 0, mousePos.Y + 20)
				cursorFrame.Parent = gui
				parent = cursorFrame
				local conn
				conn = regConn(game:GetService("RunService").RenderStepped:Connect(function()
					if cursorFrame and cursorFrame.Parent then
						local mPos = UIS:GetMouseLocation()
						local curPos = cursorFrame.Position
						local targetX = mPos.X + 12
						local targetY = mPos.Y + 20
						local newX = curPos.X.Offset + (targetX - curPos.X.Offset) * 0.15
						local newY = curPos.Y.Offset + (targetY - curPos.Y.Offset) * 0.15
						cursorFrame.Position = UDim2.new(0, newX, 0, newY)
					else
						if conn then
							conn:Disconnect()
						end
					end
				end))
				task.spawn(function()
					task.wait(duration + 0.5)
					if conn then
						conn:Disconnect()
					end
					cursorFrame:Destroy()
				end)
			else
				if location == "Right" or location == "Справа" then
					notifyContainer.Position = UDim2.new(1, -20, 1, -80)
					notifyContainer.AnchorPoint = Vector2.new(1, 1)
					notifyListLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
					notifyListLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
				elseif location == "Left" or location == "Слева" then
					notifyContainer.Position = UDim2.new(0, 20, 1, -80)
					notifyContainer.AnchorPoint = Vector2.new(0, 1)
					notifyListLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
					notifyListLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
				elseif location == "Center" or location == "Центр" then
					notifyContainer.Position = UDim2.new(0.5, 0, 0.65, 0)
					notifyContainer.AnchorPoint = Vector2.new(0.5, 0.5)
					notifyListLay.VerticalAlignment = Enum.VerticalAlignment.Center
					notifyListLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
				end
			end
			local notif = Instance.new("CanvasGroup")
			notif.Name = "Notify"
			if isCursor then
				notif.Size = UDim2.new(1, 0, 1, 0)
			else
				notif.Size = UDim2.new(1, 0, 0, 36)
			end
			notif.BackgroundColor3 = cl.bg
			notif.BorderSizePixel = 0
			notif.GroupTransparency = 1
			notif.Parent = parent
			registerRecolor(notif, "BackgroundColor3", "bg")
			registerTransparency(notif, 0)
			rnd(notif, 6)
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(36, 36, 42)
			stroke.Thickness = 1
			stroke.Transparency = 1
			stroke.Parent = notif
			pad(notif, 6, 6, 8, 8)
			local notifLay = Instance.new("UIListLayout")
			notifLay.FillDirection = Enum.FillDirection.Horizontal
			notifLay.VerticalAlignment = Enum.VerticalAlignment.Center
			notifLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
			notifLay.Padding = UDim.new(0, 8)
			notifLay.Parent = notif

			local notifIcon = Instance.new("ImageLabel")
			notifIcon.Size = UDim2.new(0, 14, 0, 14)
			notifIcon.BackgroundTransparency = 1
			notifIcon.Image = icon or MOD_ICON
			local lowerText = string.lower(text)
			if lowerText:find("enabled") or lowerText:find("включен") or lowerText:find("успешно") or lowerText:find("пройден") then
				notifIcon.ImageColor3 = Color3.fromRGB(80, 220, 100)
			elseif lowerText:find("disabled") or lowerText:find("выключен") or lowerText:find("ошибка") then
				notifIcon.ImageColor3 = Color3.fromRGB(240, 80, 80)
			else
				notifIcon.ImageColor3 = ac
			end
			notifIcon.ScaleType = Enum.ScaleType.Fit
			notifIcon.Parent = notif

			local notifText = Instance.new("TextLabel")
			notifText.BackgroundTransparency = 1
			notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
			notifText.TextSize = 11
			notifText.Font = Enum.Font.MontserratBold
			notifText.Size = UDim2.new(1, -22, 1, 0)
			notifText.TextXAlignment = Enum.TextXAlignment.Left
			notifText.RichText = true
			notifText.Text = text
			notifText.Parent = notif
			tw(notif, {GroupTransparency = 0}, 0.22)
			tw(stroke, {Transparency = 0.35}, 0.22)
			task.wait(duration)
			tw(notif, {GroupTransparency = 1}, 0.22)
			tw(stroke, {Transparency = 1}, 0.22)
			task.wait(0.22)
			notif:Destroy()
		end)
	end
	local musicGuiInstance
	local musicSound
	local currentTrackIdx = 1
	Playlist = {
		{name = "Parry Gripp - Raining Tacos", id = "rbxassetid://142376088"},
		{name = "#phonkmusic", id = "rbxassetid://139777823649977"},
		{name = "Relaxed Scene", id = "rbxassetid://1848354536"},
		{name = "The West's Awake", id = "rbxassetid://140729164726242"},
	}
	local function formatTime(seconds)
		if not seconds or seconds ~= seconds then
			return "0:00"
		end
		local mins = math.floor(seconds / 60)
		local secs = math.floor(seconds % 60)
		return string.format("%d:%02d", mins, secs)
	end
	updateMusicGui = function()
		local musicMod
		for _, mod in ipairs(_qkaspq_store.Modules["Settings"] or {}) do
			if mod.name == "Music GUI" then
				musicMod = mod
				break
			end
		end
		if not musicMod then
			return
		end
		if not musicMod.on then
			if musicGuiInstance then
				local guiToDestroy = musicGuiInstance
				musicGuiInstance = nil
				local scale = guiToDestroy:FindFirstChild("UIScale")
				if scale then
					tw(scale, {Scale = 0.8}, 0.22)
				end
				local stroke = guiToDestroy:FindFirstChildOfClass("UIStroke")
				if stroke then
					tw(stroke, {Transparency = 1}, 0.22)
				end
				tw(guiToDestroy, {GroupTransparency = 1}, 0.22)
				task.delay(0.23, function()
					guiToDestroy:Destroy()
				end)
			end
			if musicSound then
				local sndToDestroy = musicSound
				musicSound = nil
				sndToDestroy:Stop()
				sndToDestroy:Destroy()
			end
			return
		end
		if not musicGuiInstance then
			musicGuiInstance = Instance.new("CanvasGroup")
			musicGuiInstance.Name = "ZenithMusicGUI"
			musicGuiInstance.AnchorPoint = Vector2.new(0.5, 0)
			musicGuiInstance.Position = UDim2.new(0.5, 0, 0, 70)
			musicGuiInstance.Size = UDim2.new(0, 310, 0, 52)
			musicGuiInstance.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
			musicGuiInstance.BorderSizePixel = 0
			musicGuiInstance.GroupTransparency = 1
			musicGuiInstance.Parent = gui
			rnd(musicGuiInstance, 8)
			stk(musicGuiInstance, Color3.fromRGB(36, 36, 42))
			registerRecolor(musicGuiInstance, "BackgroundColor3", "bg")
			registerTransparency(musicGuiInstance, 0)
			pad(musicGuiInstance, 8, 8, 10, 10)
			local mainScale = Instance.new("UIScale")
			mainScale.Scale = 0.8
			mainScale.Parent = musicGuiInstance

			local mainLay = Instance.new("UIListLayout")
			mainLay.FillDirection = Enum.FillDirection.Horizontal
			mainLay.VerticalAlignment = Enum.VerticalAlignment.Center
			mainLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
			mainLay.Padding = UDim.new(0, 10)
			mainLay.Parent = musicGuiInstance

			local iconFrame = Instance.new("Frame")
			iconFrame.Size = UDim2.new(0, 32, 0, 32)
			iconFrame.BackgroundColor3 = cl.field
			iconFrame.BorderSizePixel = 0
			iconFrame.Parent = musicGuiInstance
			rnd(iconFrame, 5)
			stk(iconFrame, Color3.fromRGB(36, 36, 44), 1)
			local musicIcon = Instance.new("ImageLabel")
			musicIcon.Size = UDim2.new(0, 18, 0, 18)
			musicIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			musicIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
			musicIcon.BackgroundTransparency = 1
			musicIcon.Image = "rbxassetid://17387359605"
			musicIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			musicIcon.ScaleType = Enum.ScaleType.Fit
			musicIcon.Parent = iconFrame
			local midFrame = Instance.new("Frame")
			midFrame.Size = UDim2.new(0, 170, 0, 36)
			midFrame.BackgroundTransparency = 1
			midFrame.Parent = musicGuiInstance
			local midLay = Instance.new("UIListLayout")
			midLay.FillDirection = Enum.FillDirection.Vertical
			midLay.VerticalAlignment = Enum.VerticalAlignment.Center
			midLay.Padding = UDim.new(0, 4)
			midLay.Parent = midFrame
			local trackTitle = Instance.new("TextLabel")
			trackTitle.Name = "TrackTitle"
			trackTitle.Size = UDim2.new(1, 0, 0, 14)
			trackTitle.BackgroundTransparency = 1
			trackTitle.Text = Playlist[currentTrackIdx].name
			trackTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			trackTitle.TextSize = 10
			trackTitle.Font = Enum.Font.MontserratBold
			trackTitle.TextXAlignment = Enum.TextXAlignment.Left
			trackTitle.TextTruncate = Enum.TextTruncate.AtEnd
			trackTitle.Parent = midFrame
			local seekContainer = Instance.new("Frame")
			seekContainer.Size = UDim2.new(1, 0, 0, 12)
			seekContainer.BackgroundTransparency = 1
			seekContainer.Parent = midFrame
			local seekLay = Instance.new("UIListLayout")
			seekLay.FillDirection = Enum.FillDirection.Horizontal
			seekLay.VerticalAlignment = Enum.VerticalAlignment.Center
			seekLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
			seekLay.Padding = UDim.new(0, 6)
			seekLay.Parent = seekContainer
			local trackBar = Instance.new("Frame")
			trackBar.Size = UDim2.new(1, -70, 0, 4)
			trackBar.BackgroundColor3 = cl.field
			trackBar.BorderSizePixel = 0
			trackBar.Parent = seekContainer
			rnd(trackBar, 2)
			local trackFill = Instance.new("Frame")
			trackFill.Size = UDim2.new(0, 0, 1, 0)
			trackFill.BackgroundColor3 = ac
			trackFill.BorderSizePixel = 0
			trackFill.Parent = trackBar
			registerRecolor(trackFill, "BackgroundColor3", "ac")
			registerRecolor(trackBar, "BackgroundColor3", "field")
			rnd(trackFill, 2)
			local timeText = Instance.new("TextLabel")
			timeText.Size = UDim2.new(0, 64, 0, 12)
			timeText.BackgroundTransparency = 1
			timeText.Text = "0:00 / 0:00"
			timeText.TextColor3 = Color3.fromRGB(150, 150, 160)
			timeText.TextSize = 8
			timeText.Font = Enum.Font.MontserratBold
			timeText.TextXAlignment = Enum.TextXAlignment.Right
			timeText.Parent = seekContainer
			local ctrlFrame = Instance.new("Frame")
			ctrlFrame.Size = UDim2.new(0, 70, 1, 0)
			ctrlFrame.BackgroundTransparency = 1
			ctrlFrame.Parent = musicGuiInstance
			local ctrlLay = Instance.new("UIListLayout")
			ctrlLay.FillDirection = Enum.FillDirection.Horizontal
			ctrlLay.VerticalAlignment = Enum.VerticalAlignment.Center
			ctrlLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ctrlLay.SortOrder = Enum.SortOrder.LayoutOrder
			ctrlLay.Padding = UDim.new(0, 6)
			ctrlLay.Parent = ctrlFrame
			local function createIconBtn(img, size, cb)
				local btn = Instance.new("ImageButton")
				btn.Size = UDim2.new(0, size, 0, size)
				btn.BackgroundTransparency = 1
				btn.Image = "rbxassetid://" .. img
				btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
				btn.ImageTransparency = 0.35
				btn.ScaleType = Enum.ScaleType.Fit
				btn.Parent = ctrlFrame
				local btnScale = Instance.new("UIScale")
				btnScale.Scale = 1
				btnScale.Parent = btn
				btn.MouseEnter:Connect(function()
					tw(btn, {ImageTransparency = 0}, 0.12)
					tw(btnScale, {Scale = 1.15}, 0.12)
				end)
				btn.MouseLeave:Connect(function()
					tw(btn, {ImageTransparency = 0.35}, 0.12)
					tw(btnScale, {Scale = 1}, 0.12)
				end)
				btn.MouseButton1Click:Connect(cb)
				return btn
			end
			if not musicSound then
				musicSound = Instance.new("Sound")
				musicSound.Volume = 0.5
				musicSound.Parent = game:GetService("SoundService")
			end
			local playBtn
			local function updatePlayState()
				if musicSound.IsPlaying then
					musicSound:Pause()
					playBtn.Image = "rbxassetid://127467405552658"
				else
					musicSound:Play()
					playBtn.Image = "rbxassetid://94079325461679"
				end
			end
			local function loadTrack(idx)
				currentTrackIdx = idx
				musicSound:Stop()
				musicSound.SoundId = Playlist[currentTrackIdx].id
				trackTitle.Text = Playlist[currentTrackIdx].name
				musicSound:Play()
				playBtn.Image = "rbxassetid://94079325461679"
			end
			local function prevTrack()
				local idx = currentTrackIdx - 1
				if idx < 1 then
					idx = #Playlist
				end
				loadTrack(idx)
			end
			local function nextTrack()
				local idx = currentTrackIdx + 1
				if idx > #Playlist then
					idx = 1
				end
				loadTrack(idx)
			end
			local prevBtn = createIconBtn(109754291227660, 12, prevTrack)
			prevBtn.LayoutOrder = 1
			playBtn = createIconBtn(127467405552658, 14, updatePlayState)
			playBtn.Name = "PlayBtn"
			playBtn.LayoutOrder = 2
			local nextBtn = createIconBtn(130872317323632, 12, nextTrack)
			nextBtn.LayoutOrder = 3
			musicSound.Ended:Connect(nextTrack)
			regConn(game:GetService("RunService").RenderStepped:Connect(function()
				if musicGuiInstance and musicSound then
					local cur = musicSound.TimePosition
					local len = musicSound.TimeLength
					local pct = len > 0 and (cur / len) or 0
					trackFill.Size = UDim2.new(pct, 0, 1, 0)
					timeText.Text = formatTime(cur) .. " / " .. formatTime(len)
				end
			end))
			local activeSeek = false
			local seekArea = Instance.new("TextButton")
			seekArea.Size = UDim2.new(1, 0, 0, 14)
			seekArea.Position = UDim2.new(0, 0, 0.5, -7)
			seekArea.BackgroundTransparency = 1
			seekArea.Text = ""
			seekArea.Parent = trackBar
			seekArea.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					activeSeek = true
					if musicSound.TimeLength > 0 then
						local relX = math.clamp((input.Position.X - trackBar.AbsolutePosition.X) / trackBar.AbsoluteSize.X, 0, 1)
						musicSound.TimePosition = relX * musicSound.TimeLength
						trackFill.Size = UDim2.new(relX, 0, 1, 0)
					end
				end
			end)
			seekArea.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					activeSeek = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if activeSeek and input.UserInputType == Enum.UserInputType.MouseMovement then
					if musicSound.TimeLength > 0 then
						local relX = math.clamp((input.Position.X - trackBar.AbsolutePosition.X) / trackBar.AbsoluteSize.X, 0, 1)
						musicSound.TimePosition = relX * musicSound.TimeLength
						trackFill.Size = UDim2.new(relX, 0, 1, 0)
					end
				end
			end)

			loadTrack(currentTrackIdx)
			musicSound:Pause()
			playBtn.Image = "rbxassetid://127467405552658"
			tw(musicGuiInstance, {GroupTransparency = 0}, 0.35)
			tw(mainScale, {Scale = 1}, 0.35)
		end
	end
	local arrayListContainer
	local arrayListListLay
	local activeArrayListFrames = {}
	updateArrayList = function()
		local arraylistMod
		for _, mod in ipairs(_qkaspq_store.Modules["Settings"] or {}) do
			if mod.name == "Arraylist" then
				arraylistMod = mod
				break
			end
		end
		if not arraylistMod then
			return
		end
		if not arraylistMod.on then
			if arrayListContainer then
				local containerToDestroy = arrayListContainer
				arrayListContainer = nil
				task.spawn(function()
					for _, item in pairs(activeArrayListFrames) do
						pcall(function()
							tw(item.frame, {GroupTransparency = 1}, 0.2)
							if item.scale then
								tw(item.scale, {Scale = 0.8}, 0.2)
							end
						end)
					end
					task.wait(0.2)
					containerToDestroy:Destroy()
				end)
			end
			activeArrayListFrames = {}
			return
		end
		if not arrayListContainer then
			arrayListContainer = Instance.new("Frame")
			arrayListContainer.Name = "ZenithArrayList"
			arrayListContainer.Size = UDim2.new(0, 200, 1, -100)
			arrayListContainer.BackgroundTransparency = 1
			arrayListContainer.BorderSizePixel = 0
			arrayListContainer.Parent = gui
			arrayListListLay = Instance.new("UIListLayout")
			arrayListListLay.FillDirection = Enum.FillDirection.Vertical
			arrayListListLay.VerticalAlignment = Enum.VerticalAlignment.Top
			arrayListListLay.SortOrder = Enum.SortOrder.LayoutOrder
			arrayListListLay.Padding = UDim.new(0, 4)
			arrayListListLay.Parent = arrayListContainer
		end
		local alignment = "Right"
		for _, opt in ipairs(arraylistMod.opts or {}) do
			if opt.label == "Location" or opt.label == "Расположение" then
				alignment = opt.value
			end
		end
		if alignment == "Left" or alignment == "Слева" then
			arrayListContainer.Position = UDim2.new(0, 20, 0, 20)
			arrayListContainer.AnchorPoint = Vector2.new(0, 0)
			arrayListListLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
		else
			arrayListContainer.Position = UDim2.new(1, -20, 0, 20)
			arrayListContainer.AnchorPoint = Vector2.new(1, 0)
			arrayListListLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
		end
		local activeList = {}
		for tabId, mods in pairs(_qkaspq_store.Modules) do
			for _, mod in ipairs(mods) do
				if mod.on and mod.name ~= "Arraylist" and mod.name ~= "Notify" and mod.name ~= "Music GUI" and mod.name ~= "Target Hud" then
					table.insert(activeList, mod)
				end
			end
		end
		table.sort(activeList, function(a, b)
			return #a.name > #b.name
		end)
		local currentActiveNames = {}
		for i, mod in ipairs(activeList) do
			currentActiveNames[mod.name] = i
		end
		for name, item in pairs(activeArrayListFrames) do
			if not currentActiveNames[name] then
				activeArrayListFrames[name] = nil
				task.spawn(function()
					local frame = item.frame
					local scale = frame:FindFirstChild("UIScale")
					tw(frame, {GroupTransparency = 1}, 0.2)
					if scale then
						tw(scale, {Scale = 0.6}, 0.2)
					end
					tw(frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
					task.wait(0.2)
					frame:Destroy()
				end)
			end
		end
		for i, mod in ipairs(activeList) do
			local cached = activeArrayListFrames[mod.name]
			if not cached then
				local frame = Instance.new("CanvasGroup")
				frame.Name = mod.name
				frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
				frame.BorderSizePixel = 0
				frame.GroupTransparency = 1
				frame.ClipsDescendants = true
				local scale = Instance.new("UIScale")
				scale.Scale = 0.8
				scale.Parent = frame
				rnd(frame, 6)
				stk(frame, Color3.fromRGB(36, 36, 42))
				local lbl = Instance.new("TextLabel")
				lbl.Name = "Label"
				lbl.BackgroundTransparency = 1
				lbl.Text = mod.name
				lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				lbl.Font = Enum.Font.MontserratBold
				lbl.TextSize = 12
				lbl.Parent = frame
				local accent = Instance.new("Frame")
				accent.Name = "Accent"
				accent.BackgroundColor3 = ac
				accent.BorderSizePixel = 0
				accent.Parent = frame
				local textW = game:GetService("TextService"):GetTextSize(mod.name, 12, Enum.Font.MontserratBold, Vector2.new(1000, 28)).X
				local width = textW + 30
				frame.Size = UDim2.new(0, width, 0, 0)
				frame.Parent = arrayListContainer
				activeArrayListFrames[mod.name] = {frame = frame, scale = scale, width = width}
				tw(frame, {Size = UDim2.new(0, width, 0, 28), GroupTransparency = 0}, 0.22)
				tw(scale, {Scale = 1}, 0.22)
			end
			local frameObj = activeArrayListFrames[mod.name]
			local frame = frameObj.frame
			frame.LayoutOrder = i
			local accent = frame:FindFirstChild("Accent")
			local lbl = frame:FindFirstChild("Label")
			if lbl and accent then
				accent.BackgroundColor3 = ac
				if alignment == "Слева" then
					accent.Position = UDim2.new(0, 0, 0, 0)
					accent.Size = UDim2.new(0, 4, 1, 0)
					lbl.Position = UDim2.new(0, 12, 0, 0)
					lbl.Size = UDim2.new(1, -16, 1, 0)
					lbl.TextXAlignment = Enum.TextXAlignment.Left
				else
					accent.Position = UDim2.new(1, -4, 0, 0)
					accent.Size = UDim2.new(0, 4, 1, 0)
					lbl.Position = UDim2.new(0, 10, 0, 0)
					lbl.Size = UDim2.new(1, -18, 1, 0)
					lbl.TextXAlignment = Enum.TextXAlignment.Left
				end
			end
		end
	end
	local targetHudInstance
	local targetHudScale
	if not targetHudInstance then
		targetHudInstance = Instance.new("CanvasGroup")
		targetHudInstance.Name = "ZenithTargetHUD"
		targetHudInstance.Size = UDim2.new(0, 220, 0, 56)
		targetHudInstance.Position = UDim2.new(0.5, 80, 0.5, 80)
		targetHudInstance.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		targetHudInstance.BorderSizePixel = 0
		targetHudInstance.GroupTransparency = 1
		targetHudInstance.Visible = false
		targetHudInstance.Parent = gui
		rnd(targetHudInstance, 16)
		stk(targetHudInstance, Color3.fromRGB(30, 30, 35), 1)
		pad(targetHudInstance, 8, 8, 10, 10)
		targetHudScale = Instance.new("UIScale")
		targetHudScale.Scale = 0.8
		targetHudScale.Parent = targetHudInstance
		local mainLay = Instance.new("UIListLayout")
		mainLay.FillDirection = Enum.FillDirection.Horizontal
		mainLay.VerticalAlignment = Enum.VerticalAlignment.Center
		mainLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
		mainLay.Padding = UDim.new(0, 10)
		mainLay.Parent = targetHudInstance
		local avatarFrame = Instance.new("Frame")
		avatarFrame.Name = "AvatarFrame"
		avatarFrame.Size = UDim2.new(0, 40, 0, 40)
		avatarFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
		avatarFrame.BorderSizePixel = 0
		avatarFrame.Parent = targetHudInstance
		rnd(avatarFrame, 20)
		stk(avatarFrame, Color3.fromRGB(36, 36, 44), 1)
		local avatarImg = Instance.new("ImageLabel")
		avatarImg.Name = "Avatar"
		avatarImg.Size = UDim2.new(1, -2, 1, -2)
		avatarImg.Position = UDim2.new(0, 1, 0, 1)
		avatarImg.BackgroundTransparency = 1
		avatarImg.ScaleType = Enum.ScaleType.Fit
		avatarImg.Parent = avatarFrame
		rnd(avatarImg, 19)
		local infoFrame = Instance.new("Frame")
		infoFrame.Name = "InfoFrame"
		infoFrame.Size = UDim2.new(1, -50, 1, 0)
		infoFrame.BackgroundTransparency = 1
		infoFrame.Parent = targetHudInstance
		local infoLay = Instance.new("UIListLayout")
		infoLay.FillDirection = Enum.FillDirection.Vertical
		infoLay.VerticalAlignment = Enum.VerticalAlignment.Center
		infoLay.Padding = UDim.new(0, 4)
		infoLay.Parent = infoFrame
		local topRow = Instance.new("Frame")
		topRow.Name = "TopRow"
		topRow.Size = UDim2.new(1, 0, 0, 14)
		topRow.BackgroundTransparency = 1
		topRow.Parent = infoFrame
		local nameLbl = Instance.new("TextLabel")
		nameLbl.Name = "NameLabel"
		nameLbl.Size = UDim2.new(0.65, 0, 1, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLbl.Font = Enum.Font.MontserratBold
		nameLbl.TextSize = 11
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
		nameLbl.Parent = topRow
		local hpLbl = Instance.new("TextLabel")
		hpLbl.Name = "HpLabel"
		hpLbl.Size = UDim2.new(0.35, 0, 1, 0)
		hpLbl.Position = UDim2.new(0.65, 0, 0, 0)
		hpLbl.BackgroundTransparency = 1
		hpLbl.TextColor3 = ac2
		hpLbl.Font = Enum.Font.MontserratBold
		hpLbl.TextSize = 10
		hpLbl.TextXAlignment = Enum.TextXAlignment.Right
		hpLbl.Parent = topRow
		local barFrame = Instance.new("Frame")
		barFrame.Name = "BarFrame"
		barFrame.Size = UDim2.new(1, 0, 0, 8)
		barFrame.BackgroundTransparency = 1
		barFrame.Parent = infoFrame
		local hpBar = Instance.new("Frame")
		hpBar.Name = "HpBar"
		hpBar.Size = UDim2.new(1, 0, 0, 6)
		hpBar.Position = UDim2.new(0, 0, 0.5, -3)
		hpBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
		hpBar.BorderSizePixel = 0
		hpBar.Parent = barFrame
		rnd(hpBar, 3)
		local hpDrained = Instance.new("Frame")
		hpDrained.Name = "Drained"
		hpDrained.Size = UDim2.new(0.5, 0, 1, 0)
		hpDrained.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
		hpDrained.BackgroundTransparency = 0.4
		hpDrained.BorderSizePixel = 0
		hpDrained.Parent = hpBar
		rnd(hpDrained, 3)
		local hpFill = Instance.new("Frame")
		hpFill.Name = "Fill"
		hpFill.Size = UDim2.new(0.5, 0, 1, 0)
		hpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		hpFill.BorderSizePixel = 0
		hpFill.Parent = hpBar
		rnd(hpFill, 3)
		local hpGrad = Instance.new("UIGradient")
		hpGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, ac),
			ColorSequenceKeypoint.new(1, ac2)
		})
		hpGrad.Parent = hpFill
		makeDraggable(targetHudInstance)
	end
	local function makeCheckbox(parent, data, updateHeight)
		local h = data.desc and 36 or 22
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, h)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = h
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -26, 0, 14)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label
		data.originalLabel = data.originalLabel or data.label
		if data.desc then
			local desc = Instance.new("TextLabel")
			desc.Size = UDim2.new(1, -26, 0, 11)
			desc.Position = UDim2.new(0, 0, 0, 16)
			desc.BackgroundTransparency = 1
			desc.Text = data.desc
			desc.TextColor3 = Color3.fromRGB(180, 180, 190)
			desc.TextSize = 10
			desc.Font = Enum.Font.MontserratBold
			desc.TextXAlignment = Enum.TextXAlignment.Left
			desc.TextTruncate = Enum.TextTruncate.AtEnd
			desc.Parent = frame
			data.ui_desc = desc
		end
		local box = Instance.new("Frame")
		box.Size = UDim2.new(0, 16, 0, 16)
		box.Position = UDim2.new(1, -16, 0.5, -8)
		box.BackgroundColor3 = data.value and ac or cl.check
		box.BorderSizePixel = 0
		box.Parent = frame
		rnd(box, 4)
		data.ui_box = box
		local checkIcon = Instance.new("ImageLabel")
		checkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		checkIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		checkIcon.Size = UDim2.new(0, 10, 0, 10)
		checkIcon.BackgroundTransparency = 1
		checkIcon.Image = "rbxassetid://14189590169"
		checkIcon.ImageColor3 = Color3.fromRGB(20, 20, 20)
		checkIcon.ImageTransparency = data.value and 0 or 1
		checkIcon.ScaleType = Enum.ScaleType.Fit
		checkIcon.Parent = box
		data.ui_checkIcon = checkIcon
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Text = ""
		btn.Parent = frame
		btn.MouseEnter:Connect(function()
			if not data.value then
				tw(box, {BackgroundColor3 = Color3.fromRGB(52, 52, 60)}, 0.15)
			end
		end)
		btn.MouseLeave:Connect(function()
			if not data.value then
				tw(box, {BackgroundColor3 = cl.check}, 0.15)
			end
		end)
		btn.MouseButton1Click:Connect(function()
			data.value = not data.value
			tw(box, {BackgroundColor3 = data.value and ac or cl.check}, 0.15)
			tw(checkIcon, {ImageTransparency = data.value and 0 or 1}, 0.15)
			if data.callback then
				pcall(data.callback, data.value)
			end
			triggerBindRefresh()
		end)
		data.refresh = function()
			box.BackgroundColor3 = data.value and ac or cl.check
		end
	end
	local function makeDropdown(parent, data, updateHeight)
		local isMulti = data.type == "multiselect"
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 40)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 40
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 13)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label
		data.originalLabel = data.originalLabel or data.label
		local field = Instance.new("Frame")
		field.Size = UDim2.new(1, 0, 0, 24)
		field.Position = UDim2.new(0, 0, 0, 15)
		field.BackgroundColor3 = cl.field
		field.BorderSizePixel = 0
		field.ClipsDescendants = true
		field.Parent = frame
		rnd(field, 5)
		stk(field, Color3.fromRGB(36, 36, 42))
		data.ui_field = field
		local fieldHeader = Instance.new("Frame")
		fieldHeader.Size = UDim2.new(1, 0, 0, 24)
		fieldHeader.BackgroundTransparency = 1
		fieldHeader.Parent = field
		local ddIcon = Instance.new("ImageLabel")
		ddIcon.Size = UDim2.new(0, 14, 0, 14)
		ddIcon.Position = UDim2.new(0, 8, 0.5, -7)
		ddIcon.BackgroundTransparency = 1
		ddIcon.Image = "rbxassetid://15567843390"
		ddIcon.ImageColor3 = Color3.fromRGB(160, 160, 170)
		ddIcon.ScaleType = Enum.ScaleType.Fit
		ddIcon.Parent = fieldHeader
		local val = Instance.new("TextLabel")
		val.Size = UDim2.new(1, -44, 1, 0)
		val.Position = UDim2.new(0, 28, 0, 0)
		val.BackgroundTransparency = 1
		val.Text = data.value
		val.TextColor3 = Color3.fromRGB(220, 220, 225)
		val.TextSize = 11
		val.Font = Enum.Font.MontserratBold
		val.TextXAlignment = Enum.TextXAlignment.Left
		val.Parent = fieldHeader
		data.ui_val = val
		local arrow = Instance.new("ImageLabel")
		arrow.Size = UDim2.new(0, 10, 0, 10)
		arrow.Position = UDim2.new(1, -15, 0.5, 0)
		arrow.AnchorPoint = Vector2.new(0.5, 0.5)
		arrow.BackgroundTransparency = 1
		arrow.Image = "rbxassetid://91928301361749"
		arrow.ImageColor3 = Color3.fromRGB(160, 160, 170)
		arrow.ScaleType = Enum.ScaleType.Fit
		arrow.Parent = fieldHeader
		data.ui_arrow = arrow
		local optList = Instance.new("ScrollingFrame")
		optList.Size = UDim2.new(1, 0, 0, 0)
		optList.Position = UDim2.new(0, 0, 0, 24)
		optList.BackgroundTransparency = 1
		optList.BorderSizePixel = 0
		optList.Visible = false
		optList.ClipsDescendants = true
		optList.ScrollBarThickness = 3
		optList.ScrollBarImageColor3 = ac
		optList.ScrollBarImageTransparency = 0.4
		optList.CanvasSize = UDim2.new(0, 0, 0, 0)
		optList.Parent = field
		data.ui_optList = optList
		local listLay = Instance.new("UIListLayout")
		listLay.SortOrder = Enum.SortOrder.LayoutOrder
		listLay.Padding = UDim.new(0, 2)
		listLay.Parent = optList
		pad(optList, 4, 4, 8, 8)
		local fieldBtn = Instance.new("TextButton")
		fieldBtn.Size = UDim2.new(1, 0, 1, 0)
		fieldBtn.BackgroundTransparency = 1
		fieldBtn.Text = ""
		fieldBtn.Parent = fieldHeader
		local activeSelections = {}
		if isMulti then
			for item in string.gmatch(data.value, "[^,%s]+") do
				activeSelections[item] = true
			end
		end
		data.ui_activeSelections = activeSelections
		local function updateDisplayValue()
			if isMulti then
				local keys = {}
				for k, v in pairs(activeSelections) do
					if v then
						table.insert(keys, k)
					end
				end
				local str = table.concat(keys, ", ")
				data.value = str ~= "" and str or "None"
				val.Text = data.value
			else
				val.Text = data.value
			end
		end
		data.ui_updateDisplayValue = updateDisplayValue
		if data.list then
			for idx, opt in ipairs(data.list) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 22)
				optBtn.BackgroundTransparency = 1
				optBtn.BorderSizePixel = 0
				optBtn.Text = opt
				local isSel = isMulti and activeSelections[opt] or (opt == data.value)
				optBtn.TextColor3 = isSel and ac2 or Color3.fromRGB(200, 200, 205)
				optBtn.TextSize = 11
				optBtn.Font = Enum.Font.MontserratBold
				optBtn.TextXAlignment = Enum.TextXAlignment.Left
				optBtn.AutoButtonColor = false
				optBtn.Parent = optList
				rnd(optBtn, 4)
				pad(optBtn, 0, 0, 8, 0)
				optBtn.MouseEnter:Connect(function()
					tw(optBtn, {BackgroundTransparency = 0.95, BackgroundColor3 = ac, TextColor3 = ac}, 0.1)
				end)
				optBtn.MouseLeave:Connect(function()
					local currentSel = isMulti and activeSelections[opt] or (opt == data.value)
					tw(optBtn, {BackgroundTransparency = 1, TextColor3 = currentSel and ac or Color3.fromRGB(200, 200, 205)}, 0.1)
				end)
				optBtn.MouseButton1Click:Connect(function()
					if isMulti then
						activeSelections[opt] = not activeSelections[opt]
						local currentSel = activeSelections[opt]
						tw(optBtn, {TextColor3 = currentSel and ac or Color3.fromRGB(200, 200, 205)}, 0.12)
						updateDisplayValue()
						if data.callback then
							pcall(data.callback, data.value)
						end
					else
						data.value = opt
						for _, ch in pairs(optList:GetChildren()) do
							if ch:IsA("TextButton") then
								local match = ch.Text == opt
								tw(ch, {TextColor3 = match and ac or Color3.fromRGB(200, 200, 205)}, 0.12)
							end
						end
						updateDisplayValue()
						if data.callback then
							pcall(data.callback, data.value)
						end
						data.expanded = false
						tw(arrow, {Rotation = 0}, 0.15)
						tw(optList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
						task.delay(0.3, function()
							if not data.expanded then
								optList.Visible = false
							end
						end)
						tw(field, {Size = UDim2.new(1, 0, 0, 24)}, 0.3, Enum.EasingStyle.Quint)
						tw(frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3, Enum.EasingStyle.Quint)
						task.spawn(function()
							local startTime = os.clock()
							local conn
							conn = regConn(game:GetService("RunService").RenderStepped:Connect(function()
								if os.clock() - startTime > 0.3 then
									conn:Disconnect()
								end
								updateHeight(true)
							end))
						end)
					end
				end)
			end
			fieldBtn.MouseButton1Click:Connect(function()
				data.expanded = not data.expanded
				local dur = 0.3
				if data.expanded then
					optList.Visible = true
					tw(arrow, {Rotation = 90}, 0.15)
					local _0xfullH = #data.list * 24 + 8
					local listH = math.min(_0xfullH, 150)
					optList.CanvasSize = UDim2.new(0, 0, 0, _0xfullH)
					tw(optList, {Size = UDim2.new(1, 0, 0, listH)}, dur, Enum.EasingStyle.Quint)
					tw(field, {Size = UDim2.new(1, 0, 0, 24 + listH)}, dur, Enum.EasingStyle.Quint)
					tw(frame, {Size = UDim2.new(1, 0, 0, 40 + listH)}, dur, Enum.EasingStyle.Quint)
				else
					tw(arrow, {Rotation = 0}, 0.15)
					tw(optList, {Size = UDim2.new(1, 0, 0, 0)}, dur, Enum.EasingStyle.Quint)
					task.delay(dur, function()
						if not data.expanded then
							optList.Visible = false
						end
					end)
					tw(field, {Size = UDim2.new(1, 0, 0, 24)}, dur, Enum.EasingStyle.Quint)
					tw(frame, {Size = UDim2.new(1, 0, 0, 40)}, dur, Enum.EasingStyle.Quint)
				end
				task.spawn(function()
					local startTime = os.clock()
					local conn
					conn = regConn(game:GetService("RunService").RenderStepped:Connect(function()
						if os.clock() - startTime > dur then
							conn:Disconnect()
						end
						updateHeight(true)
					end))
				end)
			end)
		end
		data.refresh = function()
			field.BackgroundColor3 = cl.field
			optList.ScrollBarImageColor3 = ac
			for _, ch in pairs(optList:GetChildren()) do
				if ch:IsA("TextButton") then
					local isSel = isMulti and activeSelections[ch.Text] or (ch.Text == data.value)
					ch.TextColor3 = isSel and ac2 or Color3.fromRGB(200, 200, 205)
				end
			end
		end
	end
	local function makeSlider(parent, data, updateHeight)
		local hasDesc = data.desc ~= nil
		local h = hasDesc and 52 or 34
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, h)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = h
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.6, 0, 0, 13)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label
		data.originalLabel = data.originalLabel or data.label
		local valText = Instance.new("TextLabel")
		valText.Size = UDim2.new(0.4, 0, 0, 13)
		valText.Position = UDim2.new(0.6, 0, 0, 0)
		valText.BackgroundTransparency = 1
		valText.Text = tostring(data.value) .. (data.suffix or "")
		valText.TextColor3 = ac2
		valText.TextSize = 11
		valText.Font = Enum.Font.MontserratBold
		valText.TextXAlignment = Enum.TextXAlignment.Right
		valText.Parent = frame
		data.ui_valText = valText
		if hasDesc then
			local desc = Instance.new("TextLabel")
			desc.Size = UDim2.new(1, 0, 0, 11)
			desc.Position = UDim2.new(0, 0, 0, 14)
			desc.BackgroundTransparency = 1
			desc.Text = data.desc
			desc.TextColor3 = Color3.fromRGB(160, 160, 170)
			desc.TextSize = 10
			desc.Font = Enum.Font.MontserratBold
			desc.TextXAlignment = Enum.TextXAlignment.Left
			desc.TextTruncate = Enum.TextTruncate.AtEnd
			desc.Parent = frame
			data.ui_desc = desc
		end
		local trackY = hasDesc and 30 or 18
		local track = Instance.new("Frame")
		track.Size = UDim2.new(1, 0, 0, 4)
		track.Position = UDim2.new(0, 0, 0, trackY)
		track.BackgroundColor3 = cl.field
		track.BorderSizePixel = 0
		track.Parent = frame
		rnd(track, 2)
		data.ui_track = track
		local pct = math.clamp((data.value - data.min) / (data.max - data.min), 0, 1)
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(pct, 0, 1, 0)
		fill.BackgroundColor3 = ac
		fill.BorderSizePixel = 0
		fill.Parent = track
		rnd(fill, 2)
		data.ui_fill = fill
		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 8, 0, 8)
		knob.Position = UDim2.new(pct, -4, 0.5, -4)
		knob.BackgroundColor3 = ac
		knob.BorderSizePixel = 0
		knob.ZIndex = 2
		knob.Parent = track
		rnd(knob, 4)
		data.ui_knob = knob
		local active = false
		local hitArea = Instance.new("TextButton")
		hitArea.Size = UDim2.new(1, 0, 0, 14)
		hitArea.Position = UDim2.new(0, 0, 0, trackY - 5)
		hitArea.BackgroundTransparency = 1
		hitArea.Text = ""
		hitArea.Parent = frame
		hitArea.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				active = true
			end
		end)
		hitArea.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				active = false
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				local raw = data.min + (data.max - data.min) * rel
				if data.max <= 10 then
					data.value = math.floor(raw * 100) / 100
				else
					data.value = math.floor(raw)
				end
				tw(fill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.08)
				tw(knob, {Position = UDim2.new(rel, -4, 0.5, -4)}, 0.08)
				valText.Text = tostring(data.value) .. (data.suffix or "")
				if data.callback then
					pcall(data.callback, data.value)
				end
			end
		end)
		data.refresh = function()
			track.BackgroundColor3 = cl.field
			fill.BackgroundColor3 = ac
			knob.BackgroundColor3 = ac
			valText.TextColor3 = ac2
		end
	end
	local function makeColorPicker(parent, data, updateHeight)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 22)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 22

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -26, 0, 14)
		label.Position = UDim2.new(0, 0, 0.5, -7)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label

		local box = Instance.new("Frame")
		box.Size = UDim2.new(0, 16, 0, 16)
		box.Position = UDim2.new(1, -16, 0.5, -8)
		box.BackgroundColor3 = data.color or Color3.fromRGB(120, 110, 250)
		box.BorderSizePixel = 0
		box.Parent = frame
		rnd(box, 4)
		stk(box, Color3.fromRGB(45, 45, 52))
		data.ui_box = box

		local pickerPanel = Instance.new("Frame")
		pickerPanel.Size = UDim2.new(1, 0, 0, 0)
		pickerPanel.Position = UDim2.new(0, 0, 0, 22)
		pickerPanel.BackgroundColor3 = cl.field
		pickerPanel.BorderSizePixel = 0
		pickerPanel.ClipsDescendants = true
		pickerPanel.Visible = false
		pickerPanel.Parent = frame
		rnd(pickerPanel, 6)
		stk(pickerPanel, Color3.fromRGB(36, 36, 42))
		data.ui_pickerPanel = pickerPanel

		local pLay = Instance.new("UIListLayout")
		pLay.SortOrder = Enum.SortOrder.LayoutOrder
		pLay.Padding = UDim.new(0, 8)
		pLay.Parent = pickerPanel
		pad(pickerPanel, 8, 8, 8, 8)

		local currentH
		local currentS
		local currentV
		currentH, currentS, currentV = Color3.toHSV(data.color or Color3.fromRGB(120, 110, 250))

		local svFrame = Instance.new("Frame")
		svFrame.Size = UDim2.new(1, 0, 0, 80)
		svFrame.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1)
		svFrame.BorderSizePixel = 0
		svFrame.LayoutOrder = 1
		svFrame.Parent = pickerPanel
		rnd(svFrame, 4)
		data.ui_svFrame = svFrame

		local satGrad = Instance.new("Frame")
		satGrad.Size = UDim2.new(1, 0, 1, 0)
		satGrad.BackgroundTransparency = 0
		satGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		satGrad.BorderSizePixel = 0
		satGrad.Parent = svFrame
		rnd(satGrad, 4)

		local satUIGrad = Instance.new("UIGradient")
		satUIGrad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
		satUIGrad.Parent = satGrad

		local valGrad = Instance.new("Frame")
		valGrad.Size = UDim2.new(1, 0, 1, 0)
		valGrad.BackgroundTransparency = 0
		valGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		valGrad.BorderSizePixel = 0
		valGrad.Parent = satGrad
		rnd(valGrad, 4)

		local valUIGrad = Instance.new("UIGradient")
		valUIGrad.Rotation = 90
		valUIGrad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0)
		})
		valUIGrad.Parent = valGrad

		local svCursor = Instance.new("Frame")
		svCursor.Size = UDim2.new(0, 8, 0, 8)
		svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
		svCursor.Position = UDim2.new(currentS, 0, 1 - currentV, 0)
		svCursor.BackgroundTransparency = 1
		svCursor.Parent = valGrad
		rnd(svCursor, 4)
		data.ui_svCursor = svCursor

		local cursorStroke = Instance.new("UIStroke")
		cursorStroke.Color = Color3.fromRGB(255, 255, 255)
		cursorStroke.Thickness = 1.5
		cursorStroke.Parent = svCursor

		local hueSlider = Instance.new("Frame")
		hueSlider.Size = UDim2.new(1, 0, 0, 10)
		hueSlider.BorderSizePixel = 0
		hueSlider.LayoutOrder = 2
		hueSlider.Parent = pickerPanel
		rnd(hueSlider, 2)

		local hueGrad = Instance.new("UIGradient")
		hueGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
		})
		hueGrad.Parent = hueSlider

		local hueCursor = Instance.new("Frame")
		hueCursor.Size = UDim2.new(0, 4, 1, 4)
		hueCursor.Position = UDim2.new(currentH, -2, 0, -2)
		hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		hueCursor.BorderSizePixel = 0
		hueCursor.Parent = hueSlider
		rnd(hueCursor, 2)
		stk(hueCursor, Color3.fromRGB(0, 0, 0))
		data.ui_hueCursor = hueCursor

		local function updateColor()
			local col = Color3.fromHSV(currentH, currentS, currentV)
			data.color = col
			box.BackgroundColor3 = col
			if data.callback then
				pcall(data.callback, col)
			end
		end

		local svActive = false
		local svBtn = Instance.new("TextButton")
		svBtn.Size = UDim2.new(1, 0, 1, 0)
		svBtn.BackgroundTransparency = 1
		svBtn.Text = ""
		svBtn.Parent = valGrad

		local function updateSV()
			local mousePos = UIS:GetMouseLocation()
			local relX = math.clamp((mousePos.X - valGrad.AbsolutePosition.X) / valGrad.AbsoluteSize.X, 0, 1)
			local relY = math.clamp((mousePos.Y - valGrad.AbsolutePosition.Y) / valGrad.AbsoluteSize.Y, 0, 1)
			currentS = relX
			currentV = 1 - relY
			svCursor.Position = UDim2.new(relX, 0, relY, 0)
			updateColor()
		end

		svBtn.MouseButton1Down:Connect(function()
			svActive = true
			updateSV()
		end)

		local hueActive = false
		local hueBtn = Instance.new("TextButton")
		hueBtn.Size = UDim2.new(1, 0, 1, 0)
		hueBtn.BackgroundTransparency = 1
		hueBtn.Text = ""
		hueBtn.Parent = hueSlider

		local function updateHue()
			local mousePos = UIS:GetMouseLocation()
			local relX = math.clamp((mousePos.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
			currentH = relX
			hueCursor.Position = UDim2.new(relX, -2, 0, -2)
			svFrame.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1)
			updateColor()
		end

		hueBtn.MouseButton1Down:Connect(function()
			hueActive = true
			updateHue()
		end)

		regConn(UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				svActive = false
				hueActive = false
			end
		end))

		regConn(UIS.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if svActive then
					updateSV()
				elseif hueActive then
					updateHue()
				end
			end
		end))

		local accBtn = Instance.new("TextButton")
		accBtn.Size = UDim2.new(1, 0, 0, 22)
		accBtn.BackgroundColor3 = ac
		accBtn.Text = "Принять"
		accBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
		accBtn.TextSize = 10
		accBtn.Font = Enum.Font.MontserratBold
		accBtn.LayoutOrder = 3
		accBtn.Parent = pickerPanel
		rnd(accBtn, 4)

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 22)
		btn.Position = UDim2.new(0, 0, 0, 0)
		btn.BackgroundTransparency = 1
		btn.Text = ""
		btn.Parent = frame

		local function togglePicker()
			data.expanded = not data.expanded
			local dur = 0.26
			if data.expanded then
				pickerPanel.Visible = true
				local panelH = 80 + 10 + 22 + 24
				tw(pickerPanel, {Size = UDim2.new(1, 0, 0, panelH)}, dur, Enum.EasingStyle.Quint)
				tw(frame, {Size = UDim2.new(1, 0, 0, 22 + panelH + 6)}, dur, Enum.EasingStyle.Quint)
				data.height = 22 + panelH + 6
			else
				tw(pickerPanel, {Size = UDim2.new(1, 0, 0, 0)}, dur, Enum.EasingStyle.Quint)
				task.delay(dur, function()
					if not data.expanded then
						pickerPanel.Visible = false
					end
				end)
				tw(frame, {Size = UDim2.new(1, 0, 0, 22)}, dur, Enum.EasingStyle.Quint)
				data.height = 22
			end
			task.spawn(function()
				local startTime = os.clock()
				local conn
				conn = regConn(game:GetService("RunService").RenderStepped:Connect(function()
					if os.clock() - startTime > dur then
						conn:Disconnect()
					end
					updateHeight(true)
				end))
			end)
		end
		btn.MouseButton1Click:Connect(togglePicker)
		accBtn.MouseButton1Click:Connect(togglePicker)

		data.refresh = function()
			pickerPanel.BackgroundColor3 = cl.field
			accBtn.BackgroundColor3 = ac
		end
	end
	local moonColors = {
		["Rainbow Moon"] = Color3.fromRGB(180, 120, 255),
		["Goldmoon"] = Color3.fromRGB(255, 195, 55),
		["Bloodmoon"] = Color3.fromRGB(240, 75, 75),
	}
	local moonGradients = {
		["Rainbow Moon"] = {Color3.fromRGB(180, 120, 255), Color3.fromRGB(255, 140, 220)},
		["Goldmoon"] = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 140, 0)},
		["Bloodmoon"] = {Color3.fromRGB(255, 50, 50), Color3.fromRGB(150, 0, 0)},
	}
	local function renderPredictionRow(parent, item, index)
		local rowH = 26
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, rowH)
		row.BackgroundColor3 = cl.card
		row.BorderSizePixel = 0
		row.LayoutOrder = index
		row.Parent = parent
		rnd(row, 6)
		stk(row, Color3.fromRGB(28, 28, 34), 1)
		local accentCol = Color3.fromRGB(200, 200, 210)
		local isRare = false
		local rareName = ""
		for mName, col in pairs(moonColors) do
			if item:find(mName) then
				accentCol = col
				isRare = true
				rareName = mName
				break
			end
		end
		local accent = Instance.new("Frame")
		accent.BorderSizePixel = 0
		accent.Position = UDim2.new(0, 6, 0.5, -4)
		accent.Size = UDim2.new(0, 8, 0, 8)
		accent.BackgroundColor3 = accentCol
		accent.Parent = row
		rnd(accent, 4)
		if isRare and moonGradients[rareName] then
			local grad = Instance.new("UIGradient")
			grad.Color = ColorSequence.new(moonGradients[rareName][1], moonGradients[rareName][2])
			grad.Parent = accent
		end
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -26, 1, 0)
		lbl.Position = UDim2.new(0, 20, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = item
		lbl.TextColor3 = isRare and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
		lbl.TextSize = 10
		lbl.Font = isRare and Enum.Font.MontserratBold or Enum.Font.MontserratBold
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = row
		row.MouseEnter:Connect(function()
			tw(row, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}, 0.15)
			if isRare then
				tw(lbl, {TextColor3 = accentCol}, 0.15)
			end
		end)
		row.MouseLeave:Connect(function()
			tw(row, {BackgroundColor3 = cl.card}, 0.15)
			tw(lbl, {TextColor3 = isRare and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)}, 0.15)
		end)
	end
	local function makePredList(parent, data, updateHeight)
		local items = data.items or {}
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 40)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 40
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 13)
		label.BackgroundTransparency = 1
		label.Text = data.label or "Weather Predictions"
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		local field = Instance.new("Frame")
		field.Size = UDim2.new(1, 0, 0, 24)
		field.Position = UDim2.new(0, 0, 0, 15)
		field.BackgroundColor3 = cl.field
		field.BorderSizePixel = 0
		field.ClipsDescendants = true
		field.Parent = frame
		rnd(field, 5)
		stk(field, Color3.fromRGB(36, 36, 42))
		local fieldHeader = Instance.new("Frame")
		fieldHeader.Size = UDim2.new(1, 0, 0, 24)
		fieldHeader.BackgroundTransparency = 1
		fieldHeader.Parent = field
		local ddIcon = Instance.new("ImageLabel")
		ddIcon.Size = UDim2.new(0, 14, 0, 14)
		ddIcon.Position = UDim2.new(0, 8, 0.5, -7)
		ddIcon.BackgroundTransparency = 1
		ddIcon.Image = "rbxassetid://16000149927"
		ddIcon.ImageColor3 = Color3.fromRGB(160, 160, 170)
		ddIcon.ScaleType = Enum.ScaleType.Fit
		ddIcon.Parent = fieldHeader
		local val = Instance.new("TextLabel")
		val.Size = UDim2.new(1, -44, 1, 0)
		val.Position = UDim2.new(0, 28, 0, 0)
		val.BackgroundTransparency = 1
		local summaryText = "Show Predictions"
		for _, item in ipairs(items) do
			if item:find("Rainbow Moon") or item:find("Goldmoon") or item:find("Bloodmoon") then
				summaryText = "Next: " .. item
				break
			end
		end
		val.Text = summaryText
		val.TextColor3 = Color3.fromRGB(220, 220, 225)
		val.TextSize = 11
		val.Font = Enum.Font.MontserratBold
		val.TextXAlignment = Enum.TextXAlignment.Left
		val.Parent = fieldHeader
		local arrow = Instance.new("ImageLabel")
		arrow.Size = UDim2.new(0, 10, 0, 10)
		arrow.Position = UDim2.new(1, -15, 0.5, 0)
		arrow.AnchorPoint = Vector2.new(0.5, 0.5)
		arrow.BackgroundTransparency = 1
		arrow.Image = "rbxassetid://6031094678"
		arrow.ImageColor3 = Color3.fromRGB(160, 160, 170)
		arrow.ScaleType = Enum.ScaleType.Fit
		arrow.Parent = fieldHeader
		local optList = Instance.new("ScrollingFrame")
		optList.Size = UDim2.new(1, 0, 0, 0)
		optList.Position = UDim2.new(0, 0, 0, 24)
		optList.BackgroundTransparency = 1
		optList.BorderSizePixel = 0
		optList.Visible = false
		optList.ClipsDescendants = true
		optList.ScrollBarThickness = 3
		optList.ScrollBarImageColor3 = ac
		optList.ScrollBarImageTransparency = 0.4
		optList.CanvasSize = UDim2.new(0, 0, 0, 0)
		optList.Parent = field
		local listLay = Instance.new("UIListLayout")
		listLay.SortOrder = Enum.SortOrder.LayoutOrder
		listLay.Padding = UDim.new(0, 6)
		listLay.Parent = optList
		pad(optList, 4, 4, 8, 8)
		local fieldBtn = Instance.new("TextButton")
		fieldBtn.Size = UDim2.new(1, 0, 1, 0)
		fieldBtn.BackgroundTransparency = 1
		fieldBtn.Text = ""
		fieldBtn.Parent = fieldHeader
		for idx, item in ipairs(items) do
			renderPredictionRow(optList, item, idx)
		end
		fieldBtn.MouseButton1Click:Connect(function()
			data.expanded = not data.expanded
			if data.expanded then
				optList.Visible = true
				tw(arrow, {Rotation = 180}, 0.15)
				local rowH = 26
				local _0xfullH = #items * (rowH + 6) + 8
				local listH = math.min(_0xfullH, 180)
				optList.CanvasSize = UDim2.new(0, 0, 0, _0xfullH)
				tw(optList, {Size = UDim2.new(1, 0, 0, listH)}, 0.18)
				tw(field, {Size = UDim2.new(1, 0, 0, 24 + listH)}, 0.18)
				tw(frame, {Size = UDim2.new(1, 0, 0, 40 + listH)}, 0.18)
			else
				tw(arrow, {Rotation = 0}, 0.15)
				tw(optList, {Size = UDim2.new(1, 0, 0, 0)}, 0.18)
				task.delay(0.18, function()
					optList.Visible = false
				end)
				tw(field, {Size = UDim2.new(1, 0, 0, 24)}, 0.18)
				tw(frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.18)
			end
			task.delay(0.01, updateHeight)
			task.delay(0.19, updateHeight)
		end)
		data.refresh = function()
			field.BackgroundColor3 = cl.field
			optList.ScrollBarImageColor3 = ac
		end
	end
	local function makeButton(parent, data, updateHeight)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 22)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 22
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.BorderSizePixel = 0
		btn.Text = data.label
		btn.TextColor3 = Color3.fromRGB(20, 20, 20)
		btn.TextSize = 11
		btn.Font = Enum.Font.MontserratBold
		btn.Parent = frame
		rnd(btn, 6)
		stk(btn, Color3.fromRGB(200, 200, 200))
		data.ui_btn = btn
		data.originalLabel = data.originalLabel or data.label
		btn.MouseEnter:Connect(function()
			tw(btn, {BackgroundColor3 = Color3.fromRGB(225, 225, 225)}, 0.12)
		end)
		btn.MouseLeave:Connect(function()
			tw(btn, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
		end)
		btn.MouseButton1Down:Connect(function()
			tw(btn, {Size = UDim2.new(0.98, 0, 0.9, 0), Position = UDim2.new(0.01, 0, 0.05, 0)}, 0.08)
		end)
		btn.MouseButton1Up:Connect(function()
			tw(btn, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}, 0.08)
		end)
		btn.MouseButton1Click:Connect(function()
			if data.callback then
				pcall(data.callback)
			end
		end)
		data.refresh = function()
			btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
	local function makeToggle(parent, data, updateHeight)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 22)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 22
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 0, 14)
		label.Position = UDim2.new(0, 0, 0.5, -7)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label
		local togBg = Instance.new("Frame")
		togBg.Size = UDim2.new(0, 38, 0, 20)
		togBg.Position = UDim2.new(1, -38, 0.5, -10)
		togBg.BackgroundColor3 = data.value and ac or cl.tog_off
		togBg.BorderSizePixel = 0
		togBg.Parent = frame
		rnd(togBg, 10)
		data.ui_togBg = togBg
		local togDot = Instance.new("Frame")
		togDot.Size = UDim2.new(0, 16, 0, 16)
		togDot.Position = data.value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		togDot.BackgroundColor3 = data.value and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
		togDot.BorderSizePixel = 0
		togDot.Parent = togBg
		rnd(togDot, 8)
		data.ui_togDot = togDot
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Text = ""
		btn.Parent = frame
		btn.MouseButton1Click:Connect(function()
			data.value = not data.value
			tw(togBg, {BackgroundColor3 = data.value and ac or cl.tog_off}, 0.18)
			tw(togDot, {
				Position = data.value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				BackgroundColor3 = data.value and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
			}, 0.18)
			if data.callback then pcall(data.callback, data.value) end
		end)
		data.refresh = function()
			togBg.BackgroundColor3 = data.value and ac or cl.tog_off
			togDot.BackgroundColor3 = data.value and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
			togDot.Position = data.value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		end
	end
	local function makeText(parent, data, updateHeight)
		local h = data.desc and 30 or 16
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, h)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = h
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, 0, 0, 14)
		lbl.BackgroundTransparency = 1
		lbl.Text = data.label
		lbl.TextColor3 = data.color or Color3.fromRGB(190, 190, 210)
		lbl.TextSize = 11
		lbl.Font = Enum.Font.MontserratBold
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.RichText = true
		lbl.Parent = frame
		data.ui_label = lbl
		data.originalLabel = data.originalLabel or data.label
		if data.desc then
			local sub = Instance.new("TextLabel")
			sub.Size = UDim2.new(1, 0, 0, 12)
			sub.Position = UDim2.new(0, 0, 0, 16)
			sub.BackgroundTransparency = 1
			sub.Text = data.desc
			sub.TextColor3 = Color3.fromRGB(120, 120, 140)
			sub.TextSize = 10
			sub.Font = Enum.Font.MontserratBold
			sub.TextXAlignment = Enum.TextXAlignment.Left
			sub.RichText = true
			sub.Parent = frame
			data.ui_desc = sub
		end
	end
	local function makeTextBox(parent, data, updateHeight)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 40)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 40
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 13)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label
		local field = Instance.new("Frame")
		field.Size = UDim2.new(1, 0, 0, 24)
		field.Position = UDim2.new(0, 0, 0, 15)
		field.BackgroundColor3 = cl.field
		field.BorderSizePixel = 0
		field.Parent = frame
		registerRecolor(field, "BackgroundColor3", "field")
		rnd(field, 5)
		local stroke = stk(field, Color3.fromRGB(36, 36, 42))
		data.ui_field = field
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1, -16, 1, 0)
		box.Position = UDim2.new(0, 8, 0, 0)
		box.BackgroundTransparency = 1
		box.Text = data.value or ""
		box.PlaceholderText = data.placeholder or "Enter value..."
		box.TextColor3 = Color3.fromRGB(220, 220, 230)
		box.PlaceholderColor3 = Color3.fromRGB(90, 90, 110)
		box.TextSize = 11
		box.Font = Enum.Font.MontserratBold
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = data.clearOnFocus == true
		box.Parent = field
		data.ui_box = box
		box.Focused:Connect(function()
			tw(stroke, {Color = ac}, 0.14)
		end)
		box.FocusLost:Connect(function(enterPressed)
			tw(stroke, {Color = Color3.fromRGB(36, 36, 42)}, 0.14)
			data.value = box.Text
			if data.callback then pcall(data.callback, box.Text, enterPressed) end
		end)
		data.refresh = function()
			field.BackgroundColor3 = cl.field
		end
	end
	local function makeBind(parent, data, updateHeight)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 22)
		frame.BackgroundTransparency = 1
		frame.Parent = parent
		data.frame = frame
		data.height = 22
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -86, 0, 14)
		label.Position = UDim2.new(0, 0, 0.5, -7)
		label.BackgroundTransparency = 1
		label.Text = data.label
		label.TextColor3 = Color3.fromRGB(200, 200, 205)
		label.TextSize = 11
		label.Font = Enum.Font.MontserratBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame
		data.ui_label = label
		data.originalLabel = data.originalLabel or data.label
		local bindF = Instance.new("Frame")
		bindF.Size = UDim2.new(0, 80, 0, 20)
		bindF.Position = UDim2.new(1, -80, 0.5, -10)
		bindF.BackgroundColor3 = cl.field
		bindF.BorderSizePixel = 0
		bindF.Parent = frame
		registerRecolor(bindF, "BackgroundColor3", "field")
		rnd(bindF, 5)
		stk(bindF, Color3.fromRGB(36, 36, 44))
		data.ui_bindFrame = bindF
		local bIco = Instance.new("ImageLabel")
		bIco.Size = UDim2.new(0, 10, 0, 10)
		bIco.Position = UDim2.new(0, 6, 0.5, -5)
		bIco.BackgroundTransparency = 1
		bIco.Image = BIND_ICON
		bIco.ImageColor3 = cl.dim
		bIco.ScaleType = Enum.ScaleType.Fit
		bIco.Parent = bindF
		local bLbl = Instance.new("TextLabel")
		bLbl.Size = UDim2.new(1, -22, 1, 0)
		bLbl.Position = UDim2.new(0, 20, 0, 0)
		bLbl.BackgroundTransparency = 1
		bLbl.Text = data.key or "None"
		bLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
		bLbl.TextSize = 10
		bLbl.Font = Enum.Font.MontserratBold
		bLbl.TextXAlignment = Enum.TextXAlignment.Left
		bLbl.Parent = bindF
		data.ui_bindLbl = bLbl
		local bBtn = Instance.new("TextButton")
		bBtn.Size = UDim2.new(1, 0, 1, 0)
		bBtn.BackgroundTransparency = 1
		bBtn.Text = ""
		bBtn.ZIndex = 4
		bBtn.Parent = bindF
		local bindingNow = false
		bBtn.MouseButton1Click:Connect(function()
			if bindingNow then return end
			bindingNow = true
			bLbl.Text = "..."
			bLbl.TextColor3 = Color3.fromRGB(20, 20, 20)
			bIco.ImageColor3 = Color3.fromRGB(20, 20, 20)
			tw(bindF, {BackgroundColor3 = ac}, 0.12)
			local conn
			conn = regConn(UIS.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					local key = input.KeyCode == Enum.KeyCode.Escape and "None" or input.KeyCode.Name
					data.key = key
					bLbl.Text = key
					bLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
					bIco.ImageColor3 = cl.dim
					tw(bindF, {BackgroundColor3 = cl.field}, 0.15)
					bindingNow = false
					conn:Disconnect()
					if data.callback then pcall(data.callback, key) end
				end
			end))
		end)
		regConn(UIS.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.Keyboard and data.key and data.key ~= "None" then
				if input.KeyCode.Name == data.key and data.onActivate then
					pcall(data.onActivate)
				end
			end
		end))
		data.refresh = function()
			bindF.BackgroundColor3 = cl.field
			bIco.ImageColor3 = cl.dim
			bLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
		end
	end
	local function buildCard(modData, colIdx, order)
		local target = self.columns[colIdx]
		if not target then
			return
		end
		local card = Instance.new("Frame")
		card.Name = modData.name
		card.BorderSizePixel = 0
		card.LayoutOrder = order
		card.Parent = target
		card.ClipsDescendants = true
		registerRecolor(card, "BackgroundColor3", "card")
		registerTransparency(card, 0.1)
		rnd(card, 8)
		local cardStroke = stk(card, Color3.fromRGB(28, 28, 34))
		registerRecolor(cardStroke, "Color", "sep")
		modData.ui_card = card
		local headBtn = Instance.new("TextButton")
		headBtn.Size = UDim2.new(1, 0, 0, 32)
		headBtn.BackgroundTransparency = 1
		headBtn.Text = ""
		headBtn.Parent = card
		local modIcon = Instance.new("ImageLabel")
		modIcon.Size = UDim2.new(0, 12, 0, 12)
		modIcon.Position = UDim2.new(0, 10, 0.5, -6)
		modIcon.BackgroundTransparency = 1
		modIcon.Image = MOD_ICON
		modIcon.ImageColor3 = modData.on and ac or cl.dim
		modIcon.ScaleType = Enum.ScaleType.Fit
		modIcon.Parent = headBtn
		modData.ui_modIcon = modIcon
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.4, 0, 0, 12)
		nameLabel.Position = UDim2.new(0, 26, 0.5, -6)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = modData.name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextSize = 11
		nameLabel.Font = Enum.Font.MontserratBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.Parent = headBtn
		modData.ui_nameLabel = nameLabel
		local bindVisible = (not modData.nobind) and (not modData.notoggle)
		local badgeVisible = false
		local rightOffset = modData.notoggle and 12 or 48
		local bindFrame = Instance.new("Frame")
		bindFrame.Size = UDim2.new(0, 46, 0, 16)
		bindFrame.BorderSizePixel = 0
		bindFrame.Visible = bindVisible
		bindFrame.Parent = headBtn
		registerRecolor(bindFrame, "BackgroundColor3", "field")
		rnd(bindFrame, 5)
		stk(bindFrame, Color3.fromRGB(36, 36, 44))
		local bindIcon = Instance.new("ImageLabel")
		bindIcon.Size = UDim2.new(0, 8, 0, 8)
		bindIcon.Position = UDim2.new(0, 5, 0.5, -4)
		bindIcon.BackgroundTransparency = 1
		bindIcon.Image = BIND_ICON
		bindIcon.ImageColor3 = cl.dim
		bindIcon.ScaleType = Enum.ScaleType.Fit
		bindIcon.Parent = bindFrame
		local bindLbl = Instance.new("TextLabel")
		bindLbl.Size = UDim2.new(1, -18, 1, 0)
		bindLbl.Position = UDim2.new(0, 15, 0, 0)
		bindLbl.BackgroundTransparency = 1
		bindLbl.Text = modData.bind or "None"
		bindLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
		bindLbl.TextSize = 9
		bindLbl.Font = Enum.Font.MontserratBold
		bindLbl.TextXAlignment = Enum.TextXAlignment.Left
		bindLbl.TextTruncate = Enum.TextTruncate.AtEnd
		bindLbl.Parent = bindFrame
		local bindBtn = Instance.new("TextButton")
		bindBtn.Size = UDim2.new(1, 0, 1, 0)
		bindBtn.BackgroundTransparency = 1
		bindBtn.Text = ""
		bindBtn.ZIndex = 4
		bindBtn.Parent = bindFrame
		if bindVisible then
			bindFrame.Position = UDim2.new(1, -92, 0.5, -8)
			rightOffset = 92
		end
		if badgeVisible then
			local badgeText = "BETA"
			local badgeCol = Color3.fromRGB(36, 36, 44)
			local badgeGrad = nil
			if type(modData.badge) == "table" then
				badgeText = modData.badge.text or "BETA"
				badgeCol = modData.badge.color or Color3.fromRGB(36, 36, 44)
				badgeGrad = modData.badge.gradient
			elseif type(modData.badge) == "string" then
				badgeText = modData.badge
			end
			local badgeFrame = Instance.new("Frame")
			badgeFrame.Size = UDim2.new(0, 46, 0, 16)
			badgeFrame.Position = UDim2.new(1, -rightOffset - 46, 0.5, -8)
			badgeFrame.BackgroundColor3 = badgeCol
			badgeFrame.BorderSizePixel = 0
			badgeFrame.Parent = headBtn
			rnd(badgeFrame, 5)
			stk(badgeFrame, Color3.fromRGB(48, 48, 56))
			if badgeGrad and type(badgeGrad) == "table" then
				local grad = Instance.new("UIGradient")
				local keypoints = {}
				for kIdx, col in ipairs(badgeGrad) do
					table.insert(keypoints, ColorSequenceKeypoint.new((kIdx - 1) / (#badgeGrad - 1), col))
				end
				grad.Color = ColorSequence.new(keypoints)
				grad.Parent = badgeFrame
			end
			local badgeLbl = Instance.new("TextLabel")
			badgeLbl.Size = UDim2.new(1, 0, 1, 0)
			badgeLbl.Position = UDim2.new(0, 0, 0, 0)
			badgeLbl.BackgroundTransparency = 1
			badgeLbl.Text = badgeText
			badgeLbl.TextColor3 = (badgeCol.R + badgeCol.G + badgeCol.B > 1.8) and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
			badgeLbl.TextSize = 9
			badgeLbl.Font = Enum.Font.MontserratBold
			badgeLbl.TextXAlignment = Enum.TextXAlignment.Center
			badgeLbl.Parent = badgeFrame
		end
		local binding = false
		bindBtn.MouseButton1Click:Connect(function()
			if modData.beta then
				return
			end
			if binding then
				return
			end
			binding = true
			bindLbl.Text = "..."
			bindLbl.TextColor3 = ac
			local connection
			connection = regConn(UIS.InputBegan:Connect(function(input, gpe)
				if gpe then
					return
				end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					local key = input.KeyCode.Name
					if input.KeyCode == Enum.KeyCode.Escape then
						key = "None"
					end
					modData.bind = key
					bindLbl.Text = key
					bindLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
					binding = false
					connection:Disconnect()
					triggerBindRefresh()
					if self.currentLanguage == "ENG" then
						self:Notify("Module bind <font color=\"rgb(255, 255, 255)\">" .. modData.name .. "</font> changed to: <font color=\"rgb(120, 110, 250)\">" .. key .. "</font>", BIND_ICON)
					else
						self:Notify("Бинд модуля <font color=\"rgb(255, 255, 255)\">" .. modData.name .. "</font> изменен на: <font color=\"rgb(120, 110, 250)\">" .. key .. "</font>", BIND_ICON)
					end
				end
			end))
		end)
		local togBg, togDot, togBtn
		if not modData.notoggle then
			togBg = Instance.new("Frame")
			togBg.Size = UDim2.new(0, 34, 0, 18)
			togBg.Position = UDim2.new(1, -42, 0.5, -9)
			togBg.BackgroundColor3 = modData.on and ac or cl.tog_off
			togBg.BorderSizePixel = 0
			togBg.Parent = headBtn
			rnd(togBg, 9)
			modData.ui_togBg = togBg
			togDot = Instance.new("Frame")
			togDot.Size = UDim2.new(0, 14, 0, 14)
			togDot.Position = modData.on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
			togDot.BackgroundColor3 = modData.on and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
			togDot.BorderSizePixel = 0
			togDot.Parent = togBg
			rnd(togDot, 7)
			modData.ui_togDot = togDot
			togBtn = Instance.new("TextButton")
			togBtn.Size = UDim2.new(0, 40, 0, 24)
			togBtn.Position = UDim2.new(1, -44, 0.5, -12)
			togBtn.BackgroundTransparency = 1
			togBtn.Text = ""
			togBtn.ZIndex = 4
			togBtn.Parent = headBtn
			togBtn.MouseButton1Click:Connect(function()
				modData.on = not modData.on
				tw(togBg, {BackgroundColor3 = modData.on and ac or cl.tog_off}, 0.18)
				tw(togDot, {
					Position = modData.on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
					BackgroundColor3 = modData.on and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
				}, 0.18)
				tw(modIcon, {ImageColor3 = modData.on and ac or cl.dim}, 0.18)
				if modData.callback then
					pcall(modData.callback, modData.on)
				end
				triggerBindRefresh()
				if self.currentLanguage == "ENG" then
					self:Notify("Module <font color=\"rgb(255, 255, 255)\">" .. modData.name .. "</font> is now " .. (modData.on and "<font color=\"rgb(80, 220, 100)\">enabled</font>" or "<font color=\"rgb(240, 80, 80)\">disabled</font>"), MOD_ICON)
				else
					self:Notify("Модуль <font color=\"rgb(255, 255, 255)\">" .. modData.name .. "</font> теперь " .. (modData.on and "<font color=\"rgb(80, 220, 100)\">включен</font>" or "<font color=\"rgb(240, 80, 80)\">выключен</font>"), MOD_ICON)
				end
				if modData.name == "Music GUI" then
					updateMusicGui()
				end
			end)
		end
		local optsContainer = Instance.new("CanvasGroup")
		optsContainer.BackgroundTransparency = 1
		optsContainer.Position = UDim2.new(0, 0, 0, 32)
		optsContainer.Visible = false
		optsContainer.Parent = card
		local optsLay = Instance.new("UIListLayout")
		optsLay.SortOrder = Enum.SortOrder.LayoutOrder
		optsLay.Padding = UDim.new(0, 6)
		optsLay.Parent = optsContainer
		pad(optsContainer, 6, 6, 8, 8)
		local sep
		if modData.opts and #modData.opts > 0 then
			sep = Instance.new("Frame")
			sep.Size = UDim2.new(1, -16, 0, 1)
			sep.Position = UDim2.new(0, 8, 0, 31)
			sep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			sep.BackgroundTransparency = 0.9
			sep.BorderSizePixel = 0
			sep.Visible = false
			sep.Parent = card
			rnd(sep, 1)
		end
		local function updateCardHeight(instant)
			local expanded = modData.expanded
			local targetH = 32
			local contentH = (modData.opts and #modData.opts > 0) and (optsLay.AbsoluteContentSize.Y + 16) or 0
			local dur = 0.26
			if expanded then
				targetH = 32 + contentH
				optsContainer.Visible = true
				if instant then
					card.Size = UDim2.new(1, 0, 0, targetH)
					optsContainer.Size = UDim2.new(1, 0, 0, contentH)
					optsContainer.GroupTransparency = 0
					if sep then sep.Visible = true sep.BackgroundTransparency = 0.9 end
				else
					if sep then
						sep.Visible = true
						sep.BackgroundTransparency = 1
						tw(sep, {BackgroundTransparency = 0.9}, dur)
					end
					tw(card, {Size = UDim2.new(1, 0, 0, targetH)}, dur)
					tw(optsContainer, {Size = UDim2.new(1, 0, 0, contentH), GroupTransparency = 0}, dur)
				end
			else
				if instant then
					card.Size = UDim2.new(1, 0, 0, 32)
					optsContainer.Size = UDim2.new(1, 0, 0, 0)
					optsContainer.GroupTransparency = 1
					optsContainer.Visible = false
					if sep then sep.Visible = false end
				else
					if sep then
						tw(sep, {BackgroundTransparency = 1}, dur * 0.7)
					end
					tw(card, {Size = UDim2.new(1, 0, 0, 32)}, dur)
					tw(optsContainer, {Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1}, dur)
					task.delay(dur, function()
						if not modData.expanded then
							optsContainer.Visible = false
							if sep then sep.Visible = false end
						end
					end)
				end
			end
			task.delay(instant and 0 or dur + 0.01, updateScrollCanvasSize)
		end
		if modData.opts and #modData.opts > 0 then
			for _, opt in ipairs(modData.opts) do
				if opt.type == "checkbox" then
					makeCheckbox(optsContainer, opt, updateCardHeight)
				elseif opt.type == "toggle" then
					makeToggle(optsContainer, opt, updateCardHeight)
				elseif opt.type == "dropdown" or opt.type == "multiselect" then
					makeDropdown(optsContainer, opt, updateCardHeight)
				elseif opt.type == "slider" then
					makeSlider(optsContainer, opt, updateCardHeight)
				elseif opt.type == "colorpicker" then
					makeColorPicker(optsContainer, opt, updateCardHeight)
				elseif opt.type == "button" then
					makeButton(optsContainer, opt, updateCardHeight)
				elseif opt.type == "text" then
					makeText(optsContainer, opt, updateCardHeight)
				elseif opt.type == "textbox" then
					makeTextBox(optsContainer, opt, updateCardHeight)
				elseif opt.type == "bind" then
					makeBind(optsContainer, opt, updateCardHeight)
				elseif opt.type == "predlist" then
					makePredList(optsContainer, opt, updateCardHeight)
				end
			end
		end
		updateCardHeight(true)
		self.activeCards[modData.name .. "_main"] = function()
			if bindVisible and bindLbl then
				bindLbl.Text = modData.bind or "None"
			end
			modIcon.ImageColor3 = (modData.on or modData.notoggle) and ac or cl.dim
			if togBg and togDot then
				tw(togBg, {BackgroundColor3 = modData.on and ac or cl.tog_off}, 0.18)
				tw(togDot, {
					Position = modData.on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
					BackgroundColor3 = modData.on and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
				}, 0.18)
			end
			if currentHoveredMod == modData then
				ttIcon.ImageColor3 = (modData.on or modData.notoggle) and ac or cl.dim
			end
			if modData.opts then
				for _, opt in ipairs(modData.opts) do
					if opt.refresh then
						pcall(opt.refresh)
					end
				end
			end
		end
		headBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				modData.expanded = not modData.expanded
				updateCardHeight(false)
			end
		end)
		headBtn.MouseEnter:Connect(function()
			currentHoveredMod = modData
			showTooltip(modData.desc, modData.on)
		end)
		headBtn.MouseLeave:Connect(function()
			if currentHoveredMod == modData then
				currentHoveredMod = nil
				hideTooltip()
			end
		end)
	end
	buildBindsList = function()
		local allModules = {}
		for _, tabDef in ipairs(self.tabDefs) do
			local list = _qkaspq_store.Modules[tabDef.id]
			if list then
				for _, mod in ipairs(list) do
					if mod.on and mod.bind and mod.bind ~= "None" then
						table.insert(allModules, mod)
					end
				end
			end
		end
		table.sort(allModules, function(a, b)
			return a.name < b.name
		end)
		local activeNames = {}
		for _, modData in ipairs(allModules) do
			activeNames[modData.name] = modData
		end
		for _, child in ipairs(bindsScroll:GetChildren()) do
			if child:IsA("Frame") and not activeNames[child.Name] then
				child:Destroy()
			end
		end
		local listH = 8
		local activeCount = 0
		for idx, modData in ipairs(allModules) do
			activeCount = activeCount + 1
			local row = bindsScroll:FindFirstChild(modData.name)
			local bindLbl
			local dot
			local bindFrame
			if not row then
				row = Instance.new("Frame")
				row.Name = modData.name
				row.Size = UDim2.new(1, 0, 0, 0)
				row.BackgroundTransparency = 1
				row.BorderSizePixel = 0
				row.LayoutOrder = idx
				row.ClipsDescendants = true
				row.Parent = bindsScroll

				dot = Instance.new("Frame")
				dot.Name = "StatusDot"
				dot.Size = UDim2.new(0, 6, 0, 6)
				dot.Position = UDim2.new(0, 4, 0.5, -3)
				dot.BorderSizePixel = 0
				dot.BackgroundTransparency = 1
				dot.BackgroundColor3 = modData.on and ac or Color3.fromRGB(60, 60, 70)
				dot.Parent = row
				rnd(dot, 3)

				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
				nameLabel.Position = UDim2.new(0, 18, 0, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = modData.name
				nameLabel.TextColor3 = modData.on and Color3.fromRGB(225, 225, 230) or Color3.fromRGB(130, 130, 140)
				nameLabel.TextTransparency = 1
				nameLabel.TextSize = 11
				nameLabel.Font = Enum.Font.MontserratBold
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.Parent = row

				bindFrame = Instance.new("Frame")
				bindFrame.Name = "BindFrame"
				bindFrame.Size = UDim2.new(0, 46, 0, 18)
				bindFrame.Position = UDim2.new(1, -50, 0.5, -9)
				bindFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
				bindFrame.BackgroundTransparency = 1
				bindFrame.BorderSizePixel = 0
				bindFrame.Parent = row
				rnd(bindFrame, 4)

				local bLay = Instance.new("UIListLayout")
				bLay.FillDirection = Enum.FillDirection.Horizontal
				bLay.VerticalAlignment = Enum.VerticalAlignment.Center
				bLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
				bLay.Parent = bindFrame

				bindLbl = Instance.new("TextLabel")
				bindLbl.Name = "BindLbl"
				bindLbl.Size = UDim2.new(1, 0, 1, 0)
				bindLbl.BackgroundTransparency = 1
				bindLbl.Text = modData.bind or "None"
				bindLbl.TextColor3 = modData.on and ac or Color3.fromRGB(130, 130, 140)
				bindLbl.TextTransparency = 1
				bindLbl.TextSize = 9
				bindLbl.Font = Enum.Font.MontserratBold
				bindLbl.TextXAlignment = Enum.TextXAlignment.Center
				bindLbl.Parent = bindFrame

				tw(row, {Size = UDim2.new(1, 0, 0, 26)}, 0.22)
				tw(dot, {BackgroundTransparency = 0}, 0.22)
				tw(nameLabel, {TextTransparency = 0}, 0.22)
				tw(bindFrame, {BackgroundTransparency = 0}, 0.22)
				tw(bindLbl, {TextTransparency = 0}, 0.22)
			else
				row:SetAttribute("Removing", nil)
				row.LayoutOrder = idx
				dot = row:FindFirstChild("StatusDot")
				bindFrame = row:FindFirstChild("BindFrame")
				local nameLabel = row:FindFirstChildOfClass("TextLabel")
				if bindFrame then
					bindLbl = bindFrame:FindFirstChild("BindLbl")
					if bindLbl then
						bindLbl.Text = modData.bind or "None"
					end
				end
				tw(row, {Size = UDim2.new(1, 0, 0, 26)}, 0.22)
				if dot then
					tw(dot, {BackgroundTransparency = 0, BackgroundColor3 = modData.on and ac or Color3.fromRGB(60, 60, 70)}, 0.22)
				end
				if nameLabel then
					tw(nameLabel, {TextColor3 = modData.on and Color3.fromRGB(225, 225, 230) or Color3.fromRGB(130, 130, 140), TextTransparency = 0}, 0.22)
				end
				if bindFrame then
					tw(bindFrame, {BackgroundTransparency = 0}, 0.22)
				end
				if bindLbl then
					tw(bindLbl, {TextColor3 = modData.on and ac or Color3.fromRGB(130, 130, 140), TextTransparency = 0}, 0.22)
				end
			end
			listH = listH + 32
		end
		local targetH = 36 + (activeCount * 32) + 8
		if activeCount > 0 then
			if bindsTopSep then
				bindsTopSep.Visible = true
			end
			local bindsListMod
			for _, m in ipairs(_qkaspq_store.Modules["Settings"] or {}) do
				if m.name == "Binds List" then
					bindsListMod = m
					break
				end
			end
			if bindsListMod and bindsListMod.on then
				bindsWin.Visible = true
			end
		else
			if bindsTopSep then
				bindsTopSep.Visible = false
			end
			bindsWin.Visible = false
		end
		tw(bindsWin, {Size = UDim2.new(0, 220, 0, math.clamp(targetH, 40, 500))}, 0.25)
		bindsScroll.CanvasSize = UDim2.new(0, 0, 0, listH)
	end
	local function loadTab(idx, searchFilter)
		recreateColumns()
		local tabDef = self.tabDefs[idx]
		if not tabDef then
			return
		end
		if tabDef.customCallback then
			for _, child in pairs(colScroll:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end
			self.columns = {}
			pcall(tabDef.customCallback, colScroll)
			return
		end
		local mods = _qkaspq_store.Modules[tabDef.id]
		if not mods then
			return
		end
		local visibleCount = 0
		for i, mod in ipairs(mods) do
			local matchesSearch = true
			if searchFilter and searchFilter ~= "" then
				local cleanQuery = string.lower(string.gsub(searchFilter, "^%s*(.-)%s*$", "%1"))
				if cleanQuery ~= "" then
					local nameMatch = string.find(string.lower(mod.name), cleanQuery, 1, true) ~= nil
					local descMatch = mod.desc and string.find(string.lower(mod.desc), cleanQuery, 1, true) ~= nil
					local optMatch = false
					if mod.opts then
						for _, opt in ipairs(mod.opts) do
							if opt.label and string.find(string.lower(opt.label), cleanQuery, 1, true) ~= nil then
								optMatch = true
								break
							end
							if opt.desc and string.find(string.lower(opt.desc), cleanQuery, 1, true) ~= nil then
								optMatch = true
								break
							end
						end
					end
					matchesSearch = nameMatch or descMatch or optMatch
				end
			end
			if matchesSearch then
				visibleCount = visibleCount + 1
				local colIdx = ((visibleCount - 1) % 2) + 1
				buildCard(mod, colIdx, visibleCount)
			end
		end
		updateScrollCanvasSize()
		if tabDef.id == "Movement" and updateSpeedOptions then
			pcall(updateSpeedOptions)
		end
	end

	local function setTab(idx)
		_qkaspq_store.ActiveTab = idx
		activeTabTitle.Text = self.tabDefs[idx] and self.tabDefs[idx].id or ""
		for i, data in ipairs(self.tabBtns) do
			if i == idx then
				tw(data.btn, {BackgroundColor3 = ac, BackgroundTransparency = 0.9}, 0.22)
				tw(data.icon, {ImageColor3 = ac}, 0.22)
				tw(data.lbl, {TextColor3 = ac}, 0.22)
			else
				tw(data.btn, {BackgroundTransparency = 1}, 0.22)
				tw(data.icon, {ImageColor3 = cl.dim}, 0.22)
				tw(data.lbl, {TextColor3 = cl.dim}, 0.22)
			end
		end
		if _qkaspq_store.FirstLoad then
			_qkaspq_store.FirstLoad = false
			loadTab(idx, searchBox.Text)
		else
			tw(columnsGroup, {GroupTransparency = 1}, 0.15)
			task.delay(0.15, function()
				if _qkaspq_store.ActiveTab == idx then
					loadTab(idx, searchBox.Text)
					tw(columnsGroup, {GroupTransparency = 0}, 0.22)
				end
			end)
		end
	end

	for i, data in ipairs(self.tabBtns) do
		data.btn.MouseButton1Click:Connect(function()
			setTab(i)
		end)
	end

	_qkaspq_store.ActiveTab = 1
	_qkaspq_store.FirstLoad = true
	setTab(1)

	buildBindsList()
	regConn(UIS.InputBegan:Connect(function(input, gpe)
		if gpe then
			return
		end
		if input.KeyCode == _qkaspq_store.ToggleKey then
			_qkaspq_store.Open = not _qkaspq_store.Open
			if _qkaspq_store.Open then
				main.Visible = true
				mainScale.Scale = 0.88
				main.GroupTransparency = 1
				tw(mainScale, {Scale = 1}, 0.3)
				tw(main, {GroupTransparency = 0}, 0.3)
			else
				tw(mainScale, {Scale = 0.88}, 0.25)
				tw(main, {GroupTransparency = 1}, 0.25)
				tooltip.Visible = false
				currentHoveredMod = nil
				task.delay(0.25, function()
					if not _qkaspq_store.Open then
						main.Visible = false
					end
				end)
			end
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			local key = input.KeyCode.Name
			for tabId, mods in pairs(_qkaspq_store.Modules) do
				for _, mod in ipairs(mods) do
					if mod.bind ~= "None" and mod.bind == key then
						mod.on = not mod.on
						if mod.callback then
							pcall(mod.callback, mod.on)
						end
						triggerBindRefresh()
						if self.currentLanguage == "ENG" then
							self:Notify("Module <font color=\"rgb(255, 255, 255)\">" .. mod.name .. "</font> was " .. (mod.on and "<font color=\"rgb(80, 220, 100)\">enabled</font>" or "<font color=\"rgb(240, 80, 80)\">disabled</font>") .. " by key <font color=\"rgb(120, 110, 250)\">" .. key .. "</font>", BIND_ICON)
						else
							self:Notify("Модуль <font color=\"rgb(255, 255, 255)\">" .. mod.name .. "</font> " .. (mod.on and "<font color=\"rgb(80, 220, 100)\">включен</font>" or "<font color=\"rgb(240, 80, 80)\">выключен</font>") .. " клавишей <font color=\"rgb(120, 110, 250)\">" .. key .. "</font>", BIND_ICON)
						end
						if mod.name == "Music GUI" then
							updateMusicGui()
						end
					end
				end
			end
		end
	end))

	main.Size = UDim2.new(0, 680, 0, 480)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.GroupTransparency = 1
	columnsGroup.GroupTransparency = 0
	bindsWin.Size = UDim2.new(0, 220, 0, 40)
	bindsWin.Position = UDim2.new(0.85, 0, 0.35, 0)
	bindsWin.Visible = false
	mainScale.Scale = 0.88
	bindsScale.Scale = 0
	for i = 1, 3 do
		game:GetService("RunService").RenderStepped:Wait()
	end
	tw(main, {GroupTransparency = 0}, 0.4)
	tw(mainScale, {Scale = 1}, 0.4)
	pcall(function()
		updateArrayList()
	end)
end
function _qkaspq:CreateTab(tabId, icon, customCallback)
	local tabIndex = #self.tabDefs + 1
	self.tabDefs[tabIndex] = {id = tabId, icon = icon, customCallback = customCallback}
	_qkaspq_store.Modules[tabId] = _qkaspq_store.Modules[tabId] or {}
end
function _qkaspq:CreateModule(tabId, moduleData)
	_qkaspq_store.Modules[tabId] = _qkaspq_store.Modules[tabId] or {}
	table.insert(_qkaspq_store.Modules[tabId], moduleData)
end
function _qkaspq:SetModuleState(tabId, moduleName, isOn)
	local tab = _qkaspq_store.Modules[tabId]
	if not tab then
		return
	end
	local mod
	for _, m in ipairs(tab) do
		if m.name == moduleName or m.originalName == moduleName then
			mod = m
			break
		end
	end
	if not mod then
		return
	end
	mod.on = isOn
	if mod.ui_togBg then
		tw(mod.ui_togBg, {BackgroundColor3 = isOn and ac or cl.tog_off}, 0.18)
	end
	if mod.ui_togDot then
		tw(mod.ui_togDot, {Position = isOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.18)
	end
	if mod.ui_modIcon then
		tw(mod.ui_modIcon, {ImageColor3 = isOn and ac or cl.dim}, 0.18)
	end
	if mod.callback then
		pcall(mod.callback, isOn)
	end
	if triggerBindRefresh then
		pcall(triggerBindRefresh)
	end
	if self.currentLanguage == "ENG" then
		self:Notify("Module <font color=\"rgb(255, 255, 255)\">" .. mod.name .. "</font> is now " .. (isOn and "<font color=\"rgb(80, 220, 100)\">enabled</font>" or "<font color=\"rgb(240, 80, 80)\">disabled</font>"), MOD_ICON)
	else
		self:Notify("Модуль <font color=\"rgb(255, 255, 255)\">" .. mod.name .. "</font> " .. (isOn and "<font color=\"rgb(80, 220, 100)\">включен</font>" or "<font color=\"rgb(240, 80, 80)\">выключен</font>"), MOD_ICON)
	end
	if mod.name == "Music GUI" and updateMusicGui then
		pcall(updateMusicGui)
	end
	if mod.name == "Arraylist" and updateArrayList then
		pcall(updateArrayList)
	end
	if mod.name == "Target Hud" and updateTargetHud then
	end
end
function _qkaspq:SetOption(tabId, moduleName, optionLabel, newValue)
	local tab = _qkaspq_store.Modules[tabId]
	if not tab then
		return
	end
	local mod
	for _, m in ipairs(tab) do
		if m.name == moduleName or m.originalName == moduleName then
			mod = m
			break
		end
	end
	if not mod or not mod.opts then
		return
	end
	local opt
	for _, o in ipairs(mod.opts) do
		if o.label == optionLabel or o.originalLabel == optionLabel then
			opt = o
			break
		end
	end
	if not opt then
		return
	end
	if opt.type == "checkbox" then
		opt.value = newValue
		if opt.ui_box then
			tw(opt.ui_box, {BackgroundColor3 = newValue and ac or cl.check}, 0.15)
		end
		if opt.ui_checkIcon then
			tw(opt.ui_checkIcon, {ImageTransparency = newValue and 0 or 1}, 0.15)
		end
		if opt.callback then
			pcall(opt.callback, newValue)
		end
	elseif opt.type == "slider" then
		opt.value = newValue
		if opt.ui_fill and opt.ui_knob and opt.ui_track then
			local pct = math.clamp((newValue - opt.min) / (opt.max - opt.min), 0, 1)
			tw(opt.ui_fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.08)
			tw(opt.ui_knob, {Position = UDim2.new(pct, -4, 0.5, -4)}, 0.08)
		end
		if opt.ui_valText then
			opt.ui_valText.Text = tostring(newValue) .. (opt.suffix or "")
		end
		if opt.callback then
			pcall(opt.callback, newValue)
		end
	elseif opt.type == "dropdown" then
		opt.value = newValue
		if opt.ui_val then
			opt.ui_val.Text = newValue
		end
		if opt.ui_optList then
			for _, ch in pairs(opt.ui_optList:GetChildren()) do
				if ch:IsA("TextButton") then
					local match = (ch.Text == newValue)
					tw(ch, {TextColor3 = match and ac2 or Color3.fromRGB(200, 200, 205)}, 0.12)
				end
			end
		end
		if opt.callback then
			pcall(opt.callback, newValue)
		end
	elseif opt.type == "multiselect" then
		opt.value = newValue
		if opt.ui_activeSelections then
			table.clear(opt.ui_activeSelections)
			for item in string.gmatch(newValue, "[^,%s]+") do
				opt.ui_activeSelections[item] = true
			end
		end
		if opt.ui_updateDisplayValue then
			pcall(opt.ui_updateDisplayValue)
		end
		if opt.ui_optList then
			local activeSelections = opt.ui_activeSelections or {}
			for _, ch in pairs(opt.ui_optList:GetChildren()) do
				if ch:IsA("TextButton") then
					local isSel = activeSelections[ch.Text]
					tw(ch, {TextColor3 = isSel and ac2 or Color3.fromRGB(200, 200, 205)}, 0.12)
				end
			end
		end
		if opt.callback then
			pcall(opt.callback, newValue)
		end
	elseif opt.type == "colorpicker" then
		opt.color = newValue
		if opt.ui_box then
			opt.ui_box.BackgroundColor3 = newValue
		end
		if opt.ui_svFrame and opt.ui_svCursor and opt.ui_hueCursor then
			local currentH, currentS, currentV = Color3.toHSV(newValue)
			opt.ui_svCursor.Position = UDim2.new(currentS, 0, 1 - currentV, 0)
			opt.ui_hueCursor.Position = UDim2.new(currentH, -2, 0, -2)
			opt.ui_svFrame.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1)
		end
		if opt.callback then
			pcall(opt.callback, newValue, opt.value)
		end
	end
	if triggerBindRefresh then
		pcall(triggerBindRefresh)
	end
end
function _qkaspq:SetOptionLabel(tabId, moduleName, optionLabel, newLabel)
	local tab = _qkaspq_store.Modules[tabId]
	if not tab then
		return
	end
	local mod
	for _, m in ipairs(tab) do
		if m.name == moduleName or m.originalName == moduleName then
			mod = m
			break
		end
	end
	if not mod or not mod.opts then
		return
	end
	local opt
	for _, o in ipairs(mod.opts) do
		if o.label == optionLabel or o.originalLabel == optionLabel then
			opt = o
			break
		end
	end
	if not opt then
		return
	end
	opt.label = newLabel
	if opt.ui_label then
		opt.ui_label.Text = newLabel
	end
end
function _qkaspq:SetWatermarkTitle(text)
	_qkaspq_store.WatermarkTitle = text
	if wmText then
		wmText.Text = text
	end
end
function _qkaspq:SetPlaylist(list)
	Playlist = list
	currentTrackIdx = 1
end
function _qkaspq:SetModuleLabel(tabId, moduleName, newLabel)
	local tab = _qkaspq_store.Modules[tabId]
	if not tab then return end
	local mod
	for _, m in ipairs(tab) do
		if m.name == moduleName or m.originalName == moduleName then mod = m break end
	end
	if not mod then return end
	mod.name = newLabel
	mod.originalName = mod.originalName or mod.name
	if mod.ui_nameLabel then mod.ui_nameLabel.Text = newLabel end
	if mod.ui_card then mod.ui_card.Name = newLabel end
	if triggerBindRefresh then pcall(triggerBindRefresh) end
end
function _qkaspq:AddTheme(themeName, themeData)
	themes[themeName] = themeData
	if not table.find(themeList, themeName) then
		table.insert(themeList, themeName)
	end
end
function _qkaspq:SetTheme(themeName)
	applyTheme(themeName)
end
function _qkaspq:SetWatermark(opts)
	opts = opts or {}
	if opts.title then
		_qkaspq_store.WatermarkTitle = opts.title
		if mainSubtitle then mainSubtitle.Text = opts.title end
	end
	if opts.visible ~= nil then
		_qkaspq_store.WatermarkVisible = opts.visible
	end
end
function _qkaspq:SetWatermarkVisible(v)
	_qkaspq_store.WatermarkVisible = v
end
function _qkaspq:SetProfile(opts)
	opts = opts or {}
	if not profFrame then return end
	if opts.visible == false then
		profFrame.Visible = false
		return
	end
	profFrame.Visible = true
	if opts.name then
		profName.Text = opts.name
	else
		profName.Text = (lp.DisplayName ~= "" and lp.DisplayName ~= lp.Name) and lp.DisplayName or lp.Name
	end
	if opts.subtitle and opts.subtitle ~= "" then
		profSub.Text = opts.subtitle
		profSub.Visible = true
	else
		profSub.Visible = false
	end
	if opts.avatar then
		profAvatar.Image = opts.avatar
	else
		pcall(function()
			profAvatar.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
	end
end
function _qkaspq:GetOption(tabId, moduleName, optionLabel)
	local tab = _qkaspq_store.Modules[tabId]
	if not tab then return nil end
	for _, m in ipairs(tab) do
		if m.name == moduleName or m.originalName == moduleName then
			if m.opts then
				for _, o in ipairs(m.opts) do
					if o.label == optionLabel or o.originalLabel == optionLabel then
						return o.value, o
					end
				end
			end
		end
	end
	return nil
end
function _qkaspq:Destroy()
if gui then pcall(function() gui:Destroy() end) end
if bindsWin and bindsWin.Parent and bindsWin.Parent ~= gui then pcall(function() bindsWin.Parent:Destroy() end) end
	for _, conn in ipairs(_qkaspq_store.Connections or {}) do
		pcall(function() conn:Disconnect() end)
	end
	_qkaspq_store.Connections = {}
end
_qkaspq:CreateTab("Settings", "rbxassetid://7059346373")
_qkaspq:CreateModule("Settings", {
	name = "Notify",
	on = true,
	bind = "None",
	nobind = true,
	desc = "Configure popup notifications.",
	opts = {
		{type = "slider", label = "Duration", value = 3, min = 1, max = 10, suffix = "s"},
		{type = "slider", label = "Volume", value = 50, min = 0, max = 100, suffix = "%"},
		{type = "dropdown", label = "Sound", value = "Default", list = {"Default", "Telegram", "iPhone", "Misc", "Windows 11"}},
		{type = "dropdown", label = "Location", value = "Right", list = {"Right", "Left", "Center", "Cursor"}},
		{type = "button", label = "Test Sound", callback = function()
			local enabled, duration, soundId, volume = getNotifySettings()
			pcall(function()
				local s = Instance.new("Sound")
				s.SoundId = soundId
				s.Volume = volume
				s.Parent = game:GetService("SoundService")
				s:Play()
				s.Ended:Connect(function() s:Destroy() end)
			end)
		end}
	}
})
_qkaspq:CreateModule("Settings", {
	name = "Binds List",
	on = false,
	bind = "None",
	nobind = true,
	desc = "Show keybinds window.",
	callback = function(val)
		if bindsWin then
			bindsWin.Visible = val
			if val then
				bindsScale.Scale = 0
				tw(bindsScale, {Scale = 1}, 0.22)
			else
				tw(bindsScale, {Scale = 0}, 0.18)
			end
		end
	end
})
_qkaspq:CreateModule("Settings", {
	name = "Music GUI",
	on = false,
	bind = "None",
	nobind = true,
	beta = true,
	desc = "Music player GUI.",
	opts = {
		{
			type = "textbox",
			label = "Add Music ID",
			value = "",
			placeholder = "Enter Audio ID...",
			callback = function(text, enter)
				if enter and text ~= "" then
					local clean = string.gsub(text, "%D", "")
					local id = tonumber(clean)
					if id then
						local trackName = "Custom ID (" .. id .. ")"
						table.insert(Playlist, {name = trackName, id = "rbxassetid://" .. id})
						if musicSound then
							local nextIdx = #Playlist
							currentTrackIdx = nextIdx
							musicSound:Stop()
							musicSound.SoundId = Playlist[currentTrackIdx].id
							local trackTitle = musicGuiInstance and musicGuiInstance:FindFirstChild("TrackTitle", true)
							if trackTitle then
								trackTitle.Text = Playlist[currentTrackIdx].name
							end
							musicSound:Play()
							local playBtn = musicGuiInstance and musicGuiInstance:FindFirstChild("PlayBtn", true)
							if playBtn then
								playBtn.Image = "rbxassetid://94079325461679"
							end
						end
					end
				end
			end
		}
	},
	callback = function(val)
		if updateMusicGui then updateMusicGui() end
	end
})
_qkaspq:CreateModule("Settings", {
	name = "Arraylist",
	on = false,
	bind = "None",
	nobind = true,
	desc = "Show active modules on screen.",
	opts = {
		{type = "dropdown", label = "Location", value = "Right", list = {"Left", "Right"}, callback = function()
			if updateArrayList then updateArrayList() end
		end},
	},
	callback = function(val)
		if updateArrayList then updateArrayList() end
	end
})
_qkaspq:CreateModule("Settings", {
	name = "UI Customization",
	on = true,
	bind = "None",
	nobind = true,
	desc = "Adjust visual themes and transparency.",
	opts = {
		{
			type = "dropdown",
			label = "UI Theme",
			value = "Default",
			list = themeList,
			callback = function(val)
				applyTheme(val)
			end
		},
		{
			type = "slider",
			label = "UI Transparency",
			value = 0,
			min = 0,
			max = 80,
			suffix = "%",
			callback = function(val)
				applyTransparency(val / 100)
			end
		}
	}
})
return _qkaspq
