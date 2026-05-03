--// SnipplyssHub | UI Library v1.0
--// Part 1 – Core: Window · Sidebar · Tabs · Components
--// Fonts: Montserrat (logo) · GothamSSm (body)

local Lib = {}
Lib.__index = Lib

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")

-- ============================================================
--  PALETTE
-- ============================================================
local T = {
    BG        = Color3.fromRGB(14,  11, 22),
    Sidebar   = Color3.fromRGB(20,  15, 32),
    SbBtn     = Color3.fromRGB(28,  22, 42),
    SbActive  = Color3.fromRGB(80,  46,130),
    SbHover   = Color3.fromRGB(40,  30, 60),
    Panel     = Color3.fromRGB(22,  17, 34),
    Border    = Color3.fromRGB(42,  32, 62),
    Section   = Color3.fromRGB(18,  14, 28),
    SecBorder = Color3.fromRGB(38,  28, 58),
    Accent    = Color3.fromRGB(118, 72,188),
    AccentLt  = Color3.fromRGB(155,108,220),
    TextPri   = Color3.fromRGB(235,225,250),
    TextSec   = Color3.fromRGB(135,118,160),
    TextMut   = Color3.fromRGB(85,  75,105),
    TglOn     = Color3.fromRGB(105, 62,168),
    TglOff    = Color3.fromRGB(48,  38, 68),
    TglKnob   = Color3.fromRGB(248,242,255),
    SlFill    = Color3.fromRGB(108, 62,172),
    SlBg      = Color3.fromRGB(44,  34, 64),
    TopBar    = Color3.fromRGB(16,  12, 26),
    StatusBg  = Color3.fromRGB(11,   9, 18),
    Premium   = Color3.fromRGB(95,  55,155),
    PremTxt   = Color3.fromRGB(195,165,255),
    Close     = Color3.fromRGB(195, 55, 75),
    WinBtn    = Color3.fromRGB(65,  55, 88),
    UserBg    = Color3.fromRGB(88,  50,148),
    Green     = Color3.fromRGB(80, 200,120),
    Orange    = Color3.fromRGB(220,160, 40),
    Red       = Color3.fromRGB(200, 60, 60),
}

-- ============================================================
--  ASSETS   (icons by rbxassetid)
-- ============================================================
Lib.A = {
    User      = "rbxassetid://10747373176",
    Crosshair = "rbxassetid://10709818534",
    Eye       = "rbxassetid://10723346959",
    Sword     = "rbxassetid://10734975486",
    Swords    = "rbxassetid://10734975692",
    Settings  = "rbxassetid://10734950309",
}

-- ============================================================
--  FONTS
-- ============================================================
local F = {
    Logo   = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold),
    Title  = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold),
    Semi   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.SemiBold),
    Medium = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.Medium),
    Body   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.Regular),
    Bold   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.Bold),
}

-- ============================================================
--  HELPERS
-- ============================================================
local function New(cls, props, kids)
    local o = Instance.new(cls)
    for k, v in next, props do o[k] = v end
    if kids then for _, c in next, kids do c.Parent = o end end
    return o
end

local function Rad(r)   return New("UICorner",  {CornerRadius = UDim.new(0, r or 8)}) end
local function Brd(c,t) return New("UIStroke",  {Color = c or T.Border, Thickness = t or 1}) end
local function Pad(t,b,l,r)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0), PaddingRight  = UDim.new(0, r or 0),
    })
end
local function List(pad, dir, ha, va)
    return New("UIListLayout", {
        Padding             = UDim.new(0, pad or 6),
        FillDirection       = dir or Enum.FillDirection.Vertical,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = ha  or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = va  or Enum.VerticalAlignment.Top,
    })
end

-- ============================================================
--  WINDOW
-- ============================================================
function Lib.new()
    local self = setmetatable({}, Lib)
    self.Tabs = {}

    local player = Players.LocalPlayer
    local gui = New("ScreenGui", {
        Name = "SnipplyssHub", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    -- Executor-safe parenting: prefer protected CoreGui
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end

    -- Drag container (holds glow layer + window)
    local container = New("Frame", {
        Parent = gui, Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -494, 0.5, -334),
        Size = UDim2.new(0, 988, 0, 668),
    })
    self.Container = container

    -- Neon glow layer (sits behind window)
    local glowFrame = New("Frame", {
        Parent = container, BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.62,
        Size = UDim2.new(1, 0, 1, 0),
    }, {Rad(14)})

    local win = New("Frame", {
        Parent = container, Name = "Window",
        BackgroundColor3 = T.BG,
        Position = UDim2.new(0, 4, 0, 4),
        Size = UDim2.new(0, 980, 0, 660),
        ClipsDescendants = true,
    }, {Rad(12)})
    self.Window = win

    -- Animated neon border
    local winStroke = New("UIStroke", {
        Parent = win, Thickness = 1.5,
        Color = T.Accent,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    RunService.Heartbeat:Connect(function()
        local s = (math.sin(tick() * 2.2) + 1) * 0.5
        local col = Color3.fromRGB(100, 52, 168):Lerp(Color3.fromRGB(192, 108, 255), s)
        winStroke.Color = col
        winStroke.Thickness = 1.2 + s * 1.6
        glowFrame.BackgroundColor3 = col
        glowFrame.BackgroundTransparency = 0.60 + s * 0.22
    end)

    -- ---- TopBar ------------------------------------------------
    local topbar = New("Frame", {
        Parent = win, BackgroundColor3 = T.TopBar,
        Size = UDim2.new(1, 0, 0, 46),
    }, {Brd(T.Border, 1)})

    New("TextLabel", {
        Parent = topbar, BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -130, 0, 0), Size = UDim2.new(0, 260, 1, 0),
        Text = "✦  Snipplyss  ✦",
        TextColor3 = T.TextPri, TextSize = 22,
        FontFace = F.Logo, TextXAlignment = Enum.TextXAlignment.Center,
    })

    -- Window control buttons
    local ctrlRow = New("Frame", {
        Parent = topbar, BackgroundTransparency = 1,
        Position = UDim2.new(1, -104, 0.5, -11), Size = UDim2.new(0, 94, 0, 22),
    })
    List(6, Enum.FillDirection.Horizontal,
         Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center).Parent = ctrlRow

    local function WinCtrl(col, sym, lo)
        local b = New("TextButton", {
            Parent = ctrlRow, BackgroundColor3 = col,
            Size = UDim2.new(0, 22, 0, 22), Text = sym,
            TextColor3 = Color3.new(1,1,1), TextSize = 10,
            FontFace = F.Bold, LayoutOrder = lo,
        }, {Rad(6)})
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = col:Lerp(Color3.new(1,1,1), .15)}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = col}):Play()
        end)
        return b
    end

    WinCtrl(T.WinBtn, "—", 1).MouseButton1Click:Connect(function()
        container.Visible = not container.Visible
    end)
    WinCtrl(T.WinBtn, "⛶", 2)
    WinCtrl(T.Close,  "✕", 3).MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Drag
    local dragOn, dragStart, conStart = false, nil, nil
    topbar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragOn = true; dragStart = i.Position; conStart = container.Position
        end
    end)
    topbar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragOn = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragOn and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            container.Position = UDim2.new(conStart.X.Scale, conStart.X.Offset + d.X,
                                           conStart.Y.Scale, conStart.Y.Offset + d.Y)
        end
    end)

    -- ---- Content (between topbar and statusbar) ----------------
    local content = New("Frame", {
        Parent = win, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 46), Size = UDim2.new(1, 0, 1, -82),
    })

    -- ---- Sidebar -----------------------------------------------
    local sidebar = New("Frame", {
        Parent = content, BackgroundColor3 = T.Sidebar,
        Size = UDim2.new(0, 200, 1, 0),
    }, {Brd(T.Border, 1)})

    local navFrame = New("Frame", {
        Parent = sidebar, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 12), Size = UDim2.new(1, 0, 1, -118),
    })
    List(4).Parent = navFrame
    Pad(0, 0, 12, 12).Parent = navFrame

    -- ---- Tab container -----------------------------------------
    local tabCon = New("Frame", {
        Parent = content, BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0),
    })
    self.TabContainer = tabCon

    -- ---- Tab definitions ---------------------------------------
    local A = Lib.A
    local defs = {
        {n="Combat",   ic=A.Swords,    desc="Enhance your combat experience and dominate."},
        {n="Movement", ic=A.Sword,     desc="Control your movement and traversal abilities."},
        {n="Visuals",  ic=A.Eye,       desc="Customize visual enhancements and ESP options."},
        {n="Misc",     ic=A.Crosshair, desc="Miscellaneous tools and extra utilities."},
        {n="Settings", ic=A.Settings,  desc="Configure your Snipplyss preferences."},
    }

    for i, def in ipairs(defs) do
        -- Nav button
        local btn = New("TextButton", {
            Parent = navFrame, BackgroundColor3 = T.SbBtn,
            Size = UDim2.new(1, 0, 0, 44), Text = "", LayoutOrder = i,
        }, {Rad(8)})
        local btnIc = New("ImageLabel", {
            Parent = btn, BackgroundTransparency = 1,
            Image = def.ic, ImageColor3 = T.TextSec,
            Position = UDim2.new(0, 12, 0.5, -10), Size = UDim2.new(0, 20, 0, 20),
        })
        New("TextLabel", {
            Parent = btn, BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0),
            Text = def.n, TextColor3 = T.TextSec, TextSize = 14,
            FontFace = F.Semi, TextXAlignment = Enum.TextXAlignment.Left,
        })

        -- Tab frame
        local tabFrame = New("Frame", {
            Parent = tabCon, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0), Visible = false, Name = def.n,
        })

        -- Tab header
        local hdr = New("Frame", {
            Parent = tabFrame, BackgroundColor3 = T.Panel,
            Size = UDim2.new(1, 0, 0, 54),
        }, {Brd(T.Border, 1)})
        New("ImageLabel", {
            Parent = hdr, BackgroundTransparency = 1,
            Image = def.ic, ImageColor3 = T.Accent,
            Position = UDim2.new(0, 16, 0.5, -14), Size = UDim2.new(0, 28, 0, 28),
        })
        New("TextLabel", {
            Parent = hdr, BackgroundTransparency = 1,
            Position = UDim2.new(0, 52, 0, 8), Size = UDim2.new(0.6, 0, 0, 22),
            Text = def.n, TextColor3 = T.TextPri, TextSize = 18,
            FontFace = F.Title, TextXAlignment = Enum.TextXAlignment.Left,
        })
        New("TextLabel", {
            Parent = hdr, BackgroundTransparency = 1,
            Position = UDim2.new(0, 52, 0, 30), Size = UDim2.new(0.8, 0, 0, 16),
            Text = def.desc, TextColor3 = T.TextMut, TextSize = 11,
            FontFace = F.Body, TextXAlignment = Enum.TextXAlignment.Left,
        })

        -- Scrolling content
        local scroll = New("ScrollingFrame", {
            Parent = tabFrame, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 54), Size = UDim2.new(1, 0, 1, -54),
            ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
        })
        Pad(12, 12, 14, 14).Parent = scroll
        List(10).Parent = scroll

        self.Tabs[def.n] = {frame = tabFrame, scroll = scroll, btn = btn, ic = btnIc}

        btn.MouseButton1Click:Connect(function() self:SwitchTab(def.n) end)
        btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= def.n then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = T.SbHover}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= def.n then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = T.SbBtn}):Play()
            end
        end)
    end

    -- ---- User card ---------------------------------------------
    local uc = New("Frame", {
        Parent = sidebar, BackgroundColor3 = T.SbBtn,
        Position = UDim2.new(0, 12, 1, -106), Size = UDim2.new(1, -24, 0, 90),
    }, {Rad(10), Brd(T.Border, 1)})
    local avBg = New("Frame", {
        Parent = uc, BackgroundColor3 = T.UserBg,
        Position = UDim2.new(0, 10, 0.5, -22), Size = UDim2.new(0, 44, 0, 44),
    }, {Rad(22)})
    New("TextLabel", {
        Parent = avBg, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
        Text = "S", TextColor3 = T.TextPri, TextSize = 20, FontFace = F.Logo,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    New("TextLabel", {
        Parent = uc, BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 12), Size = UDim2.new(1, -72, 0, 14),
        Text = "Welcome back,", TextColor3 = T.TextMut, TextSize = 11,
        FontFace = F.Body, TextXAlignment = Enum.TextXAlignment.Left,
    })
    New("TextLabel", {
        Parent = uc, BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 26), Size = UDim2.new(1, -72, 0, 18),
        Text = player.Name, TextColor3 = T.TextPri, TextSize = 13,
        FontFace = F.Semi, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local prem = New("Frame", {
        Parent = uc, BackgroundColor3 = T.Premium,
        Position = UDim2.new(0, 62, 0, 50), Size = UDim2.new(0, 76, 0, 20),
    }, {Rad(5)})
    New("TextLabel", {
        Parent = prem, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
        Text = "👑 Premium", TextColor3 = T.PremTxt, TextSize = 11,
        FontFace = F.Semi, TextXAlignment = Enum.TextXAlignment.Center,
    })

    -- ---- Status Bar --------------------------------------------
    local statBar = New("Frame", {
        Parent = win, BackgroundColor3 = T.StatusBg,
        Position = UDim2.new(0, 0, 1, -36), Size = UDim2.new(1, 0, 0, 36),
    }, {Brd(T.Border, 1)})
    Pad(0, 0, 16, 16).Parent = statBar
    List(22, Enum.FillDirection.Horizontal,
         Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center).Parent = statBar

    local function SItem(lbl, val, col, lo)
        local f = New("Frame", {
            Parent = statBar, BackgroundTransparency = 1,
            Size = UDim2.new(0, 140, 1, 0), LayoutOrder = lo,
        })
        New("TextLabel", {
            Parent = f, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0.48, 0, 1, 0),
            Text = lbl..":", TextColor3 = T.TextMut, TextSize = 11,
            FontFace = F.Body, TextXAlignment = Enum.TextXAlignment.Left,
        })
        return New("TextLabel", {
            Parent = f, BackgroundTransparency = 1,
            Position = UDim2.new(0.48, 0, 0, 0), Size = UDim2.new(0.52, 0, 1, 0),
            Text = val, TextColor3 = col or T.TextSec, TextSize = 11,
            FontFace = F.Semi, TextXAlignment = Enum.TextXAlignment.Left,
        })
    end

    SItem("Status", "Attached", T.Green, 1)
    self.PlaceLbl  = SItem("Place",  game.Name ~= "" and game.Name or "Unknown", T.TextSec, 2)
    self.UptimeLbl = SItem("Uptime", "00:00:00", T.TextSec, 3)
    self.FPSLbl    = SItem("FPS",    "60",       T.Green,   4)

    -- Uptime counter
    local t0 = tick()
    RunService.Heartbeat:Connect(function()
        local e = math.floor(tick() - t0)
        self.UptimeLbl.Text = string.format("%02d:%02d:%02d", e // 3600, (e % 3600) // 60, e % 60)
    end)

    -- FPS counter
    local fc, ft = 0, 0
    RunService.Heartbeat:Connect(function(dt)
        fc += 1; ft += dt
        if ft >= 1 then
            self.FPSLbl.Text = tostring(fc)
            self.FPSLbl.TextColor3 = fc >= 50 and T.Green or fc >= 30 and T.Orange or T.Red
            fc, ft = 0, 0
        end
    end)

    self:SwitchTab("Combat")
    return self
end

-- ============================================================
--  TAB SWITCHING
-- ============================================================
function Lib:SwitchTab(name)
    for n, t in next, self.Tabs do
        local act = n == name
        t.frame.Visible = act
        TweenService:Create(t.btn, TweenInfo.new(0.15),
            {BackgroundColor3 = act and T.SbActive or T.SbBtn}):Play()
        t.ic.ImageColor3 = act and T.AccentLt or T.TextSec
    end
    self.ActiveTab = name
end

-- ============================================================
--  SECTION CARD  (pass a scroll or column frame as parent)
-- ============================================================
function Lib:AddSection(parent, title)
    local card = New("Frame", {
        Parent = parent, BackgroundColor3 = T.Panel,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = #parent:GetChildren(),
    }, {Rad(10), Brd(T.SecBorder, 1)})

    -- Header
    local hdrBg = New("Frame", {
        Parent = card, BackgroundColor3 = T.Section,
        Size = UDim2.new(1, 0, 0, 34),
    })
    Rad(10).Parent = hdrBg
    New("Frame", {
        Parent = hdrBg, BackgroundColor3 = T.Section,
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0),
    })
    -- Left accent bar
    New("Frame", {
        Parent = hdrBg, BackgroundColor3 = T.Accent,
        Position = UDim2.new(0, 0, 0.18, 0), Size = UDim2.new(0, 3, 0.64, 0),
    }, {Rad(2)})
    New("TextLabel", {
        Parent = hdrBg, BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -20, 1, 0),
        Text = title, TextColor3 = T.TextPri, TextSize = 13,
        FontFace = F.Semi, TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Body
    local body = New("Frame", {
        Parent = card, BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 42),
        Size = UDim2.new(1, -24, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    })
    List(8).Parent = body
    New("Frame", {Parent = card, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 10), LayoutOrder = 999})

    return body
end

-- ============================================================
--  TWO-COLUMN ROW  (returns left, right frames)
-- ============================================================
function Lib:AddRow(tabName)
    local scroll = self.Tabs[tabName] and self.Tabs[tabName].scroll
    if not scroll then return nil, nil end
    local row = New("Frame", {
        Parent = scroll, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = #scroll:GetChildren(),
    })
    List(10, Enum.FillDirection.Horizontal).Parent = row
    local left = New("Frame", {
        Parent = row, BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    })
    List(10).Parent = left
    local right = New("Frame", {
        Parent = row, BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    })
    List(10).Parent = right
    return left, right
end

-- Shortcut: get a tab's scroll frame
function Lib:GetScroll(tabName)
    return self.Tabs[tabName] and self.Tabs[tabName].scroll
end

-- ============================================================
--  TOGGLE
-- ============================================================
function Lib:AddToggle(parent, label, default, callback)
    local row = New("Frame", {
        Parent = parent, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30), LayoutOrder = #parent:GetChildren(),
    })
    New("TextLabel", {
        Parent = row, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, -56, 1, 0),
        Text = label, TextColor3 = T.TextSec, TextSize = 13,
        FontFace = F.Medium, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local bg = New("Frame", {
        Parent = row, BackgroundColor3 = default and T.TglOn or T.TglOff,
        Position = UDim2.new(1, -50, 0.5, -11), Size = UDim2.new(0, 42, 0, 22),
    }, {Rad(11)})
    local knob = New("Frame", {
        Parent = bg, BackgroundColor3 = T.TglKnob,
        Position = default and UDim2.new(1, -21, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 17, 0, 17),
    }, {Rad(9)})
    local st = default or false
    New("TextButton", {Parent = bg, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
        .MouseButton1Click:Connect(function()
            st = not st
            TweenService:Create(bg,   TweenInfo.new(0.18), {BackgroundColor3 = st and T.TglOn or T.TglOff}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = st and UDim2.new(1,-21,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
            if callback then callback(st) end
        end)
    return row
end

-- ============================================================
--  SLIDER
-- ============================================================
function Lib:AddSlider(parent, label, min, max, default, callback)
    local f = New("Frame", {
        Parent = parent, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52), LayoutOrder = #parent:GetChildren(),
    })
    New("TextLabel", {
        Parent = f, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 2), Size = UDim2.new(0.7, 0, 0, 18),
        Text = label, TextColor3 = T.TextSec, TextSize = 12,
        FontFace = F.Medium, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local vLbl = New("TextLabel", {
        Parent = f, BackgroundTransparency = 1,
        Position = UDim2.new(1, -38, 0, 2), Size = UDim2.new(0, 38, 0, 18),
        Text = tostring(default), TextColor3 = T.AccentLt, TextSize = 12,
        FontFace = F.Bold, TextXAlignment = Enum.TextXAlignment.Right,
    })
    local track = New("Frame", {
        Parent = f, BackgroundColor3 = T.SlBg,
        Position = UDim2.new(0, 0, 0, 28), Size = UDim2.new(1, 0, 0, 5),
    }, {Rad(3)})
    local fill = New("Frame", {
        Parent = track, BackgroundColor3 = T.SlFill,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
    }, {Rad(3)})
    local hit = New("TextButton", {
        Parent = track, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, -10), Text = "",
    })
    local drag = false
    hit.MouseButton1Down:Connect(function() drag = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local v = math.floor((min + (max - min) * p) * 100) / 100
            fill.Size = UDim2.new(p, 0, 1, 0)
            vLbl.Text = tostring(v)
            if callback then callback(v) end
        end
    end)
    return f
end

-- ============================================================
--  DROPDOWN
-- ============================================================
function Lib:AddDropdown(parent, label, options, default, callback)
    local hasLabel = label ~= ""
    local f = New("Frame", {
        Parent = parent, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, hasLabel and 52 or 34),
        LayoutOrder = #parent:GetChildren(),
    })
    if hasLabel then
        New("TextLabel", {
            Parent = f, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 2), Size = UDim2.new(1, 0, 0, 16),
            Text = label, TextColor3 = T.TextSec, TextSize = 11,
            FontFace = F.Medium, TextXAlignment = Enum.TextXAlignment.Left,
        })
    end
    local yo = hasLabel and 20 or 0
    local dd = New("Frame", {
        Parent = f, BackgroundColor3 = T.Section,
        Position = UDim2.new(0, 0, 0, yo), Size = UDim2.new(1, 0, 0, 30),
    }, {Rad(6), Brd(T.Border, 1)})
    local sel = New("TextLabel", {
        Parent = dd, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -28, 1, 0),
        Text = default or options[1], TextColor3 = T.TextPri, TextSize = 12,
        FontFace = F.Medium, TextXAlignment = Enum.TextXAlignment.Left,
    })
    New("TextLabel", {
        Parent = dd, BackgroundTransparency = 1,
        Position = UDim2.new(1, -22, 0.5, -7), Size = UDim2.new(0, 14, 0, 14),
        Text = "▾", TextColor3 = T.TextSec, TextSize = 13, FontFace = F.Body,
    })
    New("TextButton", {Parent = dd, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
        .MouseButton1Click:Connect(function()
            local cur = sel.Text; local idx = 1
            for j, v in ipairs(options) do if v == cur then idx = j; break end end
            idx = (idx % #options) + 1
            sel.Text = options[idx]
            if callback then callback(options[idx]) end
        end)
    return f
end

return Lib
