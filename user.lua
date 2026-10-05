local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local requestFunc = nil
if syn and syn.request then
    requestFunc = syn.request
elseif http and http.request then
    requestFunc = http.request
elseif http_request then
    requestFunc = http_request
elseif fluxus and fluxus.request then
    requestFunc = fluxus.request
elseif request then
    requestFunc = request
else
    error("No supported HTTP request function found! 😢")
end
local gameName = "Unknown"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    gameName = info.Name or gameName
end)
local function MakeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
        end
    end)
end

local LowServerFinder = Instance.new("ScreenGui")
LowServerFinder.Name = "LowServerFinder"
LowServerFinder.Parent = LocalPlayer:WaitForChild("PlayerGui")
LowServerFinder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = LowServerFinder
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -225)
MainFrame.Size = UDim2.new(0, 750, 0, 450)

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 16)
UICorner_Main.Parent = MainFrame

local MainFrameGradient = Instance.new("UIGradient")
MainFrameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 30, 40)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(21, 22, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 16, 22))
})
MainFrameGradient.Rotation = 90
MainFrameGradient.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Thickness = 1.5
MainFrameStroke.Color = Color3.fromRGB(75, 77, 95)
MainFrameStroke.Transparency = 0.18
MainFrameStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 25, 34)
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.new(0, 10, 0, 10)
TopBar.Size = UDim2.new(1, -20, 0, 58)

local UICorner_TopBar = Instance.new("UICorner")
UICorner_TopBar.CornerRadius = UDim.new(0, 12)
UICorner_TopBar.Parent = TopBar

local Accent = Instance.new("Frame")
Accent.Parent = TopBar
Accent.BackgroundColor3 = Color3.fromRGB(99, 91, 255)
Accent.BorderSizePixel = 0
Accent.Position = UDim2.new(0, 13, 0.5, -15)
Accent.Size = UDim2.new(0, 4, 0, 30)

local AccentCorner = Instance.new("UICorner")
AccentCorner.CornerRadius = UDim.new(1, 0)
AccentCorner.Parent = Accent

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 29, 0, 7)
Title.Size = UDim2.new(1, -100, 0, 26)
Title.Font = Enum.Font.GothamBold
Title.Text = "Server Finder"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = TopBar
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 29, 0, 32)
Subtitle.Size = UDim2.new(1, -100, 0, 17)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Public servers • Low player count first"
Subtitle.TextColor3 = Color3.fromRGB(130, 133, 150)
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Parent = TopBar
Close.BackgroundColor3 = Color3.fromRGB(38, 39, 50)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -47, 0.5, -17)
Close.Size = UDim2.new(0, 34, 0, 34)
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 221, 230)
Close.TextSize = 20
Close.AutoButtonColor = true

local UICorner_Close = Instance.new("UICorner")
UICorner_Close.CornerRadius = UDim.new(0, 9)
UICorner_Close.Parent = Close

local InfoBar = Instance.new("Frame")
InfoBar.Name = "InfoBar"
InfoBar.Parent = MainFrame
InfoBar.BackgroundColor3 = Color3.fromRGB(21, 22, 30)
InfoBar.BorderSizePixel = 0
InfoBar.Position = UDim2.new(0, 10, 0, 78)
InfoBar.Size = UDim2.new(1, -20, 0, 42)

local UICorner_InfoBar = Instance.new("UICorner")
UICorner_InfoBar.CornerRadius = UDim.new(0, 10)
UICorner_InfoBar.Parent = InfoBar

local GameDot = Instance.new("Frame")
GameDot.Parent = InfoBar
GameDot.BackgroundColor3 = Color3.fromRGB(76, 220, 139)
GameDot.BorderSizePixel = 0
GameDot.Position = UDim2.new(0, 14, 0.5, -4)
GameDot.Size = UDim2.new(0, 8, 0, 8)

local GameDotCorner = Instance.new("UICorner")
GameDotCorner.CornerRadius = UDim.new(1, 0)
GameDotCorner.Parent = GameDot

local GameLabel = Instance.new("TextLabel")
GameLabel.Parent = InfoBar
GameLabel.BackgroundTransparency = 1
GameLabel.Position = UDim2.new(0, 30, 0, 0)
GameLabel.Size = UDim2.new(0.7, -30, 1, 0)
GameLabel.Font = Enum.Font.GothamSemibold
GameLabel.Text = gameName
GameLabel.TextColor3 = Color3.fromRGB(225, 226, 235)
GameLabel.TextSize = 11
GameLabel.TextTruncate = Enum.TextTruncate.AtEnd
GameLabel.TextXAlignment = Enum.TextXAlignment.Left

local GameId = Instance.new("TextLabel")
GameId.Parent = InfoBar
GameId.BackgroundTransparency = 1
GameId.Position = UDim2.new(0.7, 0, 0, 0)
GameId.Size = UDim2.new(0.3, -15, 1, 0)
GameId.Font = Enum.Font.Gotham
GameId.Text = "PLACE ID  " .. tostring(game.PlaceId)
GameId.TextColor3 = Color3.fromRGB(112, 115, 132)
GameId.TextSize = 9
GameId.TextXAlignment = Enum.TextXAlignment.Right

local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Name = "ServerListFrame"
ServerListFrame.Parent = MainFrame
ServerListFrame.Active = true
ServerListFrame.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
ServerListFrame.BorderSizePixel = 0
ServerListFrame.Position = UDim2.new(0, 10, 0, 130)
ServerListFrame.Size = UDim2.new(1, -20, 0, 270)
ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerListFrame.ScrollBarThickness = 3
ServerListFrame.ScrollBarImageColor3 = Color3.fromRGB(94, 88, 220)

local UICorner_List = Instance.new("UICorner")
UICorner_List.CornerRadius = UDim.new(0, 12)
UICorner_List.Parent = ServerListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ServerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)

local ServerFrameTemplate = Instance.new("Frame")
ServerFrameTemplate.Name = "ServerFrame"
ServerFrameTemplate.Parent = ServerListFrame
ServerFrameTemplate.BackgroundColor3 = Color3.fromRGB(27, 28, 37)
ServerFrameTemplate.BorderSizePixel = 0
ServerFrameTemplate.Size = UDim2.new(1, -8, 0, 54)
ServerFrameTemplate.Visible = false

local UICorner_Server = Instance.new("UICorner")
UICorner_Server.CornerRadius = UDim.new(0, 10)
UICorner_Server.Parent = ServerFrameTemplate

local ServerStroke = Instance.new("UIStroke")
ServerStroke.Thickness = 1
ServerStroke.Color = Color3.fromRGB(53, 55, 70)
ServerStroke.Transparency = 0.25
ServerStroke.Parent = ServerFrameTemplate

local ServerIndicator = Instance.new("Frame")
ServerIndicator.Parent = ServerFrameTemplate
ServerIndicator.BackgroundColor3 = Color3.fromRGB(88, 205, 140)
ServerIndicator.BorderSizePixel = 0
ServerIndicator.Position = UDim2.new(0, 11, 0.5, -7)
ServerIndicator.Size = UDim2.new(0, 4, 0, 14)

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1, 0)
IndicatorCorner.Parent = ServerIndicator

local ServerInfo = Instance.new("TextLabel")
ServerInfo.Name = "ServerInfo"
ServerInfo.Parent = ServerFrameTemplate
ServerInfo.BackgroundTransparency = 1
ServerInfo.Position = UDim2.new(0, 25, 0, 0)
ServerInfo.Size = UDim2.new(0.76, 0, 1, 0)
ServerInfo.Font = Enum.Font.GothamMedium
ServerInfo.Text = string.format("Server: %s | gameId: %s (ServerId: %s)
👥 %d / %d", gameName, tostring(game.PlaceId), "N/A", 0, 0)
ServerInfo.TextColor3 = Color3.fromRGB(231, 232, 239)
ServerInfo.TextSize = 10
ServerInfo.TextWrapped = true
ServerInfo.TextXAlignment = Enum.TextXAlignment.Left
ServerInfo.TextYAlignment = Enum.TextYAlignment.Center

local Join = Instance.new("TextButton")
Join.Name = "Join"
Join.Parent = ServerFrameTemplate
Join.BackgroundColor3 = Color3.fromRGB(93, 84, 220)
Join.BorderSizePixel = 0
Join.Position = UDim2.new(1, -106, 0.5, -18)
Join.Size = UDim2.new(0, 94, 0, 36)
Join.Font = Enum.Font.GothamBold
Join.Text = "JOIN  →"
Join.TextColor3 = Color3.fromRGB(255, 255, 255)
Join.TextSize = 10
Join.AutoButtonColor = true

local UICorner_Join = Instance.new("UICorner")
UICorner_Join.CornerRadius = UDim.new(0, 9)
UICorner_Join.Parent = Join

local JoinGradient = Instance.new("UIGradient")
JoinGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 99, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(78, 70, 190))
})
JoinGradient.Rotation = 90
JoinGradient.Parent = Join

local BottomHint = Instance.new("TextLabel")
BottomHint.Parent = MainFrame
BottomHint.BackgroundTransparency = 1
BottomHint.Position = UDim2.new(0, 15, 1, -32)
BottomHint.Size = UDim2.new(1, -30, 0, 18)
BottomHint.Font = Enum.Font.Gotham
BottomHint.Text = "Drag the window to move it"
BottomHint.TextColor3 = Color3.fromRGB(91, 94, 109)
BottomHint.TextSize = 9
BottomHint.TextXAlignment = Enum.TextXAlignment.Center

local HideShow = Instance.new("TextButton")
HideShow.Name = "HideShow"
HideShow.Parent = LowServerFinder
HideShow.BackgroundColor3 = Color3.fromRGB(31, 32, 42)
HideShow.BorderSizePixel = 0
HideShow.Position = UDim2.new(0, 15, 0.46565, 0)
HideShow.Size = UDim2.new(0, 72, 0, 38)
HideShow.Font = Enum.Font.GothamBold
HideShow.Text = "HIDE"
HideShow.TextColor3 = Color3.fromRGB(232, 233, 240)
HideShow.TextSize = 10
HideShow.AutoButtonColor = true

local UICorner_HideShow = Instance.new("UICorner")
UICorner_HideShow.CornerRadius = UDim.new(0, 10)
UICorner_HideShow.Parent = HideShow

local HideShowStroke = Instance.new("UIStroke")
HideShowStroke.Thickness = 1
HideShowStroke.Color = Color3.fromRGB(75, 76, 95)
HideShowStroke.Transparency = 0.15
HideShowStroke.Parent = HideShow

local HideShowGradient = Instance.new("UIGradient")
HideShowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 46, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 29, 38))
})
HideShowGradient.Rotation = 90
HideShowGradient.Parent = HideShow

local isHidden = false
HideShow.MouseButton1Click:Connect(function()
    if not isHidden then
        local tweenOut = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            MainFrame.Visible = false
            HideShow.Text = "Show"
            isHidden = true
        end)
    else
        MainFrame.Visible = true
        local tweenIn = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        tweenIn:Play()
        HideShow.Text = "Hide"
        isHidden = false
    end
end)

Close.MouseButton1Click:Connect(function()
    local tweenClose = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    tweenClose:Play()
    tweenClose.Completed:Connect(function()
        LowServerFinder:Destroy()
    end)
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)
local function createServerEntry(serverData)
    local clone = ServerFrameTemplate:Clone()
    clone.Name = "ServerFrameClone"
    clone.Visible = true
    clone.Parent = ServerListFrame

    local serverInfoLabel = clone:FindFirstChild("ServerInfo")
    serverInfoLabel.Text = string.format("Server: %s | gameId: %s (ServerId: %s)
👥 %d / %d",
        gameName, tostring(game.PlaceId), tostring(serverData.id), serverData.playing, serverData.maxPlayers)
    local joinButton = clone:FindFirstChild("Join")
    joinButton.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer)
    end)
end
local function fetchServers(cursor)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    local response = requestFunc({
        Url = url,
        Method = "GET"
    })
    if response and response.Body then
        return HttpService:JSONDecode(response.Body)
    end
end
spawn(function()
    local servers = {}
    local cursor = nil
    repeat
        local data = fetchServers(cursor)
        if data and data.data then
            for _, server in ipairs(data.data) do
                table.insert(servers, server)
            end
            cursor = data.nextPageCursor
        else
            break
        end
    until not cursor

    table.sort(servers, function(a, b)
        return a.playing < b.playing
    end)
    for _, server in ipairs(servers) do
        if server.playing < server.maxPlayers then
            createServerEntry(server)
        end
    end
end)

MakeDraggable(MainFrame)
MakeDraggable(HideShow)
