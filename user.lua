--// Server Finder - Modern UI
--// Paste this entire script directly into your executor.
--// The script itself does not call loadstring().

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Prevent duplicate UI
local oldGui = PlayerGui:FindFirstChild("LowServerFinder")
if oldGui then
    oldGui:Destroy()
end

--// HTTP request compatibility
local requestFunc
if typeof(syn) == "table" and typeof(syn.request) == "function" then
    requestFunc = syn.request
elseif typeof(http) == "table" and typeof(http.request) == "function" then
    requestFunc = http.request
elseif typeof(http_request) == "function" then
    requestFunc = http_request
elseif typeof(fluxus) == "table" and typeof(fluxus.request) == "function" then
    requestFunc = fluxus.request
elseif typeof(request) == "function" then
    requestFunc = request
end

if not requestFunc then
    warn("[ServerFinder] No supported HTTP request function found in this environment.")
end

--// Game information
local gameName = "Unknown Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

--// Helpers
local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function addCorner(parent, radius)
    return create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
end

local function addStroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = transparency or 0
    }, parent)
end

local function tween(object, time, properties, easingStyle, easingDirection)
    local info = TweenInfo.new(
        time or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
    return animation
end

local function makeDraggable(guiObject)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// Colors
local BG = Color3.fromRGB(13, 14, 19)
local PANEL = Color3.fromRGB(18, 19, 27)
local PANEL_2 = Color3.fromRGB(22, 23, 32)
local PANEL_3 = Color3.fromRGB(28, 29, 40)
local BORDER = Color3.fromRGB(45, 47, 61)
local TEXT = Color3.fromRGB(242, 243, 248)
local MUTED = Color3.fromRGB(125, 129, 147)
local ACCENT = Color3.fromRGB(113, 96, 240)
local ACCENT_HOVER = Color3.fromRGB(132, 115, 255)
local GREEN = Color3.fromRGB(75, 220, 145)
local RED = Color3.fromRGB(218, 70, 90)

--// Root
local ScreenGui = create("ScreenGui", {
    Name = "LowServerFinder",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

--// Main window
local MainFrame = create("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -410, 0.5, -270),
    Size = UDim2.new(0, 820, 0, 540)
}, ScreenGui)
addCorner(MainFrame, 18)
addStroke(MainFrame, BORDER, 1.5, 0.15)

--// Subtle top accent line
local AccentLine = create("Frame", {
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 18, 0, 0),
    Size = UDim2.new(1, -36, 0, 3),
    ZIndex = 5
}, MainFrame)
addCorner(AccentLine, 2)

--// Sidebar
local Sidebar = create("Frame", {
    Name = "Sidebar",
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 195, 1, 0),
    ZIndex = 2
}, MainFrame)
addCorner(Sidebar, 18)

local SidebarFill = create("Frame", {
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Position = UDim2.new(0.75, 0, 0, 0),
    Size = UDim2.new(0.25, 0, 1, 0),
    ZIndex = 2
}, Sidebar)

local Brand = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 22, 0, 24),
    Size = UDim2.new(1, -44, 0, 27),
    Font = Enum.Font.GothamBold,
    Text = "SERVER",
    TextColor3 = TEXT,
    TextSize = 19,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, Sidebar)

local BrandAccent = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 22, 0, 48),
    Size = UDim2.new(1, -44, 0, 22),
    Font = Enum.Font.GothamSemibold,
    Text = "FINDER",
    TextColor3 = ACCENT_HOVER,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, Sidebar)

local Divider = create("Frame", {
    BackgroundColor3 = BORDER,
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 22, 0, 86),
    Size = UDim2.new(1, -44, 0, 1),
    ZIndex = 3
}, Sidebar)

local NavLabel = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 22, 0, 110),
    Size = UDim2.new(1, -44, 0, 18),
    Font = Enum.Font.GothamBold,
    Text = "NAVIGATION",
    TextColor3 = MUTED,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, Sidebar)

local ServersNav = create("TextButton", {
    BackgroundColor3 = Color3.fromRGB(45, 42, 71),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 13, 0, 137),
    Size = UDim2.new(1, -26, 0, 45),
    Font = Enum.Font.GothamSemibold,
    Text = "   ◈   Servers",
    TextColor3 = Color3.fromRGB(239, 237, 255),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    AutoButtonColor = false,
    ZIndex = 3
}, Sidebar)
addCorner(ServersNav, 10)

local NavBar = create("Frame", {
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 13, 0, 143),
    Size = UDim2.new(0, 3, 0, 33),
    ZIndex = 4
}, Sidebar)
addCorner(NavBar, 2)

local StatusDot = create("Frame", {
    BackgroundColor3 = GREEN,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 22, 1, -49),
    Size = UDim2.new(0, 8, 0, 8),
    ZIndex = 3
}, Sidebar)
addCorner(StatusDot, 8)

local StatusLabel = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 38, 1, -55),
    Size = UDim2.new(1, -60, 0, 20),
    Font = Enum.Font.GothamMedium,
    Text = "System ready",
    TextColor3 = Color3.fromRGB(160, 210, 185),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, Sidebar)

--// Header
local Header = create("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 220, 0, 20),
    Size = UDim2.new(1, -240, 0, 62),
    ZIndex = 3
}, MainFrame)

local Title = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, -115, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = "Public Servers",
    TextColor3 = TEXT,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Header)

local Subtitle = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 31),
    Size = UDim2.new(1, -115, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Browse available servers and join with one click",
    TextColor3 = MUTED,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Header)

local Refresh = create("TextButton", {
    BackgroundColor3 = PANEL_3,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -86, 0, 0),
    Size = UDim2.new(0, 42, 0, 38),
    Font = Enum.Font.GothamBold,
    Text = "↻",
    TextColor3 = TEXT,
    TextSize = 20,
    AutoButtonColor = false,
    ZIndex = 4
}, Header)
addCorner(Refresh, 10)
addStroke(Refresh, BORDER, 1, 0.25)

local Close = create("TextButton", {
    BackgroundColor3 = PANEL_3,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -40, 0, 0),
    Size = UDim2.new(0, 38, 0, 38),
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = TEXT,
    TextSize = 20,
    AutoButtonColor = false,
    ZIndex = 4
}, Header)
addCorner(Close, 10)
addStroke(Close, BORDER, 1, 0.25)

--// Stats bar
local Stats = create("Frame", {
    BackgroundColor3 = PANEL_2,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 220, 0, 96),
    Size = UDim2.new(1, -240, 0, 58),
    ZIndex = 3
}, MainFrame)
addCorner(Stats, 12)
addStroke(Stats, BORDER, 1, 0.35)

local ServerCount = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 16, 0, 6),
    Size = UDim2.new(0.5, -16, 0, 21),
    Font = Enum.Font.GothamBold,
    Text = "0 SERVERS",
    TextColor3 = TEXT,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Stats)

local ServerCountSub = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 16, 0, 28),
    Size = UDim2.new(0.5, -16, 0, 17),
    Font = Enum.Font.Gotham,
    Text = "Available to join",
    TextColor3 = MUTED,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, Stats)

local GameLabel = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 0, 0),
    Size = UDim2.new(0.5, -17, 1, 0),
    Font = Enum.Font.GothamSemibold,
    Text = gameName,
    TextColor3 = ACCENT_HOVER,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 4
}, Stats)

--// Loading state
local Loading = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 220, 0, 173),
    Size = UDim2.new(1, -240, 0, 35),
    Font = Enum.Font.GothamMedium,
    Text = "Scanning public servers...",
    TextColor3 = MUTED,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4
}, MainFrame)

--// Server list
local ServerListFrame = create("ScrollingFrame", {
    Name = "ServerListFrame",
    Active = true,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 220, 0, 168),
    Size = UDim2.new(1, -240, 1, -190),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(91, 83, 145),
    ZIndex = 3
}, MainFrame)

local UIListLayout = create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
}, ServerListFrame)

local UIPadding = create("UIPadding", {
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 8)
}, ServerListFrame)

local ServerTemplate = create("Frame", {
    Name = "ServerTemplate",
    BackgroundColor3 = PANEL_2,
    BorderSizePixel = 0,
    Size = UDim2.new(1, -5, 0, 74),
    Visible = false,
    ZIndex = 4
}, ServerListFrame)
addCorner(ServerTemplate, 12)
addStroke(ServerTemplate, BORDER, 1, 0.35)

local ServerIndicator = create("Frame", {
    BackgroundColor3 = GREEN,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 14, 0.5, -18),
    Size = UDim2.new(0, 4, 0, 36),
    ZIndex = 5
}, ServerTemplate)
addCorner(ServerIndicator, 3)

local ServerInfo = create("TextLabel", {
    Name = "ServerInfo",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 29, 0, 10),
    Size = UDim2.new(1, -160, 0, 54),
    Font = Enum.Font.GothamMedium,
    Text = "PUBLIC SERVER",
    TextColor3 = TEXT,
    TextSize = 10,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    ZIndex = 5
}, ServerTemplate)

local Join = create("TextButton", {
    Name = "Join",
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -116, 0.5, -20),
    Size = UDim2.new(0, 101, 0, 40),
    Font = Enum.Font.GothamBold,
    Text = "JOIN  →",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 10,
    AutoButtonColor = false,
    ZIndex = 5
}, ServerTemplate)
addCorner(Join, 10)

--// Floating toggle
local HideShow = create("TextButton", {
    Name = "HideShow",
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 18, 0.5, -22),
    Size = UDim2.new(0, 85, 0, 44),
    Font = Enum.Font.GothamBold,
    Text = "HIDE",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 10,
    AutoButtonColor = false,
    ZIndex = 10
}, ScreenGui)
addCorner(HideShow, 12)
addStroke(HideShow, Color3.fromRGB(154, 143, 255), 1, 0.5)

--// Hover effects
Refresh.MouseEnter:Connect(function()
    tween(Refresh, 0.15, {BackgroundColor3 = Color3.fromRGB(39, 40, 55)})
end)
Refresh.MouseLeave:Connect(function()
    tween(Refresh, 0.15, {BackgroundColor3 = PANEL_3})
end)

Close.MouseEnter:Connect(function()
    tween(Close, 0.15, {BackgroundColor3 = RED})
end)
Close.MouseLeave:Connect(function()
    tween(Close, 0.15, {BackgroundColor3 = PANEL_3})
end)

HideShow.MouseEnter:Connect(function()
    tween(HideShow, 0.15, {BackgroundColor3 = ACCENT_HOVER})
end)
HideShow.MouseLeave:Connect(function()
    tween(HideShow, 0.15, {BackgroundColor3 = ACCENT})
end)

--// State
local isHidden = false
local isBusy = false
local loadedServers = 0

local function clearServers()
    for _, child in ipairs(ServerListFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name == "ServerFrameClone" then
            child:Destroy()
        end
    end
    loadedServers = 0
    ServerCount.Text = "0 SERVERS"
end

local function createServerEntry(serverData)
    local clone = ServerTemplate:Clone()
    clone.Name = "ServerFrameClone"
    clone.Visible = true
    clone.LayoutOrder = loadedServers + 1
    clone.Parent = ServerListFrame

    local infoLabel = clone:FindFirstChild("ServerInfo")
    if infoLabel then
        infoLabel.Text = string.format(
            "PUBLIC SERVER\nPlayers: %d / %d    •    ID: %s",
            tonumber(serverData.playing) or 0,
            tonumber(serverData.maxPlayers) or 0,
            tostring(serverData.id):sub(1, 20)
        )
    end

    local joinButton = clone:FindFirstChild("Join")
    if joinButton then
        joinButton.MouseEnter:Connect(function()
            tween(joinButton, 0.12, {BackgroundColor3 = ACCENT_HOVER})
        end)
        joinButton.MouseLeave:Connect(function()
            tween(joinButton, 0.12, {BackgroundColor3 = ACCENT})
        end)
        joinButton.MouseButton1Click:Connect(function()
            if isBusy then
                return
            end
            isBusy = true
            joinButton.Text = "JOINING..."
            tween(joinButton, 0.12, {BackgroundColor3 = Color3.fromRGB(80, 72, 165)})

            local ok, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer)
            end)

            if not ok then
                warn("[ServerFinder] Teleport failed:", err)
                isBusy = false
                joinButton.Text = "JOIN  →"
                tween(joinButton, 0.12, {BackgroundColor3 = ACCENT})
            end
        end)
    end

    loadedServers += 1
    ServerCount.Text = string.format("%d SERVERS", loadedServers)

    clone.BackgroundTransparency = 1
    tween(clone, 0.2, {BackgroundTransparency = 0})
end

local function fetchServers(cursor)
    if not requestFunc then
        return nil, "No HTTP request function is available."
    end

    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        game.PlaceId
    )

    if cursor then
        url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
    end

    local ok, response = pcall(function()
        return requestFunc({
            Url = url,
            Method = "GET",
            Headers = {
                ["Accept"] = "application/json"
            }
        })
    end)

    if not ok then
        return nil, tostring(response)
    end

    if not response or not response.Body then
        return nil, "Empty HTTP response."
    end

    local decodeOk, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not decodeOk then
        return nil, "Invalid JSON response."
    end

    return data
end

local function loadServers()
    if isBusy then
        return
    end

    isBusy = true
    clearServers()
    Loading.Text = "Scanning public servers..."
    Loading.TextColor3 = MUTED
    StatusLabel.Text = "Scanning servers..."

    local servers = {}
    local cursor = nil
    local success = true
    local errorMessage
    local pages = 0

    repeat
        pages += 1
        local data, err = fetchServers(cursor)
        if data and data.data then
            for _, server in ipairs(data.data) do
                if tonumber(server.playing) and tonumber(server.maxPlayers)
                    and server.playing < server.maxPlayers then
                    table.insert(servers, server)
                end
            end
            cursor = data.nextPageCursor
        else
            success = false
            errorMessage = err or "Unable to load servers."
            cursor = nil
        end

        if pages >= 10 then
            break
        end
    until not cursor

    table.sort(servers, function(a, b)
        return (a.playing or 0) < (b.playing or 0)
    end)

    for _, server in ipairs(servers) do
        createServerEntry(server)
    end

    if success then
        Loading.Text = loadedServers > 0 and "Select a server to join." or "No available server found."
        Loading.TextColor3 = loadedServers > 0 and MUTED or Color3.fromRGB(220, 175, 95)
        StatusLabel.Text = loadedServers > 0 and "System ready" or "No servers found"
    else
        Loading.Text = "Error: " .. tostring(errorMessage)
        Loading.TextColor3 = Color3.fromRGB(225, 120, 130)
        StatusLabel.Text = "Request failed"
        warn("[ServerFinder] " .. tostring(errorMessage))
    end

    isBusy = false
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerListFrame.CanvasSize = UDim2.new(
        0,
        0,
        0,
        UIListLayout.AbsoluteContentSize.Y + 10
    )
end)

Refresh.MouseButton1Click:Connect(function()
    if isBusy then
        return
    end
    tween(Refresh, 0.3, {Rotation = Refresh.Rotation + 180})
    task.spawn(loadServers)
end)

Close.MouseButton1Click:Connect(function()
    if isHidden then
        return
    end

    local closeTween = tween(MainFrame, 0.22, {
        Size = UDim2.new(0, 760, 0, 500),
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Back, Enum.EasingDirection.In)

    closeTween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

HideShow.MouseButton1Click:Connect(function()
    if isHidden then
        isHidden = false
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 1
        MainFrame.Size = UDim2.new(0, 780, 0, 510)
        HideShow.Text = "HIDE"
        tween(MainFrame, 0.25, {
            Size = UDim2.new(0, 820, 0, 540),
            BackgroundTransparency = 0
        })
    else
        isHidden = true
        local hideTween = tween(MainFrame, 0.22, {
            Size = UDim2.new(0, 780, 0, 510),
            BackgroundTransparency = 1
        })
        hideTween.Completed:Connect(function()
            MainFrame.Visible = false
            HideShow.Text = "SHOW"
        end)
    end
end)

makeDraggable(MainFrame)
makeDraggable(HideShow)

--// Entrance animation
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 780, 0, 510)
tween(MainFrame, 0.32, {
    Size = UDim2.new(0, 820, 0, 540),
    BackgroundTransparency = 0
}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

--// Initial server scan
task.spawn(loadServers)
