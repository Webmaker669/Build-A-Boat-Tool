-- Modern Luau Environmental References & Structural Optimizations
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Prevent memory leak duplication overlaps
if CoreGui:FindFirstChild("CircleBuilderUI") then CoreGui.CircleBuilderUI:Destroy() end
if workspace:FindFirstChild("CirclePreviewFolder") then workspace.CirclePreviewFolder:Destroy() end

-- Shared Pipeline State Management Vectors
local SelectedCenterPos = nil
local IsSelectingAnchor = false
local ShowHologramBlueprint = false
local MixedColorObject = Color3.new(1, 1, 1)
local ActiveBlockModelName = "PlasticBlock"

-- Core UI Display Frame Infrastructure Instantiation
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CircleBuilderUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 520)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Re-open Restoration Handle Setup
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
Title.Text = "   CIRCLE BUILDER SUITE"
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

-- Parametric Input Factory Pipeline Wrapper
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

local inputRadius = createInputField("Circle Radius / Range:", 60, "20", true)
local inputSteps  = createInputField("Total Parts Count:", 100, "30", true)
local inputSizeY  = createInputField("Block Height (Y):", 140, "2", true)
local inputSizeX  = createInputField("Calculated Width (X):", 180, "0.00", false)
local inputSizeZ  = createInputField("Calculated Depth (Z):", 220, "0.00", false)

local colorLabel = Instance.new("TextLabel", MainFrame)
colorLabel.Size = UDim2.new(0, 150, 0, 30)
colorLabel.Position = UDim2.new(0, 15, 0, 260)
colorLabel.Text = "Active Build Color:"
colorLabel.TextColor3 = Color3.fromRGB(190, 190, 195)
colorLabel.TextSize = 13
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.BackgroundTransparency = 1
colorLabel.Font = Enum.Font.Gotham

local btnColorPicker = Instance.new("TextButton", MainFrame)
btnColorPicker.Size = UDim2.new(0, 130, 0, 28)
btnColorPicker.Position = UDim2.new(0, 175, 0, 260)
btnColorPicker.Text = ""
btnColorPicker.Font = Enum.Font.GothamBold
btnColorPicker.BackgroundColor3 = MixedColorObject
Instance.new("UICorner", btnColorPicker).CornerRadius = UDim.new(0, 5)

local statusLabel = Instance.new("TextLabel", MainFrame)
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.new(0, 15, 0, 295)
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

local btnSelect  = createButton("Select Center Target Block", 335, Color3.fromRGB(0, 122, 215))
local btnPreview = createButton("Hologram Preview Configuration: Disabled", 376, Color3.fromRGB(110, 110, 115))
local btnBuild   = createButton("Commence Circle Construction", 417, Color3.fromRGB(46, 139, 87))

-- Professional High-Resolution Operation Manual Panel Layout
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

-- Advanced Custom RGB Color Selection Sliding Subpanel Module Layout
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
ColorIndicator.BackgroundColor3 = MixedColorObject
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

    local track = Instance.new("Frame", ColorPanel)
    track.Size = UDim2.new(1, -30, 0, 6)
    track.Position = UDim2.new(0, 15, 0, yPos + 22)
    track.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    track.BorderSizePixel = 0

    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)local button = Instance.new("TextButton", track)button.Size = UDim2.new(0, 14, 0, 14)button.Position = UDim2.new(defaultFraction, -7, 0.5, -7)button.BackgroundColor3 = Color3.fromRGB(240, 240, 245)button.Text = ""Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)return label, track, buttonendlocal rLabel, rTrack, rBtn = createColorSlider("Red Input", 110, 1)local gLabel, gTrack, gBtn = createColorSlider("Green Input", 160, 1)local bLabel, bTrack, bBtn = createColorSlider("Blue Input", 210, 1)local hexBox = Instance.new("TextBox", ColorPanel)hexBox.Size = UDim2.new(1, -30, 0, 30)hexBox.Position = UDim2.new(0, 15, 0, 295)hexBox.Text = "#FFFFFF"hexBox.TextColor3 = Color3.fromRGB(255, 255, 255)hexBox.BackgroundColor3 = Color3.fromRGB(44, 44, 50)hexBox.BorderSizePixel = 0hexBox.Font = Enum.Font.GothamSemiboldhexBox.TextSize = 12Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 5)-- Community Clipboard Interface Hook Integration Footer Buttonlocal DiscordBtn = Instance.new("TextButton", MainFrame)DiscordBtn.Size = UDim2.new(1, -30, 0, 32)DiscordBtn.Position = UDim2.new(0, 15, 1, -45)DiscordBtn.Text = "Reviews and Suggestions: Discord Link"DiscordBtn.TextColor3 = Color3.fromRGB(114, 137, 218)DiscordBtn.BackgroundColor3 = Color3.fromRGB(44, 47, 51)DiscordBtn.Font = Enum.Font.GothamBoldDiscordBtn.TextSize = 11Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)-- Workspace Instantiated Virtual Environments Configuration Layerslocal previewFolder = Instance.new("Folder", workspace)previewFolder.Name = "CirclePreviewFolder"local selectionBox = Instance.new("SelectionBox", CoreGui)selectionBox.Color3 = Color3.fromRGB(0, 255, 255)selectionBox.LineThickness = 0.04-- Geometric Resolution Structural Vector Calculation Engine Functionslocal function updateRealtimeVisualizerRing()previewFolder:ClearAllChildren()if not SelectedCenterPos then return endlocal radius = tonumber(inputRadius.Text) or 20local steps  = tonumber(inputSteps.Text) or 30local sizeY  = tonumber(inputSizeY.Text) or 2local circumference = 2 * math.pi * radiuslocal sizeZ = circumference / stepslocal sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02inputSizeX.Text = string.format("%.3f", sizeX)inputSizeZ.Text = string.format("%.3f", sizeZ)if not ShowHologramBlueprint then return endfor i = 1, steps dolocal angle = (i / steps) * math.pi * 2local targetPlacementPos = Vector3.new(SelectedCenterPos.X + math.cos(angle) * radius, SelectedCenterPos.Y, SelectedCenterPos.Z + math.sin(angle) * radius)local hPart = Instance.new("Part")hPart.Size = Vector3.new(sizeX, sizeY, sizeZ)hPart.CFrame = CFrame.lookAt(targetPlacementPos, SelectedCenterPos)hPart.Color = MixedColorObjecthPart.Transparency = 0.5hPart.Anchored = truehPart.CanCollide = falsehPart.Material = Enum.Material.SmoothPlastichPart.Parent = previewFolderlocal sb = Instance.new("SelectionBox", hPart)sb.Adornee = hPartsb.Color3 = MixedColorObjectsb.LineThickness = 0.015endend-- Physics Modification State Sync Subroutineslocal function applyColorTransformations()ColorIndicator.BackgroundColor3 = MixedColorObjectbtnColorPicker.BackgroundColor3 = MixedColorObjectupdateRealtimeVisualizerRing()endlocal function attachSliderPhysics(button, track, label, prefix, channelCallback)local isDragging = falsebutton.MouseButton1Down:Connect(function() isDragging = true end)UserInputService.InputChanged:Connect(function(input)if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement thenlocal relativeX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)button.Position = UDim2.new(relativeX, -7, 0.5, -7)label.Text = prefix .. ": " .. string.format("%.0f", relativeX * 255)channelCallback(relativeX)MixedColorObject = Color3.new(rBtn.Position.X.Scale, gBtn.Position.X.Scale, bBtn.Position.X.Scale)applyColorTransformations()endend)UserInputService.InputEnded:Connect(function(input)if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false endend)endattachSliderPhysics(rBtn, rTrack, rLabel, "Red Input",   function() end)attachSliderPhysics(gBtn, gTrack, gLabel, "Green Input", function() end)attachSliderPhysics(bBtn, bTrack, bLabel, "Blue Input",  function() end)-- Modern String Hex Code Value Parser Matrix ImplementationhexBox.FocusLost:Connect(function()local text = hexBox.Text:gsub("#", "")if #text == 6 thenlocal r = tonumber(text:sub(1, 2), 16)local g = tonumber(text:sub(3, 4), 16)local b = tonumber(text:sub(5, 6), 16)if r and g and b thenrBtn.Position = UDim2.new(r / 255, -7, 0.5, -7)gBtn.Position = UDim2.new(g / 255, -7, 0.5, -7)bBtn.Position = UDim2.new(b / 255, -7, 0.5, -7)rLabel.Text, gLabel.Text, bLabel.Text = "Red Input: "..r, "Green Input: "..g, "Blue Input: "..bMixedColorObject = Color3.new(r / 255, g / 255, b / 255)applyColorTransformations()endendend)-- Action Trigger Mapping Hook Closuresfor _, box in ipairs({inputRadius, inputSteps, inputSizeY}) dobox:GetPropertyChangedSignal("Text"):Connect(updateRealtimeVisualizerRing)endCloseBtn.MouseButton1Click:Connect(function()MainFrame.Visible = falseReopenButton.Visible = trueColorPanel.Visible = falseHelpPanel.Visible = falseend)ReopenButton.MouseButton1Click:Connect(function()MainFrame.Visible = trueReopenButton.Visible = falseend)btnColorPicker.MouseButton1Click:Connect(function()HelpPanel.Visible = falseColorPanel.Visible = not ColorPanel.Visibleend)HelpBtn.MouseButton1Click:Connect(function()ColorPanel.Visible = falseHelpPanel.Visible = not HelpPanel.Visibleend)btnPreview.MouseButton1Click:Connect(function()ShowHologramBlueprint = not ShowHologramBlueprintif ShowHologramBlueprint thenbtnPreview.Text, btnPreview.BackgroundColor3 = "Hologram Preview Configuration: Active", Color3.fromRGB(155, 80, 180)elsebtnPreview.Text, btnPreview.BackgroundColor3 = "Hologram Preview Configuration: Disabled", Color3.fromRGB(110, 110, 115)endupdateRealtimeVisualizerRing()end)DiscordBtn.MouseButton1Click:Connect(function()local targetUrl = "discord.gg"local clipboardFunc = setclipboard or toclipboard or (Clipboard and Clipboard.set)if clipboardFunc thenclipboardFunc(targetUrl)DiscordBtn.Text = "Link Copied to Clipboard!"DiscordBtn.TextColor3 = Color3.fromRGB(80, 240, 80)task.delay(2, function()DiscordBtn.Text = "Reviews and Suggestions: Discord Link"DiscordBtn.TextColor3 = Color3.fromRGB(114, 137, 218)end)endend)-- Interactive Plot Raycast Selection EnginebtnSelect.MouseButton1Click:Connect(function()if IsSelectingAnchor then return endIsSelectingAnchor = truestatusLabel.Text, statusLabel.TextColor3, btnSelect.Text = "Hover over canvas plot area and select node...", Color3.fromRGB(240, 180, 20), "Awaiting Target Confirmation..."local renderConnection, clickConnectionrenderConnection = RunService.RenderStepped:Connect(function()local target = Mouse.Targetif target and target:IsA("BasePart") then selectionBox.Adornee = target else selectionBox.Adornee = nil endend)clickConnection = Mouse.Button1Down:Connect(function()local target = Mouse.Targetif target and target:IsA("BasePart") thenSelectedCenterPos = target.PositionstatusLabel.Text = "Anchor Node Position Synchronized: " .. target.NamestatusLabel.TextColor3 = Color3.fromRGB(80, 240, 80)renderConnection:Disconnect()clickConnection:Disconnect()selectionBox.Adornee = nilIsSelectingAnchor = falsebtnSelect.Text = "Select Center Target Block"updateRealtimeVisualizerRing()endend)end)-- Network Core Placement Invoke Loop EnginebtnBuild.MouseButton1Click:Connect(function()if IsSelectingAnchor or not SelectedCenterPos then return endlocal radius = tonumber(inputRadius.Text) or 20local steps  = tonumber(inputSteps.Text) or 30local sizeY  = tonumber(inputSizeY.Text) or 2local circumference = 2 * math.pi * radiuslocal sizeZ = circumference / stepslocal sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02local function findRemote(tName)local tl = LocalPlayer.Backpack:FindFirstChild(tName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(tName))return tl and tl:FindFirstChild("RF")endlocal bRF, sRF, pRF = findRemote("BuildingTool"), findRemote("ScalingTool"), findRemote("PaintingTool")if not bRF or not sRF or not pRF thenstatusLabel.Text, statusLabel.TextColor3 = "Hardware Fault: Missing active utilities!", Color3.fromRGB(255, 80, 80)returnendShowHologramBlueprint = falsebtnPreview.Text, btnPreview.BackgroundColor3 = "Hologram Preview Configuration: Disabled", Color3.fromRGB(110, 110, 115)previewFolder:ClearAllChildren()ColorPanel.Visible = falseHelpPanel.Visible = falsebtnBuild.Text, btnBuild.Active = "Constructing Active Sector Matrix...", falselocal folder = workspace:WaitForChild("Blocks", 5):WaitForChild(LocalPlayer.Name, 5)for i = 1, steps dolocal angle = (i / steps) * math.pi * 2local targetPlacementPos = Vector3.new(SelectedCenterPos.X + math.cos(angle) * radius, SelectedCenterPos.Y, SelectedCenterPos.Z + math.sin(angle) * radius)local pCF = CFrame.lookAt(targetPlacementPos, SelectedCenterPos)local hCF = CFrame.new(targetPlacementPos) * CFrame.Angles(0, angle, 0)local initialChildren = folder:GetChildren()bRF:InvokeServer(ActiveBlockModelName, 8001, Instance.new("Part", nil), pCF, true, hCF, false)local dynamicBlockPath, retries = nil, 0while not dynamicBlockPath and retries < 30 dotask.wait(0.01)local currentChildren = folder:GetChildren()if #currentChildren > #initialChildren then dynamicBlockPath = currentChildren[#currentChildren] endretries = retries + 1endif dynamicBlockPath thenlocal sVec = (vector and vector.create) and vector.create(sizeX, sizeY, sizeZ) or Vector3.new(sizeX, sizeY, sizeZ)sRF:InvokeServer(dynamicBlockPath, sVec, pCF)task.wait(0.01)pRF:InvokeServer({{{dynamicBlockPath, MixedColorObject}, {dynamicBlockPath, MixedColorObject}, {dynamicBlockPath, MixedColorObject}}})endtask.wait(0.03)endbtnBuild.Text, btnBuild.Active = "Commence Circle Construction", truestatusLabel.Text, statusLabel.TextColor3 = "Matrix Sequence Completed!", Color3.fromRGB(80, 240, 80)end)
