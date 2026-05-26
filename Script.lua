-- =============================================================================
-- PART 1: GLOBAL FRAME WORK INITIALIZATION
-- =============================================================================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("CircleBuilderUI") then 
	CoreGui.CircleBuilderUI:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CircleBuilderUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
-- FIX: Expanded canvas vertical boundaries up to 600px height to accommodate the discord container floor layout cleanly
MainFrame.Size = UDim2.new(0, 330, 0, 600)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local ReopenButton = Instance.new("TextButton", ScreenGui)
ReopenButton.Size = UDim2.new(0, 120, 0, 40)
ReopenButton.Position = UDim2.new(0, 10, 0.5, -20)
ReopenButton.Text = "Open Builder"
ReopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReopenButton.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
ReopenButton.Font = Enum.Font.GothamBold
ReopenButton.TextSize = 13
ReopenButton.Visible = false
Instance.new("UICorner", ReopenButton).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "  CIRCLE BUILDER SUITE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(240, 90, 90)
CloseBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local function addInput(labelText, yPos, defaultValue, editable)
	local lbl = Instance.new("TextLabel", MainFrame)
	lbl.Size = UDim2.new(0, 150, 0, 28)
	lbl.Position = UDim2.new(0, 15, 0, yPos)
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(190, 190, 195)
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Gotham
	
	local box = Instance.new("TextBox", MainFrame)
	box.Size = UDim2.new(0, 130, 0, 28)
	box.Position = UDim2.new(0, 175, 0, yPos)
	box.Text = defaultValue
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
	box.Font = Enum.Font.GothamSemibold
	box.TextSize = 13
	box.TextEditable = editable
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

local inputRadius = addInput("Circle Radius / Range:", 55, "20", true)
local inputSteps = addInput("Total Parts Count:", 97, "30", true)
local inputSizeY = addInput("Block Height (Y):", 139, "2", true)
local inputBlockType = addInput("Active Block Type:", 181, "PlasticBlock", true)
local inputSizeX = addInput("Calculated Width (X):", 223, "0.00", false)
local inputSizeZ = addInput("Calculated Depth (Z):", 265, "0.00", false)

_G.CBuilder_CoreUI = {
	MainFrame = MainFrame, ScreenGui = ScreenGui, ReopenButton = ReopenButton, CloseBtn = CloseBtn,
	inputRadius = inputRadius, inputSteps = inputSteps, inputSizeY = inputSizeY,
	inputBlockType = inputBlockType, inputSizeX = inputSizeX, inputSizeZ = inputSizeZ
}
-- // END OF FILE: Part_1.lua //

-- =============================================================================
-- PART 2: CONTROL SECTOR & SPACING ALIGNMENT WITH DISCORD ELECTION
-- =============================================================================
local core = _G.CBuilder_CoreUI
if not core then error("Critical Stack Trace Mismatch: Run Part 1 first.") end

local MainFrame = core.MainFrame
local statusLabel = Instance.new("TextLabel", MainFrame)
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.new(0, 15, 0, 310)
statusLabel.Text = "Center Target Block: Not Selected"
statusLabel.TextColor3 = Color3.fromRGB(240, 90, 90)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.BackgroundTransparency = 1

local function createButton(text, yPos, color)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Size = UDim2.new(1, -30, 0, 36)
	btn.Position = UDim2.new(0, 15, 0, yPos)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local btnSelect = createButton("Select Center Target Block", 345, Color3.fromRGB(0, 122, 215))
local btnPreview = createButton("Hologram Preview Configuration: Disabled", 388, Color3.fromRGB(110, 110, 115))
local btnBuild = createButton("Commence Circle Construction", 431, Color3.fromRGB(46, 139, 87))

-- NEW/RESTORED: Discord copy textbox element embedded securely onto main panel floor metrics 
local CopyBox = Instance.new("TextBox", MainFrame)
CopyBox.Size = UDim2.new(1, -30, 0, 32)
CopyBox.Position = UDim2.new(0, 15, 1, -45) -- Padded perfectly near the bottom floor geometry boundary
CopyBox.Text = "https://discord.com/invite/3xCwTAYhXe"
CopyBox.TextColor3 = Color3.fromRGB(114, 137, 218)
CopyBox.BackgroundColor3 = Color3.fromRGB(44, 47, 51)
CopyBox.Font = Enum.Font.GothamBold
CopyBox.TextSize = 11
CopyBox.ClearTextOnFocus = false
CopyBox.TextEditable = false
Instance.new("UICorner", CopyBox).CornerRadius = UDim.new(0, 6)

_G.CBuilder_Buttons = {
	statusLabel = statusLabel, btnSelect = btnSelect, btnPreview = btnPreview, btnBuild = btnBuild
}
-- // END OF FILE: Part_2.lua //

-- =============================================================================
-- PART 3: INVENTORY DRAWER POPUP AND SELECTION SYSTEM
-- =============================================================================
local core = _G.CBuilder_CoreUI
local buttons = _G.CBuilder_Buttons
if not core or not buttons then error("Critical Stack Trace Mismatch: Run Part 2 first.") end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local dataFolder = LocalPlayer:WaitForChild("Data", 5)

local MainFrame = core.MainFrame
local CloseBtn = core.CloseBtn
local ReopenButton = core.ReopenButton
local inputBlockType = core.inputBlockType

local BlockPanel = Instance.new("Frame", MainFrame)
BlockPanel.Size = UDim2.new(0, 240, 1, 0)
BlockPanel.Position = UDim2.new(1, 10, 0, 0)
BlockPanel.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
BlockPanel.Visible = false
Instance.new("UICorner", BlockPanel).CornerRadius = UDim.new(0, 10)

local PanelTitle = Instance.new("TextLabel", BlockPanel)
PanelTitle.Size = UDim2.new(1, 0, 0, 40)
PanelTitle.Text = "AVAILABLE BUILDING MATERIALS"
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
Instance.new("UICorner", PanelTitle).CornerRadius = UDim.new(0, 10)

local ScrollingFrame = Instance.new("ScrollingFrame", BlockPanel)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.Name

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false ReopenButton.Visible = true BlockPanel.Visible = false end)
ReopenButton.MouseButton1Click:Connect(function() MainFrame.Visible = true ReopenButton.Visible = false end)
inputBlockType.Focused:Connect(function() BlockPanel.Visible = true end)

local function updateInventoryLayout()
	for _, child in ipairs(ScrollingFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
	if not dataFolder then return end
	for _, item in ipairs(dataFolder:GetChildren()) do
		if item:IsA("ValueBase") and item.Value > 0 and not string.find(item.Name, "Tool") then
			local itemBtn = Instance.new("TextButton", ScrollingFrame)
			itemBtn.Size = UDim2.new(1, -5, 0, 30)
			itemBtn.Text = "  " .. item.Name .. " (" .. tostring(item.Value) .. ")"
			itemBtn.TextColor3 = Color3.fromRGB(190, 190, 195)
			itemBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
			itemBtn.Font = Enum.Font.GothamSemibold
			itemBtn.TextSize = 11
			itemBtn.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)
			
			itemBtn.MouseButton1Click:Connect(function() 
				inputBlockType.Text = item.Name 
				BlockPanel.Visible = false 
				updateInventoryLayout() 
				if _G.CBuilder_UpdateRing then _G.CBuilder_UpdateRing() end
			end)
		end
	end
end

if dataFolder then
	updateInventoryLayout()
	dataFolder.ChildAdded:Connect(updateInventoryLayout)
	dataFolder.ChildRemoved:Connect(updateInventoryLayout)
end

_G.CBuilder_Inventory = { BlockPanel = BlockPanel, dataFolder = dataFolder }
-- // END OF FILE: Part_3.lua //

-- =============================================================================
-- PART 4: TARGET ANALYSIS & HOLOGRAM PREVIEW MATRIX
-- =============================================================================
local core = _G.CBuilder_CoreUI
local buttons = _G.CBuilder_Buttons
local invData = _G.CBuilder_Inventory
if not core or not buttons or not invData then error("Sequence Interrupted: Run Part 3 first.") end

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local inputRadius, inputSteps, inputSizeY, inputBlockType, inputSizeX, inputSizeZ = core.inputRadius, core.inputSteps, core.inputSizeY, core.inputBlockType, core.inputSizeX, core.inputSizeZ
local statusLabel, btnSelect, btnPreview, btnBuild = buttons.statusLabel, buttons.btnSelect, buttons.btnPreview, buttons.btnBuild
local BlockPanel, dataFolder = invData.BlockPanel, invData.dataFolder

local previewFolder = workspace:FindFirstChild("CirclePreviewFolder") or Instance.new("Folder", workspace) previewFolder.Name = "CirclePreviewFolder"
local selectionBox = Instance.new("SelectionBox", CoreGui) selectionBox.Color3 = Color3.fromRGB(0, 255, 255) selectionBox.LineThickness = 0.04
local selectedCenterPos, isSelecting, showLivePreview = nil, false, false

local function updateRingVisuals()
	previewFolder:ClearAllChildren()
	if not _G.CBuilder_CenterPos then return end
	local radius, steps, sizeY = tonumber(inputRadius.Text) or 20, tonumber(inputSteps.Text) or 30, tonumber(inputSizeY.Text) or 2
	local sizeZ = (2 * math.pi * radius) / steps
	local sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02
	inputSizeX.Text, inputSizeZ.Text = string.format("%.3f", sizeX), string.format("%.3f", sizeZ)
	if not _G.CBuilder_LivePreview then return end
	for i = 1, steps do
		local angle = (i / steps) * math.pi * 2
		local p = Vector3.new(_G.CBuilder_CenterPos.X + math.cos(angle) * radius, _G.CBuilder_CenterPos.Y, _G.CBuilder_CenterPos.Z + math.sin(angle) * radius)
		local hp = Instance.new("Part", previewFolder) hp.Size = Vector3.new(sizeX, sizeY, sizeZ) hp.CFrame = CFrame.lookAt(p, _G.CBuilder_CenterPos) hp.Color = Color3.new(1,1,1) hp.Transparency = 0.5 hp.Anchored = true hp.CanCollide = false
		local sb = Instance.new("SelectionBox", hp) sb.Adornee = hp sb.Color3 = Color3.fromRGB(0, 255, 255) sb.LineThickness = 0.01
	end
end
_G.CBuilder_UpdateRing = updateRingVisuals
for _, box in ipairs({inputRadius, inputSteps, inputSizeY}) do box:GetPropertyChangedSignal("Text"):Connect(updateRingVisuals) end

btnSelect.MouseButton1Click:Connect(function()
	if isSelecting then return end isSelecting = true
	statusLabel.Text, btnSelect.Text = "Select an anchor object Node...", "Awaiting Node Target..."
	local rConn, cConn
	rConn = RunService.RenderStepped:Connect(function() selectionBox.Adornee = Mouse.Target end)
	cConn = Mouse.Button1Down:Connect(function()
		local t = Mouse.Target if t and t:IsA("BasePart") then
			_G.CBuilder_CenterPos = t.Position statusLabel.Text = "Target Locked: " .. t.Name statusLabel.TextColor3 = Color3.fromRGB(80, 240, 80)
			rConn:Disconnect() cConn:Disconnect() selectionBox.Adornee = nil isSelecting = false btnSelect.Text = "Select Center Target Block" updateRingVisuals()
		end
	end)
end)

btnPreview.MouseButton1Click:Connect(function()
	_G.CBuilder_LivePreview = not _G.CBuilder_LivePreview
	btnPreview.Text = _G.CBuilder_LivePreview and "Hologram Preview Configuration: Active" or "Hologram Preview Configuration: Disabled"
	btnPreview.BackgroundColor3 = _G.CBuilder_LivePreview and Color3.fromRGB(155, 80, 180) or Color3.fromRGB(110, 110, 115)
	updateRingVisuals()
end)

_G.CBuilder_PipelineData = { previewFolder = previewFolder, folder = workspace:WaitForChild("Blocks", 5):WaitForChild(LocalPlayer.Name, 5) }
-- // END OF FILE: Part_4.lua //

-- =============================================================================
-- PART 5: SERVER REMOTE PLACEMENT NETWORK PIPES
-- =============================================================================
local core = _G.CBuilder_CoreUI
local buttons = _G.CBuilder_Buttons
local invData = _G.CBuilder_Inventory
local pipeline = _G.CBuilder_PipelineData
if not core or not buttons or not invData or not pipeline then error("Sequence Interrupted: Run Part 4 first.") end

local LocalPlayer = game:GetService("Players").LocalPlayer
local MainFrame, inputRadius, inputSteps, inputSizeY, inputBlockType = core.MainFrame, core.inputRadius, core.inputSteps, core.inputSizeY, core.inputBlockType
local statusLabel, btnBuild = buttons.statusLabel, buttons.btnBuild
local BlockPanel, dataFolder = invData.BlockPanel, invData.dataFolder
local previewFolder, folder = pipeline.previewFolder, pipeline.folder

btnBuild.MouseButton1Click:Connect(function()
	if not _G.CBuilder_CenterPos then return end
	local blockStr = tostring(inputBlockType.Text)
	local inventoryItem = dataFolder and dataFolder:FindFirstChild(blockStr)
	if not inventoryItem or inventoryItem.Value <= 0 then statusLabel.Text = "Build Failed: Out of Blocks!" statusLabel.TextColor3 = Color3.fromRGB(255,80,80) return end
	
	local radius, steps, sizeY = tonumber(inputRadius.Text) or 20, tonumber(inputSteps.Text) or 30, tonumber(inputSizeY.Text) or 2
	local sizeZ = (2 * math.pi * radius) / steps local sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02
	local function getRF(n) local tl = LocalPlayer.Backpack:FindFirstChild(n) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(n)) return tl and tl:FindFirstChild("RF") end
	local bRF, sRF, pRF = getRF("BuildingTool"), getRF("ScalingTool"), getRF("PaintingTool")
	if not bRF or not sRF or not pRF then statusLabel.Text = "Missing Tools!" return end
	
	previewFolder:ClearAllChildren() BlockPanel.Visible = false btnBuild.Text, btnBuild.Active = "Constructing Active Sector Matrix...", false
	
	for i = 1, steps do
		if inventoryItem.Value <= 0 then statusLabel.Text = "Stopped: Empty Inventory!" statusLabel.TextColor3 = Color3.fromRGB(255,80,80) break end
		local angle = (i / steps) * math.pi * 2
		local p = Vector3.new(_G.CBuilder_CenterPos.X + math.cos(angle) * radius, _G.CBuilder_CenterPos.Y, _G.CBuilder_CenterPos.Z + math.sin(angle) * radius)
		local pCF, hCF = CFrame.lookAt(p, _G.CBuilder_CenterPos), CFrame.new(p) * CFrame.Angles(0, angle, 0)
		local initialCount = #folder:GetChildren()
		
		-- Dynamic invocation passing item name and live data value total counts
		bRF:InvokeServer(blockStr, inventoryItem.Value, Instance.new("Part", nil), pCF, true, hCF, false)
		
		local newBlock, loops = nil, 0
		while not newBlock and loops < 30 do task.wait(0.01) if #folder:GetChildren() > initialCount then newBlock = folder:GetChildren()[#folder:GetChildren()] end loops = loops + 1 end
		if newBlock then
			sRF:InvokeServer(newBlock, Vector3.new(sizeX, sizeY, sizeZ), pCF) task.wait(0.01)
			pRF:InvokeServer({{{ newBlock, Color3.new(1,1,1) }, { newBlock, Color3.new(1,1,1) }, { newBlock, Color3.new(1,1,1) }, { newBlock, Color3.new(1,1,1) }}})
		end
		task.wait(0.02)
	end
	btnBuild.Text, btnBuild.Active = "Commence Circle Construction", true
	if statusLabel.Text ~= "Stopped: Empty Inventory!" then statusLabel.Text = "Matrix Sequence Completed!" statusLabel.TextColor3 = Color3.fromRGB(80, 240, 80) end
end)
-- // END OF FILE: Part_5.lua //
