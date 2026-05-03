-- FluxWind UI Library
-- A modern Roblox Luau UI library inspired by the clean dark/glass style of WindUI.

local FluxWind = {}
FluxWind.__index = FluxWind
FluxWind.Version = "1.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Themes = {
	Dark = {
		Background = Color3.fromRGB(12, 13, 17),
		Surface = Color3.fromRGB(18, 20, 27),
		Surface2 = Color3.fromRGB(24, 27, 36),
		Surface3 = Color3.fromRGB(34, 38, 50),
		Stroke = Color3.fromRGB(61, 67, 88),
		Text = Color3.fromRGB(239, 243, 255),
		Muted = Color3.fromRGB(142, 151, 176),
		Accent = Color3.fromRGB(88, 128, 255),
		Accent2 = Color3.fromRGB(75, 224, 190),
		Danger = Color3.fromRGB(255, 82, 112),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Midnight = {
		Background = Color3.fromRGB(8, 10, 16),
		Surface = Color3.fromRGB(14, 18, 30),
		Surface2 = Color3.fromRGB(21, 27, 43),
		Surface3 = Color3.fromRGB(31, 39, 61),
		Stroke = Color3.fromRGB(55, 67, 98),
		Text = Color3.fromRGB(241, 246, 255),
		Muted = Color3.fromRGB(140, 152, 180),
		Accent = Color3.fromRGB(118, 96, 255),
		Accent2 = Color3.fromRGB(40, 214, 255),
		Danger = Color3.fromRGB(255, 92, 131),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Rose = {
		Background = Color3.fromRGB(16, 10, 14),
		Surface = Color3.fromRGB(26, 16, 24),
		Surface2 = Color3.fromRGB(37, 22, 34),
		Surface3 = Color3.fromRGB(50, 31, 47),
		Stroke = Color3.fromRGB(90, 58, 84),
		Text = Color3.fromRGB(255, 240, 248),
		Muted = Color3.fromRGB(186, 145, 169),
		Accent = Color3.fromRGB(255, 58, 138),
		Accent2 = Color3.fromRGB(255, 177, 85),
		Danger = Color3.fromRGB(255, 79, 105),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
}

local function getParent()
	local ok, holder = pcall(function()
		if gethui then
			return gethui()
		end
	end)

	if ok and holder then
		return holder
	end

	if LocalPlayer then
		local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			return playerGui
		end
	end

	return game:GetService("CoreGui")
end

local function create(className, props, children)
	local object = Instance.new(className)

	for key, value in pairs(props or {}) do
		object[key] = value
	end

	for _, child in ipairs(children or {}) do
		child.Parent = object
	end

	return object
end

local function corner(radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 10),
	})
end

local function stroke(color, transparency, thickness)
	return create("UIStroke", {
		Color = color,
		Transparency = transparency or 0,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function padding(top, right, bottom, left)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or right or 0),
	})
end

local function listLayout(spacing, horizontal)
	return create("UIListLayout", {
		FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, spacing or 8),
	})
end

local function tween(object, info, goal)
	local tw = TweenService:Create(object, info or TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal)
	tw:Play()
	return tw
end

local function safeCallback(callback, ...)
	if typeof(callback) == "function" then
		task.spawn(callback, ...)
	end
end

local function makeText(theme, text, size, weight, color)
	return create("TextLabel", {
		BackgroundTransparency = 1,
		Text = text or "",
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", weight or Enum.FontWeight.Medium),
		TextColor3 = color or theme.Text,
		TextSize = size or 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
end

local function addPressAnimation(button, theme)
	local baseSize = button.Size
	button.AutoButtonColor = false
	button.MouseEnter:Connect(function()
		tween(button, TweenInfo.new(0.15), {
			BackgroundColor3 = theme.Surface3,
		})
	end)
	button.MouseLeave:Connect(function()
		tween(button, TweenInfo.new(0.15), {
			BackgroundColor3 = theme.Surface2,
		})
	end)
	button.MouseButton1Down:Connect(function()
		tween(button, TweenInfo.new(0.08), {
			Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset, baseSize.Y.Scale, baseSize.Y.Offset - 1),
		})
	end)
	button.MouseButton1Up:Connect(function()
		tween(button, TweenInfo.new(0.12), {
			Size = baseSize,
		})
	end)
end

local function makeDraggable(frame, handle)
	local dragging = false
	local dragStart
	local startPosition

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

function FluxWind:CreateWindow(config)
	config = config or {}

	local theme = Themes[config.Theme or "Dark"] or Themes.Dark
	local gui = create("ScreenGui", {
		Name = config.Name or "FluxWind",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = config.Parent or getParent(),
	})

	local root = create("Frame", {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = config.Size or UDim2.fromOffset(650, 430),
		Parent = gui,
	}, {
		corner(14),
		stroke(theme.Stroke, 0.25, 1),
	})

	local glow = create("ImageLabel", {
		Name = "Glow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5028857084",
		ImageColor3 = theme.Accent,
		ImageTransparency = 0.55,
		Position = UDim2.fromScale(0.5, 0.5),
		ScaleType = Enum.ScaleType.Slice,
		Size = UDim2.new(1, 62, 1, 62),
		SliceCenter = Rect.new(24, 24, 276, 276),
		ZIndex = 0,
		Parent = root,
	})

	local topBar = create("Frame", {
		Name = "TopBar",
		BackgroundColor3 = theme.Surface,
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 54),
		ZIndex = 2,
		Parent = root,
	}, {
		padding(0, 14, 0, 14),
	})

	local titleWrap = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -94, 1, 0),
		Parent = topBar,
	})

	local title = makeText(theme, config.Title or "FluxWind", 16, Enum.FontWeight.Bold)
	title.Position = UDim2.fromOffset(0, 8)
	title.Size = UDim2.new(1, 0, 0, 22)
	title.Parent = titleWrap

	local subtitle = makeText(theme, config.Subtitle or "Modern Roblox UI Library", 11, Enum.FontWeight.Medium, theme.Muted)
	subtitle.Position = UDim2.fromOffset(0, 29)
	subtitle.Size = UDim2.new(1, 0, 0, 16)
	subtitle.Parent = titleWrap

	local controls = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(82, 28),
		Parent = topBar,
	}, {
		listLayout(8, true),
	})

	local minButton = create("TextButton", {
		BackgroundColor3 = theme.Surface2,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(28, 28),
		Text = "-",
		TextColor3 = theme.Muted,
		TextSize = 18,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		Parent = controls,
	}, {
		corner(8),
	})

	local closeButton = create("TextButton", {
		BackgroundColor3 = theme.Surface2,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(28, 28),
		Text = "x",
		TextColor3 = theme.Muted,
		TextSize = 14,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		Parent = controls,
	}, {
		corner(8),
	})

	local body = create("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 54),
		Size = UDim2.new(1, 0, 1, -54),
		Parent = root,
	})

	local sidebar = create("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = theme.Surface,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 178, 1, 0),
		Parent = body,
	}, {
		padding(14, 12, 14, 12),
	})

	local search = create("TextBox", {
		BackgroundColor3 = theme.Surface2,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
		PlaceholderColor3 = theme.Muted,
		PlaceholderText = "Search...",
		Position = UDim2.fromOffset(12, 12),
		Size = UDim2.new(1, -24, 0, 34),
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 12,
		Parent = sidebar,
	}, {
		corner(9),
		padding(0, 12, 0, 12),
		stroke(theme.Stroke, 0.55, 1),
	})

	local tabsHolder = create("ScrollingFrame", {
		Name = "Tabs",
		Active = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		Position = UDim2.fromOffset(0, 54),
		ScrollBarImageColor3 = theme.Accent,
		ScrollBarThickness = 2,
		Size = UDim2.new(1, 0, 1, -108),
		Parent = sidebar,
	}, {
		listLayout(8, false),
	})

	local userBox = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.Surface2,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 46),
		Parent = sidebar,
	}, {
		corner(11),
		padding(0, 10, 0, 10),
		stroke(theme.Stroke, 0.62, 1),
	})

	local avatar = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = theme.Accent,
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		Parent = userBox,
	}, {
		corner(14),
	})

	local userInitial = makeText(theme, string.sub((config.User or "A"), 1, 1), 13, Enum.FontWeight.Bold, Color3.new(1, 1, 1))
	userInitial.TextXAlignment = Enum.TextXAlignment.Center
	userInitial.Size = UDim2.fromScale(1, 1)
	userInitial.Parent = avatar

	local userName = makeText(theme, config.User or "Anonymous", 12, Enum.FontWeight.Bold)
	userName.Position = UDim2.fromOffset(46, 7)
	userName.Size = UDim2.new(1, -54, 0, 17)
	userName.Parent = userBox

	local userRole = makeText(theme, config.Role or "Free user", 10, Enum.FontWeight.Medium, theme.Muted)
	userRole.Position = UDim2.fromOffset(46, 23)
	userRole.Size = UDim2.new(1, -54, 0, 15)
	userRole.Parent = userBox

	local content = create("Frame", {
		Name = "Content",
		BackgroundColor3 = theme.Background,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(178, 0),
		Size = UDim2.new(1, -178, 1, 0),
		Parent = body,
	})

	local pages = create("Folder", {
		Name = "Pages",
		Parent = content,
	})

	makeDraggable(root, topBar)
	addPressAnimation(minButton, theme)
	addPressAnimation(closeButton, theme)

	local self = setmetatable({
		Gui = gui,
		Root = root,
		Body = body,
		Sidebar = sidebar,
		TabsHolder = tabsHolder,
		Content = content,
		Pages = pages,
		Theme = theme,
		ThemeName = config.Theme or "Dark",
		Tabs = {},
		ActiveTab = nil,
		Minimized = false,
		OriginalSize = root.Size,
	}, Window)

	closeButton.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	minButton.MouseButton1Click:Connect(function()
		self.Minimized = not self.Minimized
		minButton.Text = self.Minimized and "+" or "-"
		body.Visible = not self.Minimized
		tween(root, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = self.Minimized and UDim2.fromOffset(self.OriginalSize.X.Offset, 54) or self.OriginalSize,
		})
	end)

	search:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(search.Text)
		for _, tab in ipairs(self.Tabs) do
			tab.Button.Visible = query == "" or string.find(string.lower(tab.Name), query, 1, true) ~= nil
		end
	end)

	root.Size = UDim2.fromOffset(590, 382)
	root.BackgroundTransparency = 1
	tween(root, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = self.OriginalSize,
		BackgroundTransparency = 0,
	})
	tween(glow, TweenInfo.new(0.35), {
		ImageTransparency = 0.68,
	})

	return self
end

function Window:Destroy()
	if self.Gui then
		self.Gui:Destroy()
	end
end

function Window:Notify(config)
	config = config or {}

	local holder = self.Gui:FindFirstChild("Notifications")
	if not holder then
		holder = create("Frame", {
			Name = "Notifications",
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -18, 1, -18),
			Size = UDim2.fromOffset(280, 300),
			Parent = self.Gui,
		}, {
			listLayout(8, false),
		})
	end

	local card = create("Frame", {
		BackgroundColor3 = self.Theme.Surface,
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(280, 0),
		Parent = holder,
	}, {
		corner(12),
		padding(12, 14, 12, 14),
		stroke(self.Theme.Stroke, 0.4, 1),
	})

	local title = makeText(self.Theme, config.Title or "Notification", 13, Enum.FontWeight.Bold)
	title.Size = UDim2.new(1, 0, 0, 18)
	title.Parent = card

	local message = makeText(self.Theme, config.Content or "", 11, Enum.FontWeight.Medium, self.Theme.Muted)
	message.Position = UDim2.fromOffset(0, 20)
	message.Size = UDim2.new(1, 0, 0, 18)
	message.Parent = card

	card.Size = UDim2.fromOffset(280, 0)
	card.BackgroundTransparency = 1
	tween(card, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(280, 64),
		BackgroundTransparency = 0.04,
	})

	task.delay(config.Duration or 3, function()
		if card.Parent then
			tween(card, TweenInfo.new(0.2), {
				Size = UDim2.fromOffset(280, 0),
				BackgroundTransparency = 1,
			}).Completed:Wait()
			if card.Parent then
				card:Destroy()
			end
		end
	end)
end

function Window:CreateTab(config)
	config = config or {}

	local index = #self.Tabs + 1
	local name = config.Name or ("Tab " .. index)

	local button = create("TextButton", {
		BackgroundColor3 = self.Theme.Surface2,
		BackgroundTransparency = 0.28,
		BorderSizePixel = 0,
		LayoutOrder = index,
		Size = UDim2.new(1, 0, 0, 38),
		Text = "",
		Parent = self.TabsHolder,
	}, {
		corner(10),
		padding(0, 12, 0, 12),
	})

	local indicator = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = self.Theme.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(3, 16),
		Visible = false,
		Parent = button,
	}, {
		corner(4),
	})

	local label = makeText(self.Theme, (config.Icon and (config.Icon .. "  ") or "") .. name, 12, Enum.FontWeight.Bold, self.Theme.Muted)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Parent = button

	local page = create("ScrollingFrame", {
		Name = name,
		Active = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		Position = UDim2.fromOffset(18, 18),
		ScrollBarImageColor3 = self.Theme.Accent,
		ScrollBarThickness = 3,
		Size = UDim2.new(1, -36, 1, -36),
		Visible = false,
		Parent = self.Pages,
	}, {
		listLayout(12, false),
	})

	page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.fromOffset(0, page.UIListLayout.AbsoluteContentSize.Y + 8)
	end)

	self.TabsHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.TabsHolder.CanvasSize = UDim2.fromOffset(0, self.TabsHolder.UIListLayout.AbsoluteContentSize.Y + 8)
	end)

	local tab = setmetatable({
		Window = self,
		Name = name,
		Button = button,
		Label = label,
		Indicator = indicator,
		Page = page,
		Sections = {},
	}, Tab)

	button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	table.insert(self.Tabs, tab)

	if not self.ActiveTab then
		self:SelectTab(tab)
	end

	return tab
end

function Window:SelectTab(tab)
	for _, item in ipairs(self.Tabs) do
		local active = item == tab
		item.Page.Visible = active
		item.Indicator.Visible = active
		item.Label.TextColor3 = active and self.Theme.Text or self.Theme.Muted
		tween(item.Button, TweenInfo.new(0.16), {
			BackgroundTransparency = active and 0 or 0.28,
			BackgroundColor3 = active and self.Theme.Surface3 or self.Theme.Surface2,
		})
	end

	self.ActiveTab = tab
end

function Tab:CreateSection(config)
	config = config or {}

	local sectionFrame = create("Frame", {
		BackgroundColor3 = self.Window.Theme.Surface,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 52),
		Parent = self.Page,
	}, {
		corner(13),
		padding(14, 14, 14, 14),
		stroke(self.Window.Theme.Stroke, 0.5, 1),
		listLayout(10, false),
	})

	local title = makeText(self.Window.Theme, config.Name or "Section", 13, Enum.FontWeight.Bold)
	title.Size = UDim2.new(1, 0, 0, 18)
	title.Parent = sectionFrame

	local descText = config.Description
	if descText then
		local desc = makeText(self.Window.Theme, descText, 11, Enum.FontWeight.Medium, self.Window.Theme.Muted)
		desc.Size = UDim2.new(1, 0, 0, 16)
		desc.Parent = sectionFrame
	end

	local content = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = sectionFrame,
	}, {
		listLayout(8, false),
	})

	content.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.Size = UDim2.new(1, 0, 0, content.UIListLayout.AbsoluteContentSize.Y)
		sectionFrame.Size = UDim2.new(1, 0, 0, content.UIListLayout.AbsoluteContentSize.Y + (descText and 72 or 48))
	end)

	local section = setmetatable({
		Tab = self,
		Window = self.Window,
		Frame = sectionFrame,
		Content = content,
	}, Section)

	table.insert(self.Sections, section)
	return section
end

local function createRow(section, config, height)
	local row = create("Frame", {
		BackgroundColor3 = section.Window.Theme.Surface2,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height or 46),
		Parent = section.Content,
	}, {
		corner(10),
		padding(0, 12, 0, 12),
		stroke(section.Window.Theme.Stroke, 0.7, 1),
	})

	local title = makeText(section.Window.Theme, config.Name or "Control", 12, Enum.FontWeight.Bold)
	title.Position = UDim2.fromOffset(0, config.Description and 7 or 0)
	title.Size = UDim2.new(1, -146, 0, 20)
	title.Parent = row

	if config.Description then
		local desc = makeText(section.Window.Theme, config.Description, 10, Enum.FontWeight.Medium, section.Window.Theme.Muted)
		desc.Position = UDim2.fromOffset(0, 24)
		desc.Size = UDim2.new(1, -146, 0, 15)
		desc.Parent = row
	end

	return row, title
end

function Section:Button(config)
	config = config or {}

	local row = createRow(self, config, 48)
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = self.Window.Theme.Accent,
		BorderSizePixel = 0,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(96, 30),
		Text = config.Text or "Run",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 12,
		Parent = row,
	}, {
		corner(9),
	})

	button.MouseEnter:Connect(function()
		tween(button, TweenInfo.new(0.14), {
			BackgroundColor3 = self.Window.Theme.Accent2,
		})
	end)
	button.MouseLeave:Connect(function()
		tween(button, TweenInfo.new(0.14), {
			BackgroundColor3 = self.Window.Theme.Accent,
		})
	end)
	button.MouseButton1Click:Connect(function()
		safeCallback(config.Callback)
	end)

	return button
end

function Section:Toggle(config)
	config = config or {}

	local window = self.Window
	local enabled = config.Default == true
	local row = createRow(self, config, 48)

	local switch = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = enabled and self.Window.Theme.Accent or self.Window.Theme.Surface3,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(48, 26),
		Text = "",
		Parent = row,
	}, {
		corner(13),
	})

	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = enabled and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(20, 20),
		Parent = switch,
	}, {
		corner(10),
	})

	local object = {}

	function object:Set(value)
		enabled = value == true
		tween(switch, TweenInfo.new(0.18), {
			BackgroundColor3 = enabled and window.Theme.Accent or window.Theme.Surface3,
		})
		tween(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = enabled and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		})
		safeCallback(config.Callback, enabled)
	end

	switch.MouseButton1Click:Connect(function()
		object:Set(not enabled)
	end)

	return object
end

function Section:Slider(config)
	config = config or {}

	local min = config.Min or 0
	local max = config.Max or 100
	local step = config.Step or 1
	if max <= min then
		max = min + 1
	end
	if step <= 0 then
		step = 1
	end
	local value = math.clamp(config.Default or min, min, max)

	local row = createRow(self, config, 64)
	local valueLabel = makeText(self.Window.Theme, tostring(value), 11, Enum.FontWeight.Bold, self.Window.Theme.Accent2)
	valueLabel.AnchorPoint = Vector2.new(1, 0)
	valueLabel.Position = UDim2.new(1, 0, 0, 8)
	valueLabel.Size = UDim2.fromOffset(70, 18)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = row

	local bar = create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = self.Window.Theme.Surface3,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 1, -12),
		Size = UDim2.new(1, -4, 0, 8),
		Parent = row,
	}, {
		corner(8),
	})

	local fill = create("Frame", {
		BackgroundColor3 = self.Window.Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0, 1),
		Parent = bar,
	}, {
		corner(8),
	})

	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(16, 16),
		Parent = bar,
	}, {
		corner(8),
		stroke(self.Window.Theme.Accent, 0, 2),
	})

	local object = {}
	local dragging = false

	local function snap(number)
		return math.floor((number / step) + 0.5) * step
	end

	function object:Set(newValue)
		value = math.clamp(snap(newValue), min, max)
		local alpha = (value - min) / (max - min)
		valueLabel.Text = tostring(value)
		tween(fill, TweenInfo.new(0.13), {
			Size = UDim2.fromScale(alpha, 1),
		})
		tween(knob, TweenInfo.new(0.13), {
			Position = UDim2.fromScale(alpha, 0.5),
		})
		safeCallback(config.Callback, value)
	end

	local function updateFromInput(input)
		local alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		object:Set(min + (max - min) * alpha)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateFromInput(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	object:Set(value)
	return object
end

function Section:Dropdown(config)
	config = config or {}

	local options = config.Options or {}
	local selected = config.Default or options[1] or "Select"
	local open = false

	local row = createRow(self, config, 48)
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = self.Window.Theme.Surface3,
		BorderSizePixel = 0,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(132, 30),
		Text = tostring(selected) .. "  v",
		TextColor3 = self.Window.Theme.Text,
		TextSize = 11,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	}, {
		corner(9),
		padding(0, 8, 0, 8),
	})

	local menu = create("Frame", {
		BackgroundColor3 = self.Window.Theme.Surface2,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(1, -132, 1, 6),
		Size = UDim2.fromOffset(132, 0),
		Visible = false,
		ZIndex = 12,
		Parent = row,
	}, {
		corner(9),
		stroke(self.Window.Theme.Stroke, 0.5, 1),
		listLayout(2, false),
		padding(4, 4, 4, 4),
	})

	local object = {}

	local function setOpen(value)
		open = value
		menu.Visible = true
		tween(menu, TweenInfo.new(0.18), {
			Size = UDim2.fromOffset(132, open and math.min(#options * 28 + 8, 148) or 0),
		}).Completed:Connect(function()
			if not open then
				menu.Visible = false
			end
		end)
	end

	function object:Set(value)
		selected = value
		button.Text = tostring(selected) .. "  v"
		safeCallback(config.Callback, selected)
	end

	for _, option in ipairs(options) do
		local optionButton = create("TextButton", {
			BackgroundColor3 = self.Window.Theme.Surface2,
			BorderSizePixel = 0,
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			Size = UDim2.new(1, 0, 0, 26),
			Text = tostring(option),
			TextColor3 = self.Window.Theme.Text,
			TextSize = 11,
			ZIndex = 13,
			Parent = menu,
		}, {
			corner(7),
		})

		optionButton.MouseEnter:Connect(function()
			tween(optionButton, TweenInfo.new(0.12), {
				BackgroundColor3 = self.Window.Theme.Surface3,
			})
		end)
		optionButton.MouseLeave:Connect(function()
			tween(optionButton, TweenInfo.new(0.12), {
				BackgroundColor3 = self.Window.Theme.Surface2,
			})
		end)
		optionButton.MouseButton1Click:Connect(function()
			object:Set(option)
			setOpen(false)
		end)
	end

	button.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)

	return object
end

function Section:Input(config)
	config = config or {}

	local row = createRow(self, config, 48)
	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = self.Window.Theme.Surface3,
		BorderSizePixel = 0,
		ClearTextOnFocus = config.ClearTextOnFocus == true,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
		PlaceholderColor3 = self.Window.Theme.Muted,
		PlaceholderText = config.Placeholder or "Enter text...",
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(150, 30),
		Text = config.Default or "",
		TextColor3 = self.Window.Theme.Text,
		TextSize = 11,
		Parent = row,
	}, {
		corner(9),
		padding(0, 8, 0, 8),
	})

	box.FocusLost:Connect(function(enterPressed)
		if config.FireOnEnter == false or enterPressed then
			safeCallback(config.Callback, box.Text)
		end
	end)

	return box
end

function Section:Keybind(config)
	config = config or {}

	local current = config.Default or Enum.KeyCode.RightShift
	local listening = false
	local row = createRow(self, config, 48)

	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = self.Window.Theme.Surface3,
		BorderSizePixel = 0,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(118, 30),
		Text = current.Name,
		TextColor3 = self.Window.Theme.Text,
		TextSize = 11,
		Parent = row,
	}, {
		corner(9),
	})

	button.MouseButton1Click:Connect(function()
		listening = true
		button.Text = "Press key..."
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end

		if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
			current = input.KeyCode
			listening = false
			button.Text = current.Name
			safeCallback(config.Changed, current)
			return
		end

		if input.KeyCode == current then
			safeCallback(config.Callback)
		end
	end)

	return {
		Set = function(_, keyCode)
			current = keyCode
			button.Text = current.Name
		end,
		Get = function()
			return current
		end,
	}
end

function Section:Paragraph(config)
	config = config or {}

	local row = create("Frame", {
		BackgroundColor3 = self.Window.Theme.Surface2,
		BackgroundTransparency = 0.16,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 66),
		Parent = self.Content,
	}, {
		corner(10),
		padding(12, 12, 12, 12),
		stroke(self.Window.Theme.Stroke, 0.72, 1),
	})

	local title = makeText(self.Window.Theme, config.Title or "Paragraph", 12, Enum.FontWeight.Bold)
	title.Size = UDim2.new(1, 0, 0, 18)
	title.Parent = row

	local body = makeText(self.Window.Theme, config.Content or "", 11, Enum.FontWeight.Medium, self.Window.Theme.Muted)
	body.Position = UDim2.fromOffset(0, 24)
	body.Size = UDim2.new(1, 0, 0, 30)
	body.TextWrapped = true
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.Parent = row

	return row
end

function FluxWind:GetThemes()
	local names = {}
	for name in pairs(Themes) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

if typeof(getgenv) == "function" then
	getgenv().FluxWind = FluxWind
end

return FluxWind
