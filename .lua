local _qkaspq = loadstring(game:HttpGet("https://raw.githubusercontent.com/KaspikScriptsRb/qkaspq-s-ui-library-opensrc/refs/heads/main/.lua"))()
local _0xlp = game:GetService("Players").LocalPlayer
local _0xrunning = false
local _0xdelay = 0.5
local _0xftype = "Whitelist"
local _0xflist = ""
local function _0xallowed(_0xseed)
	local _0xset = {}
	for _0xs in (_0xflist .. ","):gmatch("([^,]+),") do
		_0xset[_0xs:match("^%s*(.-)%s*$")] = true
	end
	if _0xftype == "Whitelist" then
		return _0xset[_0xseed] == true
	end
	return _0xset[_0xseed] == nil
end
_qkaspq:CreateTab("Main", "rbxassetid://13060262529")
_qkaspq:CreateModule("Main", {
	name = "Auto Harvest",
	on = false,
	bind = "None",
	desc = "Auto-harvests fruits from your own garden.",
	callback = function(_0xval)
		_0xrunning = _0xval
		if _0xval then
			task.spawn(function()
				while _0xrunning do
					local _0xgardens = workspace:FindFirstChild("Gardens")
					if _0xgardens then
						for _, _0xplot in ipairs(_0xgardens:GetChildren()) do
							local _0xowner = _0xplot:GetAttribute("Owner")
							local _0xownerid = _0xplot:GetAttribute("OwnerUserId")
							local _0xmatch = (_0xowner == _0xlp.Name or _0xowner == _0xlp.DisplayName) or (_0xownerid == _0xlp.UserId)
							if _0xmatch then
								local _0xplants = _0xplot:FindFirstChild("Plants")
								if _0xplants then
									for _, _0xplant in ipairs(_0xplants:GetChildren()) do
										local _0xfruits = _0xplant:FindFirstChild("Fruits")
										if _0xfruits then
											for _, _0xfruit in ipairs(_0xfruits:GetChildren()) do
												local _0xseed = _0xfruit:GetAttribute("SeedName")
												if _0xallowed(_0xseed) then
													local _0xhp = _0xfruit:FindFirstChild("HarvestPart")
													if _0xhp then
														local _0xprompt = _0xhp:FindFirstChild("HarvestPrompt")
														if _0xprompt then
															pcall(fireproximityprompt, _0xprompt)
														end
													end
												end
											end
										else
											local _0xseed = _0xplant:GetAttribute("SeedName")
											if _0xallowed(_0xseed) then
												local _0xhp = _0xplant:FindFirstChild("HarvestPart")
												if _0xhp then
													local _0xprompt = _0xhp:FindFirstChild("HarvestPrompt")
													if _0xprompt then
														pcall(fireproximityprompt, _0xprompt)
													end
												end
											end
										end
									end
								end
							end
						end
					end
					task.wait(_0xdelay)
				end
			end)
		end
	end,
	opts = {
		{type = "slider", label = "Delay", value = 5, min = 0, max = 10, suffix = "s", callback = function(_0xv)
			_0xdelay = _0xv / 10
		end},
		{type = "dropdown", label = "Filter Type", value = "Whitelist", list = {"Whitelist","Blacklist"}, callback = function(_0xv)
			_0xftype = _0xv
		end},
		{type = "multiselect", label = "Filter Fruits", value = "", list = {"Carrot","Blueberry","Strawberry","Apple","Tomato","Tulip","Baby Cactus","Bamboo","Cactus","Corn","Horned Melon","Pineapple","Banana","Coconut","Glow Mushroom","Grape","Green Bean","Mango","Mushroom","Acorn","Cherry","Dragon Fruit","Poison Ivy","Sunflower","Ghost Pepper","Poison Apple","Pomegranate","Venom Spitter","Venus Fly Trap","Dragon's Breath","Hypno Bloom","Moon Bloom","Briar Rose","Romanesco","Beanstalk","Bone Blossom","Buttercup","Lotus","Magic Beanstalk","PartFruit","Pinetree","Pumpkin","Thorn Rose"}, callback = function(_0xv)
			_0xflist = _0xv
		end},
	}
})
local _0xsellrunning = false
local _0xselldelay = 5
local _0xsellev = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Packet"):WaitForChild("RemoteEvent")
local _0xsellpk = buffer.fromstring("\175\000\021")
local function _0xdosell()
	pcall(function() _0xsellev:FireServer(_0xsellpk) end)
end
_qkaspq:CreateModule("Main", {
	name = "Auto Sell",
	on = false,
	bind = "None",
	desc = "Automatically sells your harvest.",
	callback = function(_0xval)
		_0xsellrunning = _0xval
		if _0xval then
			task.spawn(function()
				while _0xsellrunning do
					_0xdosell()
					task.wait(_0xselldelay)
				end
			end)
		end
	end,
	opts = {
		{type = "slider", label = "Sell Delay", value = 5, min = 1, max = 60, suffix = "s", callback = function(_0xv)
			_0xselldelay = _0xv
		end},
		{type = "button", label = "Sell Now", callback = function()
			_0xdosell()
		end},
	}
})
local _0xbuyrunning = false
local _0xbuydelay = 3
local _0xbuylist = ""
local function _0xmakebuypkt(_0xseed)
	local _0xid = _0xsellev:GetAttribute("PurchaseSeed")
	if not _0xid then return nil end
	local _0xbuf = buffer.create(3 + #_0xseed)
	buffer.writeu16(_0xbuf, 0, _0xid)
	buffer.writeu8(_0xbuf, 2, #_0xseed)
	for _0xi = 1, #_0xseed do
		buffer.writeu8(_0xbuf, 2 + _0xi, string.byte(_0xseed, _0xi))
	end
	return _0xbuf
end
local function _0xdobuy()
	for _0xs in (_0xbuylist .. ","):gmatch("([^,]+),") do
		local _0xseed = _0xs:match("^%s*(.-)%s*$")
		local _0xpkt = _0xmakebuypkt(_0xseed)
		if _0xpkt then
			pcall(function() _0xsellev:FireServer(_0xpkt) end)
		end
		task.wait(0.15)
	end
end
_qkaspq:CreateTab("Auto Buy", "rbxassetid://13429538917")
_qkaspq:CreateModule("Auto Buy", {
	name = "Seeds",
	on = false,
	bind = "None",
	desc = "Automatically purchases seeds from the shop.",
	callback = function(_0xval)
		_0xbuyrunning = _0xval
		if _0xval then
			task.spawn(function()
				while _0xbuyrunning do
					_0xdobuy()
					task.wait(_0xbuydelay)
				end
			end)
		end
	end,
	opts = {
		{type = "slider", label = "Buy Delay", value = 3, min = 1, max = 30, suffix = "s", callback = function(_0xv)
			_0xbuydelay = _0xv
		end},
		{type = "multiselect", label = "Select Seeds", value = "", list = {"Carrot","Blueberry","Strawberry","Apple","Pumpkin","Tomato","Tulip","Bamboo","Cactus","Corn","Pineapple","Banana","Coconut","Grape","Green Bean","Mango","Mushroom","Acorn","Cherry","Dragon Fruit","Poison Ivy","Sunflower","Beanstalk","Lotus","Poison Apple","Pomegranate","Romanesco","Venom Spitter","Venus Flytrap","Dragon's Breath","Hypno Bloom","Moon Bloom","Thorn Rose"}, callback = function(_0xv)
			_0xbuylist = _0xv
		end},
		{type = "button", label = "Buy Now", callback = function()
			_0xdobuy()
		end},
	}
})
local _0xgearrunning = false
local _0xgeardelay = 3
local _0xgearlist = ""
local function _0xmakegearpkt(_0xgear)
	local _0xid = _0xsellev:GetAttribute("PurchaseGear")
	if not _0xid then return nil end
	local _0xbuf = buffer.create(3 + #_0xgear)
	buffer.writeu16(_0xbuf, 0, _0xid)
	buffer.writeu8(_0xbuf, 2, #_0xgear)
	for _0xi = 1, #_0xgear do
		buffer.writeu8(_0xbuf, 2 + _0xi, string.byte(_0xgear, _0xi))
	end
	return _0xbuf
end
local function _0xdogear()
	for _0xs in (_0xgearlist .. ","):gmatch("([^,]+),") do
		local _0xgear = _0xs:match("^%s*(.-)%s*$")
		local _0xpkt = _0xmakegearpkt(_0xgear)
		if _0xpkt then
			pcall(function() _0xsellev:FireServer(_0xpkt) end)
		end
		task.wait(0.15)
	end
end
_qkaspq:CreateModule("Auto Buy", {
	name = "Gear",
	on = false,
	bind = "None",
	desc = "Automatically purchases gear from the shop.",
	callback = function(_0xval)
		_0xgearrunning = _0xval
		if _0xval then
			task.spawn(function()
				while _0xgearrunning do
					_0xdogear()
					task.wait(_0xgeardelay)
				end
			end)
		end
	end,
	opts = {
		{type = "slider", label = "Buy Delay", value = 3, min = 1, max = 30, suffix = "s", callback = function(_0xv)
			_0xgeardelay = _0xv
		end},
		{type = "multiselect", label = "Select Gear", value = "", list = {"Common Sprinkler","Common Watering Can","Sign","Uncommon Sprinkler","Jump Mushroom","Megaphone","Rare Sprinkler","Speed Mushroom","Trowel","Basic Pot","Gnome","Shrink Mushroom","Supersize Mushroom","Invisibility Mushroom","Legendary Sprinkler","Teleporter","Wheelbarrow","Grappling Hook","Strawberry Sniper","Super Sprinkler","Super Watering Can"}, callback = function(_0xv)
			_0xgearlist = _0xv
		end},
		{type = "button", label = "Buy Now", callback = function()
			_0xdogear()
		end},
	}
})
local _0xproprunning = false
local _0xpropdelay = 3
local _0xproplist = ""
local function _0xmakeproppkt(_0xprop)
	local _0xid = _0xsellev:GetAttribute("PurchaseCrate")
	if not _0xid then return nil end
	local _0xbuf = buffer.create(3 + #_0xprop)
	buffer.writeu16(_0xbuf, 0, _0xid)
	buffer.writeu8(_0xbuf, 2, #_0xprop)
	for _0xi = 1, #_0xprop do
		buffer.writeu8(_0xbuf, 2 + _0xi, string.byte(_0xprop, _0xi))
	end
	return _0xbuf
end
local function _0xdoprop()
	for _0xs in (_0xproplist .. ","):gmatch("([^,]+),") do
		local _0xprop = _0xs:match("^%s*(.-)%s*$")
		local _0xpkt = _0xmakeproppkt(_0xprop)
		if _0xpkt then
			pcall(function() _0xsellev:FireServer(_0xpkt) end)
		end
		task.wait(0.15)
	end
end
_qkaspq:CreateModule("Auto Buy", {
	name = "Props",
	on = false,
	bind = "None",
	desc = "Automatically purchases props/crates from the shop.",
	callback = function(_0xval)
		_0xproprunning = _0xval
		if _0xval then
			task.spawn(function()
				while _0xproprunning do
					_0xdoprop()
					task.wait(_0xpropdelay)
				end
			end)
		end
	end,
	opts = {
		{type = "slider", label = "Buy Delay", value = 3, min = 1, max = 30, suffix = "s", callback = function(_0xv)
			_0xpropdelay = _0xv
		end},
		{type = "multiselect", label = "Select Props", value = "", list = {"Ladder Crate","Bench Crate","Light Crate","Sign Crate","Arch Crate","Roleplay Crate","Picture Frame Crate","Bridge Crate","SpringSeesaw Crate","Conveyor Crate","Owner Door Crate","Bear Trap Crate","Fence Crate","Teleporter Pad Crate"}, callback = function(_0xv)
			_0xproplist = _0xv
		end},
		{type = "button", label = "Buy Now", callback = function()
			_0xdoprop()
		end},
	}
})
local _0xcycle = 600
local _0xmoons = {
	{Name = "Rainbow Moon", Chance = 6},
	{Name = "Goldmoon", Chance = 13},
	{Name = "Bloodmoon", Chance = 2},
	{Name = "Moon", Chance = 79},
}
local _0xpredHours = 24
local function _0xgetmoon(_0xcid, _0xord)
	local _0xrng = Random.new(_0xcid * 1000 + _0xord)
	local _0xroll = _0xrng:NextNumber() * 100
	local _0xacc = 0
	for _, _0xm in ipairs(_0xmoons) do
		_0xacc = _0xacc + _0xm.Chance
		if _0xroll <= _0xacc then return _0xm.Name end
	end
	return "Moon"
end
local function _0xrunpredict()
	local _0xnow = os.time()
	local _0xend = _0xnow + (_0xpredHours * 3600)
	local _0xfirst = nil
	for _0xt = _0xnow, _0xend, _0xcycle do
		local _0xcid = math.floor(_0xt / _0xcycle)
		local _0xmoon = _0xgetmoon(_0xcid, 3)
		local _0xts = os.date("%H:%M", _0xt)
		if not _0xfirst and _0xmoon ~= "Moon" then
			_0xfirst = {time = _0xts, name = _0xmoon}
		end
		print(string.format("[%s] CycleID: %d | Moon: %s", _0xts, _0xcid, _0xmoon))
	end
	if _0xfirst then
		_qkaspq:Notify("Next rare: " .. _0xfirst.name .. " at " .. _0xfirst.time, "rbxassetid://16000149927")
	else
		_qkaspq:Notify("No rare moons in next " .. _0xpredHours .. "h", "rbxassetid://16000149927")
	end
end
local function _0xbuildpredopts()
	local _0xitems = {}
	local _0xnow = os.time()
	local _0xend = _0xnow + (24 * 3600)
	for _0xt = _0xnow, _0xend, _0xcycle do
		local _0xcid = math.floor(_0xt / _0xcycle)
		local _0xmoon = _0xgetmoon(_0xcid, 3)
		if _0xmoon ~= "Moon" then
			local _0xts = os.date("%H:%M", _0xt)
			table.insert(_0xitems, _0xts .. "  —  " .. _0xmoon)
		end
	end
	if #_0xitems == 0 then
		table.insert(_0xitems, "No rare moons in the next 24h")
	end
	if updatePredWin then
		pcall(updatePredWin, _0xitems)
	end
	return {{type = "predlist", label = "Upcoming Events (24h)", items = _0xitems, maxHeight = 180}}
end

local cl = {
	bg = Color3.fromRGB(8, 8, 12),
	topbar = Color3.fromRGB(14, 14, 18),
	card = Color3.fromRGB(16, 16, 21),
	sep = Color3.fromRGB(26, 26, 32)
}
local ac = Color3.fromRGB(82, 70, 210)
local TS = game:GetService("TweenService")

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
	s.Color = col or Color3.fromRGB(30, 30, 35)
	s.Thickness = th or 1
	s.Transparency = 0.35
	s.Parent = p
end

local function pad(p, t, b, l, r)
	local pd = Instance.new("UIPadding")
	pd.PaddingTop = UDim.new(0, t or 0)
	pd.PaddingBottom = UDim.new(0, b or 0)
	pd.PaddingLeft = UDim.new(0, l or 0)
	pd.PaddingRight = UDim.new(0, r or 0)
	pd.Parent = p
end

local targetParent = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui"):FindFirstChild("ZenithGUI") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local predWin = Instance.new("Frame")
predWin.Size = UDim2.new(0, 220, 0, 40)
predWin.AnchorPoint = Vector2.new(0.5, 0.5)
predWin.Position = UDim2.new(0.85, 0, 0.65, 0)
predWin.BackgroundColor3 = cl.bg
predWin.BorderSizePixel = 0
predWin.ClipsDescendants = true
predWin.Visible = false
predWin.Parent = targetParent
rnd(predWin, 10)
stk(predWin, Color3.fromRGB(36, 36, 44), 1)

local predScale = Instance.new("UIScale")
predScale.Scale = 1
predScale.Parent = predWin

local predTopbar = Instance.new("Frame")
predTopbar.Size = UDim2.new(1, 0, 0, 40)
predTopbar.BackgroundColor3 = cl.topbar
predTopbar.BorderSizePixel = 0
predTopbar.Parent = predWin
local predTopbarRound = Instance.new("UICorner")
predTopbarRound.CornerRadius = UDim.new(0, 10)
predTopbarRound.Parent = predTopbar

local predTopbarCover = Instance.new("Frame")
predTopbarCover.Size = UDim2.new(1, 0, 0, 12)
predTopbarCover.Position = UDim2.new(0, 0, 1, -12)
predTopbarCover.BackgroundColor3 = cl.topbar
predTopbarCover.BorderSizePixel = 0
predTopbarCover.Parent = predTopbar

local predTopSep = Instance.new("Frame")
predTopSep.Size = UDim2.new(1, 0, 0, 1)
predTopSep.Position = UDim2.new(0, 0, 1, -1)
predTopSep.BackgroundColor3 = cl.sep
predTopSep.BorderSizePixel = 0
predTopSep.Parent = predTopbar

local predTitleIcon = Instance.new("ImageLabel")
predTitleIcon.Size = UDim2.new(0, 14, 0, 14)
predTitleIcon.Position = UDim2.new(0, 12, 0.5, -7)
predTitleIcon.BackgroundTransparency = 1
predTitleIcon.Image = "rbxassetid://16000149927"
predTitleIcon.ImageColor3 = ac
predTitleIcon.ScaleType = Enum.ScaleType.Fit
predTitleIcon.Parent = predTopbar

local predTitle = Instance.new("TextLabel")
predTitle.Size = UDim2.new(1, -40, 1, 0)
predTitle.Position = UDim2.new(0, 32, 0, 0)
predTitle.BackgroundTransparency = 1
predTitle.Text = "Weather Predictions"
predTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
predTitle.TextSize = 12
predTitle.Font = Enum.Font.MontserratBold
predTitle.TextXAlignment = Enum.TextXAlignment.Left
predTitle.Parent = predTopbar

local UIS = game:GetService("UserInputService")
local pDragging, pDragStart, pStartPos
predTopbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		pDragging = true
		pDragStart = input.Position
		pStartPos = predWin.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				pDragging = false
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if pDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local d = input.Position - pDragStart
		predWin.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + d.X, pStartPos.Y.Scale, pStartPos.Y.Offset + d.Y)
	end
end)

local predScroll = Instance.new("ScrollingFrame")
predScroll.Size = UDim2.new(1, 0, 1, -41)
predScroll.Position = UDim2.new(0, 0, 0, 41)
predScroll.BackgroundTransparency = 1
predScroll.BorderSizePixel = 0
predScroll.ScrollBarThickness = 3
predScroll.ScrollBarImageColor3 = ac
predScroll.ScrollBarImageTransparency = 0.5
predScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
predScroll.Parent = predWin

local predListLay = Instance.new("UIListLayout")
predListLay.SortOrder = Enum.SortOrder.LayoutOrder
predListLay.Padding = UDim.new(0, 6)
predListLay.Parent = predScroll
pad(predScroll, 8, 8, 8, 8)

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

local function renderPredWinRow(item, index)
	local rowH = 36
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, rowH)
	row.BackgroundColor3 = cl.card
	row.BorderSizePixel = 0
	row.LayoutOrder = index
	row.Parent = predScroll
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

	local modIcon = Instance.new("ImageLabel")
	modIcon.Size = UDim2.new(0, 14, 0, 14)
	modIcon.Position = UDim2.new(0, 10, 0.5, -7)
	modIcon.BackgroundTransparency = 1
	modIcon.Image = "rbxassetid://16000149927"
	modIcon.ImageColor3 = accentCol
	modIcon.ScaleType = Enum.ScaleType.Fit
	modIcon.Parent = row

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.5, 0, 1, 0)
	lbl.Position = UDim2.new(0, 30, 0, 0)
	lbl.BackgroundTransparency = 1
	local timeStr, moonName = item:match("^(%d%d:%d%d)%s*—%s*(.+)$")
	if not timeStr then
		timeStr = "00:00"
		moonName = item
	end
	lbl.Text = moonName
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = 11
	lbl.Font = Enum.Font.MontserratBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local timeFrame = Instance.new("Frame")
	timeFrame.Name = "TimeFrame"
	timeFrame.Size = UDim2.new(0, 56, 0, 20)
	timeFrame.Position = UDim2.new(1, -66, 0.5, -10)
	timeFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	timeFrame.BorderSizePixel = 0
	timeFrame.Parent = row
	rnd(timeFrame, 5)
	local bStroke = Instance.new("UIStroke")
	bStroke.Color = Color3.fromRGB(36, 36, 44)
	bStroke.Thickness = 1
	bStroke.Parent = timeFrame

	local timeLbl = Instance.new("TextLabel")
	timeLbl.Size = UDim2.new(1, 0, 1, 0)
	timeLbl.BackgroundTransparency = 1
	timeLbl.Text = timeStr
	timeLbl.TextColor3 = accentCol
	timeLbl.TextSize = 9
	timeLbl.Font = Enum.Font.MontserratBold
	timeLbl.TextXAlignment = Enum.TextXAlignment.Center
	timeLbl.Parent = timeFrame

	row.MouseEnter:Connect(function()
		tw(row, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}, 0.15)
	end)
	row.MouseLeave:Connect(function()
		tw(row, {BackgroundColor3 = cl.card}, 0.15)
	end)
end

local function updatePredWin(items)
	predScroll:ClearAllChildren()
	local listLay = Instance.new("UIListLayout")
	listLay.SortOrder = Enum.SortOrder.LayoutOrder
	listLay.Padding = UDim.new(0, 6)
	listLay.Parent = predScroll
	
	local validItems = {}
	for _, item in ipairs(items) do
		if item:find("—") then
			table.insert(validItems, item)
		end
	end

	for i, item in ipairs(validItems) do
		renderPredWinRow(item, i)
	end

	local activeCount = #validItems
	local rowH = 36
	local listH = 8 + (activeCount * 42)
	predScroll.CanvasSize = UDim2.new(0, 0, 0, listH)

	local targetH = 40 + (activeCount * 42)
	if activeCount > 0 then
		targetH = targetH + 10
	end
	if predWin.Visible then
		tw(predWin, {Size = UDim2.new(0, 220, 0, math.clamp(targetH, 40, 500))}, 0.25)
	else
		predWin.Size = UDim2.new(0, 220, 0, math.clamp(targetH, 40, 500))
	end
end

local function togglePredWin(val)
	local currentZenithGUI = game:GetService("CoreGui"):FindFirstChild("ZenithGUI") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ZenithGUI")
	if currentZenithGUI and predWin.Parent ~= currentZenithGUI then
		predWin.Parent = currentZenithGUI
	end
	predWin.Visible = val
	if val then
		predScale.Scale = 0
		tw(predScale, {Scale = 1}, 0.22)
	else
		tw(predScale, {Scale = 0}, 0.18)
	end
end

_qkaspq:CreateTab("Misc", "rbxassetid://10885640682")
_qkaspq:CreateModule("Misc", {
	name = "Weather Prediction",
	on = false,
	bind = "None",
	desc = "Upcoming rare moon events (next 24h, cycle=600s). Toggles the floating window.",
	callback = function(_0xval)
		togglePredWin(_0xval)
	end,
	opts = _0xbuildpredopts()
})
_qkaspq:Init("Casual Hub")
_qkaspq:SetProfile({subtitle = "Developer"})
