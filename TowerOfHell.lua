local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

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
    createdTabs[config.Tab.Name].CreatedElements++

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
    createdTabs[config.Tab.Name].CreatedElements++
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
Window:CreateTitle({["Text"] = "Горящая жопа"})
local teleportTab = Window:CreateTab({["Text"] = "Teleport", ["Name"] = "TeleportBtn", ["IsMainTab"] = true})
Tab:CreateButton({["Text"] = "Finish", ["Name"] = "FinishTeleportBtn", ["Tab"] = teleportTab, ["CallBack"] = function()
    if game.Workspace:FindFirstChild("tower") then
        if game.Workspace.tower.sections.finish:FindFirstChild("FinishGlow") then
            player.Character.HumanoidRootPart.CFrame = game.Workspace.tower.sections.finish:FindFirstChild("FinishGlow").CFrame
        end
    end
end})
