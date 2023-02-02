local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local isJump = false

local items = {}

local queue = {}

local farmItems = {}
local farmChest = {}
local farmDebris = {}

local godmodeIsOn = false

_G.Spead = 90
_G.Jump = 140

local Library = {}
local Window = {}
local Tab = {}
local createdTabBtns = {}
local createdTabs = {}

local mainTabIsCreated = false

function Draggify(frame)
	local UserInputService = game:GetService("UserInputService")
	local runService = (game:GetService("RunService"));

	local dragging
	local dragInput
	local dragStart
	local startPos

	function Lerp(a, b, m)
		return a + (b - a) * m
	end;

	local lastMousePos
	local lastGoalPos
	local DRAG_SPEED = (16); -- // The speed of the UI darg.
	local function Update(dt)
		if not (startPos) then return end;
		if (ColorPicking) then return end;
		if not (dragging) and (lastGoalPos) then
			frame.Position = UDim2.new(startPos.X.Scale, Lerp(frame.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(frame.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
			return 
		end;

		local delta = (lastMousePos - UserInputService:GetMouseLocation())
		local xGoal = (startPos.X.Offset - delta.X);
		local yGoal = (startPos.Y.Offset - delta.Y);
		lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
		frame.Position = UDim2.new(startPos.X.Scale, Lerp(frame.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(frame.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
	end;

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			lastMousePos = UserInputService:GetMouseLocation()

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	runService.Heartbeat:Connect(Update)
end


function Library:CreateWindow(config)
    gui = Instance.new("ScreenGui")
    gui.Name = "MenuGui"
    gui.Parent = coreGui
    menu = Instance.new("Frame")
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0.05)
    menuCorner.Parent = menu
    menu.Size = UDim2.new(0, 600, 0, 350)
    menu.Position = UDim2.new(0.35, 0, 0.35, 0)
    menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    menu.Name = "Menu"

    Draggify(menu)

    mainFrame = Instance.new("Frame")

    local between = Instance.new("Frame")
    between.Position = UDim2.new(0, -60, 0, 175)
    between.Rotation = 90
    between.Size = UDim2.new(0, 347)
    between.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    between.BorderColor3 = Color3.fromRGB(85, 85, 85)
    between.BorderSizePixel = 1
    between.Name = "Between"
    tabList = Instance.new("Frame")
    tabList.Size = UDim2.new(0, 113, 0, 450)
    tabList.BorderSizePixel = 0
    tabList.BackgroundTransparency = 1
    tabList.Name = "TabList"
    between.Parent = menu
    tabList.Parent = menu
    menu.Parent = gui

    UIS.InputBegan:Connect(function(input, isTyping)
        if input.KeyCode == config.HideButton then
            if not isTyping then
                menu.Visible = not menu.Visible
            end
        end
    end)
end

function Window:CreateTitle(config)
    local border = Instance.new("Frame")
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0.4)
    borderCorner.Parent = border
    border.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    border.Position = UDim2.new(0, 0, -0.19, 0)
    border.Size = UDim2.new(0, 600, 0, 55)
    border.Name = "BorderTitle"
    border.Parent = menu

    local frame = Instance.new("Frame")
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.4)
    frameCorner.Parent = frame
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Position = UDim2.new(0, 4.5, 0, 3)
    frame.Size = UDim2.new(0.987, 0, 0.9, 0)
    frame.Name = "FrameTitle"
    frame.Parent = border

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.Font = Enum.Font.ArialBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 20
    label.Text = config.Text
    label.Name = "Title"
    label.Parent = frame
end


function Window:CreateTab(config)  
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBtn.BorderSizePixel = 0
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = config.Text or "Text Button"
    tabBtn.Name = config.Name or config.Text or "Text Button"
    tabBtn.Font = Enum.Font.ArialBold
    tabBtn.TextSize = 19

    local tab = Instance.new("Frame")
    tab.Size = UDim2.new(0, 485, 0, 450)
    tab.Position = UDim2.new(0, 115, 0, 0)
    tab.BackgroundTransparency = 1
    tab.BorderSizePixel = 0
    tab.Name = config.Name

    table.insert(createdTabBtns, tabBtn)
    createdTabs[config.Name] = {["Tab"] = tab, ["CreatedElements"] = 0}

    if #createdTabBtns == 1 then
        tabBtn.Position = UDim2.new(0, 0, 0, 15)
    else
        tabBtn.Position = UDim2.new(0, 0, 0, 40 * #createdTabBtns - 22)
    end

    if not config.IsMainTab then
        tab.Visible = false
    elseif config.IsMainTab and not mainTabIsCreated then
        mainTabIsCreated = true
        tab.Visible = true
        tabBtn.BackgroundTransparency = 0
    else
        error("Main tab already created!")
    end
    tabBtn.MouseButton1Click:Connect(function()
        for i, v in pairs(createdTabBtns) do
            if v ~= tabBtn then
                v.BackgroundTransparency = 1
            else 
                v.BackgroundTransparency = 0
            end
        end

        for i, v in pairs(createdTabs) do
            if v.Tab ~= tab then
                v.Tab.Visible = false
            else
                v.Tab.Visible = true
            end
        end
    end)

    
    tabBtn.Parent = tabList
    tab.Parent = menu

    return tab
end

function Tab:CreateToggle(config)
    local state = config.State or false
    createdTabs[config.Tab.Name].CreatedElements = createdTabs[config.Tab.Name].CreatedElements + 1

    local border = Instance.new("Frame")
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0.4)
    border.Size = UDim2.new(0.9, 0, 0, 38)
    border.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    borderCorner.Parent = border

    if createdTabs[config.Tab.Name].CreatedElements == 1 then
        border.Position = UDim2.new(0, 20, 0, 20)
    else
        border.Position = UDim2.new(0, 20, 0, 48 * createdTabs[config.Tab.Name].CreatedElements - 30)
    end

    border.Parent = config.Tab

    local frame = Instance.new("Frame")
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.4)
    frame.Size = UDim2.new(0.987, 0, 0, 32)
    frame.AnchorPoint = Vector2.new(0, 0.439)
    frame.Position = UDim2.new(0, 3, 0, 17)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    frameCorner.Parent = frame
    frame.Parent = border

    local btn = Instance.new("TextButton")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.ArialBold
    btn.TextSize = 18
    btn.Text = ""
    btn.Name = config.Name or "ToggleBtn"
    btn.Parent = frame

    local label = Instance.new("TextLabel")
    label.TextSize = 18
    label.Position = UDim2.new(0, 15, 0.5, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.ArialBold
    label.Text = config.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Name = config.Name.."Label"
    label.Parent = btn

    local toggle = Instance.new("ImageLabel")
    toggle.Size = UDim2.new(0, 24, 0, 24)
    toggle.Position = UDim2.new(0.92, 0, 0.12, 0)
    toggle.BackgroundTransparency = 1
    toggle.Image = "http://www.roblox.com/asset/?id=12184961372"
    toggle.BorderSizePixel = 0
    toggle.Name = config.Name or "Toggle"
    toggle.Parent = btn

    local toggleCenter = Instance.new("Frame")
    local toggleCenterCorner = Instance.new("UICorner")
    toggleCenterCorner.CornerRadius = UDim.new(1)
    toggleCenterCorner.Parent = toggleCenter
    toggleCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCenter.BackgroundTransparency = 1
    toggleCenter.Position = UDim2.new(0.25, 0, 0.25, 0)
    toggleCenter.Size = UDim2.new(0, 12.5, 0, 12.5)
    toggleCenter.BorderSizePixel = 0

    if state then
        toggleCenter.BackgroundTransparency = 0
    end

    toggleCenter.Parent = toggle

    btn.MouseButton1Click:Connect(function()
        state = not state 
        if state then
            tweenService:Create(toggleCenter, TweenInfo.new(0.25), {Transparency = 0}):Play()
        else
            tweenService:Create(toggleCenter, TweenInfo.new(0.25), {Transparency = 1}):Play()
        end
        if config.CallBack then
            if tostring(typeof(config.CallBack)) == "function" then
                spawn(function()
                    config.CallBack(state)
                end)
            end
        end
    end)
end

function Tab:CreateButton(config)
    createdTabs[config.Tab.Name].CreatedElements = createdTabs[config.Tab.Name].CreatedElements + 1
    local border = Instance.new("Frame")
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0.3)
    border.Size = UDim2.new(0.9, 0, 0, 38)
    border.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    borderCorner.Parent = border

    if createdTabs[config.Tab.Name].CreatedElements == 1 then
        border.Position = UDim2.new(0, 20, 0, 20)
    else
        border.Position = UDim2.new(0, 20, 0, 48 * createdTabs[config.Tab.Name].CreatedElements - 30)
    end

    border.Parent = config.Tab

    local frame = Instance.new("Frame")
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.3)
    frame.Size = UDim2.new(0.987, 0, 0, 32)
    frame.AnchorPoint = Vector2.new(0, 0.439)
    frame.Position = UDim2.new(0, 3, 0, 17)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    frameCorner.Parent = frame
    frame.Parent = border

    local btn = Instance.new("TextButton")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.ArialBold
    btn.TextSize = 18
    btn.Text = ""
    btn.Name = config.Name or "Btn"
    btn.Parent = frame

    local label = Instance.new("TextLabel")
    label.TextSize = 19
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.ArialBold
    label.Text = config.Text
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Name = config.Name.."Label"
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if config.CallBack then
            if tostring(typeof(config.CallBack)) == "function" then
                spawn(function()
                    config.CallBack()
                end)
            end
        end
    end)
end



Library:CreateWindow({["HideButton"] = Enum.KeyCode.RightControl})
Window:CreateTitle({["Text"] = "Made In Heaven"}) 
local PlayerTab = Window:CreateTab({["IsMainTab"] = true, ["Text"] = "Player", ["Name"] = "PlayerTab"})
local FarmTab = Window:CreateTab({["IsMainTab"] = false, ["Text"] = "Farm", ["Name"] = "FarmTab"})
local TeleportTab = Window:CreateTab({["IsMainTab"] = false, ["Text"] = "Teleport", ["Name"] = "TeleportTab"})
local WorldTab = Window:CreateTab({["IsMainTab"] = false, ["Text"] = "World", ["Name"] = "WorldTab"})
local MiscTab = Window:CreateTab({["IsMainTab"] = false, ["Text"] = "Misc", ["Name"] = "MiscTab"})
local mishaTab = Window:CreateTab({["IsMainTab"] = false, ["Text"] = "Для миши", ["Name"] = "ForMisha"})


Tab:CreateToggle({["Text"] = "Super spead", ["Name"] = "SuperSpeadToggle", ["Tab"] = PlayerTab, ["CallBack"] = function(state)
    superSpeadToggleValue = state
    wait()
    local humanoid
    local character = player.Character
    if character:FindFirstChild("Humanoid") then
        humanoid = character.Humanoid
    end
    if not superSpeadToggleValue then
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end})


Tab:CreateToggle({["Text"] = "Super jump", ["Name"] = "SuperJumpToggle", ["Tab"] = PlayerTab, ["CallBack"] = function(state)
    superJumpToggleValue = state
    wait()
    local humanoid
    local character = player.Character
    if character:FindFirstChild("Humanoid") then
        humanoid = character.Humanoid
    end
    if not superJumpToggleValue then
        if humanoid then
            humanoid.JumpPower = 50
        end
    end 
end})

Tab:CreateToggle({["Text"] = "Infinity jump", ["Name"] = "InfinityJumpToggle", ["Tab"] = PlayerTab, ["CallBack"] = function(state)
    infJumpToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Set hip height", ["Name"] = "SetHipHeightButton", ["Tab"] = PlayerTab, ["CallBack"] = function(state)
    local character = player.Character
    if character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if state then
            humanoid.HipHeight = 50
        else
            humanoid.HipHeight = 0
        end
    end
end})

Tab:CreateButton({["Text"] = "Godmode", ["Name"] = "GodmodeBtn", ["Tab"] = PlayerTab, ["CallBack"] = function()
    if not godmodeIsOn then
        godmodeIsOn = true
        local character = player.Character
        local humanoid
        if character:FindFirstChild("Humanoid") then
            humanoid = character.Humanoid
        end
        local block = character.Values:FindFirstChild("Block")
        if block then
            block:Destroy()
        end
        local isRun

        if humanoid.WalkSpeed == 16 then
            isRun = false
        else
            isRun = true
        end
        local connectionUIS
        connectionUIS = UIS.InputBegan:Connect(function(input, isTyping)
            if input.KeyCode == Enum.KeyCode.Z then
                if not isTyping then
                    isRun = not isRun
                end
            end
        end)

        local connectionRS
        connectionRS = runService.Stepped:Connect(function()
            if not superSpead then
                if character:FindFirstChild("Humanoid") then
                    humanoid = character.Humanoid
                end
                if not isRun then
                    humanoid.WalkSpeed = 16
                else
                    humanoid.WalkSpeed = 28
                end
            end
            if not godmodeIsOn then
                connectionUIS:Disconnect()
                connectionRS:Disconnect()
            end
        end)
    end
end})

Tab:CreateButton({["Text"] = "Reset", ["Name"] = "ResetHumButton", ["Tab"] = PlayerTab, ["CallBack"] = function()
    local character = player.Character
    local humanoid
    if character:FindFirstChild("Humanoid") then
        humanoid = character.Humanoid
        humanoid.Health = 0
    end
end})

Tab:CreateButton({["Text"] = "Reset (Delete Hum)", ["Name"] = "ResetButton", ["Tab"] = PlayerTab, ["CallBack"] = function()
    local character = player.Character
    local humanoid
    if character:FindFirstChild("Humanoid") then
        humanoid = character.Humanoid
        humanoid:Destroy()
    end
end})

Tab:CreateToggle({["Text"] = "Item farm", ["Name"] = "ItemFarmToggle", ["Tab"] = FarmTab, ["CallBack"] = function(state)
    itemFarmToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Chest farm", ["Name"] = "ChestFarmToggle", ["Tab"] = FarmTab, ["CallBack"] = function(state)
    chestFarmToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Debris farm", ["Name"] = "DebrisFarmToggle", ["Tab"] = FarmTab, ["CallBack"] = function(state)
    DebrisFarmToggleValue = state
end})


Tab:CreateButton({["Text"] = "Pucci", ["Name"] = "PucciTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(17.7901917, 974.017578, -3.1849246, 0.116389029, -5.99227619e-08, -0.9932037, 7.9396596e-09, 1, -5.94023888e-08, 0.9932037, -9.7191255e-10, 0.116389029)
    end
end})

Tab:CreateButton({["Text"] = "Metro", ["Name"] = "MetroTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(418.288605, 973.830444, -193.226654, -0.997848809, 4.23628332e-09, -0.0655571744, 5.5654632e-09, 1, -2.00925001e-08, 0.0655571744, -2.04141344e-08, -0.997848809)
    end
end})

Tab:CreateButton({["Text"] = "Beach", ["Name"] = "BeachTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(168.224655, 934.329834, 544.839172, -0.0409058481, 2.67147247e-08, 0.999163032, -7.66220154e-08, 1, -2.98740161e-08, -0.999163032, -7.77799016e-08, -0.0409058481)
    end
end})

Tab:CreateButton({["Text"] = "Johny", ["Name"] = "JohnyTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(-101.715897, 973.450623, -557.405029, 0.0640465915, -3.77561911e-08, -0.997946918, -6.37809947e-08, 1, -4.19272261e-08, 0.997946918, 6.6335339e-08, 0.0640465915)
    end
end})

Tab:CreateButton({["Text"] = "Village", ["Name"] = "VillageTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(-1059.26221, 1008.98273, -665.617188, 0.996700943, 0, -0.0811619908, 0, 1, 0, 0.0811619908, 0, 0.996700943)
    end
end})

Tab:CreateButton({["Text"] = "Backrooms", ["Name"] = "BackroomsTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(-172.740326, 466.062805, -6173.43506, -0.583818138, -4.9684612e-09, 0.811884463, -3.92354096e-08, 1, -2.20941327e-08, -0.811884463, -4.47535768e-08, -0.583818138)
    end
end})


Tab:CreateButton({["Text"] = "Space", ["Name"] = "SpaceTeleportButton", ["Tab"] = TeleportTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(-207.993378, 4308.28516, -458.037872, 1, -1.24015491e-08, 8.46372126e-13, 1.24015491e-08, 1, 5.80914943e-08, -8.47092524e-13, -5.80914943e-08, 1)
    end
end})


Tab:CreateButton({["Text"] = "Day", ["Name"] = "DayBtn", ["Tab"] = WorldTab, ["CallBack"] = function()
    game.Lighting.TimeOfDay = "13:20:00"
end})

Tab:CreateButton({["Text"] = "Night", ["Name"] = "NightBtn", ["Tab"] = WorldTab, ["CallBack"] = function()
    game.Lighting.TimeOfDay = "24:00:00"
end})

Tab:CreateButton({["Text"] = "IceCream", ["Name"] = "IceCreamTeleportButton", ["Tab"] = mishaTab, ["CallBack"] = function()
    local character = player.Character
    local humanoidRP
    if character:FindFirstChild("HumanoidRootPart") then
        humanoidRP = character.HumanoidRootPart
        humanoidRP.CFrame = CFrame.new(1.88720703, 996.50708, -8.35058594, 1, 0, 0, 0, 1, 0, 0, 0, 1) --CFrame.new(-1.97460938, 991.522949, -8.35058594, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    end
end})



Tab:CreateToggle({["Text"] = "Item notification", ["Name"] = "Item notificationToggle", ["Tab"] = MiscTab, ["CallBack"] = function(state)
    itemNotificationToggleValue = state
end})

local function addTeleportMenu(item)
    local frame = Instance.new("Frame")
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.1)
    frame.Size = UDim2.new(0, 330, 0, 150)
    frame.Position = UDim2.new(1.1, 0, 0.8, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Position = UDim2.new(0.5, 0, 0, 40)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.ArialBold
    textLabel.TextSize = 20
    textLabel.Text = ("Item has spawned - "..item.Name)

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
        if item then
            if item:FindFirstChild("ProximityAttachment") then
                if item.ProximityAttachment:FindFirstChild("Interaction") then
                    local RP = player.Character.HumanoidRootPart
                    RP.CFrame = item.CFrame + Vector3.new(0, 4, 0)
                    wait(0.2)
                    pcall(function()
                        fireproximityprompt(item:FindFirstChild("ProximityAttachment").Interaction, 20)
                    end)
                    table.remove(queue, 1)
                    local itemsIndex = table.find(items, item)
                    if itemsIndex then
                        table.remove(items, itemsIndex)
                    end
                end
            end
        end
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


UIS.InputBegan:Connect(function(input, isTyping)
    if input.KeyCode == Enum.KeyCode.Space then
        isJump = true
    end
end)

UIS.InputEnded:Connect(function(input, isTyping)
    if input.KeyCode == Enum.KeyCode.Space then
        isJump = false
    end
end)


local function superSpead()
    local connection
    connection = runService.Stepped:Connect(function()
        if superSpeadToggleValue then
            local humanoid
            local character = player.Character
            if character:FindFirstChild("Humanoid") then
                humanoid = character.Humanoid
            end
            if humanoid then
                humanoid.WalkSpeed = _G.Spead
            end
        end
    end)
end

local function superJump()
    local connection
    connection = runService.Stepped:Connect(function()
        if superJumpToggleValue then
            local humanoid
            local character = player.Character
            if character:FindFirstChild("Humanoid") then
                humanoid = character.Humanoid
            end
            if humanoid then
                humanoid.JumpPower = _G.Jump
            end
        end
    end)
end


local function itemsAutoFarm()
    while true do
        if itemFarmToggleValue then
            if farmItems[1] then
                local item = farmItems[1]
                if item:FindFirstChild("ProximityAttachment") then
                    if item.ProximityAttachment:FindFirstChild("Interaction") then
                        local RP = player.Character.HumanoidRootPart
                        RP.CFrame = item.CFrame + Vector3.new(0, 4, 0)
                        wait(0.1)
                        pcall(function()
                            fireproximityprompt(item:FindFirstChild("ProximityAttachment").Interaction, 20)
                        end)
                        wait(0.2)
                    end
                end
            end
        end
        wait()
    end
end

local function chestAutoFarm()
    while true do
        if chestFarmToggleValue then
            if farmChest[1] then
                local chest = farmChest[1]
                if chest:FindFirstChild("RootPart") then
                    if chest.RootPart:FindFirstChild("ProximityAttachment") then
                        if chest.RootPart.ProximityAttachment:FindFirstChild("Interaction") then
                            local RP = player.Character.HumanoidRootPart
                            RP.CFrame = chest.RootPart.CFrame
                            RP.Anchored = true
                            wait(0.2)                             
                            pcall(function()            
                                fireproximityprompt(chest.RootPart:FindFirstChild("ProximityAttachment").Interaction, 20)
                            end) 
                            wait(0.7)
                            RP.Anchored = false
                        end
                    end
                end
            end
        end
        wait()
    end
end

local function debrisAutoFarm()
    while true do
        if DebrisFarmToggleValue then
            if farmDebris[1] then
                local debris = farmDebris[1]
                if debris:FindFirstChild("ProximityAttachment") then
                    if debris.ProximityAttachment:FindFirstChild("Interaction") then
                        local RP = player.Character.HumanoidRootPart
                        RP.CFrame = debris.CFrame
                        wait(0.2)                             
                        pcall(function()            
                            fireproximityprompt(debris:FindFirstChild("ProximityAttachment").Interaction, 20)
                        end) 
                        wait(1)
                    end
                end
            end
        end
        wait()
    end
end


local function checkQueue()
    while true do
        if itemNotificationToggleValue then
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
        end
        wait()
    end
end


spawn(function()
    checkQueue()
end)

spawn(function()
    superSpead()
end)

spawn(function()
    superJump()
end)

spawn(function()
    itemsAutoFarm()
end)

spawn(function()
    chestAutoFarm()
end)

spawn(function()
    debrisAutoFarm()
end)


runService.Stepped:Connect(function()
    if itemNotificationToggleValue then
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

    for k in pairs(farmItems) do
        farmItems[k] = nil
    end
    for i, spawnLocation in pairs(game.workspace.ItemSpawns.StandardItems:GetChildren()) do
        for v, newItem in pairs(spawnLocation:GetChildren()) do
            table.insert(farmItems, newItem)
        end
    end

    for k in pairs(farmChest) do
        farmChest[k] = nil
    end
    for i, spawnLocation in pairs(game.workspace.ItemSpawns.Chests:GetChildren()) do
        for v, newChest in pairs(spawnLocation:GetChildren()) do
            table.insert(farmChest, newChest)
        end
    end

    for k in pairs(farmDebris) do
        farmDebris[k] = nil
    end
    for i, spawnLocation in pairs(game.workspace.ItemSpawns["Sand Debris"]:GetChildren()) do
        for v, newDebris in pairs(spawnLocation:GetChildren()) do
            table.insert(farmDebris, newDebris)
        end
    end

    if player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health <= 0 then
            godmodeIsOn = false
        end
    else
        godmodeIsOn = false
    end
end)

runService.Stepped:Connect(function()
    if infJumpToggleValue then
        if isJump then
            local character = player.Character
            character.Humanoid:ChangeState("Jumping")
        end
    end
end)
