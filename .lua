-- Тестовый скрипт для ZenithLib
-- Загрузка библиотеки через loadstring по указанной GitHub ссылке

local ZenithLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/KaspikScriptsRb/qkaspq-s-ui-library-opensrc/refs/heads/main/.lua"))()


-- Создание вкладки "Test"
ZenithLib:CreateTab("Test", "rbxassetid://7485051715")

-- Создание модуля "Все элементы"
ZenithLib:CreateModule("Test", {
	name = "Все элементы",
	on = true,
	bind = "T",
	desc = "Тест всех возможных элементов API.",
	opts = {
		{type = "text", label = "<b>Текстовый элемент</b> — поддерживает RichText", desc = "Используй color = Color3... для цвета"},
		{type = "toggle", label = "Переключатель (Toggle)", value = true, callback = function(v) end},
		{type = "checkbox", label = "Чекбокс (Checkbox)", value = false, callback = function(v) end},
		{type = "slider", label = "Слайдер", value = 50, min = 0, max = 100, suffix = "%", callback = function(v) end},
		{type = "dropdown", label = "Дропдаун", value = "Вариант A", list = {"Вариант A", "Вариант B", "Вариант C"}, callback = function(v) end},
		{type = "multiselect", label = "Мульти-дропдаун", value = "Первый", list = {"Первый", "Второй", "Третий"}, callback = function(v) end},
		{type = "colorpicker", label = "Колорпикер", value = true, color = Color3.fromRGB(120, 110, 250), callback = function(col, enabled) end},
		{type = "textbox", label = "Текстбокс", value = "", placeholder = "Введите текст...", callback = function(text, enter) end},
		{type = "bind", label = "Биндклавиша", key = "None", callback = function(key) end, onActivate = function() end},
		{type = "button", label = "Кнопка — API тест всех обновлений", callback = function()
			ZenithLib:SetOption("Test", "Все элементы", "Переключатель (Toggle)", false)
			ZenithLib:SetOption("Test", "Все элементы", "Чекбокс (Checkbox)", true)
			ZenithLib:SetOption("Test", "Все элементы", "Слайдер", 88)
			ZenithLib:SetOption("Test", "Все элементы", "Дропдаун", "Вариант C")
			ZenithLib:SetOption("Test", "Все элементы", "Мульти-дропдаун", "Второй, Третий")
			ZenithLib:SetOption("Test", "Все элементы", "Колорпикер", Color3.fromRGB(255, 80, 80))
			ZenithLib:SetOptionLabel("Test", "Все элементы", "Кнопка — API тест всех обновлений", "✓ Элементы обновлены")
			ZenithLib:Notify("API тест пройден успешно!", "rbxassetid://16000149927")
		end}
	}
})

-- Создание модуля "Второй модуль"
ZenithLib:CreateModule("Test", {
	name = "Второй модуль",
	on = false,
	bind = "U",
	desc = "Тест изменения состояния модуля через API.",
	opts = {
		{type = "text", label = "Этот модуль включается кнопкой в первом", color = Color3.fromRGB(120, 200, 120)}
	}
})

-- Инициализация интерфейса Zenith
ZenithLib:Init("Zenith Test")
ZenithLib:SetWatermark({title = "Zenith | Test Build", visible = true})

-- Установка профиля через API (если не вызывать, профиль в углу не будет создан)
ZenithLib:SetProfile({
	name = "GalaxyEsDarkv1",    -- Имя (если nil, подставится имя игрока)
	subtitle = "Premium User",  -- Подзаголовок (если nil или пустая строка "", скроется, а имя отцентрируется)
	-- avatar = "rbxassetid://..." -- Кастомная иконка аватара (если nil, подставится аватарка игрока)
})
