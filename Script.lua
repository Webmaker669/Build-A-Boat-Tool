-- =============================================================================
-- CIRCLE BUILDER SUITE: UNIFIED MASTER ARRAYS & EXPLOIT SYSTEM ENGINE
-- =============================================================================
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Automatic Interface Cleaners to prevent overlapping or duplicate frames
if CoreGui:FindFirstChild("CircleBuilderUI") then
	CoreGui.CircleBuilderUI:Destroy()
end

-- =============================================================================
-- STAGE 1: SYSTEM SETUP & WINDOW STRUCTURE INTERFACE CONTROLS
-- =============================================================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CircleBuilderUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 600) -- Expanded height to guarantee layout fit
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.BorderSizePixel = 0
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
Title.Text = " CIRCLE BUILDER SUITE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
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
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local HelpBtn = Instance.new("TextButton", MainFrame)
HelpBtn.Size = UDim2.new(0, 30, 0, 30)
HelpBtn.Position = UDim2.new(1, -75, 0, 7)
HelpBtn.Text = "?"
HelpBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
HelpBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
HelpBtn.Font = Enum.Font.GothamBold
HelpBtn.TextSize = 14
Instance.new("UICorner", HelpBtn).CornerRadius = UDim.new(0, 6)

local function createInputField(labelText, yPos, defaultValue, editable)
	local label = Instance.new("TextLabel", MainFrame)
	label.Size = UDim2.new(0, 150, 0, 28)
	label.Position = UDim2.new(0, 15, 0, yPos)
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(190, 190, 195)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	
	local box = Instance.new("TextBox", MainFrame)
	box.Size = UDim2.new(0, 130, 0, 28)
	box.Position = UDim2.new(0, 175, 0, yPos)
	box.Text = defaultValue
	box.TextColor3 = editable and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 125)
	box.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
	box.BorderSizePixel = 0
	box.Font = Enum.Font.GothamSemibold
	box.TextSize = 13
	box.TextEditable = editable
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

-- Adjusted vertical spacing parameters to completely clear out overlap bugs
local inputRadius = createInputField("Circle Radius / Range:", 55, "20", true)
local inputSteps = createInputField("Total Parts Count:", 97, "30", true)
local inputSizeY = createInputField("Block Height (Y):", 139, "2", true)
local inputBlockType = createInputField("Active Block Type:", 181, "PlasticBlock", true)
local inputSizeX = createInputField("Calculated Width (X):", 223, "0.00", false)
local inputSizeZ = createInputField("Calculated Depth (Z):", 265, "0.00", false)

local colorData = { CurrentR = 1, CurrentG = 1, CurrentB = 1, ColorObject = Color3.new(1, 1, 1) }

-- =============================================================================
-- STAGE 2: SUBMENUS & CONTAINER MAPPING OPERATIONS LAYOUTS
-- =============================================================================
local colorLabel = Instance.new("TextLabel", MainFrame)
colorLabel.Size = UDim2.new(0, 150, 0, 30)
colorLabel.Position = UDim2.new(0, 15, 0, 307)
colorLabel.Text = "Active Build Color:"
colorLabel.TextColor3 = Color3.fromRGB(190, 190, 195)
colorLabel.TextSize = 13
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.BackgroundTransparency = 1
colorLabel.Font = Enum.Font.Gotham

local btnColorPicker = Instance.new("TextButton", MainFrame)
btnColorPicker.Size = UDim2.new(0, 130, 0, 28)
btnColorPicker.Position = UDim2.new(0, 175, 0, 307)
btnColorPicker.Text = ""
btnColorPicker.Font = Enum.Font.GothamBold
btnColorPicker.BackgroundColor3 = colorData.ColorObject
Instance.new("UICorner", btnColorPicker).CornerRadius = UDim.new(0, 5)

local statusLabel = Instance.new("TextLabel", MainFrame)
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.new(0, 15, 0, 345) -- Pushed safely under fields
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

local btnSelect = createButton("Select Center Target Block", 385, Color3.fromRGB(0, 122, 215))
local btnPreview = createButton("Hologram Preview Configuration: Disabled", 428, Color3.fromRGB(110, 110, 115))
local btnBuild = createButton("Commence Circle Construction", 471, Color3.fromRGB(46, 139, 87))

local HelpPanel = Instance.new("Frame", MainFrame)
HelpPanel.Name = "HelpSelectionPanel"
HelpPanel.Size = UDim2.new(0, 270, 1, 0)
HelpPanel.Position = UDim2.new(1, 10, 0, 0)
HelpPanel.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
HelpPanel.BorderSizePixel = 0
HelpPanel.Visible = false
Instance.new("UICorner", HelpPanel).CornerRadius = UDim.new(0, 10)

local HelpTitle = Instance.new("TextLabel", HelpPanel)
HelpTitle.Size = UDim2.new(1, 0, 0, 40)
HelpTitle.Text = "SYSTEM OPERATION MANUAL"
HelpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HelpTitle.TextSize = 11
HelpTitle.Font = Enum.Font.GothamBold
HelpTitle.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
Instance.new("UICorner", HelpTitle).CornerRadius = UDim.new(0, 10)

local HelpText = Instance.new("TextLabel", HelpPanel)
HelpText.Size = UDim2.new(1, -20, 1, -50)
HelpText.Position = UDim2.new(0, 10, 0, 45)
HelpText.Text = "<b>1. Configuration Settings:</b>\nInput your circle size range value parameter and the total block count parameters.\n\n<b>2. Target Placement Alignment:</b>\nClick 'Select Center Target Block' and tap any target part folder object to assign coordinates.\n\n<b>3. Visual Blueprint Matrix:</b>\nToggle live holographic mapping previews to safely inspect structural curves before building.\n\n<b>4. Advanced Color Module:</b>\nClick the active fill button to expand RGB sliders or save raw hex values."
HelpText.TextColor3 = Color3.fromRGB(210, 210, 215)
HelpText.TextSize = 12
HelpText.Font = Enum.Font.SourceSans
HelpText.RichText = true
HelpText.TextWrapped = true
HelpText.TextYAlignment = Enum.TextYAlignment.Top
HelpText.TextXAlignment = Enum.TextXAlignment.Left
HelpText.BackgroundTransparency = 1

local ColorPanel = Instance.new("Frame", MainFrame)
ColorPanel.Name = "ColorSelectionPanel"
ColorPanel.Size = UDim2.new(0, 240, 1, 0)
ColorPanel.Position = UDim2.new(1, 10, 0, 0)
ColorPanel.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
ColorPanel.BorderSizePixel = 0
ColorPanel.Visible = false
Instance.new("UICorner", ColorPanel).CornerRadius = UDim.new(0, 10)

local PanelTitle = Instance.new("TextLabel", ColorPanel)
PanelTitle.Size = UDim2.new(1, 0, 0, 40)
PanelTitle.Text = "ADVANCED COLOR SYSTEM"
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.TextSize = 12
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
Instance.new("UICorner", PanelTitle).CornerRadius = UDim.new(0, 10)

local ColorIndicator = Instance.new("Frame", ColorPanel)
ColorIndicator.Name = "ColorIndicator"
ColorIndicator.Size = UDim2.new(1, -30, 0, 40)
ColorIndicator.Position = UDim2.new(0, 15, 0, 55)
ColorIndicator.BackgroundColor3 = colorData.ColorObject
Instance.new("UICorner", ColorIndicator).CornerRadius = UDim.new(0, 5)

local function createColorSlider(channelName, yPos, defaultFraction)
	local label = Instance.new("TextLabel", ColorPanel)
	label.Size = UDim2.new(1, -30, 0, 20)
	label.Position = UDim2.new(0, 15, 0, yPos)
	label.Text = channelName .. ": " .. string.format("%.0f", defaultFraction * 255)
	label.TextColor3 = Color3.fromRGB(180, 180, 185)
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamSemibold

local track = Instance.new("Frame", ColorPanel)track.Size = UDim2.new(1, -30, 0, 6)track.Position = UDim2.new(0, 15, 0, yPos + 22)track.BackgroundColor3 = Color3.fromRGB(55, 55, 60)track.BorderSizePixel = 0Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)local button = Instance.new("TextButton", track)button.Size = UDim2.new(0, 14, 0, 14)button.Position = UDim2.new(defaultFraction, -7, 0.5, -7)button.BackgroundColor3 = Color3.fromRGB(240, 240, 245)button.Text = ""Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)return label, track, buttonendlocal rLabel, rTrack, rBtn = createColorSlider("Red Input", 110, 1)local gLabel, gTrack, gBtn = createColorSlider("Green Input", 160, 1)local bLabel, bTrack, bBtn = createColorSlider("Blue Input", 210, 1)local hexBox = Instance.new("TextBox", ColorPanel)hexBox.Size = UDim2.new(1, -30, 0, 30)hexBox.Position = UDim2.new(0, 15, 0, 295)hexBox.Text = "#FFFFFF"hexBox.TextColor3 = Color3.fromRGB(255, 255, 255)hexBox.BackgroundColor3 = Color3.fromRGB(44, 44, 50)hexBox.BorderSizePixel = 0hexBox.Font = Enum.Font.GothamSemiboldhexBox.TextSize = 12Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 5)-- =============================================================================-- STAGE 3: FLUID BLOCK MATERIAL PICKER & DATA TRACKING LOGIC-- =============================================================================local BlockPanel = Instance.new("Frame", MainFrame)BlockPanel.Name = "BlockSelectionPanel"BlockPanel.Size = UDim2.new(0, 240, 1, 0)BlockPanel.Position = UDim2.new(1, 10, 0, 0)BlockPanel.BackgroundColor3 = Color3.fromRGB(34, 34, 38)BlockPanel.BorderSizePixel = 0BlockPanel.Visible = falseInstance.new("UICorner", BlockPanel).CornerRadius = UDim.new(0, 10)local SelectionTitle = Instance.new("TextLabel", BlockPanel)SelectionTitle.Size = UDim2.new(1, 0, 0, 40)SelectionTitle.Text = "AVAILABLE BUILDING MATERIALS"SelectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)SelectionTitle.TextSize = 11SelectionTitle.Font = Enum.Font.GothamBoldSelectionTitle.BackgroundColor3 = Color3.fromRGB(44, 44, 50)Instance.new("UICorner", SelectionTitle).CornerRadius = UDim.new(0, 10)local ScrollingFrame = Instance.new("ScrollingFrame", BlockPanel)ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)ScrollingFrame.BackgroundTransparency = 1ScrollingFrame.BorderSizePixel = 0ScrollingFrame.ScrollBarThickness = 4ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Ylocal UIListLayout = Instance.new("UIListLayout", ScrollingFrame)UIListLayout.Padding = UDim.new(0, 4)UIListLayout.SortOrder = Enum.SortOrder.Namelocal dataFolder = LocalPlayer:WaitForChild("Data", 5)local function updateInventoryLayout()for _, child in ipairs(ScrollingFrame:GetChildren()) doif child:IsA("TextButton") then child:Destroy() endendif not dataFolder then return endfor _, item in ipairs(dataFolder:GetChildren()) doif item:IsA("ValueBase") and item.Value > 0 and not string.find(item.Name, "Tool") thenlocal itemBtn = Instance.new("TextButton", ScrollingFrame)itemBtn.Size = UDim2.new(1, -5, 0, 30)itemBtn.Text = "  " .. item.Name .. " (" .. tostring(item.Value) .. ")"itemBtn.TextColor3 = (inputBlockType.Text == item.Name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 195)itemBtn.BackgroundColor3 = (inputBlockType.Text == item.Name) and Color3.fromRGB(0, 122, 215) or Color3.fromRGB(44, 44, 50)itemBtn.Font = Enum.Font.GothamSemibolditemBtn.TextSize = 11itemBtn.TextXAlignment = Enum.TextXAlignment.LeftitemBtn.BorderSizePixel = 0Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)itemBtn.MouseButton1Click:Connect(function()inputBlockType.Text = item.NameBlockPanel.Visible = falseupdateInventoryLayout()if _G.updateRealtimeVisualizerRingGlobal then_G.updateRealtimeVisualizerRingGlobal()endend)endendendinputBlockType.Focused:Connect(function()ColorPanel.Visible = falseHelpPanel.Visible = falseBlockPanel.Visible = trueupdateInventoryLayout()end)if dataFolder thendataFolder.ChildAdded:Connect(updateInventoryLayout)for _, item in ipairs(dataFolder:GetChildren()) doif item:IsA("ValueBase") thenitem.Changed:Connect(function()if inputBlockType.Text == item.Name and item.Value <= 0 theninputBlockType.Text = "PlasticBlock"endupdateInventoryLayout()end)endendend-- =============================================================================-- STAGE 4: PHYSICS GRAPHICS HOOKS & Ring VISUALIZER MATRICES-- =============================================================================local CopyBox = Instance.new("TextBox", MainFrame)CopyBox.Size = UDim2.new(1, -30, 0, 32)CopyBox.Position = UDim2.new(0, 15, 1, -45)CopyBox.Text = "discord.gg"CopyBox.TextColor3 = Color3.fromRGB(114, 137, 218)CopyBox.BackgroundColor3 = Color3.fromRGB(44, 47, 51)CopyBox.Font = Enum.Font.GothamBoldCopyBox.TextSize = 11CopyBox.ClearTextOnFocus = falseCopyBox.TextEditable = falseInstance.new("UICorner", CopyBox).CornerRadius = UDim.new(0, 6)if workspace:FindFirstChild("CirclePreviewFolder") thenworkspace.CirclePreviewFolder:Destroy()endlocal previewFolder = Instance.new("Folder", workspace)previewFolder.Name = "CirclePreviewFolder"local selectionBox = Instance.new("SelectionBox", CoreGui)selectionBox.Color3 = Color3.fromRGB(0, 255, 255)selectionBox.LineThickness = 0.04local showLivePreview = falselocal selectedCenterPos = nilCloseBtn.MouseButton1Click:Connect(function()MainFrame.Visible = falseReopenButton.Visible = trueColorPanel.Visible = falseHelpPanel.Visible = falseBlockPanel.Visible = falseend)ReopenButton.MouseButton1Click:Connect(function()MainFrame.Visible = trueReopenButton.Visible = falseend)btnColorPicker.MouseButton1Click:Connect(function()HelpPanel.Visible = falseBlockPanel.Visible = falseColorPanel.Visible = not ColorPanel.Visibleend)HelpBtn.MouseButton1Click:Connect(function()ColorPanel.Visible = falseBlockPanel.Visible = falseHelpPanel.Visible = not HelpPanel.Visibleend)local function updateRealtimeVisualizerRing()previewFolder:ClearAllChildren()if not selectedCenterPos then return endlocal radius = tonumber(inputRadius.Text) or 20local steps = tonumber(inputSteps.Text) or 30local sizeY = tonumber(inputSizeY.Text) or 2local circumference = 2 * math.pi * radiuslocal sizeZ = circumference / stepslocal sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02inputSizeX.Text, inputSizeZ.Text = string.format("%.3f", sizeX), string.format("%.3f", sizeZ)if not showLivePreview then return endfor i = 1, steps dolocal angle = (i / steps) * math.pi * 2local targetPlacementPos = Vector3.new(selectedCenterPos.X + math.cos(angle) * radius, selectedCenterPos.Y, selectedCenterPos.Z + math.sin(angle) * radius)local hPart = Instance.new("Part")hPart.Size = Vector3.new(sizeX, sizeY, sizeZ)hPart.CFrame = CFrame.lookAt(targetPlacementPos, selectedCenterPos)hPart.Color = colorData.ColorObjecthPart.Transparency = 0.5hPart.Anchored = truehPart.CanCollide = falsehPart.Material = Enum.Material.SmoothPlastichPart.Parent = previewFolderlocal sb = Instance.new("SelectionBox", hPart)sb.Adornee = hPartsb.Color3 = colorData.ColorObjectsb.LineThickness = 0.02endend_G.updateRealtimeVisualizerRingGlobal = updateRealtimeVisualizerRinglocal function applyColorTransformations()colorData.ColorObject = Color3.new(colorData.CurrentR, colorData.CurrentG, colorData.CurrentB)ColorIndicator.BackgroundColor3, btnColorPicker.BackgroundColor3 = colorData.ColorObject, colorData.ColorObjectupdateRealtimeVisualizerRing()endlocal function attachSliderPhysics(button, track, label, prefix, channelCallback)local isDragging = falsebutton.MouseButton1Down:Connect(function() isDragging = true end)UserInputService.InputChanged:Connect(function(input)if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement thenlocal relativeX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)button.Position = UDim2.new(relativeX, -7, 0.5, -7)label.Text = prefix .. ": " .. string.format("%.0f", relativeX * 255)channelCallback(relativeX)applyColorTransformations()endend)UserInputService.InputEnded:Connect(function(input)if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false endend)endattachSliderPhysics(rBtn, rTrack, rLabel, "Red Input", function(val) colorData.CurrentR = val end)attachSliderPhysics(gBtn, gTrack, gLabel, "Green Input", function(val) colorData.CurrentG = val end)attachSliderPhysics(bBtn, bTrack, bBtn, "Blue Input", function(val) colorData.CurrentB = val end)hexBox.FocusLost:Connect(function()local text = hexBox.Text:gsub("#", "")if #text == 6 thenlocal r, g, b = tonumber(text:sub(1, 2), 16), tonumber(text:sub(3, 4), 16), tonumber(text:sub(5, 6), 16)if r and g and b thencolorData.CurrentR, colorData.CurrentG, colorData.CurrentB = r / 255, g / 255, b / 255rBtn.Position = UDim2.new(colorData.CurrentR, -7, 0.5, -7)gBtn.Position = UDim2.new(colorData.CurrentG, -7, 0.5, -7)bBtn.Position = UDim2.new(colorData.CurrentB, -7, 0.5, -7)rLabel.Text, gLabel.Text, bLabel.Text = "Red Input: "..r, "Green Input: "..g, "Blue Input: "..bapplyColorTransformations()endendend)for _, box in ipairs({inputRadius, inputSteps, inputSizeY}) dobox:GetPropertyChangedSignal("Text"):Connect(updateRealtimeVisualizerRing)endbtnPreview.MouseButton1Click:Connect(function()showLivePreview = not showLivePreviewbtnPreview.Text = showLivePreview and "Hologram Preview Configuration: Active" or "Hologram Preview Configuration: Disabled"btnPreview.BackgroundColor3 = showLivePreview and Color3.fromRGB(155, 80, 180) or Color3.fromRGB(110, 110, 115)updateRealtimeVisualizerRing()end)-- =============================================================================-- STAGE 5: RAYCAST TARGET LOCKS & SERVER REMOTE PLACEMENT Matrix-- =============================================================================local folder = workspace:WaitForChild("Blocks", 5):WaitForChild(LocalPlayer.Name, 5)btnSelect.MouseButton1Click:Connect(function()if isSelecting then return endisSelecting = truestatusLabel.Text, statusLabel.TextColor3, btnSelect.Text = "Hover over canvas plot area and select node...", Color3.fromRGB(240, 180, 20), "Awaiting Target Confirmation..."local renderConnection, clickConnectionrenderConnection = RunService.RenderStepped:Connect(function()local target = Mouse.TargetselectionBox.Adornee = (target and target:IsA("BasePart")) and target or nilend)clickConnection = Mouse.Button1Down:Connect(function()local target = Mouse.Targetif target and target:IsA("BasePart") thenselectedCenterPos = target.PositionstatusLabel.Text = "Anchor Node Position Synchronized: " .. target.NamestatusLabel.TextColor3 = Color3.fromRGB(80, 240, 80)renderConnection:Disconnect()clickConnection:Disconnect()selectionBox.Adornee = nilisSelecting = falsebtnSelect.Text = "Select Center Target Block"updateRealtimeVisualizerRing()endend)end)btnBuild.MouseButton1Click:Connect(function()if isSelecting or not selectedCenterPos then return endlocal selectedBlockString = tostring(inputBlockType.Text)local blockTrackValueInstance = dataFolder and dataFolder:FindFirstChild(selectedBlockString)if not blockTrackValueInstance or (blockTrackValueInstance:IsA("ValueBase") and blockTrackValueInstance.Value <= 0) thenstatusLabel.Text = "Build Failed: Out of " .. selectedBlockString .. "!"statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)returnendlocal radius, steps, sizeY = tonumber(inputRadius.Text) or 20, tonumber(inputSteps.Text) or 30, tonumber(inputSizeY.Text) or 2local circumference = 2 * math.pi * radiuslocal sizeZ, sizeX = circumference / steps, (2 * radius * math.tan(math.pi / steps)) + 0.02local function findRemote(tName)local tl = LocalPlayer.Backpack:FindFirstChild(tName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(tName))return tl and tl:FindFirstChild("RF")endlocal bRF, sRF, pRF = findRemote("BuildingTool"), findRemote("ScalingTool"), findRemote("PaintingTool")if not bRF or not sRF or not pRF thenstatusLabel.Text, statusLabel.TextColor3 = "Hardware Fault: Missing active utilities!", Color3.fromRGB(255, 80, 80)returnendshowLivePreview = falsebtnPreview.Text, btnPreview.BackgroundColor3 = "Hologram Preview Configuration: Disabled", Color3.fromRGB(110, 110, 115)previewFolder:ClearAllChildren()ColorPanel.Visible, HelpPanel.Visible, BlockPanel.Visible = false, false, falsebtnBuild.Text, btnBuild.Active = "Constructing Active Sector Matrix...", falsefor i = 1, steps doif blockTrackValueInstance and blockTrackValueInstance.Value <= 0 thenstatusLabel.Text = "Interrupted: Ran out of " .. selectedBlockString .. "!"statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)breakendlocal angle = (i / steps) * math.pi * 2local targetPlacementPos = Vector3.new(selectedCenterPos.X + math.cos(angle) * radius, selectedCenterPos.Y, selectedCenterPos.Z + math.sin(angle) * radius)local pCF, hCF = CFrame.lookAt(targetPlacementPos, selectedCenterPos), CFrame.new(targetPlacementPos) * CFrame.Angles(0, angle, 0)local initialChildren = folder:GetChildren()-- Passes your live total count value straight into the remote deployment network loopsbRF:InvokeServer(selectedBlockString, blockTrackValueInstance.Value, Instance.new("Part", nil), pCF, true, hCF, false)
