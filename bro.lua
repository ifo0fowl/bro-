if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    local IsMobile = UserInputService.TouchEnabled or false

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.25,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "lds13",
            Configs = "lds13/Configs",
            Assets = "lds13/Assets",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        KeybindEntries = { },
        KeybindList = nil,
        KeybindEditor = nil,

        SetFlags = { },

        SearchItems = { },
        CurrentPage = nil,

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        UIScale = nil,

        Font = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(0, 0, 0),
            ["Inline"] = FromRGB(0, 0, 0),
            ["Outline"] = FromRGB(191, 69, 255),
            ["Text"] = FromRGB(200, 200, 200),
            ["Dark Text"] = FromRGB(255, 255, 255),
            ["Element"] = FromRGB(124, 0, 156),
            ["Accent"] = FromRGB(163, 0, 204)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    local Folders = {
        Directory = "lds13",
        Configs = "lds13/Configs",
        Assets = "lds13/Assets",
    }
    
    for Index, Value in Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            if IsMobile then 
                if Event == "MouseButton1Down" or Event == "MouseButton1Click" then 
                    Event = "TouchTap"
                elseif Event == "MouseButton2Down" or Event == "MouseButton2Click" then 
                    Event = "TouchLongPress"
                end
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self, OnMoved)
            if not self.Instance then 
                return
            end
        
            local Gui = self.Instance
            local Dragging = false 
            local DragStart
            local StartPosition 
        
            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y

                local ScreenSize = Gui.Parent:IsA("GuiObject") and Gui.Parent.AbsoluteSize or Camera.ViewportSize
                local GuiSize = Gui.AbsoluteSize
                local Scale = (Library.UIScale and Library.UIScale.Instance and Library.UIScale.Instance.Scale) or 1

                -- MainFrame.Position is in unscaled coordinates, while AbsoluteSize is scaled.
                -- Convert the visible size back to UI coordinates so smaller scales can still
                -- move the window all the way across the screen.
                local UnscaledWidth = GuiSize.X / Scale
                local UnscaledHeight = GuiSize.Y / Scale
                local UnscaledScreenWidth = ScreenSize.X / Scale
                local UnscaledScreenHeight = ScreenSize.Y / Scale
        
                NewX = MathClamp(NewX, 0, math.max(0, UnscaledScreenWidth - UnscaledWidth))
                NewY = MathClamp(NewY, 0, math.max(0, UnscaledScreenHeight - UnscaledHeight))

                local NewPosition = UDim2New(0, NewX, 0, NewY)
                Gui.Position = NewPosition

                if OnMoved then
                    OnMoved(NewPosition)
                end
            end
        
            local InputChanged
        
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
        
                    if InputChanged then 
                        return
                    end
        
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
        
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)
        
            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local CurrentSide = nil

            local StartMouse = nil 
            local StartPosition = nil 
            local StartSize = nil
            
            local EdgeThickness = 2

            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  Button:AddToTheme({BackgroundColor3 = "Accent"})

                return Button
            end

            local Edges = {
                {Button = MakeEdge(
                    "Left", 
                    UDim2New(0, 0, 0, 0), 
                    UDim2New(0, EdgeThickness, 1, 0)), 
                    Side = "L"
                },

                {Button = MakeEdge(
                    "Right", 
                    UDim2New(1, -EdgeThickness, 0, 0), 
                    UDim2New(0, EdgeThickness, 1, 0)), 
                    Side = "R"
                },

                {Button = MakeEdge(
                    "Top", UDim2New(0, 0, 0, 0), 
                    UDim2New(1, 0, 0, EdgeThickness)), 
                    Side = "T"
                },

                {Button = MakeEdge(
                    "Bottom", 
                    UDim2New(0, 0, 1, -EdgeThickness), 
                    UDim2New(1, 0, 0, EdgeThickness)), 
                    Side = "B"
                },
            }

            local BeginResizing = function(Side)
                Resizing = true 
                CurrentSide = Side 

                StartMouse = UserInputService:GetMouseLocation()

                -- store offsets, not absolute screen pos
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                
                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
                end
            end

            local EndResizing = function()
                Resizing = false 
                CurrentSide = nil

                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end

            for Index, Value in Edges do 
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end)
            end

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then 
                    return 
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
            
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end
            
                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end
            
                Gui.Position = UDim2FromOffset(x, y)
                Gui.Size = UDim2FromOffset(w, h)
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("InterSemiBold", 400, "Regular", {
            Id = "InterSemiBold",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
        })
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    -- One shared scale applies to the complete interface.
    -- Start from a comfortable scale based on the current viewport, then allow
    -- the user to override it from Settings or the resize handle.
    local Viewport = Camera.ViewportSize
    local DefaultUIScale = IsMobile
        and MathClamp(Viewport.X / 540, 0.68, 0.82)
        or (Viewport.X < 1200 and 0.9 or 1)

    Library.UIScale = Instances:Create("UIScale", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Scale = DefaultUIScale
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 1, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        Padding = UDimNew(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 12),
        PaddingBottom = UDimNew(0, 12),
        PaddingRight = UDimNew(0, 12),
        PaddingLeft = UDimNew(0, 12)
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s", self.UnnamedConnections + 1)

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        NewConnection.Connection = Event:Connect(Callback)
        self.UnnamedConnections = self.UnnamedConnections + 1

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {
                        Key = tostring(Value.Key),
                        Mode = Value.Mode,
                        Toggled = Value.Toggled == true,
                        OnValue = Value.OnValue,
                        OffValue = Value.OffValue,
                        Name = Value.Name
                    }
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end

            -- Serialize the actual keybind objects as well. Some keybinds can have
            -- state that is newer than their Library.Flags entry.
            for Keybind in Library.KeybindEntries do
                if Keybind.Flag then
                    Config[Keybind.Flag] = {
                        Key = tostring(Keybind.Key),
                        Mode = Keybind.Mode,
                        Toggled = Keybind.Toggled == true,
                        OnValue = Keybind.OnValue,
                        OffValue = Keybind.OffValue,
                        Name = Keybind.Name
                    }
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize 

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    do
        Library.CreateColorpicker = function(self, Data)
            local Colorpicker = {
                Flag = Data.Flag, 

                Hue = 0,
                Saturation = 0,
                Value = 0,

                Color = Color3.fromRGB(0, 0, 0),
                HexValue = "",

                IsOpen = false,
                StreamerMode = false
            }

            local Items = { } do 
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 193, 249)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(209, 209, 209))}
                })                

                Items["ColorpickerWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 44, 0, 169),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 180, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(26, 30, 36),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})
                
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -36, 1, -16),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 193, 249)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Saturation"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Items["Value"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 1, 1, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(0, 0, 0)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 15, 0, 15),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 8, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(255, 255, 255),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0"
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -8, 0, 8),
                    Size = UDim2New(0, 12, 1, -16),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })
                
                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 12, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(255, 255, 255),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0"
                })
            end

            function Colorpicker:Get()
                return Colorpicker.Color
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color)
                end
            end

            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Hue = ValueY

                local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.955)

                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
                Colorpicker:Update()
            end

            local Debounce = false
            local RenderStepped  

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 

                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["ColorpickerWindow"].Instance.Position = UDim2New(
                            0, 
                            Items["ColorpickerButton"].Instance.AbsolutePosition.X, 
                            0, 
                            Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5
                        )
                    end)

                    Items["ColorpickerWindow"]:Tween(nil, {Size = UDim2New(0, 180, 0, 179)})

                    if not Data.Section.IsSettings then
                        for Index, Value in Library.OpenFrames do 
                            if Value ~= Colorpicker then
                                Value:SetOpen(false)
                            end
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    if not Data.Section.IsSettings then
                        if Library.OpenFrames[Colorpicker] then 
                            Library.OpenFrames[Colorpicker] = nil
                        end
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    Items["ColorpickerWindow"]:Tween(nil, {Size = UDim2New(0, 180, 0, 0)})
                end

                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9) or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3) or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Colorpicker:Set(Color)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)
                    
                local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.955)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true 

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true 

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Colorpicker.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                        return
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default)
            end

            Library.SetFlags[Colorpicker.Flag] = function(Value)
                Colorpicker:Set(Value)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(self, Data)
            local Keybind = {
                Name = Data.Name or Data.Flag or "Keybind",
                Flag = Data.Flag,

                Mode = "",
                Value = "",
                Key = "",
                OnValue = Data.OnValue ~= false,
                OffValue = Data.OffValue == true,

                Picking = false,
                Toggled = false,
                IsOpen = false,
                Initializing = true
            }

            local Items = { } do
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "mb2",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["KeyButton"]:AddToTheme({TextColor3 = "Dark Text"})           
                
                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 904, 0, 179),
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 67, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(26, 30, 36),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})
                
                Instances:Create("UIListLayout", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(200, 200, 200),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Toggle",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Toggle"]:AddToTheme({TextColor3 = "Dark Text"})     
                
                Instances:Create("UIPadding", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 6),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Items["Hold"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Hold",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Hold"]:AddToTheme({TextColor3 = "Dark Text"})     
                
                Items["Always"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Always",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Always"]:AddToTheme({TextColor3 = "Dark Text"})                
            end

            local Modes = {
                Toggle = Items["Toggle"],
                Hold = Items["Hold"],
                Always = Items["Always"]
            }

            local Debounce = false
            local RenderStepped  

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true 

                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["KeybindWindow"].Instance.Position = UDim2New(
                            0, 
                            Items["KeyButton"].Instance.AbsolutePosition.X, 
                            0, 
                            Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5
                        )
                    end)

                    Items["KeybindWindow"]:Tween(nil, {Size = UDim2New(0, 67, 0, 80)})

                    if not Data.Section.IsSettings then
                        for Index, Value in Library.OpenFrames do 
                            if Value ~= Keybind then
                                Value:SetOpen(false)
                            end
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    if not Data.Section.IsSettings then
                        if Library.OpenFrames[Keybind] then 
                            Library.OpenFrames[Keybind] = nil
                        end
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    Items["KeybindWindow"]:Tween(nil, {Size = UDim2New(0, 67, 0, 0)})
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Keybind.IsOpen and 4 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                    task.wait(0.2)
                    Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Keybind:SetMode(Mode)
                for Index, Value in Modes do 
                    if Index == Mode then
                        Value:ChangeItemTheme({TextColor3 = "Text"})
                        Value:Tween(nil, {TextColor3 = Library.Theme.Text})
                    else
                        Value:ChangeItemTheme({TextColor3 = "Dark Text"})
                        Value:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                    end
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled,
                    OnValue = Keybind.OnValue,
                    OffValue = Keybind.OffValue,
                    Name = Keybind.Name
                }

                if Data.Callback and not Keybind.Initializing then 
                    local Output = Keybind.Toggled and Keybind.OnValue or Keybind.OffValue
                    Library:SafeCall(Data.Callback, Output)
                end

                Library:RefreshKeybindList()
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Off" then
                    Keybind.Toggled = false
                elseif Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled,
                    OnValue = Keybind.OnValue,
                    OffValue = Keybind.OffValue,
                    Name = Keybind.Name
                }

                if Data.Callback and not Keybind.Initializing then 
                    local Output = Keybind.Toggled and Keybind.OnValue or Keybind.OffValue
                    Library:SafeCall(Data.Callback, Output)
                end

                Library:RefreshKeybindList()
            end

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled,
                        OnValue = Keybind.OnValue,
                        OffValue = Keybind.OffValue,
                        Name = Keybind.Name
                    }

                    if Data.Callback and not Keybind.Initializing then 
                        local Output = Keybind.Toggled and Keybind.OnValue or Keybind.OffValue
                        Library:SafeCall(Data.Callback, Output)
                    end
                elseif type(Key) == "table" then
                    local RawKey = tostring(Key.Key)
                    local KeyName = StringGSub(StringGSub(RawKey, "Enum.KeyCode.", ""), "Enum.UserInputType.", "")
                    local IsNone = KeyName == "Backspace" or KeyName == "None"
                    local RealKey = IsNone and "None" or RawKey
                    Keybind.Key = IsNone and tostring(Enum.KeyCode.Backspace) or RawKey

                    if Key.OnValue ~= nil then
                        Keybind.OnValue = Key.OnValue
                    end

                    if Key.OffValue ~= nil then
                        Keybind.OffValue = Key.OffValue
                    end

                    if Key.Name and Key.Name ~= "" then
                        Keybind.Name = Key.Name
                    end

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    -- Restore the saved enabled/active state after changing mode.
                    -- SetMode can invoke the parent callback, so this must happen
                    -- after the mode has been applied.
                    if Key.Toggled ~= nil then
                        Keybind.Toggled = Key.Toggled == true
                    end

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled,
                        OnValue = Keybind.OnValue,
                        OffValue = Keybind.OffValue,
                        Name = Keybind.Name
                    }

                    local KeyString = IsNone and "None" or Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback and not Keybind.Initializing then 
                        local Output = Keybind.Toggled and Keybind.OnValue or Keybind.OffValue
                        Library:SafeCall(Data.Callback, Output)
                    end
                elseif TableFind({"Off", "Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)

                    if Data.Callback and not Keybind.Initializing then 
                        local Output = Keybind.Toggled and Keybind.OnValue or Keybind.OffValue
                        Library:SafeCall(Data.Callback, Output)
                    end
                end

                --Items["KeyButton"].Instance.Position = UDim2New(0, Data.Text.Instance.TextBounds.X + 12, 0, 0)
                Keybind.Picking = false
                Library:RefreshKeybindList()

                if Library.KeybindEditor then
                    Library.KeybindEditor:Refresh()
                end
            end

            function Keybind:BeginPicking(DisplayItem)
                if Keybind.Picking then
                    return
                end

                Keybind.Picking = true 
                local Display = DisplayItem and (DisplayItem.Instance or DisplayItem) or Items["KeyButton"].Instance
                Display.Text = "Press a key"

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Input.UserInputType == Enum.UserInputType.MouseButton2
                        or Input.UserInputType == Enum.UserInputType.MouseButton3 then
                        Keybind:Set(Input.UserInputType)
                    else
                        return
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind:BeginPicking(Items["KeyButton"])
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                if Keybind.Editor then
                    local ShouldOpen = not (Keybind.Editor.IsOpen and Keybind.Editor.Current == Keybind)
                    Keybind.Editor:SetOpen(ShouldOpen, Keybind, Data.Source)
                else
                    Keybind:SetOpen(not Keybind.IsOpen)
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)

            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
            end)

            Items["Always"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Always"
                Keybind:SetMode("Always")
            end)

            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            Keybind.Initializing = false

            Library:RegisterKeybind(Keybind)

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.CreateKeybindEditor = function(self)
            if self.KeybindEditor then
                return self.KeybindEditor
            end

            local Editor = {
                Current = nil,
                Source = nil,
                IsOpen = false,
                Items = { }
            }

            local Items = Editor.Items

            Items["Frame"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Size = UDim2New(0, 222, 0, 168),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Background,
                ZIndex = 90
            })
            Items["Frame"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(1, 22, 1, 22),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Image = "http://www.roblox.com/asset/?id=18245826428",
                ImageColor3 = Library.Theme.Accent,
                ImageTransparency = 0.62,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = RectNew(21, 21, 79, 79),
                ZIndex = 89
            })
            Items["Shadow"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["Frame"].Instance,
                CornerRadius = UDimNew(0, 5)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Frame"].Instance,
                Rotation = 90,
                Color = RGBSequence{
                    RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                    RGBSequenceKeypoint(1, FromRGB(218, 218, 224))
                }
            })

            Items["Stroke"] = Instances:Create("UIStroke", {
                Parent = Items["Frame"].Instance,
                Color = Library.Theme.Accent,
                Thickness = 1,
                Transparency = 0.08,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
            Items["Stroke"]:AddToTheme({Color = "Accent"})

            Items["Header"] = Instances:Create("Frame", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 28),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline,
                ZIndex = 91
            })
            Items["Header"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = Items["Header"].Instance,
                CornerRadius = UDimNew(0, 5)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Header"].Instance,
                Rotation = 0,
                Color = RGBSequence{
                    RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                    RGBSequenceKeypoint(1, FromRGB(225, 225, 232))
                }
            })

            Instances:Create("Frame", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 5),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline,
                ZIndex = 91
            }):AddToTheme({BackgroundColor3 = "Inline"})

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                Position = UDim2New(0, 10, 0, 0),
                Size = UDim2New(1, -42, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = "Keybind Settings",
                TextColor3 = Library.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 11,
                ZIndex = 93
            })
            Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Close"] = Instances:Create("TextButton", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                Position = UDim2New(1, -27, 0, 4),
                Size = UDim2New(0, 22, 0, 20),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Text = "×",
                TextColor3 = Library.Theme["Dark Text"],
                FontFace = Library.Font,
                TextSize = 15,
                ZIndex = 94
            })
            Items["Close"]:AddToTheme({TextColor3 = "Dark Text"})

            Items["Close"]:OnHover(function()
                Items["Close"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            end)

            Items["Close"]:OnHoverLeave(function()
                Items["Close"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
            end)

            local function CreateDivider(Y)
                local Divider = Instances:Create("Frame", {
                    Parent = Items["Frame"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 9, 0, Y),
                    Size = UDim2New(1, -18, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Outline,
                    BackgroundTransparency = 0.8,
                    ZIndex = 91
                })
                Divider:AddToTheme({BackgroundColor3 = "Outline"})
            end

            local function CreateLabel(Text, Y)
                local Label = Instances:Create("TextLabel", {
                    Parent = Items["Frame"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 10, 0, Y),
                    Size = UDim2New(0, 78, 0, 27),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = Text,
                    TextColor3 = Library.Theme["Dark Text"],
                    TextTransparency = 0.08,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                    TextSize = 11,
                    ZIndex = 92
                })
                Label:AddToTheme({TextColor3 = "Dark Text"})
                return Label
            end

            local function CreateValueButton(Name, Y, Text)
                local Button = Instances:Create("TextButton", {
                    Parent = Items["Frame"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 90, 0, Y + 4),
                    Size = UDim2New(1, -100, 0, 19),
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    BackgroundColor3 = Library.Theme.Element,
                    BackgroundTransparency = 0.56,
                    Text = Text,
                    TextColor3 = Library.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                    TextSize = 10,
                    ZIndex = 93
                })
                Button:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

                Button:OnHover(function()
                    Button:Tween(nil, {BackgroundTransparency = 0.45})
                end)

                Button:OnHoverLeave(function()
                    Button:Tween(nil, {BackgroundTransparency = 0.56})
                end)

                Instances:Create("UICorner", {
                    Parent = Button.Instance,
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIStroke", {
                    Parent = Button.Instance,
                    Color = Library.Theme.Outline,
                    Thickness = 1,
                    Transparency = 0.72
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIPadding", {
                    Parent = Button.Instance,
                    PaddingLeft = UDimNew(0, 7),
                    PaddingRight = UDimNew(0, 7)
                })

                Items[Name] = Button
                return Button
            end

            CreateLabel("Key", 28)
            CreateLabel("Mode", 56)
            CreateLabel("On value", 84)
            CreateLabel("Off value", 112)
            CreateLabel("Name", 140)

            CreateDivider(55)
            CreateDivider(83)
            CreateDivider(111)
            CreateDivider(139)

            CreateValueButton("KeyValue", 28, "None")
            CreateValueButton("ModeValue", 56, "Toggle")

            Items["ModeArrow"] = Instances:Create("TextLabel", {
                Parent = Items["ModeValue"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, -5, 0.5, 0),
                Size = UDim2New(0, 12, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = "⌄",
                TextColor3 = Library.Theme.Text,
                FontFace = Library.Font,
                TextSize = 12,
                ZIndex = 95
            })
            Items["ModeArrow"]:AddToTheme({TextColor3 = "Text"})

            Items["ModeMenu"] = Instances:Create("Frame", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 90, 0, 80),
                Size = UDim2New(1, -100, 0, 82),
                Visible = false,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline,
                BackgroundTransparency = 0.04,
                ZIndex = 100
            })
            Items["ModeMenu"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = Items["ModeMenu"].Instance,
                CornerRadius = UDimNew(0, 4)
            })

            Instances:Create("UIStroke", {
                Parent = Items["ModeMenu"].Instance,
                Color = Library.Theme.Accent,
                Thickness = 1,
                Transparency = 0.18
            }):AddToTheme({Color = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["ModeMenu"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            for Index, Mode in {"Off", "Toggle", "Hold", "Always"} do
                local Option = Instances:Create("TextButton", {
                    Parent = Items["ModeMenu"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, Index == 4 and 22 or 20),
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme.Accent,
                    Text = Mode,
                    TextColor3 = Library.Theme["Dark Text"],
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                    TextSize = 10,
                    ZIndex = 101
                })
                Option:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Dark Text"})

                Instances:Create("UIPadding", {
                    Parent = Option.Instance,
                    PaddingLeft = UDimNew(0, 7)
                })

                Option:OnHover(function()
                    Option:Tween(nil, {BackgroundTransparency = 0.78})
                end)

                Option:OnHoverLeave(function()
                    Option:Tween(nil, {BackgroundTransparency = 1})
                end)

                Option:Connect("MouseButton1Down", function()
                    local Keybind = Editor.Current
                    if not Keybind then
                        return
                    end

                    Keybind.Mode = Mode
                    if Mode == "Always" then
                        Keybind.Toggled = true
                    elseif Mode == "Off" or Mode == "Hold" then
                        Keybind.Toggled = false
                    end

                    Keybind:SetMode(Mode)
                    Items["ModeMenu"].Instance.Visible = false
                    Editor:Refresh()
                end)
            end

            local function CreateSwitch(Name, Y)
                local Button = Instances:Create("TextButton", {
                    Parent = Items["Frame"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -10, 0, Y + 13),
                Size = UDim2New(0, 30, 0, 16),
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    BackgroundColor3 = Library.Theme.Element,
                    Text = "",
                    ZIndex = 93
                })
                Button:AddToTheme({BackgroundColor3 = "Element"})

                Instances:Create("UICorner", {
                    Parent = Button.Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                local Knob = Instances:Create("Frame", {
                    Parent = Button.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0, 8, 0.5, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(238, 238, 242),
                    ZIndex = 94
                })

                Instances:Create("UICorner", {
                    Parent = Knob.Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                Items[Name] = Button
                Items[Name .. "Knob"] = Knob
            end

            CreateSwitch("OnSwitch", 84)
            CreateSwitch("OffSwitch", 112)

            Items["NameValue"] = Instances:Create("TextBox", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 90, 0, 144),
                Size = UDim2New(1, -100, 0, 19),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element,
                BackgroundTransparency = 0.56,
                ClearTextOnFocus = false,
                MultiLine = false,
                Active = true,
                Selectable = true,
                Text = "",
                PlaceholderText = "Feature name",
                TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Library.Theme["Dark Text"],
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 10,
                ZIndex = 93
            })
            Items["NameValue"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "Dark Text"})

            Instances:Create("UICorner", {
                Parent = Items["NameValue"].Instance,
                CornerRadius = UDimNew(0, 4)
            })

            Instances:Create("UIStroke", {
                Parent = Items["NameValue"].Instance,
                Color = Library.Theme.Outline,
                Thickness = 1,
                Transparency = 0.72
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIPadding", {
                Parent = Items["NameValue"].Instance,
                PaddingLeft = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7)
            })

            local function UpdateSwitch(Button, Knob, State)
                Button:ChangeItemTheme({BackgroundColor3 = State and "Accent" or "Element"})
                Button:Tween(nil, {BackgroundColor3 = Library.Theme[State and "Accent" or "Element"]})
                Knob:Tween(nil, {Position = State and UDim2New(1, -8, 0.5, 0) or UDim2New(0, 8, 0.5, 0)})
            end

            function Editor:Refresh()
                local Keybind = self.Current
                if not Keybind then
                    return
                end

                Items["KeyValue"].Instance.Text = Keybind.Picking and "Press a key" or Keybind.Value
                Items["ModeValue"].Instance.Text = Keybind.Mode
                Items["NameValue"].Instance.Text = Keybind.Name
                UpdateSwitch(Items["OnSwitch"], Items["OnSwitchKnob"], Keybind.OnValue)
                UpdateSwitch(Items["OffSwitch"], Items["OffSwitchKnob"], Keybind.OffValue)
            end

            function Editor:SetOpen(State, Keybind, Source)
                if State and Keybind then
                    self.Current = Keybind
                    self.Source = Source
                end

                self.IsOpen = State == true and self.Current ~= nil

                if self.IsOpen then
                    for _, OpenFrame in Library.OpenFrames do
                        if OpenFrame ~= self and OpenFrame.SetOpen then
                            OpenFrame:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[self] = self
                    Items["Frame"].Instance.Parent = Library.Holder.Instance
                    Items["Frame"].Instance.Visible = true

                    local Viewport = Camera.ViewportSize
                    local SourceInstance = self.Source and (self.Source.Instance or self.Source)
                    local X = UserInputService:GetMouseLocation().X
                    local Y = UserInputService:GetMouseLocation().Y + 5

                    if SourceInstance and SourceInstance.Parent then
                        X = SourceInstance.AbsolutePosition.X + SourceInstance.AbsoluteSize.X - 222
                        Y = SourceInstance.AbsolutePosition.Y + SourceInstance.AbsoluteSize.Y + 5

                        if Y + 168 > Viewport.Y then
                            Y = SourceInstance.AbsolutePosition.Y - 173
                        end
                    end

                    X = MathClamp(X, 4, math.max(4, Viewport.X - 226))
                    Y = MathClamp(Y, 4, math.max(4, Viewport.Y - 172))
                    Items["Frame"].Instance.Position = UDim2New(0, X, 0, Y)
                    self:Refresh()
                else
                    Library.OpenFrames[self] = nil
                    Items["ModeMenu"].Instance.Visible = false
                    Items["Frame"].Instance.Visible = false
                    Items["Frame"].Instance.Parent = Library.UnusedHolder.Instance
                end
            end

            Items["Close"]:Connect("MouseButton1Down", function()
                Editor:SetOpen(false)
            end)

            Items["KeyValue"]:Connect("MouseButton1Down", function()
                if Editor.Current then
                    Editor.Current:BeginPicking(Items["KeyValue"])
                end
            end)

            Items["ModeValue"]:Connect("MouseButton1Down", function()
                Items["ModeMenu"].Instance.Visible = not Items["ModeMenu"].Instance.Visible
            end)

            Items["OnSwitch"]:Connect("MouseButton1Down", function()
                if Editor.Current then
                    Editor.Current.OnValue = not Editor.Current.OnValue
                    Editor.Current:SetMode(Editor.Current.Mode)
                    Editor:Refresh()
                end
            end)

            Items["OffSwitch"]:Connect("MouseButton1Down", function()
                if Editor.Current then
                    Editor.Current.OffValue = not Editor.Current.OffValue
                    Editor.Current:SetMode(Editor.Current.Mode)
                    Editor:Refresh()
                end
            end)

            Library:Connect(Items["NameValue"].Instance.FocusLost, function()
                if not Editor.Current then
                    return
                end

                local NewName = Items["NameValue"].Instance.Text
                if NewName ~= "" then
                    Editor.Current.Name = NewName
                    Editor.Current:SetMode(Editor.Current.Mode)
                    Library:RefreshKeybindList()
                else
                    Items["NameValue"].Instance.Text = Editor.Current.Name
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if not Editor.IsOpen then
                    return
                end

                if Input.KeyCode == Enum.KeyCode.Escape then
                    Editor:SetOpen(false)
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1
                    and not Library:IsMouseOverFrame(Items["Frame"]) then
                    Editor:SetOpen(false)
                end
            end)

            self.KeybindEditor = Editor
            return Editor
        end

        Library.Notification = function(self, Name, Icon, Duration)
            Icon = Icon or "90449909165261"
            Name = Name or "Notification"
            Duration = Duration or 5

            --Library:Thread(function() lol
                local Items = { } do
                    Items["Notification"] = Instances:Create("Frame", {
                        Parent = Library.NotifHolder.Instance,
                        Name = "\0",
                        Size = UDim2New(0, 0, 0, 32),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = FromRGB(13, 15, 18)
                    })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background"})
                    
                    Instances:Create("UICorner", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 6)
                    })
                    
                    Items["Stroke"] = Instances:Create("UIStroke", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        Color = FromRGB(26, 30, 36),
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })  Items["Stroke"]:AddToTheme({Color = "Outline"})
                    
                    Items["Text"] = Instances:Create("TextLabel", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(200, 200, 200),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Name,
                        AnchorPoint = Vector2New(0, 0.5),
                        Size = UDim2New(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 24, 0.5, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
                    
                    Items["Icon"] = Instances:Create("ImageLabel", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(200, 200, 200),
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        Image = "rbxassetid://"..Icon,
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0.5, 0),
                        Size = UDim2New(0, 16, 0, 16),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    
                    Instances:Create("UIPadding", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 8),
                        PaddingBottom = UDimNew(0, 8),
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })                
                end

                local Size = Items["Notification"].Instance.AbsoluteSize
                Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
    
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value.Instance.BackgroundTransparency = 1
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value.Instance.TextTransparency = 1
                    elseif Value.Instance:IsA("ImageLabel") then 
                        Value.Instance.ImageTransparency = 1
                    elseif Value.Instance:IsA("UIStroke") then
                        Value.Instance.Transparency = 1
                    end
                end 
    
                Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y
                local Info = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
    
                Library:Thread(function()
                    for Index, Value in Items do 
                        if Value.Instance:IsA("Frame") then
                            Value:Tween(Info, {BackgroundTransparency = 0})
                        elseif Value.Instance:IsA("TextLabel") then 
                            Value:Tween(Info, {TextTransparency = 0})
                        elseif Value.Instance:IsA("ImageLabel") then 
                            Value:Tween(Info, {ImageTransparency = 0})
                        elseif Value.Instance:IsA("UIStroke") then 
                            Value:Tween(Info, {Transparency = 0})
                        end
                    end
    
                    Items["Notification"]:Tween(Info, {Size = UDim2New(0, Size.X, 0, Size.Y)})
    
                    task.delay(Duration + 0.15, function()
                        for Index, Value in Items do 
                            if Value.Instance:IsA("Frame") then
                                Value:Tween(nil, {BackgroundTransparency = 1})
                            elseif Value.Instance:IsA("TextLabel") then 
                                Value:Tween(nil, {TextTransparency = 1})
                            elseif Value.Instance:IsA("ImageLabel") then 
                                Value:Tween(nil, {ImageTransparency = 1})
                            elseif Value.Instance:IsA("UIStroke") then 
                                Value:Tween(nil, {Transparency = 1})
                            end
                        end
    
                        Items["Notification"]:Tween(Info, {Size = UDim2New(0, 0, 0, 32)})
                        task.wait(0.5)
                        Items["Notification"]:Clean()
                    end)
                end)
            --end)
        end
        
        Library.CreateKeybindList = function(self)
            if self.KeybindList then
                return self.KeybindList
            end

            local SavedPosition = getgenv().JXVKeybindListPosition
            if typeof(SavedPosition) ~= "UDim2" then
                SavedPosition = UDim2New(0, 14, 0, 120)
            end

            local KeybindList = {
                Items = { },
                Rows = { },
                Visible = true
            }

            local Items = KeybindList.Items

            Items["Frame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Position = SavedPosition,
                Size = UDim2New(0, 218, 0, 66),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Background,
                ClipsDescendants = false,
                ZIndex = 80
            })
            Items["Frame"]:AddToTheme({BackgroundColor3 = "Background"})
            Items["Frame"]:MakeDraggable(function(Position)
                getgenv().JXVKeybindListPosition = Position
            end)

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(1, 24, 1, 24),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Image = "http://www.roblox.com/asset/?id=18245826428",
                ImageColor3 = Library.Theme.Accent,
                ImageTransparency = 0.55,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = RectNew(21, 21, 79, 79),
                ZIndex = 78
            })
            Items["Shadow"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["Frame"].Instance,
                CornerRadius = UDimNew(0, 5)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Frame"].Instance,
                Rotation = 90,
                Color = RGBSequence{
                    RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                    RGBSequenceKeypoint(1, FromRGB(220, 220, 226))
                }
            })

            Items["Stroke"] = Instances:Create("UIStroke", {
                Parent = Items["Frame"].Instance,
                Color = Library.Theme.Accent,
                Thickness = 1,
                Transparency = 0.12,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
            Items["Stroke"]:AddToTheme({Color = "Accent"})

            Items["Header"] = Instances:Create("Frame", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline,
                ZIndex = 81
            })
            Items["Header"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = Items["Header"].Instance,
                CornerRadius = UDimNew(0, 5)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Header"].Instance,
                Rotation = 0,
                Color = RGBSequence{
                    RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                    RGBSequenceKeypoint(1, FromRGB(226, 226, 232))
                }
            })

            Instances:Create("Frame", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 6),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline,
                ZIndex = 81
            }):AddToTheme({BackgroundColor3 = "Inline"})

            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Accent,
                BackgroundTransparency = 0.28,
                ZIndex = 83
            })
            Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                Position = UDim2New(0, 11, 0, 0),
                Size = UDim2New(1, -92, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = "Jxv.Hub  •  Keybinds",
                TextColor3 = Library.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 12,
                ZIndex = 83
            })
            Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Count"] = Instances:Create("TextLabel", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                Position = UDim2New(1, -76, 0, 0),
                Size = UDim2New(0, 65, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = "0 active",
                TextColor3 = Library.Theme["Dark Text"],
                TextTransparency = 0.35,
                TextXAlignment = Enum.TextXAlignment.Right,
                FontFace = Library.Font,
                TextSize = 10,
                ZIndex = 83
            })
            Items["Count"]:AddToTheme({TextColor3 = "Dark Text"})

            Items["Body"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Frame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 34),
                Size = UDim2New(1, 0, 0, 32),
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Library.Theme.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 81
            })
            Items["Body"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Body"].Instance,
                PaddingTop = UDimNew(0, 4),
                PaddingBottom = UDimNew(0, 4),
                PaddingLeft = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Body"].Instance,
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Empty"] = Instances:Create("TextLabel", {
                Parent = Items["Body"].Instance,
                Name = "\0",
                Size = UDim2New(1, -14, 0, 24),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = "No keybinds yet",
                TextColor3 = Library.Theme["Dark Text"],
                TextTransparency = 0.48,
                FontFace = Library.Font,
                TextSize = 11,
                LayoutOrder = 999999,
                ZIndex = 82
            })
            Items["Empty"]:AddToTheme({TextColor3 = "Dark Text"})

            function KeybindList:SetVisible(State)
                self.Visible = State == true
                Items["Frame"].Instance.Visible = self.Visible
            end

            function KeybindList:Refresh()
                local VisibleCount = 0
                local ActiveCount = 0

                for Keybind, Row in Library.KeybindEntries do
                    local Assigned = Keybind.Value ~= "" and Keybind.Value ~= "None"
                    local Active = Keybind.Toggled or Keybind.Mode == "Always"

                    Row.Items["Row"].Instance.Visible = Assigned

                    if Assigned then
                        VisibleCount += 1
                        ActiveCount += Active and 1 or 0

                        Row.Items["Name"].Instance.Text = Keybind.Name
                        Row.Items["Key"].Instance.Text = Keybind.Value
                        Row.Items["KeyBox"].Instance.BackgroundTransparency = Active and 0.78 or 0.9

                        Row.Items["Name"]:ChangeItemTheme({TextColor3 = Active and "Text" or "Dark Text"})
                        Row.Items["Name"]:Tween(nil, {TextColor3 = Library.Theme[Active and "Text" or "Dark Text"]})
                        Row.Items["Name"].Instance.TextTransparency = Active and 0 or 0.24
                        Row.Items["Key"]:ChangeItemTheme({TextColor3 = Active and "Text" or "Dark Text"})
                        Row.Items["Key"]:Tween(nil, {TextColor3 = Library.Theme[Active and "Text" or "Dark Text"]})
                        Row.Items["Key"].Instance.TextTransparency = Active and 0 or 0.18

                        task.defer(function()
                            if Row.Items["Key"].Instance.Parent then
                                Row.Items["KeyBox"].Instance.Size = UDim2New(0, MathClamp(Row.Items["Key"].Instance.TextBounds.X + 14, 34, 72), 0, 18)
                            end
                        end)
                    end
                end

                Items["Empty"].Instance.Visible = VisibleCount == 0
                Items["Count"].Instance.Text = tostring(ActiveCount) .. " active"

                local ContentHeight = VisibleCount > 0 and (VisibleCount * 26 + 8) or 32
                local BodyHeight = MathClamp(ContentHeight, 32, 190)
                Items["Body"].Instance.CanvasSize = UDim2New(0, 0, 0, ContentHeight)
                Items["Body"].Instance.Size = UDim2New(1, 0, 0, BodyHeight)
                local ListHeight = 34 + BodyHeight
                Items["Frame"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2New(0, 218, 0, ListHeight)
                })

                local Viewport = Camera.ViewportSize
                local CurrentPosition = Items["Frame"].Instance.Position
                local SafePosition = UDim2New(
                    0,
                    MathClamp(CurrentPosition.X.Offset, 0, math.max(0, Viewport.X - 218)),
                    0,
                    MathClamp(CurrentPosition.Y.Offset, 0, math.max(0, Viewport.Y - ListHeight))
                )

                if SafePosition ~= CurrentPosition then
                    Items["Frame"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = SafePosition})
                    getgenv().JXVKeybindListPosition = SafePosition
                end
            end

            self.KeybindList = KeybindList
            KeybindList:Refresh()
            return KeybindList
        end

        Library.RegisterKeybind = function(self, Keybind)
            if self.KeybindEntries[Keybind] then
                return
            end

            local List = self.KeybindList or self:CreateKeybindList()
            local Row = {Items = { }}
            local RowItems = Row.Items

            RowItems["Row"] = Instances:Create("Frame", {
                Parent = List.Items["Body"].Instance,
                Name = "\0",
                Size = UDim2New(1, -14, 0, 24),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline,
                BackgroundTransparency = 0.8,
                ZIndex = 82
            })
            RowItems["Row"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = RowItems["Row"].Instance,
                CornerRadius = UDimNew(0, 3)
            })

            RowItems["Name"] = Instances:Create("TextLabel", {
                Parent = RowItems["Row"].Instance,
                Name = "\0",
                Position = UDim2New(0, 9, 0, 0),
                Size = UDim2New(1, -84, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = Keybind.Name,
                TextColor3 = Library.Theme["Dark Text"],
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                FontFace = Library.Font,
                TextSize = 11,
                ZIndex = 84
            })
            RowItems["Name"]:AddToTheme({TextColor3 = "Dark Text"})

            RowItems["KeyBox"] = Instances:Create("Frame", {
                Parent = RowItems["Row"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, -4, 0.5, 0),
                Size = UDim2New(0, 42, 0, 18),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Accent,
                BackgroundTransparency = 0.9,
                ZIndex = 83
            })
            RowItems["KeyBox"]:AddToTheme({BackgroundColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = RowItems["KeyBox"].Instance,
                CornerRadius = UDimNew(0, 3)
            })

            Instances:Create("UIStroke", {
                Parent = RowItems["KeyBox"].Instance,
                Color = Library.Theme.Accent,
                Thickness = 1,
                Transparency = 0.62
            }):AddToTheme({Color = "Accent"})

            RowItems["Key"] = Instances:Create("TextLabel", {
                Parent = RowItems["KeyBox"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = Keybind.Value,
                TextColor3 = Library.Theme["Dark Text"],
                FontFace = Library.Font,
                TextSize = 10,
                ZIndex = 85
            })
            RowItems["Key"]:AddToTheme({TextColor3 = "Dark Text"})

            self.KeybindEntries[Keybind] = Row
            List:Refresh()
        end

        Library.RefreshKeybindList = function(self)
            if self.KeybindList then
                self.KeybindList:Refresh()
            end
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "Window",
                TimeRemaining = Data.TimeRemaining or 0,
                SubTitle = Data.SubTitle or Data.subtitle or "LDS13",
                Logo = Data.Logo or Data.logo or "",
                
                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 622, 0, 502),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y), Vector2New(9999, 9999))

                Items["Shadow"] = Instances:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.4,
                    Size = UDim2.new(1, 25, 1, 25),
                    ZIndex = -1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = Library.Theme["Accent"],
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })  Items["Shadow"]:AddToTheme({ImageColor3 = 'Accent'})                

                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 30)
                })  Items["Top"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 30)
                }):AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(26, 30, 36)
                }):AddToTheme({BackgroundColor3 = "Outline"})
                
                Instances:Create("UIGradient", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    Rotation = -90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(223, 223, 223))}
                })

                Items["BrandGlow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 8, 0.5, 0),
                    Size = UDim2New(0, 38, 0, 38),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Image = Window.Logo,
                    ImageColor3 = Library.Theme["Accent"],
                    ImageTransparency = 0.58,
                    ScaleType = Enum.ScaleType.Fit,
                    Visible = Window.Logo ~= "",
                    ZIndex = 19
                }) Items["BrandGlow"]:AddToTheme({ImageColor3 = "Accent"})

                Items["BrandImage"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 34, 0, 34),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Image = Window.Logo,
                    ScaleType = Enum.ScaleType.Fit,
                    Visible = Window.Logo ~= "",
                    ZIndex = 21
                })

                Items["BrandLetter"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 34, 0, 34),
                    BackgroundTransparency = 1,
                    Text = "J",
                    TextColor3 = Library.Theme["Accent"],
                    FontFace = Library.Font,
                    TextSize = 18,
                    Visible = Window.Logo == "",
                    ZIndex = 21
                }) Items["BrandLetter"]:AddToTheme({TextColor3 = "Accent"})

                Items["Username"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(225, 228, 235),
                    Text = LocalPlayer.Name,
                    Size = UDim2New(0, 210, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 52, 0, 9),
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 11,
                    Visible = true,
                    ZIndex = 20
                }) Items["Username"]:AddToTheme({TextColor3 = "Text"})

                Items["TimeRemaining"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(120, 124, 137),
                    TextTransparency = 0.1,
                    Text = Window.Name .. "  •  " .. Window.SubTitle,
                    Size = UDim2New(0, 245, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 52, 0, 24),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 9,
                    Visible = true,
                    ZIndex = 20
                })

                Items["Pages"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ZIndex = 5
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })                

                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Bottom"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 30)
                })  Items["Bottom"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("Frame", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 30)
                }):AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("Frame", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(26, 30, 36)
                }):AddToTheme({BackgroundColor3 = "Outline"})
                
                Instances:Create("UIGradient", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(223, 223, 223))}
                })
                
                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(200, 200, 200),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 10),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
                
                Items["GameName"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Window.SubTitle,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 25),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["GameName"]:AddToTheme({TextColor3 = "Text"})
                
                Items["Search"] = Instances:Create("Frame", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -48, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 33, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["Search"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["SearchIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://108790783092951",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -8, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["SearchIcon"]:AddToTheme({ImageColor3 = "Text"})
                
                Items["Settings"] = Instances:Create("Frame", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -8, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 30, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["Settings"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Settings"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["SettingsIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Settings"].Instance,
                    Name = "\0",
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://75058048389410",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["SettingsIcon"]:AddToTheme({ImageColor3 = "Text"})
                                
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 50),
                    Size = UDim2New(1, 0, 1, -100),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Page"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items["Settings"]:OnHover(function()
                    Items["SettingsIcon"]:Tween(nil, {ImageTransparency = 0})
                end)

                Items["Settings"]:OnHoverLeave(function()
                    Items["SettingsIcon"]:Tween(nil, {ImageTransparency = 0.5})
                end)

                Items["Search"]:OnHover(function()
                    Items["SearchIcon"]:Tween(nil, {ImageTransparency = 0})
                end)

                Items["Search"]:OnHoverLeave(function()
                    Items["SearchIcon"]:Tween(nil, {ImageTransparency = 0.5})
                end)

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -32, 0.5, 0),
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local IsSearching = false

                Items["SearchIcon"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsSearching = not IsSearching
                        
                        if IsSearching then
                            Items["Input"].Instance.PlaceholderText = "Search..."
                            Items["Input"].Instance.Text = ""
                            Items["Input"].Instance:CaptureFocus()
                            Items["Search"]:Tween(nil, {
                                Size = UDim2New(0, Items["Input"].Instance.TextBounds.X + 42, 0, 30)
                            })
                        else
                            Items["Search"]:Tween(nil, {Size = UDim2New(0, 33, 0, 30)})
                            Items["Input"].Instance.PlaceholderText = ""
                            Items["Input"].Instance.Text = ""
                            Items["Input"].Instance:ReleaseFocus()
                        end
                    end
                end)

                Items["Input"]:Connect("FocusLost", function()
                    Items["Search"]:Tween(nil, {Size = UDim2New(0, 33, 0, 30)})
                    Items["Input"].Instance.PlaceholderText = ""
                    Items["Input"].Instance.Text = ""
                    Items["Input"].Instance:ReleaseFocus()
                end)

                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    local Text = Items["Input"].Instance.Text
                    local Query = StringLower(Text)

                    Items["Search"]:Tween(nil, {
                        Size = UDim2New(0, Items["Input"].Instance.TextBounds.X + 42, 0, 30)
                    })

                    local PageSearchData = Library.SearchItems[Library.CurrentPage]
                    if not PageSearchData then
                        return
                    end

                    -- Filter immediately instead of creating a RenderStepped
                    -- connection on every text change.
                    for _, Value in PageSearchData do
                        local Element = Value.Element
                        local Name = StringLower(Value.Name)
                        Element.Instance.Visible = Query == "" or StringFind(Name, Query, 1, true) ~= nil
                    end
                end)

                local Settings = {
                    IsOpen = false,
                    Name = ""..#Library.Sections,
                    Items = { },
                    IsSettings = true,
                    Elements = { }
                }
    
                local SettingsItems = { }
                do
                    SettingsItems["Settings"] = Instances:Create("TextButton", {
                        Parent = Library.UnusedHolder.Instance,
                        Text = "",
                        AutoButtonColor = false,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0.5, 0.5),
                        BorderSizePixel = 0,
                        Position = UDim2New(0.8949604630470276, 0, 0.2945185601711273, 0),
                        Size = UDim2New(0, 325, 0, 159),
                        ZIndex = 2,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = FromRGB(21, 21, 24)
                    }) SettingsItems["Settings"]:AddToTheme({BackgroundColor3 = "Background"})
                    
                    Instances:Create("UICorner", {
                        Parent = SettingsItems["Settings"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 6)
                    })
                    
                    SettingsItems["CloseButton"] = Instances:Create("TextButton", {
                        Parent = SettingsItems["Settings"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = Vector2New(0, 1),
                        BorderSizePixel = 0,
                        Position = UDim2New(0, 8, 1, -8),
                        Size = UDim2New(1, -16, 0, 22),
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(27, 26, 29)
                    }) SettingsItems["CloseButton"]:AddToTheme({BackgroundColor3 = "Element"})
                
                    Instances:Create("UICorner", {
                        Parent = SettingsItems["CloseButton"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })
                    
                    SettingsItems["Text"] = Instances:Create("TextLabel", {
                        Parent = SettingsItems["CloseButton"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(100, 100, 100),
                        TextTransparency = 0,
                        Text = "Exit",
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0.5, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  SettingsItems["Text"]:AddToTheme({TextColor3 = "Dark Text"})
                    
                    SettingsItems["CloseButton"]:OnHover(function()
                        SettingsItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                        SettingsItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                    end)

                    SettingsItems["CloseButton"]:OnHoverLeave(function()
                        SettingsItems["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                        SettingsItems["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                    end)

                    SettingsItems["Content"] = Instances:Create("ScrollingFrame", {
                        Parent = SettingsItems["Settings"].Instance,
                        Name = "\0",
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        Selectable = false,
                        Size = UDim2New(1, -8, 1, -46),
                        Position = UDim2New(0, 4, 0, 4),
                        ScrollBarThickness = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })
                    
                    Instances:Create("UIListLayout", {
                        Parent = SettingsItems["Content"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })                    
                    
                    Instances:Create("UIPadding", {
                        Parent = SettingsItems["Content"].Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 4),
                        PaddingBottom = UDimNew(0, 4),
                        PaddingRight = UDimNew(0, 4),
                        PaddingLeft = UDimNew(0, 4)
                    })
    
                    Instances:Create("UICorner", {
                        Parent = SettingsItems["CloseButton"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })
    
                    local RenderStepped 
                    local Debounce = false
    
                    function Settings:SetOpen(Bool)
                        if Debounce then 
                            return
                        end
        
                        Settings.IsOpen = Bool
        
                        Debounce = true 
        
                        if Settings.IsOpen then 
                            for Index, Value in Settings.Elements do
                                Value:RefreshPosition(true)
                                task.wait(0.03)
                            end
    
                            SettingsItems["Settings"].Instance.Visible = true
                            SettingsItems["Settings"].Instance.Parent = Library.Holder.Instance

                            SettingsItems["Settings"].Instance.Position = UDim2New(
                                0, Items["SettingsIcon"].Instance.AbsolutePosition.X + 18, 
                                0, 
                                Items["SettingsIcon"].Instance.AbsolutePosition.Y + Items["SettingsIcon"].Instance.AbsoluteSize.Y * 3 -- its weird
                            )
                            SettingsItems["Settings"]:Tween(nil, {Size = UDim2New(0, 325, 0, 185)})
        
                            for Index, Value in Library.OpenFrames do 
                                if Value ~= Settings then 
                                    Value:SetOpen(false)
                                end
                            end
        
                            Library.OpenFrames[Settings] = Settings 
                        else
                            if Library.OpenFrames[Settings] then 
                                Library.OpenFrames[Settings] = nil
                            end

                            SettingsItems["Settings"]:Tween(nil, {Size = UDim2New(0, 325, 0, 0)})
                        end
        
                        local Descendants = SettingsItems["Settings"].Instance:GetDescendants()
                        TableInsert(Descendants, SettingsItems["Settings"].Instance)
        
                        local NewTween
        
                        for Index, Value in Descendants do 
                            local TransparencyProperty = Tween:GetProperty(Value)
        
                            if not TransparencyProperty then
                                continue 
                            end
        
                            if not Value.ClassName:find("UI") then 
                                Value.ZIndex = Settings.IsOpen and 7 or 1
                                SettingsItems["Text"].Instance.ZIndex = 8
                            end
        
                            if type(TransparencyProperty) == "table" then 
                                for _, Property in TransparencyProperty do 
                                    NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                                end
                            else
                                NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                            end
                        end
                        
                        NewTween.Tween.Completed:Connect(function()
                            Debounce = false 
                            SettingsItems["Settings"].Instance.Visible = Settings.IsOpen
                            task.wait(0.2)
                            SettingsItems["Settings"].Instance.Parent = not Settings.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance

                            if Settings.IsOpen then 
                                RenderStepped = RunService.RenderStepped:Connect(function()
                                    SettingsItems["Settings"].Instance.Position = UDim2New(
                                        0, Items["SettingsIcon"].Instance.AbsolutePosition.X + 18, 
                                        0, 
                                        Items["SettingsIcon"].Instance.AbsolutePosition.Y + Items["SettingsIcon"].Instance.AbsoluteSize.Y * 3 -- its weird
                                    )
                                    SettingsItems["Settings"].Instance.Size = UDim2New(0, 325, 0, 185)
                                end)
                            else
                                if RenderStepped then 
                                    RenderStepped:Disconnect()
                                    RenderStepped = nil
                                end
                            end
                        end)
                    end
    
                    SettingsItems["CloseButton"]:Connect("MouseButton1Down", function()
                        Settings:SetOpen(false)
                    end)
    
                    Items["SettingsIcon"]:Connect("InputBegan", function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                            Settings:SetOpen(not Settings.IsOpen)
                        end
                    end)
    
                    Settings.Items = SettingsItems
                    setmetatable(Settings, Library.Sections)
    
                    for Index, Value in Library.Theme do 
                        Settings:Label(Index):Colorpicker({
                            Flag = Index,
                            Default = Library.Theme[Index],
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end
                end

                if IsMobile then 
                    Items["FloatingButton"] = Instances:Create("TextButton", {
                        Parent = Library.Holder.Instance,
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = Vector2New(0.5, 0),
                        Name = "\0",
                        Position = UDim2New(0.5, 0, 0, 25),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 50, 0, 50),
                        BorderSizePixel = 0,
                        ZIndex = 127,
                        BackgroundColor3 = Library.Theme.Background
                    })  Items["FloatingButton"]:AddToTheme({BackgroundColor3 = "Background"})
        
                    Items["FloatingButton"]:MakeDraggable()
        
                    Items["Textsss"] = Instances:Create("TextLabel", {
                        Parent = Items["FloatingButton"].Instance,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Name = "\0",
                        Text = "Close",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        ZIndex = 127,
                        Size = UDim2New(1, -10, 1, -10),
                        BorderSizePixel = 0,
                        TextSize = 14,
                        FontFace = Library.Font,
                        BackgroundColor3 = FromRGB(255, 255, 255),
                    })  Items["Textsss"]:AddToTheme({TextColor3 = "Text"})
         
                    Instances:Create("UICorner", {
                        Parent = Items["FloatingButton"].Instance,
                        CornerRadius = UDimNew(1, 0)
                    }) 
        
                    Items["FloatingButton"]:Connect("InputBegan", function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            Window:SetOpen(not Window.IsOpen)
                            Items["Textsss"].Instance.Text = Window.IsOpen and "Close" or "Open"
                        end
                    end)

                    local CenterPosition = Items["FloatingButton"].Instance.AbsolutePosition
                    task.wait()
                    Items["FloatingButton"].Instance.AnchorPoint = Vector2New(0, 0)
        
                    Items["FloatingButton"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
                end

                -- Smooth UI scaling: one shared UIScale, interpolated once per frame.
                -- This avoids spawning a tween for every mouse/touch movement.
                do
                    local MainFrame = Items["MainFrame"].Instance
                    local UIScale = Library.UIScale.Instance

                    local MinScale, MaxScale = 0.6, 1.4
                    local ScaleResponsiveness = 24

                    local Dragging = false
                    local InputChanged
                    local ScaleConnection
                    local StartMouse, StartScale, StartWidth, StartHeight
                    local TargetScale = UIScale.Scale

                    local GetViewport = function()
                        return Camera.ViewportSize
                    end

                    local ClampPosition = function(X, Y, Scale)
                        local Viewport = GetViewport()
                        local Width = MainFrame.Size.X.Offset
                        local Height = MainFrame.Size.Y.Offset

                        X = MathClamp(X, 0, math.max(0, Viewport.X / Scale - Width))
                        Y = MathClamp(Y, 0, math.max(0, Viewport.Y / Scale - Height))

                        return X, Y
                    end

                    local SetScaleImmediate = function(NewScale)
                        NewScale = MathClamp(NewScale, MinScale, MaxScale)

                        local OldScale = UIScale.Scale
                        if MathAbs(NewScale - OldScale) < 0.0001 then
                            return
                        end

                        local Position = MainFrame.Position
                        local Width = MainFrame.Size.X.Offset
                        local Height = MainFrame.Size.Y.Offset

                        -- Preserve the window's top-right screen point while scaling.
                        local RightEdge = (Position.X.Offset + Width) * OldScale
                        local TopEdge = Position.Y.Offset * OldScale

                        local X = (RightEdge / NewScale) - Width
                        local Y = TopEdge / NewScale

                        X, Y = ClampPosition(X, Y, NewScale)

                        UIScale.Scale = NewScale
                        MainFrame.Position = UDim2New(0, X, 0, Y)
                    end

                    local StopScaleSmoothing = function()
                        if ScaleConnection then
                            ScaleConnection:Disconnect()
                            ScaleConnection = nil
                        end

                        SetScaleImmediate(TargetScale)
                    end

                    local StartScaleSmoothing = function()
                        if ScaleConnection then
                            return
                        end

                        ScaleConnection = RunService.RenderStepped:Connect(function(DeltaTime)
                            local Current = UIScale.Scale
                            local Difference = TargetScale - Current

                            if MathAbs(Difference) < 0.0001 then
                                StopScaleSmoothing()
                                return
                            end

                            -- Frame-rate independent exponential smoothing.
                            local Alpha = 1 - math.exp(-ScaleResponsiveness * DeltaTime)
                            SetScaleImmediate(Current + Difference * Alpha)
                        end)
                    end

                    local SetScaleTarget = function(NewScale, Smooth)
                        NewScale = tonumber(NewScale) or UIScale.Scale
                        NewScale = MathClamp(NewScale, MinScale, MaxScale)

                        TargetScale = NewScale
                        Library.Flags["UI Scale"] = NewScale * 100

                        if Smooth then
                            StartScaleSmoothing()
                        else
                            StopScaleSmoothing()
                        end
                    end

                    -- Smooth bottom-right scale handle.
                    -- The handle only changes TargetScale; the shared RenderStepped
                    -- smoother above applies the visual scale, avoiding tween spam.
                    do
                        local ScaleHandle = Instances:Create("TextButton", {
                            Parent = MainFrame,
                            Name = "ScaleHandle",
                            AnchorPoint = Vector2New(1, 1),
                            Position = UDim2New(1, -2, 1, -2),
                            Size = UDim2New(0, 18, 0, 18),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            AutoButtonColor = false,
                            Text = "",
                            ZIndex = 100000
                        })

                        local Pieces = {}

                        local MakePiece = function(Position, Size, Rotation)
                            local Piece = Instances:Create("Frame", {
                                Parent = ScaleHandle.Instance,
                                Name = "\0",
                                AnchorPoint = Vector2New(0.5, 0.5),
                                Position = Position,
                                Size = Size,
                                Rotation = Rotation,
                                BorderSizePixel = 0,
                                BackgroundTransparency = 0.45,
                                ZIndex = 100001
                            })
                            Piece:AddToTheme({BackgroundColor3 = "Text"})
                            TableInsert(Pieces, Piece)
                        end

                        -- Clean bottom-right resize arrow.
                        MakePiece(UDim2New(0, 9, 0, 9), UDim2New(0, 14, 0, 2), 45)
                        MakePiece(UDim2New(0, 11, 0, 13), UDim2New(0, 8, 0, 2), 0)
                        MakePiece(UDim2New(0, 14, 0, 11), UDim2New(0, 2, 0, 8), 0)

                        local SetPieces = function(Transparency)
                            for _, Piece in Pieces do
                                Piece:Tween(nil, {BackgroundTransparency = Transparency})
                            end
                        end

                        ScaleHandle:OnHover(function()
                            SetPieces(0)
                        end)

                        ScaleHandle:OnHoverLeave(function()
                            if not Dragging then
                                SetPieces(0.45)
                            end
                        end)

                        local Scaling = false
                        local ScaleInputChanged
                        local StartMouse
                        local StartScale

                        ScaleHandle:Connect("InputBegan", function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                                return
                            end

                            Scaling = true
                            StartMouse = Vector2New(Input.Position.X, Input.Position.Y)
                            StartScale = TargetScale
                            SetPieces(0)

                            if ScaleInputChanged then
                                ScaleInputChanged:Disconnect()
                            end

                            ScaleInputChanged = Input.Changed:Connect(function()
                                if Input.UserInputState == Enum.UserInputState.End then
                                    Scaling = false
                                    SetPieces(0.45)
                                    if ScaleInputChanged then
                                        ScaleInputChanged:Disconnect()
                                        ScaleInputChanged = nil
                                    end
                                end
                            end)
                        end)

                        Library:Connect(UserInputService.InputChanged, function(Input)
                            if not Scaling then
                                return
                            end

                            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then
                                return
                            end

                            local DeltaX = Input.Position.X - StartMouse.X
                            local DeltaY = Input.Position.Y - StartMouse.Y
                            local DiagonalDelta = (DeltaX + DeltaY) * 0.5

                            -- About 500 screen pixels = 1.00 scale change.
                            -- No snapping, so every small mouse movement is represented.
                            local NewScale = MathClamp(StartScale + (DiagonalDelta / 500), MinScale, MaxScale)
                            SetScaleTarget(NewScale, true)
                        end)

                        Library:Connect(UserInputService.InputEnded, function(Input)
                            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                                Scaling = false
                                SetPieces(0.45)
                            end
                        end)

                        Items["ScaleHandle"] = ScaleHandle
                    end

                    -- Public setter used by Settings and configs.
                    Library.SetUIScale = function(self, NewScale, Smooth)
                        SetScaleTarget(NewScale, Smooth ~= false)
                    end

                    -- Config support, including old values such as "100%".
                    Library.SetFlags["UI Scale"] = function(Value)
                        if type(Value) == "string" then
                            Value = (tonumber(Value:match("[%d%.]+")) or 100) / 100
                        elseif type(Value) == "number" and Value > 10 then
                            Value = Value / 100
                        end

                        SetScaleTarget(tonumber(Value) or 1, false)
                    end

                    Library.Flags["UI Scale"] = TargetScale * 100
                end

                Window.Items = Items
            end

            Library:CreateKeybindList()
            
            local Debounce = false

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetStreamerMode(State)
                Window.StreamerMode = State == true

                if Items["Username"] and Items["Username"].Instance then
                    Items["Username"].Instance.Visible = true
                    Items["Username"].Instance.Text = Window.StreamerMode and "Jxv.Hub" or LocalPlayer.Name
                end

                if Items["TimeRemaining"] and Items["TimeRemaining"].Instance then
                    Items["TimeRemaining"].Instance.Visible = true
                    Items["TimeRemaining"].Instance.Text = Window.StreamerMode and "Streamer Mode" or (Window.Name .. "  •  " .. Window.SubTitle)
                end
            end

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Window.IsOpen = Bool

                Debounce = true 

                if Window.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true 
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Icon = Data.Icon or Data.icon or "131145598162617",
                Columns = Data.Columns or Data.columns or 2,

                Items = { },
                ColumnsData = { },
                Active = false
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 30, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://"..Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})     
                
                Items["Inactive"]:OnHover(function()
                    if Page.Active then return end
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0})
                end)

                Items["Inactive"]:OnHoverLeave(function()
                    if Page.Active then return end
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.5})
                end)

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 0, 0, 67), -- 67 LOL LMFAO FUNY
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })                

                Items["LeftColumn"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["LeftColumn"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 12),
                    PaddingBottom = UDimNew(0, 12),
                    PaddingRight = UDimNew(0, 1),
                    PaddingLeft = UDimNew(0, 12)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["LeftColumn"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })        
                
                Items["RightColumn"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["RightColumn"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 12),
                    PaddingBottom = UDimNew(0, 1),
                    PaddingRight = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 12)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["RightColumn"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })        

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BackgroundColor3 = FromRGB(184, 212, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Items["Gradient"] = Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Enabled = false,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(170, 170, 170))}
                })    

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]
                
                Page.Items = Items
            end

            local Debounce = false

            Library.SearchItems[Page] = { }

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = function()
                        return FromRGB(0, 0, 0)
                    end})

                    Items["Accent"]:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New(1, 0, 1, 0), BackgroundTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(0, 0, 0), ImageTransparency = 0})
                    Items["Page"]:Tween(TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 0)})
                    Items["Gradient"].Instance.Enabled = true

                    Library.CurrentPage = Page
                else
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})

                    Items["Accent"]:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New(0, 0, 0, 0), BackgroundTransparency = 1})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.5})
                    Items["Page"]:Tween(TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 67)})
                    Items["Gradient"].Instance.Enabled = false
                end

                local AllInstances = Items["Page"].Instance:GetDescendants()
                TableInsert(AllInstances, Items["Page"].Instance)
                
                local NewTween 

                for Index, Value in AllInstances do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                end)
            end

            local PageSearchData = Library.SearchItems[Page]

            function Page:InsertElement(Name, Element)
                local SearchData = {
                    Element = Element,
                    Name = Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Icon = Data.Icon or Data.icon or "131145598162617",
                Side = Data.Side or Data.side or 1,

                Items = { }
            }

            local Items = { } do
                Items["Section"] = Instances:Create("Frame", {
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 45),
                    Position = UDim2New(0.29109588265419006, 0, -0.1190476194024086, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(22, 25, 30)
                })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0"
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    Color = FromRGB(26, 30, 36),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})
                
                Items["IconBackground"] = Instances:Create("TextButton", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(0, 25, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(184, 212, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["IconBackground"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["IconBackground"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(200, 200, 200),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://"..Section.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(200, 200, 200),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 38, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
                
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 40),
                    Size = UDim2New(1, -20, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 10)
                })                
                
                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false,
                KeybindObject = nil
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 16),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(28, 32, 38)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(184, 212, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(209, 209, 209))}
                })
                
                Items["CheckImage"] = Instances:Create("ImageLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://74979969250992",
                    BackgroundTransparency = 1,
                    Rotation = 85,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 8, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Toggle.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 24, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Dark Text"})
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Items["Toggle"]:OnHover(function()
                    if Toggle.Value then return end
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end)

                Items["Toggle"]:OnHoverLeave(function()
                    if Toggle.Value then return end
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                end)
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if Toggle.Value then 
                    Items["Accent"]:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(1, 0, 1, 0)})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                    Items["CheckImage"]:Tween(nil, {Rotation = 0, ImageTransparency = 0})
                else
                    Items["Accent"]:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                    Items["CheckImage"]:Tween(nil, {Rotation = 85, ImageTransparency = 1})
                end

                if Toggle.Callback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                if Toggle.KeybindObject then
                    return Toggle.KeybindObject
                end

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function(Value)
                        Toggle:Set(Value)
                    end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                    OnValue = Data.OnValue ~= false,
                    OffValue = Data.OffValue == true
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Data.Name or Data.name or Toggle.Name,
                    Source = Items["Toggle"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback,
                    OnValue = Keybind.OnValue,
                    OffValue = Keybind.OffValue
                })

                NewKeybind.Editor = Library:CreateKeybindEditor()
                Toggle.KeybindObject = NewKeybind

                return NewKeybind
            end

            local PageSearchData = Library.SearchItems[Toggle.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Toggle"],
                    Name = Toggle.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            Items["Toggle"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Toggle:Set(not Toggle.Value)
                end
            end)

            Items["Toggle"]:Connect("MouseButton2Down", function()
                local Keybind = Toggle.KeybindObject

                if not Keybind then
                    Keybind = Toggle:Keybind({
                        Name = Toggle.Name,
                        Flag = Toggle.Flag .. "/Keybind",
                        Default = Enum.KeyCode.Backspace,
                        Mode = "Toggle",
                        Callback = function(Value)
                            Toggle:Set(Value)
                        end
                    })
                end

                local Editor = Keybind.Editor
                local ShouldOpen = not (Editor.IsOpen and Editor.Current == Keybind)
                Editor:SetOpen(ShouldOpen, Keybind, Items["Toggle"])
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do 
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 22),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(28, 32, 38)
                })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    ZIndex = 2,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Dark Text"})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(184, 212, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(209, 209, 209))}
                })

                Items["Button"]:OnHover(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end)

                Items["Button"]:OnHoverLeave(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                end)
            end 

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                Items["Text"]:ChangeItemTheme({TextColor3 = function()
                    return FromRGB(0, 0, 0)
                end})
                Items["Text"]:Tween(nil, {TextColor3 = FromRGB(0, 0, 0)})
                Items["Accent"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(1, 0, 1, 0)})
                task.wait(0.2)
                Library:SafeCall(Button.Callback)
                Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                Items["Accent"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})
            end

            local PageSearchData = Library.SearchItems[Button.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Button"],
                    Name = Button.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Default = Data.Default or Data.default or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Decimals = Data.Decimals or Data.decimals or 1,
                DisplayMultiplier = Data.DisplayMultiplier or Data.displayMultiplier or 1,
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do 
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 36),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Dark Text"})
                
                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 10),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(28, 32, 38)
                })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.6000000238418579, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(184, 212, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  
                
                Instances:Create("UICorner", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(170, 170, 170))}
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(170, 170, 170))}
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "60%",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Dark Text"})       
                
                Items["RealSlider"]:OnHover(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Value"]:ChangeItemTheme({TextColor3 = "Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                    Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end)

                Items["RealSlider"]:OnHoverLeave(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                    Items["Value"]:ChangeItemTheme({TextColor3 = "Dark Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                    Items["Value"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                end)
            end

            function Slider:Get()
                return Slider.Value 
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value * Slider.DisplayMultiplier, Slider.Suffix)

                if Slider.Value <= Slider.Min then
                    Items["Dragger"].Instance.Position = UDim2New(1, 10, 0.5, 0)
                else
                    Items["Dragger"].Instance.Position = UDim2New(1, 0, 0.5, 0)
                end

                if Slider.Callback then 
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local PageSearchData = Library.SearchItems[Slider.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Slider"],
                    Name = Slider.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider 
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Default = Data.Default or Data.default or nil,
                MaxSize = Data.MaxSize or Data.maxsize or 145,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 48),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Dark Text"})
                
                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 24),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(28, 32, 38)
                })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "...",
                    Size = UDim2New(1, -35, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 10, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Dark Text"})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://134676997516408",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -4, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})       
                
                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Visible = false,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 31, 0, 170),
                    Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 127),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(13, 15, 18)
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(26, 30, 36),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})
                
                Items["Holder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    Size = UDim2New(1, -14, 1, -14),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0, 7),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 1),
                    PaddingBottom = UDimNew(0, 1),
                    PaddingRight = UDimNew(0, 1),
                    PaddingLeft = UDimNew(0, 1)
                })

                Items["RealDropdown"]:OnHover(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Value"]:ChangeItemTheme({TextColor3 = "Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                    Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end)

                Items["RealDropdown"]:OnHoverLeave(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                    Items["Value"]:ChangeItemTheme({TextColor3 = "Dark Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                    Items["Value"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                end)
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false 
            local RenderStepped 

            -- OptionHolder is moved to the scaled ScreenGui. AbsolutePosition/AbsoluteSize
            -- are screen-space pixels, while Position/Size under UIScale use unscaled UI
            -- coordinates. Convert the dropdown metrics so they stay aligned at every scale.
            local GetDropdownMetrics = function()
                local Scale = (Library.UIScale and Library.UIScale.Instance and Library.UIScale.Instance.Scale) or 1
                if Scale <= 0 then
                    Scale = 1
                end

                local Real = Items["RealDropdown"].Instance
                local Position = Real.AbsolutePosition
                local Size = Real.AbsoluteSize
                local HolderPosition = Library.Holder.Instance.AbsolutePosition

                local X = (Position.X - HolderPosition.X) / Scale
                local Y = (Position.Y - HolderPosition.Y) / Scale
                local Width = Size.X / Scale
                local Height = Size.Y / Scale

                return X, Y + Height + (5 / Scale), Width
            end

            local UpdateOptionHolderPosition = function()
                if not Dropdown.IsOpen then
                    return
                end

                local X, Y, Width = GetDropdownMetrics()
                Items["OptionHolder"].Instance.Position = UDim2New(0, X, 0, Y)
                Items["OptionHolder"].Instance.Size = UDim2New(0, Width, Items["OptionHolder"].Instance.Size.Y.Scale, Items["OptionHolder"].Instance.Size.Y.Offset)
            end

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

                    local X, Y, Width = GetDropdownMetrics()
                    local Scale = (Library.UIScale and Library.UIScale.Instance and Library.UIScale.Instance.Scale) or 1
                    if Scale <= 0 then Scale = 1 end

                    Items["OptionHolder"].Instance.Size = UDim2New(0, Width, 0, 0)
                    Items["OptionHolder"].Instance.Position = UDim2New(0, X, 0, Y)
                    Items["OptionHolder"]:Tween(nil, {Size = UDim2New(0, Width, 0, Dropdown.MaxSize / Scale)})

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    local _, _, Width = GetDropdownMetrics()
                    Items["OptionHolder"]:Tween(nil, {Size = UDim2New(0, Width, 0, 0)})
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance

                    task.wait(0.1)
                    if Dropdown.IsOpen then 
                        -- Keep the floating dropdown in the same coordinate space as the
                        -- scaled Holder. Do not assign screen-space AbsolutePosition values
                        -- directly here, or UIScale will introduce a growing gap/offset.
                        RenderStepped = RunService.RenderStepped:Connect(function()
                            UpdateOptionHolderPosition()

                            local Scale = (Library.UIScale and Library.UIScale.Instance and Library.UIScale.Instance.Scale) or 1
                            if Scale <= 0 then
                                Scale = 1
                            end

                            local Holder = Items["OptionHolder"].Instance
                            local Width = Holder.Size.X.Offset
                            Holder.Size = UDim2New(0, Width, 0, Dropdown.MaxSize / Scale)
                        end)
                    else
                        if RenderStepped then 
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end

                        local _, _, Width = GetDropdownMetrics()
                        Items["OptionHolder"]:Tween(nil, {Size = UDim2New(0, Width, 0, 0)})
                    end
                end)
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(184, 212, 255)
                })  OptionButton:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UIGradient", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(170, 170, 170))}
                })
                
                Instances:Create("UICorner", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionText:AddToTheme({TextColor3 = "Dark Text"})      
                
                local OptionData = {
                    Text = OptionText,
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }
                
                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Text:ChangeItemTheme({TextColor3 = function()
                            return FromRGB(0, 0, 0)
                        end})

                        OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                        OptionData.Text:Tween(nil, {TextColor3 = FromRGB(0, 0, 0)})
                    else
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Dark Text"})

                        OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                        OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            local PageSearchData = Library.SearchItems[Dropdown.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Dropdown"],
                    Name = Dropdown.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if (Property == "AbsolutePosition" or Property == "AbsoluteSize") and Dropdown.IsOpen then
                    UpdateOptionHolderPosition()
                    Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do 
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Dark Text"})
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Label"]:OnHover(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end)

                Items["Label"]:OnHoverLeave(function()
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme["Dark Text"]})
                end)
            end

            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Data.Name or Data.name or Label.Name,
                    Source = Items["Label"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                NewKeybind.Editor = Library:CreateKeybindEditor()

                return NewKeybind
            end

            local PageSearchData = Library.SearchItems[Label.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Label"],
                    Name = Label.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            return Label
        end

        Library.Sections.Searchbar = function(self, Data)
            Data = Data or { }

            local Searchbar = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Placeholder = Data.Placeholder or Data.placeholder or "Search",
                Target = Data.Target or Data.target or "Section",
                Callback = Data.Callback or Data.callback or function() end,
                Value = ""
            }

            local Items = { } do
                Items["Searchbar"] = Instances:Create("Frame", {
                    Parent = Searchbar.Section.Items["Content"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 28),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(24, 28, 34)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Searchbar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Searchbar"].Instance,
                    Name = "\0",
                    Color = FromRGB(43, 49, 58),
                    Transparency = 0.25,
                    Thickness = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Searchbar"].Instance,
                    Name = "\0",
                    Image = "rbxassetid://108790783092951",
                    ImageTransparency = 0.45,
                    ImageColor3 = FromRGB(190, 195, 203),
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 8, 0.5, 0),
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Searchbar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Text = "",
                    PlaceholderText = Searchbar.Placeholder,
                    PlaceholderColor3 = FromRGB(110, 116, 126),
                    TextColor3 = FromRGB(220, 223, 228),
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 29, 0.5, 0),
                    Size = UDim2New(1, -37, 0, 18),
                    BorderSizePixel = 0
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Dark Text"})
            end

            local function IsTarget(Element)
                if Searchbar.Target == "Page" or Searchbar.Target == "page" then
                    return true
                end

                local TargetSection = type(Searchbar.Target) == "table" and Searchbar.Target or Searchbar.Section

                if not TargetSection or not TargetSection.Items or not TargetSection.Items["Section"] then
                    return false
                end

                return Element.Instance:IsDescendantOf(TargetSection.Items["Section"].Instance)
            end

            function Searchbar:Filter(Text)
                Text = tostring(Text or "")
                Searchbar.Value = Text

                local Query = StringLower(Text)
                local PageSearchData = Library.SearchItems[Searchbar.Page]

                if PageSearchData then
                    for _, Value in PageSearchData do
                        local Element = Value.Element

                        if Element and Element.Instance and IsTarget(Element) then
                            Element.Instance.Visible = Query == "" or StringFind(StringLower(tostring(Value.Name)), Query, 1, true) ~= nil
                        end
                    end
                end

                Library:SafeCall(Searchbar.Callback, Text)
            end

            function Searchbar:Get()
                return Searchbar.Value
            end

            function Searchbar:Set(Text)
                Text = tostring(Text or "")
                Items["Input"].Instance.Text = Text
                Searchbar:Filter(Text)
            end

            function Searchbar:Clear()
                Searchbar:Set("")
            end

            function Searchbar:SetVisibility(Bool)
                Items["Searchbar"].Instance.Visible = Bool
            end

            Items["Input"]:Connect("Focused", function()
                Items["Stroke"]:Tween(nil, {Color = FromRGB(72, 79, 90), Transparency = 0})
                Items["Icon"]:Tween(nil, {ImageTransparency = 0.15})
            end)

            Items["Input"]:Connect("FocusLost", function()
                Items["Stroke"]:Tween(nil, {Color = FromRGB(43, 49, 58), Transparency = 0.25})
                Items["Icon"]:Tween(nil, {ImageTransparency = 0.45})
            end)

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                Searchbar:Filter(Items["Input"].Instance.Text)
            end)

            return Searchbar
        end

        Library.Sections.Search = Library.Sections.Searchbar

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Textbox",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do 
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 24),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Size = UDim2New(1, 0, 0, 24),
                    Position = UDim2New(0, 0, 1, 0),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(28, 32, 38)
                })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Active = true,
                    Selectable = true,
                    TextEditable = true,
                    ClearTextOnFocus = false,
                    MultiLine = false,
                    AnchorPoint = Vector2New(0, 0.5),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 14,
                    Size = UDim2New(1, -20, 0, 15),
                    TextColor3 = FromRGB(200, 200, 200),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Position = UDim2New(0, 10, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    PlaceholderColor3 = FromRGB(100, 100, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Dark Text"})              
            end

            -- Let touch users focus the field from anywhere inside its background.
            Items["Background"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Items["Input"].Instance:CaptureFocus()
                end
            end)
            
            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            local PageSearchData = Library.SearchItems[Textbox.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Textbox"],
                    Name = Textbox.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end
    end

    Library.CreateSettingsPage = function(self, Window)
        local SettingsPage = Window:Page({Name = "Settings", Icon = "77861834748434"})

        local ConfigsSection = SettingsPage:Section({Name = "Configs", Side = 2}) do 
            local ConfigName
            local ConfigSelected

            local ConfigsDropdown = ConfigsSection:Dropdown({
                Name = "Configs", 
                Flag = "Configs",
                Items = { }, 
                Multi = false,
                MaxSize = 120,
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            ConfigsSection:Textbox({
                Name = "Config name",
                Placeholder = "Config name",
                Flag = "ConfigName",
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            ConfigsSection:Button({
                Name = "Create",
                Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:RefreshConfigsList(ConfigsDropdown)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Load",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json"))
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Save",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        writefile(Library.Folders.Configs .. "/" .. ConfigSelected..".json", Library:GetConfig())
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Delete",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        delfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json")
                        Library:RefreshConfigsList(ConfigsDropdown)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Refresh",
                Callback = function()
                    Library:RefreshConfigsList(ConfigsDropdown)
                end
            })

            Library:RefreshConfigsList(ConfigsDropdown)
        end
        
        local SettingsSection = SettingsPage:Section({Name = "Settings", Side = 1}) do 
            SettingsSection:Label("Menu Keybind"):Keybind({Name = "Menu Keybind", Flag = "Menu Keybind", Default = Enum.KeyCode.RightControl, Mode = "Toggle", Callback = function(Value)
                Library.MenuKeybind = Library.Flags["Menu Keybind"].Key
            end})

            SettingsSection:Toggle({
                Name = "Show Keybind List",
                Flag = "Show Keybind List",
                Default = true,
                Callback = function(Value)
                    if Library.KeybindList then
                        Library.KeybindList:SetVisible(Value)
                    end
                end
            })

            SettingsSection:Toggle({
                Name = "Streamer Mode",
                Flag = "Streamer Mode",
                Default = false,
                Callback = function(Value)
                    Window:SetStreamerMode(Value)
                end
            })

            SettingsSection:Slider({
                Name = "Fade Time",
                Default = Library.FadeSpeed,
                Min = 0,
                Max = 1,
                Suffix = "s",
                Decimals = 0.01,
                Callback = function(Value)
                    Library.FadeSpeed = Value
                end
            })

            SettingsSection:Slider({
                Name = "Animation Speed",
                Default = Library.Tween.Time,
                Min = 0,
                Max = 1,
                Suffix = "s",
                Decimals = 0.01,
                Callback = function(Value)
                    Library.Tween.Time = Value
                end
            })
        end

        local ServerSection = SettingsPage:Section({Name = "Server Settings",Side = 2}) do
            
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")
            local function requestAPI(url)
                local ok, res = pcall(function() return game:HttpGet(url) end)
                if ok and res and res ~= "" then return res end
                return nil
            end
            local function getServers(sortOrder, maxPages)
                local proxies = {
                    "games.roblox.com",
                    "games.roproxy.com",
                    "games.proxy.rblx.trade"
                }
                sortOrder = sortOrder or "Desc"
                maxPages = maxPages or 1
                for _, proxy in ipairs(proxies) do
                    local allServers = {}
                    local cursor = ""
                    local pageCount = 0
                    local failed = false
                    while pageCount < maxPages do
                        pageCount = pageCount + 1
                        local cursorParam = (cursor ~= "") and ("&cursor=" .. cursor) or ""
                        local url = "https://" .. proxy .. "/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100&excludeFullGames=true" .. cursorParam
                        local body = requestAPI(url)
                        if body then
                            local success, data = pcall(function() return HttpService:JSONDecode(body) end)
                            if success and data and data.data then
                                for _, s in ipairs(data.data) do
                                    table.insert(allServers, s)
                                end
                                if data.nextPageCursor and type(data.nextPageCursor) == "string" and data.nextPageCursor ~= "" then
                                    cursor = data.nextPageCursor
                                else
                                    break
                                end
                            else
                                failed = true
                                break
                            end
                        else
                            failed = true
                            break
                        end
                    end
                    if not failed and #allServers > 0 then
                        return allServers
                    end
                end
                return nil
            end
            local function NotifyCompat(text, time)
                pcall(function()
                    if Library.Notifications and Library.Notifications.Create then
                        Library.Notifications:Create({Name = text, LifeTime = time or 3})
                    end
                end)
            end
            ServerSection:Button({Name = "Rejoin Server",Callback = function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,game.Players.LocalPlayer)
            end})

            ServerSection:Button({Name = "Server Hop",Callback = function()
                local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" ..game.PlaceId .."/servers/Public?sortOrder=Asc&limit=100"))
                for _, Server in next, Servers.data do
                    if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(
                            game.PlaceId,
                            Server.id,
                            game.Players.LocalPlayer
                        )
                        break
                    end
                end
            end})

            ServerSection:Button({Name = "Join Lowest Server",Callback = function()
                local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" ..game.PlaceId .."/servers/Public?sortOrder=Asc&limit=100"))
                local LowestServer
                for _, Server in next, Servers.data do
                    if Server.playing < Server.maxPlayers
                        and Server.id ~= game.JobId
                        and (not LowestServer or Server.playing < LowestServer.playing) then
                        LowestServer = Server
                    end
                end
                if LowestServer then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId,LowestServer.id,game.Players.LocalPlayer)
                end
            end})

            ServerSection:Button({
                Name = "Join Lowest Ping Server",
                Callback = function()
                    task.spawn(function()
                        NotifyCompat("Scanning for lowest ping server (best region)...", 4)
                        local servers = getServers("Desc", 3)
                        local bestServer = nil
                        local lowestPing = math.huge

                        if servers then
                            for _, s in ipairs(servers) do
                                if s.id ~= game.JobId and type(s.playing) == "number" and s.playing > 0 and s.playing < s.maxPlayers then
                                    local ping = tonumber(s.ping)
                                    if ping and ping > 0 then
                                        if ping < lowestPing then
                                            lowestPing = ping
                                            bestServer = s
                                        end
                                    end
                                end
                            end

                            if not bestServer then
                                local highestFps = 0
                                for _, s in ipairs(servers) do
                                    if s.id ~= game.JobId and type(s.playing) == "number" and s.playing > 0 and s.playing < s.maxPlayers then
                                        local fps = tonumber(s.fps) or 60
                                        if fps > highestFps then
                                            highestFps = fps
                                            bestServer = s
                                        end
                                    end
                                end
                            end
                        end

                        if bestServer then
                            local pingInfo = (lowestPing ~= math.huge) and (tostring(math.floor(lowestPing)) .. "ms ping") or "optimal connection"
                            NotifyCompat("Found server: " .. pingInfo .. " (" .. tostring(bestServer.playing) .. "/" .. tostring(bestServer.maxPlayers) .. " plrs). Teleporting...", 4)
                            task.wait(0.5)
                            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, bestServer.id, game:GetService("Players").LocalPlayer)
                        else
                            NotifyCompat("Failed to find lowest ping server!", 3)
                        end
                    end)
                end
            })
        end
    end
end

getgenv().Library = Library
return Library
