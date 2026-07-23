local ZenithLib
if isfile and isfile("ZenithLib.lua") then
	ZenithLib = loadstring(readfile("ZenithLib.lua"))()
else
	ZenithLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/KaspikScriptsRb/qkaspq-s-ui-library-opensrc/refs/heads/main/.lua"))()
end


-- Create tab "Test"
ZenithLib:CreateTab("Test", "rbxassetid://7485051715")

-- Create module "All Elements"
ZenithLib:CreateModule("Test", {
	name = "All Elements",
	on = true,
	bind = "T",
	desc = "Test all possible API elements.",
	opts = {
		{type = "text", label = "<b>Text Element</b> — supports RichText", desc = "Use color = Color3... for coloring"},
		{type = "toggle", label = "Toggle Switch", value = true, callback = function(v) end},
		{type = "checkbox", label = "Checkbox", value = false, callback = function(v) end},
		{type = "slider", label = "Slider", value = 50, min = 0, max = 100, suffix = "%", callback = function(v) end},
		{type = "dropdown", label = "Dropdown", value = "Option A", list = {"Option A", "Option B", "Option C"}, callback = function(v) end},
		{type = "multiselect", label = "Multi-Dropdown", value = "First", list = {"First", "Second", "Third"}, callback = function(v) end},
		{type = "colorpicker", label = "Colorpicker", value = true, color = Color3.fromRGB(120, 110, 250), callback = function(col, enabled) end},
		{type = "textbox", label = "Textbox", value = "", placeholder = "Enter text...", callback = function(text, enter) end},
		{type = "bind", label = "Keybind", key = "None", callback = function(key) end, onActivate = function() end},
		{type = "button", label = "Button — API Test Updates", callback = function()
			ZenithLib:SetOption("Test", "All Elements", "Toggle Switch", false)
			ZenithLib:SetOption("Test", "All Elements", "Checkbox", true)
			ZenithLib:SetOption("Test", "All Elements", "Slider", 88)
			ZenithLib:SetOption("Test", "All Elements", "Dropdown", "Option C")
			ZenithLib:SetOption("Test", "All Elements", "Multi-Dropdown", "Second, Third")
			ZenithLib:SetOption("Test", "All Elements", "Colorpicker", Color3.fromRGB(255, 80, 80))
			ZenithLib:SetOptionLabel("Test", "All Elements", "Button — API Test Updates", "✓ Elements Updated")
			ZenithLib:Notify("API Test Completed Successfully!", "rbxassetid://16000149927")
		end}
	}
})

-- Create module "Second Module"
ZenithLib:CreateModule("Test", {
	name = "Second Module",
	on = false,
	bind = "U",
	desc = "Test module state changes via API.",
	opts = {
		{type = "text", label = "This module is enabled by the first module button", color = Color3.fromRGB(120, 200, 120)}
	}
})

-- Initialize Zenith UI
ZenithLib:Init("Zenith Test")
ZenithLib:SetWatermark({title = "Zenith | Test Build", visible = true})

-- Set profile via API
ZenithLib:SetProfile({
	name = "GalaxyEsDarkv1",    -- Username
	subtitle = "Premium User",  -- Subtitle
	-- avatar = "rbxassetid://..." -- Custom avatar (player avatar by default)
})
