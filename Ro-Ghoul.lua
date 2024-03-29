local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local player =  game:GetService("Players").LocalPlayer

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

--_G.farmSpeed = 200
--_G.repFarmSpead = 220
--_G.stage = "One"
--_G.timeToSkipNPC = 4
--_G.bossesWhitelist = {
--    "Nishiki Nishio",
--    "Koutarou Amon",
--    "Eto Yoshimura"
--}

local npc_blacklist = {}
local goalNPCPos = nil

local isJump = false
local isAlive = true

local key = "操你💦💔🍑👌💦操你💦💔🍑👌💦💔🍑👌💦💔🍑👌💔🍑👌💦💔🍑👌"
local infJumpToggleValue
local repAutoFarmToggleValue
local autoFarmToggleValue
local eatCorpsesToggleValue
local bossAutoFarmToggleValue
local autoCashoutToggleValue
local antiAfkToggleValue

local aogiri = {
    "Low Rank Aogiri Member",
    "Mid Rank Aogiri Member",
    "High Rank Aogiri Member"
}

Library:CreateWindow({["HideButton"] = Enum.KeyCode.RightControl})
Window:CreateTitle({["Text"] = "RG | Beta"})
local playerTab = Window:CreateTab({["Text"] = "Player", ["Name"] = "PlayerTab", ["IsMainTab"] = true})
local farmTab = Window:CreateTab({["Text"] = "Farm", ["Name"] = "FarmTab"})
local teleportTab = Window:CreateTab({["Text"] = "Teleport", ["Name"] = "TeleportTab"})
local miscTab = Window:CreateTab({["Text"] = "Misc", ["Name"] = "MiscTab"})

Tab:CreateToggle({["Text"] = "Infinity Jump", ["Name"] = "InfinityJumpToggle", ["Tab"] = playerTab, ["State"] = false, ["CallBack"] = function(state)
    infJumpToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Farm", ["Name"] = "FarmToggle", ["Tab"] = farmTab, ["State"] = false, ["CallBack"] = function(state)
    autoFarmToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Farm Reputation", ["Name"] = "autoRepAutoFarmToggle", ["Tab"] = farmTab, ["State"] = false, ["CallBack"] = function(state)
    repAutoFarmToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Boss Farm", ["Name"] = "BossAutoFarmToggle", ["Tab"] = farmTab, ["State"] = false, ["CallBack"] = function(state)
    bossAutoFarmToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Auto Cashout", ["Name"] = "autoRepAutoFarmToggle", ["Tab"] = farmTab, ["State"] = false, ["CallBack"] = function(state)
    autoCashoutToggleValue = state
end})

Tab:CreateToggle({["Text"] = "Eat Corpses", ["Name"] = "EatCorpsesToggle", ["Tab"] = farmTab, ["State"] = false, ["CallBack"] = function(state)
    eatCorpsesToggleValue = state
end})

Tab:CreateButton({["Text"] = "Nishiki", ["Name"] = "NishikiTeleportBtn", ["Tab"] = teleportTab, ["State"] = false, ["CallBack"] = function(state)
    if player.Character:FindFirstChild("HumanoidRootPart") then
        for i, v in pairs(game.Workspace.NPCSpawns:GetChildren()) do
            if v.Name == "BossSpawns" then
                if v:FindFirstChild("Nishiki Nishio") then
                    local RP = player.Character:FindFirstChild("HumanoidRootPart")
                    local tp_part = v:FindFirstChild("Nishiki Nishio"):FindFirstChild("HumanoidRootPart")
                    local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - tp_part.Position).Magnitude / _G.farmSpeed, Enum.EasingStyle.Linear), {CFrame = tp_part.CFrame})
                    tween:Play()
                    while true do
                        if not RP or not tp_part then
                            tween:Pause()
                            break
                        end
                        wait()
                    end 
                end
            end
        end
    end
end})

Tab:CreateButton({["Text"] = "Amon", ["Name"] = "AmonTeleportBtn", ["Tab"] = teleportTab, ["State"] = false, ["CallBack"] = function(state)
    if player.Character:FindFirstChild("HumanoidRootPart") then
        for i, v in pairs(game.Workspace.NPCSpawns:GetChildren()) do
            if v.Name == "BossSpawns" then
                if v:FindFirstChild("Koutarou Amon") then
                    local RP = player.Character:FindFirstChild("HumanoidRootPart")
                    local tp_part = v:FindFirstChild("Koutarou Amon"):FindFirstChild("HumanoidRootPart")
                    local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - tp_part.Position).Magnitude / _G.farmSpeed, Enum.EasingStyle.Linear), {CFrame = tp_part.CFrame})
                    tween:Play()
                    while true do
                        if not RP or not tp_part then
                            tween:Pause()
                            break
                        end
                        wait()
                    end 
                end
            end
        end
    end
end})

Tab:CreateToggle({["Text"] = "Anti afk", ["Name"] = "AntiAfkToggle", ["Tab"] = miscTab, ["State"] = false, ["CallBack"] = function(state)
    antiAfkToggleValue = state
end})



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


function findNearest(onlyAogiri, onlyBosses) 
    local nearest = nil
    local nearestBoss = nil
    if player.Character:FindFirstChild("HumanoidRootPart") then
        local RP = player.Character:FindFirstChild("HumanoidRootPart")
        for i, v in pairs(game.Workspace.NPCSpawns:GetChildren()) do
            if bossAutoFarmToggleValue then
                if v.Name == "BossSpawns" then
                    for k, boss in pairs(v:GetChildren()) do
                        if table.find(_G.bossesWhitelist, boss.Name) then
                            print(boss)
                            print("boss")
                            if boss:FindFirstChild("HumanoidRootPart") then
                                if not nearestBoss then
                                    nearestBoss = boss
                                elseif (RP.Position - boss.HumanoidRootPart.Position).Magnitude < (RP.Position - nearestBoss.HumanoidRootPart.Position).Magnitude then
                                    nearestBoss = boss
                                end
                            end  
                        end
                    end
                end  
            end
            if not nearestBoss and not onlyBosses then      
                for i1, v1 in pairs(v:GetChildren()) do              
                    if onlyAogiri then
                        if not table.find(aogiri, v1.Name) then
                            continue
                        end
                    end
                    if table.find(npc_blacklist, v1) then
                        continue
                    end
                
                    if v1:FindFirstChild("HumanoidRootPart") and v1 then 
                        if not nearest then
                            nearest = v1
                        elseif (RP.Position - v1.HumanoidRootPart.Position).Magnitude < (RP.Position - nearest.HumanoidRootPart.Position).Magnitude then
                            nearest = v1
                        end
                    end   
                end
            end
        end        
    end
    if nearestBoss then
        return(nearestBoss)
    end
    return(nearest)
end

function checkStat()	
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("HUD") then
        for i, v in pairs(game.Players.LocalPlayer.PlayerGui.HUD.TaskFrame:GetChildren()) do
            if v.Name ~= "FailureLabel" and player.PlayerGui:FindFirstChild("HUD") and player.PlayerGui.HUD.TaskFrame.CompleteLabel.Text ~= "You have no task at the moment." and v.Text then 
                local split = string.split(v.Text, '/')

                local max = split[2]
                local splitCur = string.split(split[1], ':')
                
                local cur = splitCur[2]:gsub("%s+", "")
                
                if max ~= nil and cur ~= nil then
                    if tonumber(cur) >= tonumber(max) then
                        return(1) 
                    else   
                        return(0)
                    end           
                end        
            end
        end
    end
    return(-1)
end

function eatCorpse(Enemy)
    if Enemy:FindFirstChild(Enemy.Name.." Corpse") and player.Character:FindFirstChild("HumanoidRootPart") then
        if Enemy:FindFirstChild(Enemy.Name.." Corpse"):FindFirstChild("ClickPart") then
            if Enemy:FindFirstChild(Enemy.Name.." Corpse"):FindFirstChild("ClickPart"):FindFirstChildWhichIsA("ClickDetector") then
                local rep = false
                spawn(function()
                    repeat
                        if player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = Enemy:FindFirstChild(Enemy.Name.." Corpse").HumanoidRootPart.CFrame
                            pcall(function()
                                fireclickdetector(Enemy:FindFirstChild(Enemy.Name.." Corpse"):FindFirstChild("ClickPart"):FindFirstChildWhichIsA("ClickDetector"), 1)
                            end)
                        end
                    wait()
                    until rep == true
                end)
                wait(0.3)
                rep = true
            end
        end
    end
end

function beat(RP, Enemy)
    local addToBlacklist = false
    local isBoss = table.find(_G.bossesWhitelist, Enemy.Name)
    if not isBoss then
        delay(_G.timeToSkipNPC, function()
            addToBlacklist = true
        end)
    end
    while true do
        if Enemy:FindFirstChild(Enemy.Name.." Corpse") then
            if eatCorpsesToggleValue then           
                spawn(function()
                    eatCorpse(Enemy)                    
                end)  
            end
            break
        end

        if not Enemy:FindFirstChild("HumanoidRootPart") or not RP or (isBoss and not bossAutoFarmToggleValue) then
            break
        end

        if addToBlacklist then
            table.insert(npc_blacklist, Enemy)
            return(0)
        end

        RP.CFrame = Enemy:FindFirstChild("HumanoidRootPart").CFrame

        player.Character.Remotes.KeyEvent:FireServer(key, "Mouse1", "Down", CFrame.new(), CFrame.new())

        if ((not autoFarmToggleValue and not repAutoFarmToggleValue) or (player.Character:FindFirstChild("Humanoid"))) and not isAlive then
            break
        elseif not repAutoFarmToggleValue then
            break
        end
        wait()
    end
    if eatCorpsesToggleValue then
        wait(1)
    end
    wait()
end

spawn(function()
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        if antiAfkToggleValue then
            game:GetService("VirtualUser"):Button2Down(Vector2.new())
        end
    end)
end)

spawn(function()
    while true do
        if (player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health == 0) and (autoFarmToggleValue or repAutoFarmToggleValue or bossAutoFarmToggleValue) then
            isAlive = false
	        repeat wait() until player.PlayerGui:FindFirstChild("SpawnSelection")
            repeat wait() until not player.PlayerGui:FindFirstChild("SpawnSelection")
            wait(1)
            repeat wait() until player.Character:FindFirstChild("Remotes")
	        player.Character.Remotes.KeyEvent:FireServer(key, _G.stage, "Down", CFrame.new(), CFrame.new())
            isAlive = true
        end
        wait()
    end
end)

spawn(function()
    while true do
        if autoFarmToggleValue then
            if player.Character:FindFirstChild("HumanoidRootPart") then
                local RP = player.Character:FindFirstChild("HumanoidRootPart")
                local nearest = findNearest(false, false)
                if nearest then
                    local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - nearest:FindFirstChild("HumanoidRootPart").Position).Magnitude / _G.farmSpeed, Enum.EasingStyle.Linear), {CFrame = nearest:FindFirstChild("HumanoidRootPart").CFrame})
                    tween:Play()
                    while true do
                        if not autoFarmToggleValue then
                            tween:Pause()
                            break
                        end
                        if nearest:FindFirstChild("HumanoidRootPart") then
                            if ((RP.Position - nearest.HumanoidRootPart.Position).Magnitude < 30) then
                                tween:Pause()
                                beat(RP, nearest, false)
                                break
                            end
                        end
                        wait()
                    end
                end
            end
        end
        wait()
    end
end)

function getQuest()
    game:GetService("ReplicatedStorage").Remotes.Yoshimura.Task:InvokeServer()
end


function cashout()
    game:GetService("ReplicatedStorage").Remotes.ReputationCashOut:InvokeServer()
end

spawn(function()
    while true do 
        if repAutoFarmToggleValue and isAlive then
            if player.PlayerGui:FindFirstChild("HUD") then
                if player.Character:FindFirstChild("HumanoidRootPart") then
                    if player.PlayerGui.HUD.TaskFrame.CompleteLabel.Text == "You have no task at the moment." then
                        local RP = player.Character:FindFirstChild("HumanoidRootPart")
                        local tp_part = game.Workspace.Anteiku.Yoshimura.HumanoidRootPart

                        local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - tp_part.Position).Magnitude / _G.repFarmSpead, Enum.EasingStyle.Linear), {CFrame = tp_part.CFrame})

                        tween:Play()

                        while true do
                            if not repAutoFarmToggleValue or not RP or not tp_part then
                                tween:Pause()
                                break
                            end

                            if (RP.Position - tp_part.Position).Magnitude < 2 then
                                getQuest()
                                if autoCashoutToggleValue then
                                    cashout()
                                end
                                break
                            end
                            wait()
                        end
                    elseif checkStat() == 0 then
                        local RP = player.Character:FindFirstChild("HumanoidRootPart")
                        local nearest
                        while true do
                            nearest = findNearest(true, false)
                            if nearest then
                                break
                            end
                            wait()
                        end
                        local isBoss = table.find(_G.bossesWhitelist, nearest.Name)
                        if nearest then
                            goalNPCPos = nearest:FindFirstChild("HumanoidRootPart").Position
                            local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - nearest:FindFirstChild("HumanoidRootPart").Position).Magnitude / _G.repFarmSpead, Enum.EasingStyle.Linear), {CFrame = nearest:FindFirstChild("HumanoidRootPart").CFrame})
                            tween:Play()
                            while isAlive do
                                if not repAutoFarmToggleValue or not nearest:FindFirstChild("HumanoidRootPart") or (isBoss and not bossAutoFarmToggleValue) then
                                    tween:Pause()
                                    break
                                end
                                
                                if goalNPCPos ~= nearest:FindFirstChild("HumanoidRootPart").Position then
                                    tween:Pause()
                                    tween = tweenService:Create(RP, TweenInfo.new((RP.Position - nearest:FindFirstChild("HumanoidRootPart").Position).Magnitude / _G.repFarmSpead, Enum.EasingStyle.Linear), {CFrame = nearest:FindFirstChild("HumanoidRootPart").CFrame})
                                    tween:Play()
                                    goalNPCPos = nearest:FindFirstChild("HumanoidRootPart").Position
                                end

                                if (RP.Position - nearest.HumanoidRootPart.Position).Magnitude < 30 then
                                    tween:Pause()
                                    beat(RP, nearest)
                                    break
                                end 
                                wait()
                            end
                        end
                    else
                        if player.Character:FindFirstChild("HumanoidRootPart") then
                            local RP = player.Character:FindFirstChild("HumanoidRootPart")
                            local tp_part = game.Workspace.Anteiku.Yoshimura.HumanoidRootPart

                            local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - tp_part.Position).Magnitude / _G.repFarmSpead, Enum.EasingStyle.Linear), {CFrame = tp_part.CFrame})

                            tween:Play()

                            while true do
                                if not repAutoFarmToggleValue or not RP or not tp_part then
                                    tween:Pause()
                                    break
                                end

                                if (RP.Position - tp_part.Position).Magnitude < 2 then
                                    getQuest()
                                    if autoCashoutToggleValue then
                                        cashout()
                                    end
                                    break
                                end
                                wait()
                            end 
                        end
                    end 
                end
            end
        end
        wait()
    end
end)

spawn(function()
    while true do 
        if bossAutoFarmToggleValue and isAlive and not repAutoFarmToggleValue and not autoFarmToggleValue then
            if player.Character:FindFirstChild("HumanoidRootPart") then
                local RP = player.Character:FindFirstChild("HumanoidRootPart")
                local nearest = findNearest(false, true)
                if nearest then
                    local tween = tweenService:Create(RP, TweenInfo.new((RP.Position - nearest:FindFirstChild("HumanoidRootPart").Position).Magnitude / _G.farmSpeed, Enum.EasingStyle.Linear), {CFrame = nearest:FindFirstChild("HumanoidRootPart").CFrame})
                    tween:Play()
                    while true do
                        if not bossAutoFarmToggleValue or repAutoFarmToggleValue then
                            tween:Pause()
                            break
                        end
                        if nearest:FindFirstChild("HumanoidRootPart") then
                            if ((RP.Position - nearest.HumanoidRootPart.Position).Magnitude < 30) then
                                tween:Pause()
                                beat(RP, nearest)
                                break
                            end
                        end
                        wait()
                    end
                end
            end
        end
        wait()
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
