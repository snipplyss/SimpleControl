--// SnipplyssHub | UI Library v3.0
--// Executor-safe · loadstring · ≤500 lines
--// Logo: Montserrat ExtraBold uppercase (Orbitron-like)
--// Body: GothamSSm (Inter/Poppins-like)

local Lib = {}; Lib.__index = Lib
local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS  = game:GetService("RunService")
local PL  = game:GetService("Players")

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ PALETTE ━━━━━━━━━━━━━━━━━━━━━━━━━━
local C = {
    BG    = Color3.fromRGB(10,  8, 18),   Side  = Color3.fromRGB(14, 11, 24),
    Pnl   = Color3.fromRGB(17, 13, 29),   Sec   = Color3.fromRGB(12, 10, 21),
    Card  = Color3.fromRGB(19, 15, 32),   Bdr   = Color3.fromRGB(36, 26, 56),
    SbN   = Color3.fromRGB(22, 16, 38),   SbA   = Color3.fromRGB(90, 52,155),
    SbH   = Color3.fromRGB(30, 22, 50),   Acc   = Color3.fromRGB(130, 75,205),
    AHi   = Color3.fromRGB(205,120,255),  ALo   = Color3.fromRGB(85, 42,150),
    TOn   = Color3.fromRGB(112, 65,178),  TOff  = Color3.fromRGB(38,  30, 58),
    Knob  = Color3.fromRGB(252,246,255),  SlF   = Color3.fromRGB(115, 66,188),
    SlB   = Color3.fromRGB(34,  26, 52),  Top   = Color3.fromRGB(12,  9, 20),
    Stat  = Color3.fromRGB(8,   6, 15),   UBg   = Color3.fromRGB(90,  50,158),
    Prem  = Color3.fromRGB(75,  40,130),  PTxt  = Color3.fromRGB(195,160,255),
    T1    = Color3.fromRGB(240,230,255),  T2    = Color3.fromRGB(128,110,158),
    T3    = Color3.fromRGB(62,  52, 85),  Cls   = Color3.fromRGB(200, 52, 68),
    WB    = Color3.fromRGB(50,  40, 70),  Grn   = Color3.fromRGB(65, 190,105),
    Org   = Color3.fromRGB(215,150, 36),  Rd    = Color3.fromRGB(200, 52, 52),
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ ASSETS ━━━━━━━━━━━━━━━━━━━━━━━━━━
Lib.A = {
    User      = "rbxassetid://10747373176",
    Crosshair = "rbxassetid://10709818534",
    Eye       = "rbxassetid://10723346959",
    Sword     = "rbxassetid://10734975486",
    Swords    = "rbxassetid://10734975692",
    Settings  = "rbxassetid://10734950309",
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ FONTS ━━━━━━━━━━━━━━━━━━━━━━━━━━
local F = {
    Logo = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold),
    Head = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold),
    Sm   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.Bold),
    Md   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.SemiBold),
    Rg   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.Medium),
    Bd   = Font.new("rbxasset://fonts/families/GothamSSm.json",  Enum.FontWeight.ExtraBold),
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ HELPERS ━━━━━━━━━━━━━━━━━━━━━━━━━━
local function N(cls, p, ch)
    local o = Instance.new(cls)
    for k, v in next, p do o[k] = v end
    if ch then for _, c in next, ch do c.Parent = o end end
    return o
end
local function Rad(r)       return N("UICorner",  {CornerRadius = UDim.new(0, r or 8)}) end
local function Str(c, t)    return N("UIStroke",  {Color = c or C.Bdr, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end
local function Pad(t,b,l,r) return N("UIPadding", {PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0)}) end
local function Lst(g,d,ha,va) return N("UIListLayout",{Padding=UDim.new(0,g or 6),FillDirection=d or Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=ha or Enum.HorizontalAlignment.Left,VerticalAlignment=va or Enum.VerticalAlignment.Top}) end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ WINDOW ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib.new()
    local self = setmetatable({}, Lib)
    self.Tabs = {}
    local player = PL.LocalPlayer

    local gui = N("ScreenGui", {Name="SnipplyssHub", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    if syn and syn.protect_gui then syn.protect_gui(gui); gui.Parent = game:GetService("CoreGui")
    elseif gethui then gui.Parent = gethui()
    else gui.Parent = game:GetService("CoreGui") end

    -- Drag container
    local ctn = N("Frame",{Parent=gui, BackgroundTransparency=1, Name="Container",
        Position=UDim2.new(0.5,-410,0.5,-278), Size=UDim2.new(0,820,0,556)})
    self.Container = ctn

    -- Outer soft glow halos (behind window, never clipped)
    local gOut = N("Frame",{Parent=ctn,BackgroundColor3=C.Acc,BackgroundTransparency=0.82,
        Position=UDim2.new(0,-10,0,-10),Size=UDim2.new(1,20,1,20)},{Rad(22)})
    local gMid = N("Frame",{Parent=ctn,BackgroundColor3=C.Acc,BackgroundTransparency=0.70,
        Position=UDim2.new(0,-4,0,-4),Size=UDim2.new(1,8,1,8)},{Rad(16)})
    -- Dedicated border frame (transparent bg, NOT inside win so never clipped)
    local bFrm = N("Frame",{Parent=ctn,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},{Rad(14)})
    local wStroke = N("UIStroke",{Parent=bFrm,Color=C.Acc,Thickness=2,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border})

    -- Window
    local win = N("Frame",{Parent=ctn,Name="Window",BackgroundColor3=C.BG,
        Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,812,0,548),ClipsDescendants=true},{Rad(12)})
    self.Window = win

    -- Pulsing neon border + glow (direct property set every frame = real animation)
    RS.Heartbeat:Connect(function()
        local s = (math.sin(tick() * 2.4) + 1) * 0.5
        local col = C.ALo:Lerp(C.AHi, s)
        gOut.BackgroundColor3=col; gOut.BackgroundTransparency = 0.78 + s * 0.16
        gMid.BackgroundColor3=col; gMid.BackgroundTransparency = 0.60 + s * 0.20
        wStroke.Color=col;         wStroke.Thickness = 1.5 + s * 2.5
    end)

    -- Top bar
    local top = N("Frame",{Parent=win,BackgroundColor3=C.Top,Size=UDim2.new(1,0,0,52)},{Str(C.Bdr,1)})

    -- Logo row: [star icon] SNIPPLYSS [star icon]
    local logoRow = N("Frame",{Parent=top,BackgroundTransparency=1,
        Position=UDim2.new(0.5,-175,0,0),Size=UDim2.new(0,350,1,0)})
    Lst(6,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Center).Parent=logoRow
    local starL = N("ImageLabel",{Parent=logoRow,BackgroundTransparency=1,
        Size=UDim2.new(0,22,0,22),Image="rbxassetid://10734966248",ImageColor3=C.AHi,LayoutOrder=1})
    local titleLbl = N("TextLabel",{Parent=logoRow,BackgroundTransparency=1,
        Size=UDim2.new(0,280,1,0),Text="SNIPPLYSS",TextColor3=C.AHi,TextSize=26,
        FontFace=F.Logo,TextXAlignment=Enum.TextXAlignment.Center,LayoutOrder=2})
    local starR = N("ImageLabel",{Parent=logoRow,BackgroundTransparency=1,
        Size=UDim2.new(0,22,0,22),Image="rbxassetid://10734966248",ImageColor3=C.AHi,LayoutOrder=3})
    local grad = N("UIGradient",{Parent=titleLbl,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(162, 72,248)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218,145,255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(152, 62,215)),
        }, Rotation=35})
    RS.Heartbeat:Connect(function()
        local s2 = (math.sin(tick() * 0.9) + 1) * 0.5
        grad.Rotation = 35 + s2 * 44
        local sc = Color3.fromRGB(162,72,248):Lerp(Color3.fromRGB(218,145,255), s2)
        starL.ImageColor3 = sc; starR.ImageColor3 = sc
    end)

    -- Window controls (ImageButtons with real icons)
    local cRow = N("Frame",{Parent=top,BackgroundTransparency=1,
        Position=UDim2.new(1,-112,0.5,-11),Size=UDim2.new(0,102,0,22)})
    Lst(5,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Right,Enum.VerticalAlignment.Center).Parent=cRow

    local function IBtn(col, img, lo)
        local b = N("ImageButton",{Parent=cRow,BackgroundColor3=col,
            Image=img,ImageColor3=Color3.new(1,1,1),
            Size=UDim2.new(0,22,0,22),LayoutOrder=lo},{Rad(6)})
        Pad(4,4,4,4).Parent=b
        b.MouseEnter:Connect(function() TS:Create(b,TweenInfo.new(0.1),{BackgroundColor3=col:Lerp(Color3.new(1,1,1),.22)}):Play() end)
        b.MouseLeave:Connect(function() TS:Create(b,TweenInfo.new(0.1),{BackgroundColor3=col}):Play() end)
        return b
    end

    -- Size constants
    local NRM_CTN  = UDim2.new(0,820,0,556)
    local NRM_WIN  = UDim2.new(0,812,0,548)
    local MINI_CTN = UDim2.new(0,260,0,52)
    local TI_Q     = TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    local TI_B     = TweenInfo.new(0.28,Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local minimized  = false
    local fullscreen = false

    -- Mini widget: small card shown when minimized (replaces ugly topbar collapse)
    local miniWin = N("Frame",{Parent=ctn,Name="MiniWindow",BackgroundColor3=C.Top,
        Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,280,0,52),
        Visible=false},{Rad(12),Str(C.Bdr,1)})
    N("ImageLabel",{Parent=miniWin,BackgroundTransparency=1,
        Image="rbxassetid://10734966248",ImageColor3=C.AHi,
        Position=UDim2.new(0,12,0.5,-8),Size=UDim2.new(0,16,0,16)})
    local mTitle = N("TextLabel",{Parent=miniWin,BackgroundTransparency=1,
        Position=UDim2.new(0,34,0,0),Size=UDim2.new(1,-80,1,0),
        Text="SnipplyssHub",TextColor3=C.AHi,TextSize=14,
        FontFace=F.Logo,TextXAlignment=Enum.TextXAlignment.Left})
    N("UIGradient",{Parent=mTitle,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0,  Color3.fromRGB(162,72,248)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(218,145,255)),
            ColorSequenceKeypoint.new(1,  Color3.fromRGB(152,62,215)),
        },Rotation=35})
    local expandBtn = N("ImageButton",{Parent=miniWin,BackgroundColor3=C.WB,
        Image="rbxassetid://10734895698",ImageColor3=Color3.new(1,1,1),
        Position=UDim2.new(1,-52,0.5,-11),Size=UDim2.new(0,22,0,22)},{Rad(6)})
    Pad(4,4,4,4).Parent=expandBtn
    local mClose = N("ImageButton",{Parent=miniWin,BackgroundColor3=C.Cls,
        Image="rbxassetid://10747384394",ImageColor3=Color3.new(1,1,1),
        Position=UDim2.new(1,-26,0.5,-11),Size=UDim2.new(0,22,0,22)},{Rad(6)})
    Pad(4,4,4,4).Parent=mClose

    -- Minimize: hide main window, show mini card
    IBtn(C.WB,"rbxassetid://10734896206",1).MouseButton1Click:Connect(function()
        if fullscreen then return end
        minimized = true
        win.Visible = false
        miniWin.Visible = true
        TS:Create(ctn, TI_Q, {Size=MINI_CTN}):Play()
    end)

    -- Expand from mini card → back to full window
    expandBtn.MouseButton1Click:Connect(function()
        minimized = false
        miniWin.Visible = false
        win.Visible = true
        TS:Create(ctn, TI_B, {Size=NRM_CTN}):Play()
    end)

    -- Close from mini card
    mClose.MouseButton1Click:Connect(function()
        TS:Create(ctn, TweenInfo.new(0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.In),
            {Size=UDim2.new(0,MINI_CTN.X.Offset*0.88,0,MINI_CTN.Y.Offset*0.88)}):Play()
        task.delay(0.14, function() gui:Destroy() end)
    end)

    -- Fullscreen: fill viewport
    IBtn(C.WB,"rbxassetid://10734895698",2).MouseButton1Click:Connect(function()
        if minimized then return end
        fullscreen = not fullscreen
        if fullscreen then
            local vp = workspace.CurrentCamera.ViewportSize
            TS:Create(ctn, TI_Q, {Size=UDim2.new(0,vp.X+24,0,vp.Y+24), Position=UDim2.new(0,-12,0,-12)}):Play()
            TS:Create(win, TI_Q, {Size=UDim2.new(0,vp.X-8, 0,vp.Y-8)}):Play()
        else
            TS:Create(ctn, TI_Q, {Size=NRM_CTN, Position=UDim2.new(0.5,-494,0.5,-334)}):Play()
            TS:Create(win, TI_Q, {Size=NRM_WIN}):Play()
        end
    end)

    -- Close: shrink + destroy
    IBtn(C.Cls,"rbxassetid://10747384394",3).MouseButton1Click:Connect(function()
        TS:Create(ctn, TweenInfo.new(0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.In),
            {Size=UDim2.new(0,NRM_CTN.X.Offset*0.88,0,NRM_CTN.Y.Offset*0.88)}):Play()
        task.delay(0.14, function() gui:Destroy() end)
    end)

    -- Drag
    local dOn, dSt, cSt = false, nil, nil
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dOn=true; dSt=i.Position; cSt=ctn.Position end
    end)
    top.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dOn=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dOn and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dSt
            ctn.Position = UDim2.new(cSt.X.Scale,cSt.X.Offset+d.X,cSt.Y.Scale,cSt.Y.Offset+d.Y)
        end
    end)

    -- Content
    local content = N("Frame",{Parent=win,BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,52),Size=UDim2.new(1,0,1,-88)})

    -- Sidebar
    local sb = N("Frame",{Parent=content,BackgroundColor3=C.Side,Size=UDim2.new(0,188,1,0)},{Str(C.Bdr,1)})
    local nav = N("Frame",{Parent=sb,BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,12),Size=UDim2.new(1,0,1,-108)})
    Lst(3).Parent=nav; Pad(0,0,10,10).Parent=nav

    -- Tab container
    local tabCon = N("Frame",{Parent=content,BackgroundTransparency=1,
        Position=UDim2.new(0,188,0,0),Size=UDim2.new(1,-188,1,0)})
    self.TabContainer = tabCon

    -- Tab definitions
    local A = Lib.A
    local defs = {
        {n="Combat",   ic=A.Swords,    desc="Enhance your combat experience and dominate."},
        {n="Movement", ic=A.Sword,     desc="Control your movement and traversal abilities."},
        {n="Visuals",  ic=A.Eye,       desc="Customize visual enhancements and ESP options."},
        {n="Misc",     ic=A.Crosshair, desc="Miscellaneous tools and extra utilities."},
        {n="Settings", ic=A.Settings,  desc="Configure your Snipplyss preferences."},
    }

    for i, def in ipairs(defs) do
        local btn = N("TextButton",{Parent=nav,BackgroundColor3=C.SbN,
            Size=UDim2.new(1,0,0,40),Text="",LayoutOrder=i},{Rad(8)})
        local bAcc = N("Frame",{Parent=btn,BackgroundColor3=C.Acc,
            Position=UDim2.new(0,0,0.15,0),Size=UDim2.new(0,3,0.7,0),
            Visible=false},{Rad(2)})
        local bIc = N("ImageLabel",{Parent=btn,BackgroundTransparency=1,
            Image=def.ic,ImageColor3=C.T2,
            Position=UDim2.new(0,14,0.5,-9),Size=UDim2.new(0,18,0,18)})
        local bTxt = N("TextLabel",{Parent=btn,BackgroundTransparency=1,
            Position=UDim2.new(0,38,0,0),Size=UDim2.new(1,-46,1,0),
            Text=def.n,TextColor3=C.T2,TextSize=13,FontFace=F.Sm,TextXAlignment=Enum.TextXAlignment.Left})

        local tf = N("Frame",{Parent=tabCon,BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),Visible=false,Name=def.n})

        local hdr = N("Frame",{Parent=tf,BackgroundColor3=C.Pnl,Size=UDim2.new(1,0,0,58)},{Str(C.Bdr,1)})
        N("ImageLabel",{Parent=hdr,BackgroundTransparency=1,Image=def.ic,ImageColor3=C.Acc,
            Position=UDim2.new(0,18,0.5,-14),Size=UDim2.new(0,28,0,28)})
        N("TextLabel",{Parent=hdr,BackgroundTransparency=1,
            Position=UDim2.new(0,54,0,9),Size=UDim2.new(0.6,0,0,22),
            Text=def.n,TextColor3=C.T1,TextSize=17,FontFace=F.Head,TextXAlignment=Enum.TextXAlignment.Left})
        N("TextLabel",{Parent=hdr,BackgroundTransparency=1,
            Position=UDim2.new(0,54,0,31),Size=UDim2.new(0.82,0,0,14),
            Text=def.desc,TextColor3=C.T3,TextSize=11,FontFace=F.Rg,TextXAlignment=Enum.TextXAlignment.Left})

        local scroll = N("ScrollingFrame",{Parent=tf,BackgroundTransparency=1,
            Position=UDim2.new(0,0,0,58),Size=UDim2.new(1,0,1,-58),
            ScrollBarThickness=3,ScrollBarImageColor3=C.Acc,
            CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
            BorderSizePixel=0})
        Pad(12,12,14,14).Parent=scroll; Lst(10).Parent=scroll

        self.Tabs[def.n] = {frame=tf, scroll=scroll, btn=btn, ic=bIc, lbl=bTxt, acc=bAcc}

        btn.MouseButton1Click:Connect(function() self:SwitchTab(def.n) end)
        btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= def.n then TS:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=C.SbH}):Play() end
        end)
        btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= def.n then TS:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=C.SbN}):Play() end
        end)
    end

    -- User card
    local uc = N("Frame",{Parent=sb,BackgroundColor3=C.SbN,
        Position=UDim2.new(0,10,1,-96),Size=UDim2.new(1,-20,0,84)},{Rad(10),Str(C.Bdr,1)})
    local av = N("Frame",{Parent=uc,BackgroundColor3=C.UBg,
        Position=UDim2.new(0,10,0.5,-20),Size=UDim2.new(0,40,0,40)},{Rad(20)})
    N("TextLabel",{Parent=av,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
        Text="S",TextColor3=C.T1,TextSize=17,FontFace=F.Logo,TextXAlignment=Enum.TextXAlignment.Center})
    N("TextLabel",{Parent=uc,BackgroundTransparency=1,
        Position=UDim2.new(0,58,0,10),Size=UDim2.new(1,-68,0,13),
        Text="Welcome back,",TextColor3=C.T3,TextSize=10,FontFace=F.Rg,TextXAlignment=Enum.TextXAlignment.Left})
    N("TextLabel",{Parent=uc,BackgroundTransparency=1,
        Position=UDim2.new(0,58,0,24),Size=UDim2.new(1,-68,0,16),
        Text=player.Name,TextColor3=C.T1,TextSize=12,FontFace=F.Sm,TextXAlignment=Enum.TextXAlignment.Left})
    local prem = N("Frame",{Parent=uc,BackgroundColor3=C.Prem,
        Position=UDim2.new(0,58,0,46),Size=UDim2.new(0,72,0,18)},{Rad(5)})
    N("TextLabel",{Parent=prem,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
        Text="👑 Premium",TextColor3=C.PTxt,TextSize=10,FontFace=F.Sm,TextXAlignment=Enum.TextXAlignment.Center})

    -- Status bar
    local stat = N("Frame",{Parent=win,BackgroundColor3=C.Stat,
        Position=UDim2.new(0,0,1,-36),Size=UDim2.new(1,0,0,36)},{Str(C.Bdr,1)})
    Pad(0,0,16,16).Parent=stat
    Lst(20,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Left,Enum.VerticalAlignment.Center).Parent=stat

    local function SI(lbl, val, col, lo)
        local f = N("Frame",{Parent=stat,BackgroundTransparency=1,Size=UDim2.new(0,138,1,0),LayoutOrder=lo})
        N("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0.46,0,1,0),
            Text=lbl..":",TextColor3=C.T3,TextSize=11,FontFace=F.Rg,TextXAlignment=Enum.TextXAlignment.Left})
        return N("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.new(0.46,0,0,0),Size=UDim2.new(0.54,0,1,0),
            Text=val,TextColor3=col or C.T2,TextSize=11,FontFace=F.Sm,TextXAlignment=Enum.TextXAlignment.Left})
    end
    local pingLbl  = SI("Ping",   "---ms",   C.T2,  1)
    self.PlaceLbl  = SI("Place",  game.Name ~= "" and game.Name or tostring(game.PlaceId), C.T2, 2)
    self.UptimeLbl = SI("Uptime", "00:00:00", C.T2, 3)
    self.FPSLbl    = SI("FPS",    "60",       C.Grn, 4)

    -- Fetch actual game name async (game.Name can be wrong in executor)
    task.spawn(function()
        local ok, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        if ok and info and info.Name then self.PlaceLbl.Text = info.Name end
    end)

    local t0 = tick()
    RS.Heartbeat:Connect(function()
        local e = math.floor(tick()-t0)
        self.UptimeLbl.Text = string.format("%02d:%02d:%02d", e//3600, (e%3600)//60, e%60)
    end)
    local fc, ft, pingT = 0, 0, 0
    RS.Heartbeat:Connect(function(dt)
        fc+=1; ft+=dt; pingT+=dt
        if ft >= 1 then
            self.FPSLbl.Text = tostring(fc)
            self.FPSLbl.TextColor3 = fc>=50 and C.Grn or fc>=30 and C.Org or C.Rd
            fc, ft = 0, 0
        end
        if pingT >= 2 then
            pingT = 0
            local ok, ms = pcall(function() return math.floor(player:GetNetworkPing()*1000) end)
            if ok then
                pingLbl.Text = ms.."ms"
                pingLbl.TextColor3 = ms<100 and C.Grn or ms<200 and C.Org or C.Rd
            end
        end
    end)

    -- RightShift: hide/show (no gameProcessed filter — executor compat)
    local _open = true
    UIS.InputBegan:Connect(function(i)
        if i.KeyCode ~= Enum.KeyCode.RightShift then return end
        _open = not _open
        if _open then
            local tSz = minimized and MINI_CTN or NRM_CTN
            ctn.Size = UDim2.new(0, tSz.X.Offset*0.88, 0, tSz.Y.Offset*0.88)
            ctn.Visible = true
            TS:Create(ctn, TI_B, {Size=tSz}):Play()
        else
            local sz = ctn.Size
            TS:Create(ctn, TweenInfo.new(0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.In),
                {Size=UDim2.new(0,sz.X.Offset*0.88,0,sz.Y.Offset*0.88)}):Play()
            task.delay(0.15, function()
                ctn.Visible = false
                ctn.Size = minimized and MINI_CTN or NRM_CTN
            end)
        end
    end)

    self:SwitchTab("Combat")
    return self
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ SWITCH TAB ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib:SwitchTab(name)
    for n, t in next, self.Tabs do
        local a = n == name
        t.frame.Visible = a
        TS:Create(t.btn, TweenInfo.new(0.15), {BackgroundColor3 = a and C.SbA or C.SbN}):Play()
        TS:Create(t.lbl, TweenInfo.new(0.15), {TextColor3       = a and C.T1  or C.T2 }):Play()
        t.ic.ImageColor3 = a and C.AHi or C.T2
        if t.acc then t.acc.Visible = a end
    end
    self.ActiveTab = name
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ SECTION ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib:AddSection(parent, title)
    local card = N("Frame",{Parent=parent,BackgroundColor3=C.Card,
        Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
        LayoutOrder=#parent:GetChildren()},{Rad(10),Str(C.Bdr,1)})
    local hdr = N("Frame",{Parent=card,BackgroundColor3=C.Sec,Size=UDim2.new(1,0,0,32)})
    Rad(10).Parent = hdr
    N("Frame",{Parent=hdr,BackgroundColor3=C.Sec,Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0.5,0)})
    N("Frame",{Parent=hdr,BackgroundColor3=C.Acc,Position=UDim2.new(0,0,0.18,0),Size=UDim2.new(0,3,0.64,0)},{Rad(2)})
    N("TextLabel",{Parent=hdr,BackgroundTransparency=1,
        Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-16,1,0),
        Text=title,TextColor3=C.T1,TextSize=13,FontFace=F.Sm,TextXAlignment=Enum.TextXAlignment.Left})
    local body = N("Frame",{Parent=card,BackgroundTransparency=1,
        Position=UDim2.new(0,12,0,40),Size=UDim2.new(1,-24,0,0),AutomaticSize=Enum.AutomaticSize.Y})
    Lst(8).Parent = body
    N("Frame",{Parent=card,BackgroundTransparency=1,Size=UDim2.new(1,0,0,10),LayoutOrder=999})
    return body
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ TWO-COLUMN ROW ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib:AddRow(tabName)
    local sc = self.Tabs[tabName] and self.Tabs[tabName].scroll
    if not sc then return nil, nil end
    local row = N("Frame",{Parent=sc,BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
        LayoutOrder=#sc:GetChildren()})
    Lst(10,Enum.FillDirection.Horizontal).Parent = row
    local L1 = N("Frame",{Parent=row,BackgroundTransparency=1,Size=UDim2.new(0.5,-5,0,0),AutomaticSize=Enum.AutomaticSize.Y}); Lst(10).Parent=L1
    local L2 = N("Frame",{Parent=row,BackgroundTransparency=1,Size=UDim2.new(0.5,-5,0,0),AutomaticSize=Enum.AutomaticSize.Y}); Lst(10).Parent=L2
    return L1, L2
end

function Lib:GetScroll(tabName)
    return self.Tabs[tabName] and self.Tabs[tabName].scroll
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ TOGGLE ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib:AddToggle(parent, label, default, callback)
    local row = N("Frame",{Parent=parent,BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,28),LayoutOrder=#parent:GetChildren()})
    N("TextLabel",{Parent=row,BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,-50,1,0),
        Text=label,TextColor3=C.T2,TextSize=12,FontFace=F.Md,TextXAlignment=Enum.TextXAlignment.Left})
    local bg = N("Frame",{Parent=row,BackgroundColor3=default and C.TOn or C.TOff,
        Position=UDim2.new(1,-44,0.5,-10),Size=UDim2.new(0,38,0,20)},{Rad(10)})
    local kn = N("Frame",{Parent=bg,BackgroundColor3=C.Knob,
        Position=default and UDim2.new(1,-19,0.5,-7) or UDim2.new(0,2,0.5,-7),
        Size=UDim2.new(0,15,0,15)},{Rad(8)})
    local st = default or false
    N("TextButton",{Parent=bg,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""})
        .MouseButton1Click:Connect(function()
            st = not st
            TS:Create(bg,TweenInfo.new(0.16),{BackgroundColor3=st and C.TOn or C.TOff}):Play()
            TS:Create(kn,TweenInfo.new(0.16),{Position=st and UDim2.new(1,-19,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
            if callback then callback(st) end
        end)
    return row
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ SLIDER ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib:AddSlider(parent, label, min, max, default, callback)
    local f = N("Frame",{Parent=parent,BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,48),LayoutOrder=#parent:GetChildren()})
    N("TextLabel",{Parent=f,BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,2),Size=UDim2.new(0.72,0,0,16),
        Text=label,TextColor3=C.T2,TextSize=11,FontFace=F.Md,TextXAlignment=Enum.TextXAlignment.Left})
    local vL = N("TextLabel",{Parent=f,BackgroundTransparency=1,
        Position=UDim2.new(1,-36,0,2),Size=UDim2.new(0,36,0,16),
        Text=tostring(default),TextColor3=C.AHi,TextSize=11,FontFace=F.Bd,TextXAlignment=Enum.TextXAlignment.Right})
    local trk = N("Frame",{Parent=f,BackgroundColor3=C.SlB,
        Position=UDim2.new(0,0,0,28),Size=UDim2.new(1,0,0,4)},{Rad(3)})
    local pct = (default-min)/(max-min)
    local fill  = N("Frame",{Parent=trk,BackgroundColor3=C.SlF,Size=UDim2.new(pct,0,1,0)},{Rad(3)})
    local thumb = N("Frame",{Parent=trk,BackgroundColor3=C.AHi,Size=UDim2.new(0,10,0,10),
        Position=UDim2.new(pct,-5,0.5,-5)},{Rad(5)})
    local hit = N("TextButton",{Parent=trk,BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0.5,-11),Text=""})
    local drag = false
    hit.MouseButton1Down:Connect(function() drag=true end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1)
            local v = math.floor((min+(max-min)*p)*100)/100
            fill.Size=UDim2.new(p,0,1,0); thumb.Position=UDim2.new(p,-5,0.5,-5)
            vL.Text=tostring(v)
            if callback then callback(v) end
        end
    end)
    return f
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━ DROPDOWN ━━━━━━━━━━━━━━━━━━━━━━━━━━
function Lib:AddDropdown(parent, label, options, default, callback)
    local hasL = label ~= ""
    local f = N("Frame",{Parent=parent,BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,hasL and 50 or 32),LayoutOrder=#parent:GetChildren()})
    if hasL then
        N("TextLabel",{Parent=f,BackgroundTransparency=1,
            Position=UDim2.new(0,0,0,2),Size=UDim2.new(1,0,0,14),
            Text=label,TextColor3=C.T2,TextSize=10,FontFace=F.Md,TextXAlignment=Enum.TextXAlignment.Left})
    end
    local yo = hasL and 18 or 0
    local dd = N("Frame",{Parent=f,BackgroundColor3=C.Sec,
        Position=UDim2.new(0,0,0,yo),Size=UDim2.new(1,0,0,30)},{Rad(7),Str(C.Bdr,1)})
    local sel = N("TextLabel",{Parent=dd,BackgroundTransparency=1,
        Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,-26,1,0),
        Text=default or options[1],TextColor3=C.T1,TextSize=12,FontFace=F.Md,TextXAlignment=Enum.TextXAlignment.Left})
    N("TextLabel",{Parent=dd,BackgroundTransparency=1,
        Position=UDim2.new(1,-20,0.5,-7),Size=UDim2.new(0,14,0,14),
        Text="▾",TextColor3=C.T2,TextSize=12,FontFace=F.Rg})
    N("TextButton",{Parent=dd,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""})
        .MouseButton1Click:Connect(function()
            local cur,idx=sel.Text,1
            for j,v in ipairs(options) do if v==cur then idx=j;break end end
            idx=(idx%#options)+1; sel.Text=options[idx]
            if callback then callback(options[idx]) end
        end)
    return f
end

return Lib
