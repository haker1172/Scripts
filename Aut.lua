local player = game:GetService("Players").LocalPlayer
local character = player.Character
local RP = character.HumanoidRootPart
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")
local gui = Instance.new("ScreenGui")
local UIS = game:GetService("UserInputService")


local items = {}

local queue = {}

gui.Name = "MenuGui"
gui.Parent = coreGui



local menu = Instance.new("Frame")
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.05)
menuCorner.Parent = menu
menu.Size = UDim2.new(0, 400, 0, 250)
menu.Position = UDim2.new(0.75, 0, 0.05, 0)
menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menu.Name = "menu"

local page1 = Instance.new("Frame")
local page1Corner = Instance.new("UICorner")
page1Corner.CornerRadius = UDim.new(0.05)
page1Corner.Parent = page1
page1.Size = UDim2.new(1, 0, 1, 0)
page1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local itemNotificationBtn = Instance.new("TextButton")
itemNotificationBtn.Text = ""
itemNotificationBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
itemNotificationBtn.BackgroundTransparency = 1
itemNotificationBtn.Size = UDim2.new(0, 205, 0, 20)
itemNotificationBtn.Position = UDim2.new(0, 20, 0, 20)
itemNotificationBtn.Name = "Item notification button"


local itemNotificationLbl = Instance.new("TextLabel")
itemNotificationLbl.Font = Enum.Font.ArialBold
itemNotificationLbl.TextSize = 19
itemNotificationLbl.Text = "Item notification"
itemNotificationLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
itemNotificationLbl.Position = UDim2.new(0, 70, 0, 10)
itemNotificationLbl.Name = "Item notification"


local itemNotificationToggleBack = Instance.new("Frame")
local itemNotificationToggleBackCorner = Instance.new("UICorner")
itemNotificationToggleBackCorner.CornerRadius = UDim.new(1)
itemNotificationToggleBackCorner.Parent = itemNotificationToggleBack
itemNotificationToggleBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
itemNotificationToggleBack.Size = UDim2.new(0, 52, 0, 19.5)
itemNotificationToggleBack.Position = itemNotificationLbl.Position - UDim2.new(0, -80, 0 , 9)
itemNotificationToggleBack.Name = "Toggle back"


local itemNotificationToggle = Instance.new("Frame")
local itemNotificationToggleValue = Instance.new("BoolValue")
itemNotificationToggleValue.Parent = itemNotificationToggle
local itemNotificationToggleCorner = Instance.new("UICorner")
itemNotificationToggleCorner.CornerRadius = UDim.new(1)
itemNotificationToggleCorner.Parent = itemNotificationToggle
itemNotificationToggle.Size = UDim2.new(0, 14, 0, 14)
itemNotificationToggle.Position = UDim2.new(0, 8, 0, 2.7)
itemNotificationToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
itemNotificationToggle.Name = "Toggle"




menu.Parent = gui
page1.Parent = menu
itemNotificationBtn.Parent = page1
itemNotificationLbl.Parent = itemNotificationBtn
itemNotificationToggleBack.Parent = itemNotificationBtn
itemNotificationToggle.Parent = itemNotificationToggleBack



UIS.InputBegan:Connect(function(input, isTyping)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if not isTyping then
            menu.Visible = not menu.Visible
        end
    end
end)



local function addTeleportMenu(item)
    local frame = Instance.new("Frame")
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.05)
    frame.Size = UDim2.new(0, 330, 0, 150)
    frame.Position = UDim2.new(1.1, 0, 0.8, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Position = UDim2.new(0.5, 0, 0, 40)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.ArialBold
    textLabel.TextSize = 20
    textLabel.Text = ("New item has spawned - "..item.Name)

    local teleportButton = Instance.new("TextButton")
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.4)
    teleportButton.BackgroundColor3 = Color3.fromRGB(50, 200, 0)
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.BorderSizePixel = 0
    teleportButton.Font = Enum.Font.SourceSansBold
    teleportButton.Size = UDim2.new(0, 200, 0, 40)
    teleportButton.TextSize = 25
    teleportButton.Position = UDim2.new(0, 65, 0, 80)
    teleportButton.Text = "Teleport"
    
    local connection

    connection = teleportButton.MouseButton1Click:Connect(function()
        RP.CFrame = item.CFrame
        wait(0.2)
        fireproximityprompt(item.ProximityAttachment.Interaction, 20)
    end)

    frame.Parent = gui
    frameCorner.Parent = frame
    textLabel.Parent = frame
    teleportButton.Parent = frame
    buttonCorner.Parent = teleportButton

    tweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(0.8, 0, 0.8, 0)}):Play()
    wait(3)
    tweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(1.1, 0, 0.8, 0)}):Play()
    wait(1)
    connection:Disconnect()
    frame:Destroy()
end


local function addLabel(item) 
    local label = Instance.new("TextLabel")
    label.TextSize = 38
    label.Text = ("item is spawned - "..item.Name)
    label.Font = Enum.Font.ArialBold
    label.Position = UDim2.new(0.5, 0, 0, 100)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = gui
    tweenService:Create(label, TweenInfo.new(1.5), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()
    delay(2, function()
         tweenService:Create(label, TweenInfo.new(1), {Transparency = 1}):Play()
    end)
    wait(3.5)
    label:Destroy()
end


local function checkQueue()
    while true do
        if queue[1] then
            spawn(function()
                addLabel(queue[1])
            end)
            spawn(function()
                addTeleportMenu(queue[1])
            end)
            wait(4)
            table.remove(queue, 1)
        end
        wait()
    end
end



itemNotificationBtn.MouseButton1Click:Connect(function()
    for i, v in pairs(itemNotificationBtn:GetDescendants()) do
        if v.Name == "Toggle" then
            if v:FindFirstChild("Value") then
                v.Value.Value = not v.Value.Value
                if v.Value.Value then
                    tweenService:Create(v, TweenInfo.new(0.7), {Position = UDim2.new(0, 30, 0, 2.5), BackgroundColor3 = Color3.fromRGB(50, 200, 0)}):Play()
                else
                    tweenService:Create(v, TweenInfo.new(0.7), {Position = UDim2.new(0, 8, 0, 2.5), BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
                end
            end
        end
    end
end)


spawn(function()
    checkQueue()
end)



spawn(function()
    runService.Stepped:Connect(function()
        if itemNotificationToggleValue.Value then
            for i, spawnLocation in pairs(game.workspace.ItemSpawns.StandardItems:GetChildren()) do
                for v, newItem in pairs(spawnLocation:GetChildren()) do
                    local inTable = false
                    for j, oldItem in pairs(items) do
                        if oldItem == newItem then
                            inTable = true
                        end
                    end
                    if not inTable then
                        table.insert(items, newItem)
                        table.insert(queue, newItem)
                    end
                end
            end
        end
    end)
end)


