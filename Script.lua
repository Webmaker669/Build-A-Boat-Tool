-- =============================================================================
-- MATRIX CONFIGURATION: EXTRA INTERFACE EXTENSIONS & ITEM SELECTOR
-- =============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

local uiData = _G.CircleBuilderUI_SharedData
local colorData = _G.ActiveCircleBuilderColorData

if not uiData or not uiData.updateRealtimeVisualizerRing then 
	error("Sequence Interrupted: Run Part 3 first.") 
end

local MainFrame = uiData.MainFrame
local inputRadius = uiData.inputRadius
local inputSteps = uiData.inputSteps
local inputSizeY = uiData.inputSizeY
local statusLabel = uiData.statusLabel
local btnPreview = uiData.btnPreview
local btnBuild = uiData.btnBuild
local previewFolder = uiData.previewFolder
local btnSelect = uiData.btnSelect
local selectionBox = uiData.selectionBox
local ColorPanel = uiData.ColorPanel
local HelpPanel = uiData.HelpPanel

local isSelecting = false
local dataFolder = LocalPlayer:WaitForChild("Data")

-- Adapt UI dimensions side-by-side to accommodate materials menu gracefully
MainFrame.Size = UDim2.new(0, 580, 0, 520)

local InvPanel = Instance.new("Frame", MainFrame)
InvPanel.Name = "DynamicInventoryContainer"
InvPanel.Size = UDim2.new(0, 220, 1, -20)
InvPanel.Position = UDim2.new(0, 345, 0, 10)
InvPanel.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
InvPanel.BorderSizePixel = 0
Instance.new("UICorner", InvPanel).CornerRadius = UDim.new(0, 10)

local InvTitle = Instance.new("TextLabel", InvPanel)
InvTitle.Size = UDim2.new(1, 0, 0, 35)
InvTitle.Text = "BUILD MATERIALS"
InvTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InvTitle.TextSize = 11
InvTitle.Font = Enum.Font.GothamBold
InvTitle.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
Instance.new("UICorner", InvTitle).CornerRadius = UDim.new(0, 10)

local ToggleInvBtn = Instance.new("TextButton", MainFrame)
ToggleInvBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleInvBtn.Position = UDim2.new(1, -110, 0, 7)
ToggleInvBtn.Text = "📦"
ToggleInvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleInvBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
ToggleInvBtn.Font = Enum.Font.GothamBold
ToggleInvBtn.TextSize = 14
Instance.new("UICorner", ToggleInvBtn).CornerRadius = UDim.new(0, 6)

local ScrollingFrame = Instance.new("ScrollingFrame", InvPanel)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -85)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.Name

local SelectedMaterialLabel = Instance.new("TextLabel", InvPanel)
SelectedMaterialLabel.Size = UDim2.new(1, -10, 0, 25)
SelectedMaterialLabel.Position = UDim2.new(0, 5, 1, -30)
SelectedMaterialLabel.Text = "Selected Material: None"
SelectedMaterialLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
SelectedMaterialLabel.TextSize = 11
SelectedMaterialLabel.Font = Enum.Font.GothamSemibold
SelectedMaterialLabel.BackgroundTransparency = 1
SelectedMaterialLabel.TextXAlignment = Enum.TextXAlignment.Left

_G.SelectedBuildMaterialToken = nil

-- =============================================================================
-- INTERFACE REFRACTION: DYNAMIC REFRESH CYCLES & TOGGLES
-- =============================================================================
ToggleInvBtn.MouseButton1Click:Connect(function()
	InvPanel.Visible = not InvPanel.Visible
	if InvPanel.Visible then
		MainFrame.Size = UDim2.new(0, 580, 0, 520)
		ToggleInvBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
	else
		MainFrame.Size = UDim2.new(0, 330, 0, 520)
		ToggleInvBtn.BackgroundColor3 = Color3.fromRGB(240, 173, 78)
	end
end)

local function updateInventoryLayout()
	for _, child in ipairs(ScrollingFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	for _, item in ipairs(dataFolder:GetChildren()) do
		if item:IsA("ValueBase") and item.Value > 0 then
			if string.find(item.Name, "Tool") then
				continue
			end
			
			local itemBtn = Instance.new("TextButton", ScrollingFrame)
			itemBtn.Size = UDim2.new(1, -5, 0, 28)
			itemBtn.Text = "  " .. item.Name .. " (" .. tostring(item.Value) .. ")"
			itemBtn.TextColor3 = (_G.SelectedBuildMaterialToken == item.Name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 195)
			itemBtn.BackgroundColor3 = (_G.SelectedBuildMaterialToken == item.Name) and Color3.fromRGB(0, 122, 215) or Color3.fromRGB(44, 44, 50)
			itemBtn.Font = Enum.Font.GothamSemibold
			itemBtn.TextSize = 11
			itemBtn.TextXAlignment = Enum.TextXAlignment.Left
			itemBtn.BorderSizePixel = 0
			Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)
			
			itemBtn.MouseButton1Click:Connect(function()
				_G.SelectedBuildMaterialToken = item.Name
				SelectedMaterialLabel.Text = "Selected: " .. item.Name
				updateInventoryLayout()
			end)
		end
	end
end

updateInventoryLayout()
dataFolder.ChildAdded:Connect(updateInventoryLayout)
for _, item in ipairs(dataFolder:GetChildren()) do
	if item:IsA("ValueBase") then
		item.Changed:Connect(function()
			if _G.SelectedBuildMaterialToken == item.Name and item.Value <= 0 then
				_G.SelectedBuildMaterialToken = nil
				SelectedMaterialLabel.Text = "Selected Material: None"
			end
			updateInventoryLayout()
		end)
	end
end

-- =============================================================================
-- RAYCAST ROUTINES: COORDINATE EXTRACTION & RENDERING CONNECTIONS
-- =============================================================================
btnSelect.MouseButton1Click:Connect(function()
	if isSelecting then return end
	isSelecting = true
	statusLabel.Text, statusLabel.TextColor3, btnSelect.Text = "Hover over canvas plot area and select node...", Color3.fromRGB(240, 180, 20), "Awaiting Target Confirmation..."
	
	local renderConnection, clickConnection
	renderConnection = RunService.RenderStepped:Connect(function()
		local target = Mouse.Target
		if target and target:IsA("BasePart") then
			selectionBox.Adornee = target
		else
			selectionBox.Adornee = nil
		end
	end)
	
	clickConnection = Mouse.Button1Down:Connect(function()
		local target = Mouse.Target
		if target and target:IsA("BasePart") then
			uiData.selectedCenterPos = target.Position
			statusLabel.Text = "Anchor Node Position Synchronized: " .. target.Name
			statusLabel.TextColor3 = Color3.fromRGB(80, 240, 80)
			renderConnection:Disconnect()
			clickConnection:Disconnect()
			selectionBox.Adornee = nil
			isSelecting = false
			btnSelect.Text = "Select Center Target Block"
			uiData.updateRealtimeVisualizerRing()
		end
	end)
end)

-- =============================================================================
-- PLACEMENT PIPELINE: HARDWARE VERIFICATION & REMOTE PIPES
-- =============================================================================
btnBuild.MouseButton1Click:Connect(function()
	local selectedCenterPos = uiData.selectedCenterPos
	if isSelecting or not selectedCenterPos then 
		statusLabel.Text, statusLabel.TextColor3 = "Error: Select Center Target First!", Color3.fromRGB(255, 80, 80)
		return 
	end
	
	if not _G.SelectedBuildMaterialToken then
		statusLabel.Text, statusLabel.TextColor3 = "Error: Choose a Build Material Item!", Color3.fromRGB(255, 80, 80)
		return
	end
	
	local materialCheck = dataFolder:FindFirstChild(_G.SelectedBuildMaterialToken)
	if not materialCheck or materialCheck.Value <= 0 then
		statusLabel.Text, statusLabel.TextColor3 = "Error: Material completely empty!", Color3.fromRGB(255, 80, 80)
		return
	end

	local radius = tonumber(inputRadius.Text) or 20
	local steps = tonumber(inputSteps.Text) or 30
	local sizeY = tonumber(inputSizeY.Text) or 2
	
	local circumference = 2 * math.pi * radius
	local sizeZ = circumference / steps
	local sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02
	
	local function findRemote(tName)
		local tl = LocalPlayer.Backpack:FindFirstChild(tName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(tName))
		return tl and tl:FindFirstChild("RF")
	end
	
	local bRF, sRF, pRF = findRemote("BuildingTool"), findRemote("ScalingTool"), findRemote("PaintingTool")
	if not bRF or not sRF or not pRF then
		statusLabel.Text, statusLabel.TextColor3 = "Hardware Fault: Missing active utilities!", Color3.fromRGB(255, 80, 80)
		return
	end
	
	btnPreview.Text, btnPreview.BackgroundColor3 = "Hologram Preview Configuration: Disabled", Color3.fromRGB(110, 110, 115)
	previewFolder:ClearAllChildren()
	ColorPanel.Visible = false
	HelpPanel.Visible = false
	
	btnBuild.Text, btnBuild.Active = "Constructing Active Sector Matrix...", false
	local folder = workspace:WaitForChild("Blocks", 5):WaitForChild(LocalPlayer.Name, 5)
	
	for i = 1, steps do
		if materialCheck.Value <= 0 then
			statusLabel.Text, statusLabel.TextColor3 = "Interrupted: Ran out of materials!", Color3.fromRGB(255, 80, 80)
			break
		end

		local angle = (i / steps) * math.pi * 2
		local targetPlacementPos = Vector3.new(selectedCenterPos.X + math.cos(angle) * radius, selectedCenterPos.Y, selectedCenterPos.Z + math.sin(angle) * radius)
		
		local pCF, hCF = CFrame.lookAt(targetPlacementPos, selectedCenterPos), CFrame.new(targetPlacementPos) * CFrame.Angles(0, angle, 0)
		local initialChildren = folder:GetChildren()
		
		-- PASSES DYNAMIC TOKEN DIRECTLY TO SERVER REMOTE
		bRF:InvokeServer(_G.SelectedBuildMaterialToken, 8001, Instance.new("Part", nil), pCF, true, hCF, false)
		
		local dynamicBlockPath, retries = nil, 0
		while not dynamicBlockPath and retries < 30 do
			task.wait(0.01)
			local currentChildren = folder:GetChildren()
			if #currentChildren > #initialChildren then
				dynamicBlockPath = currentChildren[#currentChildren]
			end
			retries = retries + 1
		end
		
		if dynamicBlockPath then
			local sVec = Vector3.new(sizeX, sizeY, sizeZ)
			sRF:InvokeServer(dynamicBlockPath, sVec, pCF)
			task.wait(0.01)
			
			local col = colorData.ColorObject
			local args = {
				{
					{ dynamicBlockPath, col },
					{ dynamicBlockPath, col },
					{ dynamicBlockPath, col },
					{ dynamicBlockPath, col }
				}
			}
			pRF:InvokeServer(unpack(args))
		end
		task.wait(0.03)
	end
	
	btnBuild.Text, btnBuild.Active = "Commence Circle Construction", true
	statusLabel.Text, statusLabel.TextColor3 = "Matrix Sequence Completed!", Color3.fromRGB(80, 240, 80)
end)

-- // END OF FILE: Part_4_Engine.lua //
