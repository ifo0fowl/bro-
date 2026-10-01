local Library = {}
Library.Version = "5.0.0"
Library.Accent = Color3.fromRGB(139, 92, 246) -- Vibrant Violet
Library.Tween = {Time = 0.35, Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.Out}
Library.MenuKeybind = Enum.KeyCode.RightShift
Library.Windows = {}
Library.Registry = {}
Library.Flags = {}
Library.SetFlags = {}
Library.UnnamedFlags = 0
Library.Directory = "External_Loader"
Library.ConfigFolder = Library.Directory .. "/configs"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Main      = Color3.fromRGB(12, 12, 18),
    Sidebar   = Color3.fromRGB(8, 8, 12),
    Element   = Color3.fromRGB(22, 22, 32), -- Cards, Buttons
    Hover     = Color3.fromRGB(32, 32, 48),
    Inset     = Color3.fromRGB(16, 16, 24), -- Input boxes, Slider tracks
    Line      = Color3.fromRGB(38, 38, 54),
    Bright    = Color3.fromRGB(240, 242, 250),
    Dim       = Color3.fromRGB(160, 162, 180),
    Faint     = Color3.fromRGB(90, 92, 110),
    SwitchOff = Color3.fromRGB(30, 30, 42),
    KnobOff   = Color3.fromRGB(130, 132, 150),
}

local SETTINGS_ICON = "rbxthumb://type=Asset&id=128742673777519&w=150&h=150"
local LOGO_IMAGE = "rbxthumb://type=Asset&id=84038719784102&w=420&h=420"
local FLOAT_IMAGE = "rbxthumb://type=Asset&id=84038719784102&w=420&h=420"

local function clamp(v,a,b) if v<a then return a elseif v>b then return b else return v end end
local function round(v,d) local m=10^(d or 0) return math.floor(v*m+0.5)/m end

pcall(function() if makefolder and not isfolder(Library.Directory) then makefolder(Library.Directory) end end)
pcall(function() if makefolder and not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end end)

function Library:NextFlag()
    Library.UnnamedFlags = Library.UnnamedFlags + 1
    return "_autoflag_" .. Library.UnnamedFlags
end

local function SerializeData(data)
    if typeof(data) == "Color3" then
        return {_type = "Color3", R = data.R, G = data.G, B = data.B}
    elseif typeof(data) == "EnumItem" then
        return {_type = "EnumItem", Value = tostring(data)}
    elseif type(data) == "table" then
        local t = {}
        for k, v in pairs(data) do t[k] = SerializeData(v) end
        return t
    end
    return data
end

local function DeserializeData(data)
    if type(data) == "table" then
        if data._type == "Color3" then return Color3.new(data.R, data.G, data.B)
        elseif data._type == "EnumItem" then
            local ok, val = pcall(function()
                local parts = tostring(data.Value):split(".")
                return Enum[parts[2]][parts[3]]
            end)
            return ok and val or data.Value
        end
        local t = {}
        for k, v in pairs(data) do t[k] = DeserializeData(v) end
        return t
    end
    return data
end

function Library:GetConfig()
    local cfg = {}
    for idx, val in pairs(Library.Flags) do
        if idx ~= "_config_name" and idx ~= "_config_list" then cfg[idx] = SerializeData(val) end
    end
    return HttpService:JSONEncode(cfg)
end

function Library:LoadConfig(json)
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" then return false end
    for idx, val in pairs(data) do
        if idx == "_config_name" or idx == "_config_list" then continue end
        local decoded = DeserializeData(val)
        Library.Flags[idx] = decoded
        if Library.SetFlags[idx] then pcall(Library.SetFlags[idx], decoded) end
    end
    return true
end

local function Create(class, props, children)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do if k ~= "Parent" then pcall(function() o[k]=v end) end end
    for _,c in ipairs(children or {}) do c.Parent=o end
    if props and props.Parent then o.Parent=props.Parent end
    return o
end

local function Corner(p,r) return Create("UICorner",{CornerRadius=UDim.new(0,r or 10),Parent=p}) end
local function Stroke(p,c,t,th) return Create("UIStroke",{Color=c or Theme.Line,Transparency=t==nil and 0.3 or t,Thickness=th or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=p}) end
local function Padding(p,l,t,r,b) return Create("UIPadding",{PaddingLeft=UDim.new(0,l or 12),PaddingTop=UDim.new(0,t or 10),PaddingRight=UDim.new(0,r or 12),PaddingBottom=UDim.new(0,b or 10),Parent=p}) end
local function Gradient(p, c1, c2, rot) return Create("UIGradient",{Color=ColorSequence.new(c1 or Color3.new(1,1,1),c2 or Color3.new(0.6,0.6,0.6)),Rotation=rot or 90,Parent=p}) end
local function Tween(o,pr,tm,st,dr)
    local tw=TweenService:Create(o,TweenInfo.new(tm or Library.Tween.Time,st or Library.Tween.Style,dr or Library.Tween.Direction),pr)
    tw:Play() return tw
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    handle.Active = true
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true dragStart=input.Position startPos=frame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-dragStart
            Tween(frame, {Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)}, 0.08, Enum.EasingStyle.Linear)
        end
    end)
end

local function GetParentGui()
    local ok,hui=pcall(function() return gethui and gethui() end)
    if ok and typeof(hui)=="Instance" then return hui end
    local ok2,cg=pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")
end

function Library:SetAccent(color)
    Library.Accent=color
    for _,e in ipairs(Library.Registry) do
        pcall(function() if e.Obj and e.Obj.Parent then e.Obj[e.Prop]=color end end)
    end
    for _,w in ipairs(Library.Windows) do
        if w._ApplyAccent then pcall(w._ApplyAccent,color) end
    end
end

function Library:CreateWindow(config)
    config=config or {}
    local Name=config.Name or "External"
    local SubTitle=config.SubTitle or "v5.0"
    local Accent=config.Accent or Color3.fromRGB(139, 92, 246)
    local ToggleKey=config.ToggleKey or Enum.KeyCode.RightShift
    local SearchEnabled=config.SearchEnabled==nil and true or config.SearchEnabled
    local SubText=config.SubText or "Sub expires in: Lifetime"
    local FooterText=config.FooterText or (LocalPlayer and LocalPlayer.DisplayName or "guest")
    local WinSize=config.Size or UDim2.fromOffset(920,600)
    local SideW=260
    Library.Accent=Accent
    Library.MenuKeybind=ToggleKey
    local isMobile=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local GuiParent=GetParentGui()
    local ScreenGui=Create("ScreenGui",{Name=Name.."_V5_"..tostring(math.random(10000,99999)),ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,DisplayOrder=50,Parent=GuiParent})
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) elseif protect_gui then protect_gui(ScreenGui) end end)
    local MainScale = Create("UIScale",{Parent=ScreenGui, Scale=1})

    -- floating button for mobile
    local FloatBtn=Create("TextButton",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,16,0.5,0),Size=UDim2.fromOffset(54,54),BackgroundColor3=Theme.Element,Text="",AutoButtonColor=false,Visible=false,Parent=ScreenGui})
    Corner(FloatBtn,16) Stroke(FloatBtn,Library.Accent,0.2,1.5)
    Create("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(1,-16,1,-16),BackgroundTransparency=1,Image=FLOAT_IMAGE,Parent=FloatBtn})

    -- main frame with heavy drop shadow
    local Main=Create("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=WinSize,BackgroundColor3=Theme.Main,BorderSizePixel=0,ClipsDescendants=true,Parent=ScreenGui})
    Corner(Main,14) Stroke(Main,Theme.Line,0.4,1)
    
    -- Drop shadow image behind main (if we wanted true shadow, we'd need an image slice, skipping for simplicity)
    
    -- ambient top glow
    local topGlow=Create("Frame",{Size=UDim2.new(1,0,0,160),BackgroundColor3=Library.Accent,BackgroundTransparency=0.90,BorderSizePixel=0,ZIndex=0,Parent=Main})
    Gradient(topGlow, Color3.new(1,1,1), Color3.new(1,1,1), 90)
    Create("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.4,0.7),NumberSequenceKeypoint.new(1,1)}),Rotation=90,Parent=topGlow})
    table.insert(Library.Registry,{Obj=topGlow,Prop="BackgroundColor3"})

    -- resize grip
    local Grip=Create("TextButton",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,0,1,0),Size=UDim2.fromOffset(30,30),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=50,Parent=Main})
    local rsz=false local rStart=nil local rSize=nil
    local GripIcon=Create("ImageLabel",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-8,1,-8),Size=UDim2.fromOffset(14,14),BackgroundTransparency=1,Image="rbxthumb://type=Asset&id=6153965706&w=150&h=150",ImageColor3=Theme.Faint,ImageTransparency=0.3,ZIndex=50,Parent=Grip})
    Grip.MouseEnter:Connect(function() Tween(GripIcon,{ImageColor3=Theme.Bright,ImageTransparency=0},0.2) end)
    Grip.MouseLeave:Connect(function() if not rsz then Tween(GripIcon,{ImageColor3=Theme.Faint,ImageTransparency=0.3},0.2) end end)
    Grip.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then rsz=true rStart=input.Position rSize=Main.Size end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if rsz and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-rStart
            Main.Size=UDim2.new(0,math.clamp(rSize.X.Offset+d.X,700,1800),0,math.clamp(rSize.Y.Offset+d.Y,480,1200))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if rsz and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then rsz=false WinSize=Main.Size end
    end)

    -- sidebar
    local Sidebar=Create("Frame",{Size=UDim2.new(0,SideW,1,0),BackgroundColor3=Theme.Sidebar,BorderSizePixel=0,Parent=Main})
    Corner(Sidebar,14)
    Create("Frame",{Position=UDim2.new(1,-14,0,0),Size=UDim2.new(0,14,1,0),BackgroundColor3=Theme.Sidebar,BorderSizePixel=0,Parent=Sidebar})
    local sideDiv=Create("Frame",{Position=UDim2.new(0,SideW,0,16),Size=UDim2.new(0,1,1,-32),BackgroundColor3=Theme.Line,BackgroundTransparency=0.6,BorderSizePixel=0,Parent=Main})
    
    local sideGrad=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Library.Accent,BackgroundTransparency=0.96,BorderSizePixel=0,ZIndex=0,Parent=Sidebar})
    Gradient(sideGrad, Color3.new(1,1,1), Color3.new(0.3,0.3,0.3), 180)
    table.insert(Library.Registry,{Obj=sideGrad,Prop="BackgroundColor3"})

    -- logo row
    local LogoRow=Create("Frame",{Position=UDim2.new(0,20,0,20),Size=UDim2.new(1,-40,0,56),BackgroundTransparency=1,Parent=Sidebar})
    local LogoBox=Create("Frame",{Position=UDim2.new(0,0,0.5,-26),Size=UDim2.fromOffset(52,52),BackgroundColor3=Theme.Element,BorderSizePixel=0,Parent=LogoRow})
    Corner(LogoBox,14)
    local logoStroke=Stroke(LogoBox,Library.Accent,0.4,1.5) table.insert(Library.Registry,{Obj=logoStroke,Prop="Color"})
    Create("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(1,-12,1,-12),BackgroundTransparency=1,Image=LOGO_IMAGE,Parent=LogoBox})
    Create("TextLabel",{Position=UDim2.new(0,64,0,6),Size=UDim2.new(1,-64,0,24),BackgroundTransparency=1,Text=Name,Font=Enum.Font.GothamBold,TextSize=18,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=LogoRow})
    Create("TextLabel",{Position=UDim2.new(0,64,0,30),Size=UDim2.new(1,-64,0,18),BackgroundTransparency=1,Text=SubTitle,Font=Enum.Font.GothamMedium,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextTruncate=Enum.TextTruncate.AtEnd,Parent=LogoRow})

    -- tab list
    local TabList=Create("ScrollingFrame",{Position=UDim2.new(0,20,0,96),Size=UDim2.new(1,-40,1,-200),BackgroundTransparency=1,ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Sidebar})
    Create("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=TabList})
    local Groups={} local GroupOrder={}
    local function GroupHolder(gname)
        if Groups[gname] then return Groups[gname] end
        local label=Create("TextLabel",{Size=UDim2.new(1,-4,0,36),BackgroundTransparency=1,Text=string.upper(gname),Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Faint,Parent=TabList})
        Padding(label,6,12,0,4)
        local h=Create("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Parent=TabList})
        Create("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=h})
        Groups[gname]=h table.insert(GroupOrder,gname)
        return h
    end

    -- footer
    local Footer=Create("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,90),BackgroundTransparency=1,Parent=Sidebar})
    Padding(Footer,20,10,20,16)
    Create("Frame",{Position=UDim2.new(0,20,0,0),Size=UDim2.new(1,-40,0,1),BackgroundColor3=Theme.Line,BackgroundTransparency=0.6,BorderSizePixel=0,Parent=Footer})
    local Avatar=Create("ImageLabel",{Position=UDim2.new(0,0,0,14),Size=UDim2.fromOffset(40,40),BackgroundColor3=Theme.Element,Image="",Parent=Footer})
    Corner(Avatar,20) Stroke(Avatar,Theme.Line,0.3,1.5)
    task.spawn(function()
        for _=1,12 do
            local ok,img=pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48) end)
            if ok and typeof(img)=="string" and img~="" then Avatar.Image=img break end
            task.wait(0.5)
        end
    end)
    Create("TextLabel",{Position=UDim2.new(0,54,0,12),Size=UDim2.new(1,-54,0,20),BackgroundTransparency=1,Text=FooterText,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=Footer})
    Create("TextLabel",{Position=UDim2.new(0,54,0,32),Size=UDim2.new(1,-54,0,18),BackgroundTransparency=1,Text=SubText,Font=Enum.Font.GothamMedium,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextTruncate=Enum.TextTruncate.AtEnd,Parent=Footer})
    local SessLabel=Create("TextLabel",{Position=UDim2.new(0,0,1,-18),Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text="Session duration: 0:00",Font=Enum.Font.GothamMedium,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Faint,Parent=Footer})
    local _t0=os.clock()
    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(1)
            pcall(function()
                local s=math.floor(os.clock()-_t0)
                SessLabel.Text="Session duration: "..math.floor(s/60)..":"..string.format("%02d",s%60)
            end)
        end
    end)

    -- content area
    local ContentWrap=Create("Frame",{Position=UDim2.new(0,SideW+1,0,0),Size=UDim2.new(1,-SideW-1,1,0),BackgroundTransparency=1,Parent=Main})

    -- header bar
    local Headbar=Create("Frame",{Size=UDim2.new(1,0,0,64),BackgroundTransparency=1,Parent=ContentWrap})
    Padding(Headbar,24,18,20,8)
    local TitleLabel=Create("TextLabel",{Size=UDim2.new(1,-300,1,0),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=22,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=Headbar})

    -- search box
    local SearchBox=Create("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-96,0,0),Size=UDim2.new(0,240,0,38),BackgroundColor3=Theme.Element,BackgroundTransparency=0.3,Parent=Headbar})
    Corner(SearchBox,12) Stroke(SearchBox,Theme.Line,0.5,1)
    Create("TextLabel",{Position=UDim2.new(0,16,0,0),Size=UDim2.new(0,16,1,0),BackgroundTransparency=1,Text="🔎",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Faint,Parent=SearchBox})
    local SearchInput=Create("TextBox",{Position=UDim2.new(0,38,0,0),Size=UDim2.new(1,-46,1,0),BackgroundTransparency=1,PlaceholderText="Search elements...",PlaceholderColor3=Theme.Faint,Text="",Font=Enum.Font.GothamMedium,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,ClearTextOnFocus=false,Parent=SearchBox})
    if not SearchEnabled then SearchBox.Visible=false end

    -- header buttons
    local function GhostBtn(txt, xoff)
        local b=Create("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,xoff,0,3),Size=UDim2.fromOffset(32,32),BackgroundColor3=Theme.Element,BackgroundTransparency=1,Text=txt,Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Theme.Faint,AutoButtonColor=false,Parent=Headbar})
        Corner(b,8)
        b.MouseEnter:Connect(function() Tween(b,{TextColor3=Theme.Bright,BackgroundTransparency=0.3},0.2) end)
        b.MouseLeave:Connect(function() Tween(b,{TextColor3=Theme.Faint,BackgroundTransparency=1},0.2) end)
        return b
    end
    local CloseBtn=GhostBtn("✕", 0)
    local MinBtn=GhostBtn("—", -42)

    -- sub-tab bar
    local SubBar=Create("Frame",{Position=UDim2.new(0,0,0,64),Size=UDim2.new(1,0,0,42),BackgroundTransparency=1,Visible=false,Parent=ContentWrap})
    Padding(SubBar,24,0,0,0)
    Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=SubBar})

    -- pages container
    local Pages=Create("Frame",{Position=UDim2.new(0,0,0,64),Size=UDim2.new(1,0,1,-64),BackgroundTransparency=1,ClipsDescendants=true,Parent=ContentWrap})
    Padding(Pages,6,0,16,20)

    -- notification holder
    local NotifHolder=Create("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-20,1,-20),Size=UDim2.new(0,340,1,-40),BackgroundTransparency=1,Parent=ScreenGui})
    Create("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=UDim.new(0,12),Parent=NotifHolder})

    local Window={Gui=ScreenGui,Main=Main,Tabs={},CurrentTab=nil,_AllElements={},Visible=true}
    function Window._ApplyAccent(c)
        for _,t in pairs(Window.Tabs) do if t._Active and t._Edge then t._Edge.BackgroundColor3=c end end
    end

    function Window:Notify(opts)
        opts=opts or {}
        local title=opts.Title or "Notification"
        local desc=opts.Description or ""
        local dur=opts.Duration or 4

        local card=Create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=Theme.Element,BackgroundTransparency=0.1,Parent=NotifHolder})
        Corner(card,14) Stroke(card,Theme.Line,0.4,1)
        
        -- glass effect gradient
        local cardGrad=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.96,BorderSizePixel=0,ZIndex=0,Parent=card})
        Corner(cardGrad,14) Gradient(cardGrad, Color3.new(1,1,1), Color3.new(0.4,0.4,0.5), 90)

        local acc=Create("Frame",{Size=UDim2.new(0,4,1,-24),Position=UDim2.new(0,12,0,12),BackgroundColor3=Library.Accent,BorderSizePixel=0,Parent=card})
        Corner(acc,2) table.insert(Library.Registry,{Obj=acc,Prop="BackgroundColor3"})

        local accGlow=Create("Frame",{Size=UDim2.new(0,10,1,-18),Position=UDim2.new(0,9,0,9),BackgroundColor3=Library.Accent,BackgroundTransparency=0.88,BorderSizePixel=0,Parent=card})
        Corner(accGlow,5) table.insert(Library.Registry,{Obj=accGlow,Prop="BackgroundColor3"})

        Create("TextLabel",{Position=UDim2.new(0,30,0,12),Size=UDim2.new(1,-40,0,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,Text=title,Parent=card})
        Create("TextLabel",{Position=UDim2.new(0,30,0,32),Size=UDim2.new(1,-40,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Font=Enum.Font.GothamMedium,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextWrapped=true,Text=desc,Parent=card})
        Padding(card,0,0,0,16)

        card.Position=UDim2.new(1,50,0,0)
        Tween(card,{Position=UDim2.new(0,0,0,0)},0.4,Enum.EasingStyle.Back)

        task.delay(dur,function()
            Tween(card,{BackgroundTransparency=1,Position=UDim2.new(1,50,0,0)},0.35)
            for _,d in ipairs(card:GetDescendants()) do
                pcall(function()
                    if d:IsA("TextLabel") then Tween(d,{TextTransparency=1},0.35) elseif d:IsA("Frame") then Tween(d,{BackgroundTransparency=1},0.35) end
                end)
            end
            task.wait(0.38) pcall(function() card:Destroy() end)
        end)
    end

    function Window:SetAccent(c) Library:SetAccent(c) end

    function Window:Toggle(force)
        local target=force if target==nil then target=not Window.Visible end
        Window.Visible=target Main.Visible=target FloatBtn.Visible=(not target) and isMobile
        if target then
            Main.Size=UDim2.fromOffset(WinSize.X.Offset,WinSize.Y.Offset-30)
            Main.BackgroundTransparency=0.2
            Tween(Main,{Size=WinSize,BackgroundTransparency=0},0.35,Enum.EasingStyle.Back)
        end
    end

    local fDrag=false local fStart=nil local fMoved=false
    FloatBtn.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then fDrag=true fMoved=false fStart=input.Position end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if fDrag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            if (input.Position-fStart).Magnitude>8 then
                if not fMoved then fMoved=true FloatBtn.AnchorPoint=Vector2.new(0.5,0.5) end
                FloatBtn.Position=UDim2.new(0,input.Position.X,0,input.Position.Y)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if fDrag and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
            fDrag=false if not fMoved then Window:Toggle(true) end
        end
    end)

    MinBtn.MouseButton1Click:Connect(function() Window:Toggle(false) end)
    CloseBtn.MouseButton1Click:Connect(function() Window:Toggle(false) end)
    UserInputService.InputBegan:Connect(function(i,g) if g then return end if i.KeyCode==ToggleKey then Window:Toggle() end end)
    MakeDraggable(Main,Headbar) MakeDraggable(Main,Sidebar)

    -- =============================================
    -- ELEMENT FACTORY
    -- =============================================
    local function attachElements(host, body, elements, allElements)
        local function reg(frame,txt) local el={Frame=frame,SearchText=txt} table.insert(elements,el) table.insert(allElements,el) return el end

        function host:AddToggle(opts)
            opts=opts or {}
            local tName=opts.Name or "Toggle"
            local desc=opts.Description or opts.Desc or ""
            local default=opts.Default or false
            local cb=opts.Callback or function() end
            local keyHint=opts.KeyHint or opts.Hint or ""
            local flag=opts.Flag or opts.flag

            local hasDesc=desc~=""
            local rowH=hasDesc and 50 or 38
            local row=Create("Frame",{Size=UDim2.new(1,0,0,rowH),BackgroundTransparency=1,Parent=body})

            Create("TextLabel",{
                Position=UDim2.new(0,4,0,hasDesc and 4 or 0),
                Size=UDim2.new(1,-68,0,hasDesc and 20 or 38),
                BackgroundTransparency=1,
                Text=tName,
                Font=Enum.Font.GothamBold,
                TextSize=14,
                TextXAlignment=Enum.TextXAlignment.Left,
                TextYAlignment=Enum.TextYAlignment.Center,
                TextColor3=Theme.Bright,
                TextTruncate=Enum.TextTruncate.AtEnd,
                Parent=row
            })

            if hasDesc then
                Create("TextLabel",{
                    Position=UDim2.new(0,4,0,24),
                    Size=UDim2.new(1,-84,0,18),
                    BackgroundTransparency=1,
                    Text=desc,
                    Font=Enum.Font.GothamMedium,
                    TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    TextColor3=Theme.Faint,
                    TextTruncate=Enum.TextTruncate.AtEnd,
                    Parent=row
                })
            end

            local hint=nil
            if keyHint~="" then
                hint=Create("TextLabel",{
                    AnchorPoint=Vector2.new(1,0.5),
                    Position=UDim2.new(1,-60,0.5,0),
                    Size=UDim2.fromOffset(26,22),
                    BackgroundColor3=Theme.Hover,
                    Text=tostring(keyHint),
                    Font=Enum.Font.GothamBold,
                    TextSize=11,
                    TextColor3=Theme.Faint,
                    Parent=row
                })
                Corner(hint,6) Stroke(hint,Theme.Line,0.5,1)
            end

            -- High-fidelity pill switch
            local track=Create("TextButton",{
                AnchorPoint=Vector2.new(1,0.5),
                Position=UDim2.new(1,-2,0.5,0),
                Size=UDim2.fromOffset(46,26),
                BackgroundColor3=default and Library.Accent or Theme.SwitchOff,
                Text="",
                AutoButtonColor=false,
                Parent=row
            })
            Corner(track,13)
            local trackStroke=Stroke(track, default and Library.Accent or Theme.Line, default and 0.2 or 0.4, 1)

            -- Knob
            local knob=Create("Frame",{
                AnchorPoint=Vector2.new(0,0.5),
                Position=default and UDim2.new(1,-23,0.5,0) or UDim2.new(0,3,0.5,0),
                Size=UDim2.fromOffset(20,20),
                BackgroundColor3=default and Color3.fromRGB(255,255,255) or Theme.KnobOff,
                BorderSizePixel=0,
                Parent=track
            })
            Corner(knob,10)
            -- Subtle drop shadow for knob
            local knobShadow = Create("ImageLabel",{
                AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(0.5,0,0.5,2),
                Size=UDim2.new(1,12,1,12),
                BackgroundTransparency=1,
                Image="rbxthumb://type=Asset&id=6015897843&w=150&h=150",
                ImageColor3=Color3.fromRGB(0,0,0),
                ImageTransparency=default and 0.5 or 0.7,
                ZIndex=knob.ZIndex-1,
                Parent=knob
            })

            if default then
                table.insert(Library.Registry,{Obj=track,Prop="BackgroundColor3"})
                table.insert(Library.Registry,{Obj=trackStroke,Prop="Color"})
            end

            local T={Value=default,Flag=flag}
            local function apply(v,silent)
                T.Value=v
                if flag then Library.Flags[flag]=v end
                if v then
                    local ft,fs=false,false
                    for _,e in ipairs(Library.Registry) do if e.Obj==track then ft=true elseif e.Obj==trackStroke then fs=true end end
                    if not ft then table.insert(Library.Registry,{Obj=track,Prop="BackgroundColor3"}) end
                    if not fs then table.insert(Library.Registry,{Obj=trackStroke,Prop="Color"}) end

                    Tween(track,{BackgroundColor3=Library.Accent},0.25)
                    Tween(trackStroke,{Color=Library.Accent,Transparency=0.2},0.25)
                    Tween(knob,{Position=UDim2.new(1,-23,0.5,0),BackgroundColor3=Color3.fromRGB(255,255,255)},0.3,Enum.EasingStyle.Back)
                    Tween(knobShadow,{ImageTransparency=0.5},0.25)
                else
                    for i=#Library.Registry,1,-1 do
                        local o=Library.Registry[i].Obj
                        if o==track or o==trackStroke then table.remove(Library.Registry,i) end
                    end

                    Tween(track,{BackgroundColor3=Theme.SwitchOff},0.25)
                    Tween(trackStroke,{Color=Theme.Line,Transparency=0.4},0.25)
                    Tween(knob,{Position=UDim2.new(0,3,0.5,0),BackgroundColor3=Theme.KnobOff},0.3,Enum.EasingStyle.Back)
                    Tween(knobShadow,{ImageTransparency=0.7},0.25)
                end
                if not silent then pcall(cb,v) end
            end

            function T:Set(v) apply(v and true or false) end
            function T:Get() return T.Value end
            function T:AddKeybind(kb)
                kb=kb or {} local def=kb.Default or Enum.KeyCode.T local kcb=kb.Callback or function() end
                local badge=hint or Create("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-60,0.5,0),Size=UDim2.fromOffset(26,22),BackgroundColor3=Theme.Hover,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Theme.Faint,Parent=row})
                if not hint then Corner(badge,6) Stroke(badge,Theme.Line,0.5,1) end
                local cur=def badge.Text=cur.Name local wait=false
                local rb=Create("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=badge.Position,Size=badge.Size,BackgroundTransparency=1,Text="",Parent=row})
                rb.MouseButton1Click:Connect(function() wait=true badge.Text="..." end)
                UserInputService.InputBegan:Connect(function(inp,gpe)
                    if wait and not gpe and inp.UserInputType==Enum.UserInputType.Keyboard then cur=inp.KeyCode badge.Text=cur.Name wait=false return end
                    if not gpe and inp.KeyCode==cur then T:Set(not T.Value) pcall(kcb,cur) end
                end)
                return T
            end

            track.MouseButton1Click:Connect(function() apply(not T.Value) end)
            Create("TextButton",{Size=UDim2.new(1,-70,1,0),BackgroundTransparency=1,Text="",Parent=row}).MouseButton1Click:Connect(function() apply(not T.Value) end)
            reg(row,tName.." "..desc)

            if flag then Library.Flags[flag]=default Library.SetFlags[flag]=function(v) T:Set(v) end end
            pcall(cb,default) return T
        end

        function host:AddButton(opts)
            opts=opts or {}
            local n=opts.Name or opts.Text or "Button"
            local cb=opts.Callback or function() end

            local b=Create("TextButton",{
                Size=UDim2.new(1,0,0,40),
                BackgroundColor3=Theme.Element,
                BackgroundTransparency=0.4,
                Text=n,
                Font=Enum.Font.GothamBold,
                TextSize=14,
                TextColor3=Theme.Bright,
                AutoButtonColor=false,
                Parent=body
            })
            Corner(b,10) Stroke(b,Theme.Line,0.4,1)

            b.MouseEnter:Connect(function() Tween(b,{BackgroundColor3=Library.Accent,BackgroundTransparency=0.1,TextColor3=Color3.fromRGB(255,255,255)},0.2) end)
            b.MouseLeave:Connect(function() Tween(b,{BackgroundColor3=Theme.Element,BackgroundTransparency=0.4,TextColor3=Theme.Bright},0.2) end)
            b.MouseButton1Click:Connect(function()
                Tween(b,{BackgroundTransparency=0},0.05)
                task.delay(0.08,function() Tween(b,{BackgroundTransparency=0.1},0.15) end)
                pcall(cb)
            end)
            reg(b,n) return b
        end

        function host:AddSlider(opts)
            opts=opts or {}
            local n=opts.Name or "Slider"
            local min=opts.Min or 0
            local max=opts.Max or 100
            local def=clamp(opts.Default or opts.Value or min,min,max)
            local suf=opts.Suffix or ""
            local dec=opts.Decimals or 0
            local cb=opts.Callback or function() end
            local flag=opts.Flag or opts.flag

            local wrap=Create("Frame",{Size=UDim2.new(1,0,0,58),BackgroundTransparency=1,Parent=body})
            Create("TextLabel",{Position=UDim2.new(0,4,0,2),Size=UDim2.new(1,-80,0,20),BackgroundTransparency=1,Text=n,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=wrap})
            local val=Create("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-4,0,2),Size=UDim2.new(0,70,0,20),BackgroundTransparency=1,Text=tostring(round(def,dec))..suf,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Right,TextColor3=Theme.Dim,TextTruncate=Enum.TextTruncate.AtEnd,Parent=wrap})

            local track=Create("TextButton",{Position=UDim2.new(0,4,0,36),Size=UDim2.new(1,-8,0,8),BackgroundColor3=Theme.Inset,Text="",AutoButtonColor=false,Parent=wrap})
            Corner(track,4) Stroke(track,Theme.Line,0.5,1)

            local fill=Create("Frame",{Size=UDim2.new((def-min)/math.max(1,(max-min)),0,1,0),BackgroundColor3=Library.Accent,BorderSizePixel=0,Parent=track})
            Corner(fill,4) table.insert(Library.Registry,{Obj=fill,Prop="BackgroundColor3"})
            local fillGlow=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.85,BorderSizePixel=0,Parent=fill})
            Corner(fillGlow,4) Gradient(fillGlow, Color3.new(1,1,1), Color3.new(0.6,0.6,0.6), 90)

            local knob=Create("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((def-min)/math.max(1,(max-min)),0,0.5,0),Size=UDim2.fromOffset(18,18),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,Parent=track})
            Corner(knob,9) Stroke(knob,Color3.fromRGB(0,0,0),0.7,1)
            
            local knobShadow = Create("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,2),Size=UDim2.new(1,10,1,10),BackgroundTransparency=1,Image="rbxthumb://type=Asset&id=6015897843&w=150&h=150",ImageColor3=Color3.fromRGB(0,0,0),ImageTransparency=0.6,ZIndex=knob.ZIndex-1,Parent=knob})

            local S={Value=def,Flag=flag} local drag=false
            local function setX(x)
                local a=clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)
                local v=round(min+(max-min)*a,dec) S.Value=v
                if flag then Library.Flags[flag]=v end
                fill.Size=UDim2.new(a,0,1,0) knob.Position=UDim2.new(a,0,0.5,0) val.Text=tostring(v)..suf pcall(cb,v)
            end

            track.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    drag=true setX(i.Position.X) Tween(knob,{Size=UDim2.fromOffset(20,20)},0.15)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false Tween(knob,{Size=UDim2.fromOffset(18,18)},0.15) end
            end)
            UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then setX(i.Position.X) end end)

            function S:Set(v)
                v=clamp(round(v,dec),min,max) local a=(v-min)/math.max(1,(max-min)) S.Value=v if flag then Library.Flags[flag]=v end
                Tween(fill,{Size=UDim2.new(a,0,1,0)},0.15) Tween(knob,{Position=UDim2.new(a,0,0.5,0)},0.15) val.Text=tostring(v)..suf pcall(cb,v)
            end
            function S:Get() return S.Value end
            if flag then Library.Flags[flag]=def Library.SetFlags[flag]=function(v) S:Set(v) end end
            reg(wrap,n) return S
        end

        function host:AddDropdown(opts)
            opts=opts or {}
            local n=opts.Name or "Dropdown"
            local options=opts.Options or opts.Items or {"Option 1"}
            local def=opts.Default or options[1]
            local multi=opts.Multi or opts.Multiple or false
            local cb=opts.Callback or function() end
            local flag=opts.Flag or opts.flag

            local wrap=Create("Frame",{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,ClipsDescendants=false,Parent=body})
            Create("TextLabel",{Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-170,1,0),BackgroundTransparency=1,Text=n,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=wrap})

            local btn=Create("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.new(0,165,0,34),BackgroundColor3=Theme.Hover,Text="",AutoButtonColor=false,Parent=wrap})
            Corner(btn,8) Stroke(btn,Theme.Line,0.4,1)

            local sel=Create("TextLabel",{Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-34,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextTruncate=Enum.TextTruncate.AtEnd,Parent=btn})
            local chevron=Create("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(16,16),BackgroundTransparency=1,Text="▾",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Faint,Parent=btn})

            local list=Create("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-2,0,38),Size=UDim2.new(0,165,0,0),BackgroundColor3=Theme.Element,ClipsDescendants=true,Visible=false,ZIndex=20,Parent=wrap})
            Corner(list,10) Stroke(list,Theme.Line,0.3,1)
            Create("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=list}) Padding(list,4,4,4,4)

            local selected=multi and {} or tostring(def)
            if multi and type(def)=="table" then for _,v in ipairs(def) do selected[v]=true end end
            local open=false

            local function refresh()
                if multi then
                    local t={} for k,v in pairs(selected) do if v then table.insert(t,k) end end
                    sel.Text=#t>0 and table.concat(t,", ") or "None" sel.TextColor3=#t>0 and Theme.Bright or Theme.Dim
                else sel.Text=tostring(selected) sel.TextColor3=Theme.Bright end
                if flag then Library.Flags[flag]=selected end
            end

            local function setOpen(v)
                open=v list.Visible=true
                if v then
                    local h=math.min(#options*34+8,180)
                    Tween(list,{Size=UDim2.new(0,165,0,h)},0.25,Enum.EasingStyle.Back)
                    Tween(wrap,{Size=UDim2.new(1,0,0,40+h)},0.25,Enum.EasingStyle.Back)
                    Tween(chevron,{Rotation=180},0.25)
                else
                    Tween(list,{Size=UDim2.new(0,165,0,0)},0.2)
                    Tween(wrap,{Size=UDim2.new(1,0,0,36)},0.2)
                    Tween(chevron,{Rotation=0},0.2)
                    task.delay(0.22,function() if not open then list.Visible=false end end)
                end
            end

            btn.MouseButton1Click:Connect(function() setOpen(not open) end)

            local function buildOpts()
                for _,c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _,opt in ipairs(options) do
                    local ob=Create("TextButton",{Size=UDim2.new(1,0,0,32),BackgroundColor3=Theme.Element,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=list})
                    Corner(ob,8)
                    Create("TextLabel",{Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-24,1,0),BackgroundTransparency=1,Text=tostring(opt),Font=Enum.Font.GothamMedium,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=ob})
                    ob.MouseEnter:Connect(function() Tween(ob,{BackgroundTransparency=0,BackgroundColor3=Theme.Hover},0.15) end)
                    ob.MouseLeave:Connect(function() Tween(ob,{BackgroundTransparency=1},0.15) end)
                    ob.MouseButton1Click:Connect(function()
                        if multi then selected[opt]=not selected[opt] refresh() local out={} for k,v in pairs(selected) do if v then table.insert(out,k) end end pcall(cb,out)
                        else selected=tostring(opt) refresh() setOpen(false) pcall(cb,selected) end
                    end)
                end
            end
            buildOpts() refresh()
            local el=reg(wrap,n.." "..table.concat(options," "))
            local D={}
            function D:Set(v)
                if multi and type(v)=="table" then selected={} for _,x in ipairs(v) do selected[x]=true end refresh() pcall(cb,v)
                else selected=tostring(v) refresh() pcall(cb,selected) end
            end
            function D:Get() return selected end
            function D:SetOptions(o) options=o buildOpts() refresh() el.SearchText=n.." "..table.concat(options," ") end
            if flag then Library.Flags[flag]=selected Library.SetFlags[flag]=function(v) D:Set(v) end end
            return D
        end

        function host:AddInput(opts)
            opts=opts or {}
            local n=opts.Name or "Input"
            local ph=opts.Placeholder or ("Enter "..string.lower(n).."...")
            local def=opts.Default or ""
            local cb=opts.Callback or function() end
            local flag=opts.Flag or opts.flag

            local wrap=Create("Frame",{Size=UDim2.new(1,0,0,40),BackgroundTransparency=1,Parent=body})
            Create("TextLabel",{Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-176,1,0),BackgroundTransparency=1,Text=n,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=wrap})

            local bx=Create("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.new(0,165,0,32),BackgroundColor3=Theme.Inset,Parent=wrap})
            Corner(bx,8) local st=Stroke(bx,Theme.Line,0.4,1)

            local tb=Create("TextBox",{Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-24,1,0),BackgroundTransparency=1,PlaceholderText=ph,PlaceholderColor3=Theme.Faint,Text=tostring(def),Font=Enum.Font.GothamMedium,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,ClearTextOnFocus=false,Parent=bx})
            tb.Focused:Connect(function() Tween(st,{Transparency=0.1},0.2) Tween(bx,{BackgroundColor3=Theme.Hover},0.2) st.Color=Library.Accent end)
            tb.FocusLost:Connect(function(e) Tween(st,{Transparency=0.4},0.2) Tween(bx,{BackgroundColor3=Theme.Inset},0.2) st.Color=Theme.Line if flag then Library.Flags[flag]=tb.Text end pcall(cb,tb.Text,e) end)

            reg(wrap,n.." "..ph)
            local o={} function o:Set(v) tb.Text=tostring(v) if flag then Library.Flags[flag]=tostring(v) end end function o:Get() return tb.Text end
            if flag then Library.Flags[flag]=def Library.SetFlags[flag]=function(v) o:Set(v) end end
            return o
        end
        host.AddTextbox=host.AddInput

        function host:AddKeybind(opts)
            opts=opts or {}
            local n=opts.Name or "Keybind"
            local def=opts.Default or Enum.KeyCode.F
            local cb=opts.Callback or function() end
            local flag=opts.Flag or opts.flag

            local row=Create("Frame",{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,Parent=body})
            Create("TextLabel",{Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-100,1,0),BackgroundTransparency=1,Text=n,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=row})

            local kb=Create("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.new(0,0,0,28),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=Theme.Hover,Text="",AutoButtonColor=false,Parent=row})
            Corner(kb,8) Stroke(kb,Theme.Line,0.4,1)

            local kl=Create("TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=def.Name,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Dim,Parent=kb})
            Padding(kl,16,0,16,0)

            local cur=def local wait=false
            kb.MouseButton1Click:Connect(function() wait=true kl.Text="..." Tween(kb,{BackgroundColor3=Library.Accent},0.2) end)
            UserInputService.InputBegan:Connect(function(inp,gpe)
                if wait then
                    if inp.UserInputType==Enum.UserInputType.Keyboard then cur=inp.KeyCode kl.Text=cur.Name wait=false Tween(kb,{BackgroundColor3=Theme.Hover},0.2) if flag then Library.Flags[flag]=cur end end return
                end
                if not gpe and inp.KeyCode==cur then pcall(cb,cur) end
            end)

            reg(row,n)
            local K={}
            function K:Set(v)
                if type(v)=="table" and v.Key then
                    local ok,kc=pcall(function() return Enum.KeyCode[v.Key] or Enum.KeyCode[tostring(v.Key)] end)
                    if ok and kc then cur=kc kl.Text=cur.Name if flag then Library.Flags[flag]=cur end end
                elseif typeof(v)=="EnumItem" then cur=v kl.Text=cur.Name if flag then Library.Flags[flag]=cur end end
            end
            function K:Get() return cur end
            if flag then Library.Flags[flag]=cur Library.SetFlags[flag]=function(v) K:Set(v) end end
            return K
        end

        function host:AddColorpicker(opts)
            opts=opts or {}
            local n=opts.Name or "Color"
            local def=opts.Default or Color3.fromRGB(139, 92, 246)
            local cb=opts.Callback or function() end
            local flag=opts.Flag or opts.flag

            local vals={math.floor(def.R*255),math.floor(def.G*255),math.floor(def.B*255)}
            local wrap=Create("Frame",{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,Parent=body})
            Create("TextLabel",{Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-70,1,0),BackgroundTransparency=1,Text=n,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=wrap})

            local prev=Create("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.fromOffset(50,24),BackgroundColor3=def,Text="",AutoButtonColor=false,Parent=wrap})
            Corner(prev,8) Stroke(prev,Theme.Line,0.3,1)

            local picker=Create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=Theme.Inset,Visible=false,Parent=body})
            Corner(picker,10) Stroke(picker,Theme.Line,0.3,1) Padding(picker,14,12,14,12)

            local names={"R","G","B"}
            local function cur() return Color3.fromRGB(vals[1],vals[2],vals[3]) end
            for i=1,3 do
                local sr=Create("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=picker})
                Create("TextLabel",{Size=UDim2.new(0,20,1,0),BackgroundTransparency=1,Text=names[i],Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Dim,Parent=sr})

                local tr=Create("TextButton",{Position=UDim2.new(0,28,0.5,-4),Size=UDim2.new(1,-72,0,8),BackgroundColor3=Theme.SwitchOff,Text="",AutoButtonColor=false,Parent=sr})
                Corner(tr,4)
                local fl=Create("Frame",{Size=UDim2.new(vals[i]/255,0,1,0),BackgroundColor3=Library.Accent,BorderSizePixel=0,Parent=tr})
                Corner(fl,4)

                local vl=Create("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.new(0,40,0,18),BackgroundTransparency=1,Text=tostring(vals[i]),Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,TextColor3=Theme.Bright,Parent=sr})

                local idx=i local dr=false
                local function setX(x)
                    local a=clamp((x-tr.AbsolutePosition.X)/math.max(1,tr.AbsoluteSize.X),0,1)
                    vals[idx]=math.floor(a*255) fl.Size=UDim2.new(a,0,1,0) vl.Text=tostring(vals[idx]) prev.BackgroundColor3=cur()
                    if flag then Library.Flags[flag]=cur() end pcall(cb,cur())
                end
                tr.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dr=true setX(inp.Position.X) end end)
                UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end end)
                UserInputService.InputChanged:Connect(function(inp) if dr and inp.UserInputType==Enum.UserInputType.MouseMovement then setX(inp.Position.X) end end)
            end

            local ex=false prev.MouseButton1Click:Connect(function() ex=not ex picker.Visible=ex end)
            reg(wrap,n)
            local o={}
            function o:Set(c) if typeof(c)=="Color3" then vals={math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)} prev.BackgroundColor3=c if flag then Library.Flags[flag]=c end pcall(cb,c) end end
            function o:Get() return cur() end
            if flag then Library.Flags[flag]=def Library.SetFlags[flag]=function(v) if typeof(v)=="Color3" then o:Set(v) elseif type(v)=="string" then pcall(function() o:Set(Color3.fromHex(v)) end) end end end
            return o
        end

        function host:AddLabel(t)
            local l=Create("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=t or "Label",Font=Enum.Font.GothamMedium,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextWrapped=true,Parent=body})
            reg(l,tostring(t)) return l
        end

        function host:AddParagraph(t,bd)
            local w=Create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=body})
            Create("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text=t or "Title",Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,Parent=w})
            Create("TextLabel",{Position=UDim2.new(0,0,0,24),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=bd or "",Font=Enum.Font.GothamMedium,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextWrapped=true,Parent=w})
            Padding(w,4,4,4,8)
            reg(w,tostring(t).." "..tostring(bd)) return w
        end

        function host:AddDivider()
            return Create("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=Theme.Line,BackgroundTransparency=0.3,BorderSizePixel=0,Parent=body})
        end
    end

    -- =============================================
    -- PAGE & SECTION FACTORY
    -- =============================================
    local function makePage(parent)
        local page=Create("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,ScrollBarThickness=4,ScrollBarImageColor3=Theme.Faint,ScrollBarImageTransparency=0.5,ScrollingDirection=Enum.ScrollingDirection.Y,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=parent})
        local colWrap=Create("Frame",{Size=UDim2.new(1,-8,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=page})
        Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,24),SortOrder=Enum.SortOrder.LayoutOrder,Parent=colWrap})
        local leftCol=Create("Frame",{Size=UDim2.new(0.5,-12,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=1,Parent=colWrap})
        Create("UIListLayout",{Padding=UDim.new(0,20),SortOrder=Enum.SortOrder.LayoutOrder,Parent=leftCol})
        local rightCol=Create("Frame",{Size=UDim2.new(0.5,-12,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=2,Parent=colWrap})
        Create("UIListLayout",{Padding=UDim.new(0,20),SortOrder=Enum.SortOrder.LayoutOrder,Parent=rightCol})
        return page, leftCol, rightCol
    end

    local function makeSection(host, col, secName, secIcon)
        local box=Create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=Theme.Element,BackgroundTransparency=0.3,BorderSizePixel=0,ClipsDescendants=false,Parent=col})
        Corner(box,14) Stroke(box,Theme.Line,0.5,1)

        local cardGrad=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.97,BorderSizePixel=0,ZIndex=0,Parent=box})
        Corner(cardGrad,14) Gradient(cardGrad, Color3.new(1,1,1), Color3.new(0.3,0.3,0.4), 90)

        local header=Create("TextButton",{Size=UDim2.new(1,0,0,40),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=box})

        local tx=6
        if secIcon and string.find(secIcon,"://",1,true) then
            Create("ImageLabel",{Position=UDim2.new(0,6,0.5,-10),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,Image=secIcon,ImageColor3=Theme.Dim,Parent=header})
            tx=32
        end

        Create("TextLabel",{Position=UDim2.new(0,tx,0,0),Size=UDim2.new(1,-40-tx,1,0),BackgroundTransparency=1,Text=secName,Font=Enum.Font.GothamBold,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Bright,TextTruncate=Enum.TextTruncate.AtEnd,Parent=header})
        local chev=Create("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),Size=UDim2.fromOffset(18,18),BackgroundTransparency=1,Text="▾",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Faint,Parent=header})

        -- Custom separator line inside groupbox header
        local sep = Create("Frame",{Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),BackgroundColor3=Theme.Line,BackgroundTransparency=0.5,BorderSizePixel=0,Parent=header})

        local sbody=Create("Frame",{Position=UDim2.new(0,0,0,42),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,ClipsDescendants=false,Parent=box})
        Create("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=sbody}) Padding(sbody,16,8,16,16)

        local GB={Name=secName,Box=box,Body=sbody,_Collapsed=false}
        function GB:SetCollapsed(s)
            GB._Collapsed=s sbody.Visible=not s sep.Visible=not s Tween(chev,{Rotation=s and -90 or 0},0.25)
        end
        header.MouseButton1Click:Connect(function() GB:SetCollapsed(not GB._Collapsed) end)
        return GB, sbody
    end

    -- =============================================
    -- TAB SYSTEM
    -- =============================================
    function Window:AddTab(tabName, icon, group)
        local gname="Features"
        if group==true or tabName=="Presets" or tabName=="Auto Buy" or tabName=="Accounts" or tabName=="Settings" then gname="Manager" elseif typeof(group)=="string" and group~="" then gname=group end
        local holder=GroupHolder(gname)
        local useImg=typeof(icon)=="string" and string.find(icon,"://",1,true) ~= nil

        local btn=Create("TextButton",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=holder})
        Corner(btn,12)

        local edge=Create("Frame",{Position=UDim2.new(0,0,0.5,-12),Size=UDim2.new(0,4,0,24),BackgroundColor3=Library.Accent,BackgroundTransparency=1,BorderSizePixel=0,Visible=false,Parent=btn})
        Corner(edge,2)

        local tabIcon
        if useImg then tabIcon=Create("ImageLabel",{Position=UDim2.new(0,16,0.5,-11),Size=UDim2.fromOffset(22,22),BackgroundTransparency=1,Image=icon,ImageColor3=Theme.Dim,Parent=btn})
        else tabIcon=Create("TextLabel",{Position=UDim2.new(0,16,0.5,-11),Size=UDim2.fromOffset(22,22),BackgroundTransparency=1,Text=string.upper(string.sub(tostring(tabName),1,1)),Font=Enum.Font.GothamBold,TextSize=15,TextColor3=Theme.Faint,Parent=btn}) end

        local nameL=Create("TextLabel",{Position=UDim2.new(0,48,0,0),Size=UDim2.new(1,-54,1,0),BackgroundTransparency=1,Text=tabName,Font=Enum.Font.GothamMedium,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Theme.Dim,TextTruncate=Enum.TextTruncate.AtEnd,Parent=btn})

        local PagesWrap=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,Parent=Pages})
        local Tab={Name=tabName,Button=btn,Page=PagesWrap,_Icon=tabIcon,_Name=nameL,_Edge=edge,_Subs={},_Order={},_ActiveSub=nil,_Elements={},_Active=false}

        local function paintActive()
            Tween(btn,{BackgroundColor3=Theme.Element,BackgroundTransparency=0.2},0.25)
            if tabIcon:IsA("ImageLabel") then Tween(tabIcon,{ImageColor3=Theme.Bright},0.25) else Tween(tabIcon,{TextColor3=Theme.Bright},0.25) end
            Tween(nameL,{TextColor3=Theme.Bright},0.25) nameL.Font=Enum.Font.GothamBold
            edge.Visible=true Tween(edge,{BackgroundTransparency=0,BackgroundColor3=Library.Accent},0.25)
        end
        local function paintIdleOf(o)
            Tween(o.Button,{BackgroundTransparency=1},0.25)
            if o._Icon:IsA("ImageLabel") then Tween(o._Icon,{ImageColor3=Theme.Dim},0.25) else Tween(o._Icon,{TextColor3=Theme.Faint},0.25) end
            Tween(o._Name,{TextColor3=Theme.Dim},0.25) o._Name.Font=Enum.Font.GothamMedium o._Edge.Visible=false
        end
        local function showSub(sub)
            for _,s in ipairs(Tab._Order) do s.Page.Visible=false if s.Pill then Tween(s.Pill,{BackgroundTransparency=1},0.2) Tween(s.PillLabel,{TextColor3=Theme.Dim},0.2) end end
            sub.Page.Visible=true
            if sub.Pill then Tween(sub.Pill,{BackgroundTransparency=0.1,BackgroundColor3=Theme.Element},0.2) Tween(sub.PillLabel,{TextColor3=Theme.Bright},0.2) end
            Tab._ActiveSub=sub
        end
        local function setActive()
            for _,o in pairs(Window.Tabs) do o._Active=false o.Page.Visible=false paintIdleOf(o) end
            Tab._Active=true Tab.Page.Visible=true paintActive()
            TitleLabel.Text=tabName SubBar.Visible=#Tab._Order>1
            for _,c in ipairs(SubBar:GetChildren()) do if c:IsA("TextButton") then c.Parent=nil end end
            if #Tab._Order>1 then for _,s in ipairs(Tab._Order) do s.Pill.Parent=SubBar if s==Tab._ActiveSub then showSub(s) end end else showSub(Tab._Order[1]) end
            if SearchInput.Text~="" then SearchInput.Text="" end Window.CurrentTab=Tab
        end

        function Tab:AddSubTab(subName)
            if #Tab._Order==1 and #Tab._Order[1]._Elements==0 then local old=table.remove(Tab._Order,1) pcall(function() old.Page:Destroy() end) Tab._ActiveSub=nil end
            local page,lc,rc=makePage(PagesWrap) local sub={Name=subName,Page=page,_Elements={}}
            local pill=Create("TextButton",{Size=UDim2.new(0,0,0,36),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=SubBar})
            Corner(pill,10) Stroke(pill,Theme.Line,0.5,1)
            local pl=Create("TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=subName,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Dim,Parent=pill})
            Padding(pl,18,0,18,0)
            sub.Pill=pill sub.PillLabel=pl pill.MouseButton1Click:Connect(function() showSub(sub) end)

            function sub:AddGroupbox(gbName, side, secIcon)
                local col=lc if side=="right" or side==2 or side=="r" then col=rc end
                local GB,sbody=makeSection(sub, col, gbName, secIcon) attachElements(GB, sbody, sub._Elements, Tab._Elements) return GB
            end
            table.insert(Tab._Order,sub) if #Tab._Order==1 then Tab._ActiveSub=sub end if Tab._Active then setActive() end return sub
        end

        local defSub=nil
        do
            local page,lc,rc=makePage(PagesWrap) defSub={Name="Main",Page=page,_Elements={}}
            function defSub:AddGroupbox(gbName, side, secIcon)
                local col=lc if side=="right" or side==2 or side=="r" then col=rc end
                local GB,sbody=makeSection(defSub, col, gbName, secIcon) attachElements(GB, sbody, defSub._Elements, Tab._Elements) return GB
            end
            table.insert(Tab._Order,defSub) Tab._ActiveSub=defSub
        end
        function Tab:AddGroupbox(gbName, side, secIcon) return defSub:AddGroupbox(gbName, side, secIcon) end

        btn.MouseButton1Click:Connect(setActive)
        btn.MouseEnter:Connect(function() if not Tab._Active then Tween(btn,{BackgroundColor3=Theme.Hover,BackgroundTransparency=0.5},0.2) end end)
        btn.MouseLeave:Connect(function() if not Tab._Active then Tween(btn,{BackgroundTransparency=1},0.2) end end)

        Window.Tabs[tabName]=Tab
        if Window.CurrentTab==nil then task.defer(function() for _,t in pairs(Window.Tabs) do if t._Active then return end end setActive() end) end return Tab
    end

    if SearchEnabled then
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local q=string.lower(SearchInput.Text or "") local tab=Window.CurrentTab if not tab then return end
            local els=(tab._ActiveSub and tab._ActiveSub._Elements) or tab._Elements
            if q=="" then for _,el in ipairs(els) do if el.Frame then el.Frame.Visible=true end end
            else for _,el in ipairs(els) do local hay=string.lower(el.SearchText or "") if el.Frame then el.Frame.Visible=(string.find(hay,q,1,true)~=nil) end end end
        end)
    end

    Main.Size=UDim2.fromOffset(0,0) Main.BackgroundTransparency=1
    Tween(Main,{Size=WinSize,BackgroundTransparency=0},0.45,Enum.EasingStyle.Back)

    function Window:CreateSettingsPage(folder)
        folder = folder or Library.ConfigFolder
        pcall(function() if makefolder and not isfolder(Library.Directory) then makefolder(Library.Directory) end end)
        pcall(function() if makefolder and not isfolder(folder) then makefolder(folder) end end)
        local Tab = Window:AddTab("Settings", SETTINGS_ICON, "Manager")
        local Cfg = Tab:AddGroupbox("Configs", "left")
        local curConfig, cfgName = nil, ""
        local list = Cfg:AddDropdown({Name = "Available Configs", Options = {"None"}, Default = "None", Flag = "_config_list", Callback = function(v) curConfig = v end})
        local function files()
            local out = {}
            pcall(function() for _,f in ipairs(listfiles(folder)) do local n=string.match(f,"([^\\/]+)%.cfg$") if n then table.insert(out,n) end end end)
            if #out==0 then out={"None"} end return out
        end
        local function refresh() local f=files() curConfig=f[1] list:SetOptions(f) list:Set(f[1]) end
        Cfg:AddInput({Name = "Config Name", Placeholder = "Enter config name...", Default = "", Flag = "_config_name", Callback = function(v) cfgName=v end})
        Cfg:AddButton({Name = "Save Config", Callback = function()
            local name = cfgName ~= "" and cfgName or curConfig
            if not name or name == "" or name == "None" then Window:Notify({Title="Configs",Description="Enter a config name first.",Duration=3}) return end
            local ok, err = pcall(function() writefile(folder.."/"..name..".cfg", Library:GetConfig()) end)
            if ok then Window:Notify({Title="Configs",Description="Saved: "..name,Duration=3}) else Window:Notify({Title="Configs",Description="Save failed. Check F9.",Duration=4}) warn("Config save error: "..tostring(err)) end
            refresh()
        end})
        Cfg:AddButton({Name = "Load Config", Callback = function()
            local name = curConfig
            if not name or name == "" or name == "None" then Window:Notify({Title="Configs",Description="Select a config to load.",Duration=3}) return end
            local ok, err = pcall(function() local content = readfile(folder.."/"..name..".cfg") Library:LoadConfig(content) end)
            if ok then Window:Notify({Title="Configs",Description="Loaded: "..name,Duration=3}) else Window:Notify({Title="Configs",Description="Load failed. Check F9.",Duration=4}) warn("Config load error: "..tostring(err)) end
        end})
        Cfg:AddButton({Name = "Delete Config", Callback = function()
            local name = curConfig if not name or name == "" or name == "None" then return end
            pcall(function() delfile(folder.."/"..name..".cfg") end) Window:Notify({Title="Configs",Description="Deleted: "..name,Duration=3}) refresh()
        end})
        Cfg:AddButton({Name = "Refresh", Callback = refresh}) refresh()

        local Th = Tab:AddGroupbox("Theming", "left")
        local map = {Background = "Main", Inline = "Element", Element = "Hover", Accent = "Accent", Border = "Line"}
        local cur_ = {Background = Theme.Main, Inline = Theme.Element, Element = Theme.Hover, Accent = Library.Accent, Border = Theme.Line}
        for _,key in ipairs({"Background","Inline","Element","Accent","Border"}) do
            local k=key
            Th:AddColorpicker({Name=k, Default=cur_[k], Callback=function(v)
                if k=="Accent" then Window:SetAccent(v) return end
                local target=map[k] local old=Theme[target] Theme[target]=v
                for _,d in ipairs(ScreenGui:GetDescendants()) do
                    pcall(function() if d.BackgroundColor3==old then d.BackgroundColor3=v end if d:IsA("UIStroke") and d.Color==old then d.Color=v end end)
                end
            end})
        end

        local St = Tab:AddGroupbox("Settings", "right")
        St:AddButton({Name = "Unload", Callback = function() Library:Unload() end})
        St:AddKeybind({Name = "Menu Keybind", Default = ToggleKey, Callback = function(k) ToggleKey=k Library.MenuKeybind=k end})
        local origText = setmetatable({}, {__mode = "k"})
        St:AddToggle({Name = "Streamer / Anonymous Mode", Default = false, Callback = function(v)
            getgenv().StreamerModeEnabled = v
            if v then
                task.spawn(function()
                    while getgenv().StreamerModeEnabled and ScreenGui.Parent do
                        task.wait(1) local n1, n2 = LocalPlayer.Name, LocalPlayer.DisplayName
                        for _, d in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                            pcall(function() if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then if d.Text:find(n1, 1, true) or d.Text:find(n2, 1, true) then origText[d] = origText[d] or d.Text d.Text = d.Text:gsub(n1, "Streamer"):gsub(n2, "Streamer") end end end)
                        end
                    end
                end)
            else for d, txt in pairs(origText) do pcall(function() if d.Parent then d.Text = txt end end) end table.clear(origText) end
        end})
        St:AddSlider({Name = "Tween Speed", Min = 0, Max = 10, Default = Library.Tween.Time, Decimals = 0.01, Suffix = "s", Callback = function(v) Library.Tween.Time=v end})
        St:AddDropdown({Name = "Tween Style", Options = {"Linear","Quad","Quart","Back","Bounce","Circular","Cubic","Elastic","Exponential","Sine","Quint"}, Default = "Quint", Callback = function(v) if Enum.EasingStyle[v] then Library.Tween.Style=Enum.EasingStyle[v] end end})
        St:AddDropdown({Name = "Tween Direction", Options = {"In","Out","InOut"}, Default = "Out", Callback = function(v) if Enum.EasingDirection[v] then Library.Tween.Direction=Enum.EasingDirection[v] end end})
        return Tab
    end

    table.insert(Library.Windows,Window) return Window
end

function Library:Unload() for _,w in ipairs(Library.Windows) do pcall(function() w.Gui:Destroy() end) end Library.Windows={} end
return Library
