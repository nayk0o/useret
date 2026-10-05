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
LowServerFinder.ResetOnSpawn = false

--// Modern UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = LowServerFinder
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.Size = UDim2.new(0, 800, 0, 500)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 58, 75)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.15
MainStroke.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -30, 0, -30)
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.ZIndex = 0
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.55
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

--// Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(19, 20, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 190, 1, 0)
Sidebar.ZIndex = 2

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 18)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Parent = Sidebar
SidebarFix.BackgroundColor3 = Sidebar.BackgroundColor3
SidebarFix.BorderSizePixel = 0
SidebarFix.Position = UDim2.new(0.7, 0, 0, 0)
SidebarFix.Size = UDim2.new(0.3, 0, 1, 0)

local Logo = Instance.new("TextLabel")
Logo.Parent = Sidebar
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 22, 0, 24)
Logo.Size = UDim2.new(1, -44, 0, 35)
Logo.Font = Enum.Font.GothamBold
Logo.Text = "SERVER"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 20
Logo.TextXAlignment = Enum.TextXAlignment.Left

local LogoAccent = Instance.new("TextLabel")
LogoAccent.Parent = Sidebar
LogoAccent.BackgroundTransparency = 1
LogoAccent.Position = UDim2.new(0, 22, 0, 52)
LogoAccent.Size = UDim2.new(1, -44, 0, 25)
LogoAccent.Font = Enum.Font.GothamMedium
LogoAccent.Text = "FINDER"
LogoAccent.TextColor3 = Color3.fromRGB(120, 105, 255)
LogoAccent.TextSize = 14
LogoAccent.TextXAlignment = Enum.TextXAlignment.Left

local NavTitle = Instance.new("TextLabel")
NavTitle.Parent = Sidebar
NavTitle.BackgroundTransparency = 1
NavTitle.Position = UDim2.new(0, 22, 0, 112)
NavTitle.Size = UDim2.new(1, -44, 0, 20)
NavTitle.Font = Enum.Font.GothamBold
NavTitle.Text = "NAVIGATION"
NavTitle.TextColor3 = Color3.fromRGB(105, 108, 125)
NavTitle.TextSize = 10
NavTitle.TextXAlignment = Enum.TextXAlignment.Left

local NavButton = Instance.new("TextButton")
NavButton.Parent = Sidebar
NavButton.BackgroundColor3 = Color3.fromRGB(43, 40, 66)
NavButton.BorderSizePixel = 0
NavButton.Position = UDim2.new(0, 14, 0, 140)
NavButton.Size = UDim2.new(1, -28, 0, 44)
NavButton.Font = Enum.Font.GothamSemibold
NavButton.Text = "   ◈   Servers"
NavButton.TextColor3 = Color3.fromRGB(235, 233, 255)
NavButton.TextSize = 13
NavButton.TextXAlignment = Enum.TextXAlignment.Left
NavButton.AutoButtonColor = false

local NavCorner = Instance.new("UICorner")
NavCorner.CornerRadius = UDim.new(0, 10)
NavCorner.Parent = NavButton

local Status = Instance.new("TextLabel")
Status.Parent = Sidebar
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 22, 1, -55)
Status.Size = UDim2.new(1, -44, 0, 20)
Status.Font = Enum.Font.GothamMedium
Status.Text = "●  Online"
Status.TextColor3 = Color3.fromRGB(85, 220, 145)
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Left

--// Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0, 215, 0, 20)
Header.Size = UDim2.new(1, -235, 0, 65)
Header.ZIndex = 3

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -100, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Public Servers"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 0, 0, 31)
Subtitle.Size = UDim2.new(1, -100, 0, 22)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Find an available server and join instantly"
Subtitle.TextColor3 = Color3.fromRGB(125, 128, 145)
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Parent = Header
Close.BackgroundColor3 = Color3.fromRGB(35, 36, 47)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -40, 0, 0)
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(210, 212, 220)
Close.TextSize = 20
Close.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(185, 55, 75)}):Play()
end)
Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 36, 47)}):Play()
end)

--// Stats
local Stats = Instance.new("Frame")
Stats.Parent = MainFrame
Stats.BackgroundColor3 = Color3.fromRGB(22, 23, 32)
Stats.BorderSizePixel = 0
Stats.Position = UDim2.new(0, 215, 0, 92)
Stats.Size = UDim2.new(1, -235, 0, 55)
Stats.ZIndex = 3

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 12)
StatsCorner.Parent = Stats

local ServerCount = Instance.new("TextLabel")
ServerCount.Parent = Stats
ServerCount.BackgroundTransparency = 1
ServerCount.Position = UDim2.new(0, 16, 0, 7)
ServerCount.Size = UDim2.new(0.5, -16, 0, 20)
ServerCount.Font = Enum.Font.GothamBold
ServerCount.Text = "0 SERVERS"
ServerCount.TextColor3 = Color3.fromRGB(225, 225, 235)
ServerCount.TextSize = 12
ServerCount.TextXAlignment = Enum.TextXAlignment.Left

local ServerCountSub = Instance.new("TextLabel")
ServerCountSub.Parent = Stats
ServerCountSub.BackgroundTransparency = 1
ServerCountSub.Position = UDim2.new(0, 16, 0, 27)
ServerCountSub.Size = UDim2.new(0.5, -16, 0, 17)
ServerCountSub.Font = Enum.Font.Gotham
ServerCountSub.Text = "Available to join"
ServerCountSub.TextColor3 = Color3.fromRGB(105, 108, 125)
ServerCountSub.TextSize = 9
ServerCountSub.TextXAlignment = Enum.TextXAlignment.Left

local GameLabel = Instance.new("TextLabel")
GameLabel.Parent = Stats
GameLabel.BackgroundTransparency = 1
GameLabel.Position = UDim2.new(0.5, 0, 0, 0)
GameLabel.Size = UDim2.new(0.5, -15, 1, 0)
GameLabel.Font = Enum.Font.GothamMedium
GameLabel.Text = gameName
GameLabel.TextColor3 = Color3.fromRGB(120, 105, 255)
GameLabel.TextSize = 11
GameLabel.TextXAlignment = Enum.TextXAlignment.Right

--// Server list
local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Name = "ServerListFrame"
ServerListFrame.Parent = MainFrame
ServerListFrame.Active = true
ServerListFrame.BackgroundTransparency = 1
ServerListFrame.BorderSizePixel = 0
ServerListFrame.Position = UDim2.new(0, 215, 0, 162)
ServerListFrame.Size = UDim2.new(1, -235, 1, -180)
ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerListFrame.ScrollBarThickness = 3
ServerListFrame.ScrollBarImageColor3 = Color3.fromRGB(85, 82, 125)
ServerListFrame.ZIndex = 3

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ServerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local ServerFrameTemplate = Instance.new("Frame")
ServerFrameTemplate.Name = "ServerFrame"
ServerFrameTemplate.Parent = ServerListFrame
ServerFrameTemplate.BackgroundColor3 = Color3.fromRGB(23, 24, 33)
ServerFrameTemplate.BorderSizePixel = 0
ServerFrameTemplate.Size = UDim2.new(1, -5, 0, 68)
ServerFrameTemplate.Visible = false

local UICorner_Server = Instance.new("UICorner")
UICorner_Server.CornerRadius = UDim.new(0, 12)
UICorner_Server.Parent = ServerFrameTemplate

local ServerStroke = Instance.new("UIStroke")
ServerStroke.Color = Color3.fromRGB(43, 45, 58)
ServerStroke.Thickness = 1
ServerStroke.Transparency = 0.25
ServerStroke.Parent = ServerFrameTemplate

local ServerInfo = Instance.new("TextLabel")
ServerInfo.Name = "ServerInfo"
ServerInfo.Parent = ServerFrameTemplate
ServerInfo.BackgroundTransparency = 1
ServerInfo.Position = UDim2.new(0, 16, 0, 9)
ServerInfo.Size = UDim2.new(1, -145, 0, 48)
ServerInfo.Font = Enum.Font.GothamMedium
ServerInfo.Text = "Server"
ServerInfo.TextColor3 = Color3.fromRGB(225, 225, 232)
ServerInfo.TextSize = 11
ServerInfo.TextWrapped = true
ServerInfo.TextXAlignment = Enum.TextXAlignment.Left
ServerInfo.TextYAlignment = Enum.TextYAlignment.Center

local Join = Instance.new("TextButton")
Join.Name = "Join"
Join.Parent = ServerFrameTemplate
Join.BackgroundColor3 = Color3.fromRGB(106, 91, 230)
Join.BorderSizePixel = 0
Join.Position = UDim2.new(1, -115, 0.5, -20)
Join.Size = UDim2.new(0, 100, 0, 40)
Join.Font = Enum.Font.GothamBold
Join.Text = "JOIN  →"
Join.TextColor3 = Color3.fromRGB(255, 255, 255)
Join.TextSize = 11
Join.AutoButtonColor = false

local JoinCorner = Instance.new("UICorner")
JoinCorner.CornerRadius = UDim.new(0, 10)
JoinCorner.Parent = Join

Join.MouseEnter:Connect(function()
    TweenService:Create(Join, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(128, 112, 255)}):Play()
end)
Join.MouseLeave:Connect(function()
    TweenService:Create(Join, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(106, 91, 230)}):Play()
end)

--// Floating hide button
local HideShow = Instance.new("TextButton")
HideShow.Name = "HideShow"
HideShow.Parent = LowServerFinder
HideShow.BackgroundColor3 = Color3.fromRGB(106, 91, 230)
HideShow.BorderSizePixel = 0
HideShow.Position = UDim2.new(0, 18, 0.5, -22)
HideShow.Size = UDim2.new(0, 82, 0, 44)
HideShow.Font = Enum.Font.GothamBold
HideShow.Text = "HIDE"
HideShow.TextColor3 = Color3.fromRGB(255, 255, 255)
HideShow.TextSize = 11
HideShow.AutoButtonColor = false

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 12)
HideCorner.Parent = HideShow

local isHidden = false
HideShow.MouseButton1Click:Connect(function()
    if not isHidden then
        local tweenOut = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            MainFrame.Visible = false
            HideShow.Text = "SHOW"
            isHidden = true
        end)
    else
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
        HideShow.Text = "HIDE"
        isHidden = false
    end
end)

Close.MouseButton1Click:Connect(function()
    local tweenClose = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 760, 0, 470)
    })
    tweenClose:Play()
    tweenClose.Completed:Connect(function()
        LowServerFinder:Destroy()
    end)
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 8)
end)

local loadedServers = 0

local function createServerEntry(serverData)
    local clone = ServerFrameTemplate:Clone()
    clone.Name = "ServerFrameClone"
    clone.Visible = true
    clone.Parent = ServerListFrame

    local serverInfoLabel = clone:FindFirstChild("ServerInfo")
    serverInfoLabel.Text = string.format(
        "PUBLIC SERVER\n👥  %d / %d players     •     ID: %s",
        serverData.playing,
        serverData.maxPlayers,
        tostring(serverData.id):sub(1, 18)
    )

    local joinButton = clone:FindFirstChild("Join")
    joinButton.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer)
    end)

    loadedServers += 1
    ServerCount.Text = string.format("%d SERVERS", loadedServers)
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

--// Entrance animation
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 760, 0, 470)
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0,
    Size = UDim2.new(0, 800, 0, 500)
}):Play()

task.spawn(function()
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
)
MakeDraggable(HideShow)
```
