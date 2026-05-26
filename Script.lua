-- =============================================================================
-- SYSTEM SETUP: WINDOW FRAME & INTERFACE CONTROLS
-- =============================================================================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("CircleBuilderUI") then
    CoreGui.CircleBuilderUI:Destroy()
end

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

local inputRadius = createInputField("Circle Radius / Range:", 60, "20", true)
local inputSteps = createInputField("Total Parts Count:", 100, "30", true)
local inputSizeY = createInputField("Block Height (Y):", 140, "2", true)
local inputSizeX = createInputField("Calculated Width (X):", 180, "0.00", false)
local inputSizeZ = createInputField("Calculated Depth (Z):", 220, "0.00", false)

_G.CircleBuilderUI_SharedData = {
    MainFrame = MainFrame,
    inputRadius = inputRadius,
    inputSteps = inputSteps,
    inputSizeY = inputSizeY,
    inputSizeX = inputSizeX,
    inputSizeZ = inputSizeZ,
    CloseBtn = CloseBtn,
    HelpBtn = HelpBtn,
    ReopenButton = ReopenButton
}

_G.ActiveCircleBuilderColorData = {
    CurrentR = 1,
    CurrentG = 1,
    CurrentB = 1,
    ColorObject = Color3.new(1, 1, 1)
}
-- // END OF FILE: Part_1_UI_Base.lua //

-- =============================================================================
-- INTERFACE LAYOUTS: SUBMENUS & OPERATION MANUALS
-- =============================================================================
local uiData = _G.CircleBuilderUI_SharedData
if not uiData or not uiData.MainFrame then
    error("Run Part 1 first.")
end

local MainFrame = uiData.MainFrame
local colorData = _G.ActiveCircleBuilderColorData

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
btnColorPicker.BackgroundColor3 = colorData.ColorObject
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

local btnSelect = createButton("Select Center Target Block", 335, Color3.fromRGB(0, 122, 215))
local btnPreview = createButton("Hologram Preview Configuration: Disabled", 376, Color3.fromRGB(110, 110, 115))
local btnBuild = createButton("Commence Circle Construction", 417, Color3.fromRGB(46, 139, 87))

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

local IndicatorText = Instance.new("TextLabel", ColorIndicator)
IndicatorText.Size = UDim2.new(1, 0, 1, 0)
IndicatorText.Text = ""
IndicatorText.BackgroundTransparency = 1

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
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)
    
    local button = Instance.new("TextButton", track)
    button.Size = UDim2.new(0, 14, 0, 14)
    button.Position = UDim2.new(defaultFraction, -7, 0.5, -7)
    button.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    button.Text = ""
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
    return label, track, button
end

local rLabel, rTrack, rBtn = createColorSlider("Red Input", 110, 1)
local gLabel, gTrack, gBtn = createColorSlider("Green Input", 160, 1)
local bLabel, bTrack, bBtn = createColorSlider("Blue Input", 210, 1)

local hexBox = Instance.new("TextBox", ColorPanel)
hexBox.Size = UDim2.new(1, -30, 0, 30)
hexBox.Position = UDim2.new(0, 15, 0, 295)
hexBox.Text = "#FFFFFF"
hexBox.TextColor3 = Color3.fromRGB(255, 255, 255)
hexBox.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
hexBox.BorderSizePixel = 0
hexBox.Font = Enum.Font.GothamSemibold
hexBox.TextSize = 12
Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 5)

uiData.btnColorPicker = btnColorPicker
uiData.statusLabel = statusLabel
uiData.btnSelect = btnSelect
uiData.btnPreview = btnPreview
uiData.btnBuild = btnBuild
uiData.ColorIndicator = ColorIndicator
uiData.IndicatorText = IndicatorText
uiData.hexBox = hexBox
uiData.rLabel = rLabel
uiData.rTrack = rTrack
uiData.rBtn = rBtn
uiData.gLabel = gLabel
uiData.gTrack = gTrack
uiData.gBtn = gBtn
uiData.bLabel = bLabel
uiData.bTrack = bTrack
uiData.bBtn = bBtn
uiData.ColorPanel = ColorPanel
uiData.HelpPanel = HelpPanel
-- // END OF FILE: Part_2_Submenus.lua //

-- =============================================================================
-- INTERACTIVE SUBSYSTEMS: HOLOGRAM RESPONSIVENESS & INPUT TRACKING
-- =============================================================================
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local uiData = _G.CircleBuilderUI_SharedData
local colorData = _G.ActiveCircleBuilderColorData

if not uiData or not uiData.btnBuild then
    error("Run Part 2 first.")
end

local MainFrame = uiData.MainFrame
local CloseBtn = uiData.CloseBtn
local HelpBtn = uiData.HelpBtn
local ReopenButton = uiData.ReopenButton
local inputRadius = uiData.inputRadius
local inputSteps = uiData.inputSteps
local inputSizeY = uiData.inputSizeY
local inputSizeX = uiData.inputSizeX
local inputSizeZ = uiData.inputSizeZ
local btnColorPicker = uiData.btnColorPicker
local statusLabel = uiData.statusLabel
local btnSelect = uiData.btnSelect
local btnPreview = uiData.btnPreview
local btnBuild = uiData.btnBuild
local ColorIndicator = uiData.ColorIndicator
local IndicatorText = uiData.IndicatorText
local ColorPanel = uiData.ColorPanel
local HelpPanel = uiData.HelpPanel
local hexBox = uiData.hexBox
local rLabel, rTrack, rBtn = uiData.rLabel, uiData.rTrack, uiData.rBtn
local gLabel, gTrack, gBtn = uiData.gLabel, uiData.gTrack, uiData.gBtn
local bLabel, bTrack, bBtn = uiData.bLabel, uiData.bTrack, uiData.bBtn

local CopyBox = Instance.new("TextBox", MainFrame)
CopyBox.Size = UDim2.new(1, -30, 0, 32)
CopyBox.Position = UDim2.new(0, 15, 1, -45)
CopyBox.Text = "https://discord.gg"
CopyBox.TextColor3 = Color3.fromRGB(114, 137, 218)
CopyBox.BackgroundColor3 = Color3.fromRGB(44, 47, 51)
CopyBox.Font = Enum.Font.GothamBold
CopyBox.TextSize = 11
CopyBox.ClearTextOnFocus = false
CopyBox.TextEditable = false
Instance.new("UICorner", CopyBox).CornerRadius = UDim.new(0, 6)

if workspace:FindFirstChild("CirclePreviewFolder") then
    workspace.CirclePreviewFolder:Destroy()
end

local previewFolder = Instance.new("Folder", workspace)
previewFolder.Name = "CirclePreviewFolder"

local selectionBox = Instance.new("SelectionBox", CoreGui)
selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
selectionBox.LineThickness = 0.04
local isSelecting = false
local showLivePreview = false

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ReopenButton.Visible = true
    ColorPanel.Visible = false
    HelpPanel.Visible = false
end)

ReopenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ReopenButton.Visible = false
end)

btnColorPicker.MouseButton1Click:Connect(function()
    HelpPanel.Visible = false
    ColorPanel.Visible = not ColorPanel.Visible
end)

HelpBtn.MouseButton1Click:Connect(function()
    ColorPanel.Visible = false
    HelpPanel.Visible = not HelpPanel.Visible
end)

local function updateRealtimeVisualizerRing()
    previewFolder:ClearAllChildren()
    local center = uiData.selectedCenterPos
    if not center then return end
    
    local radius = tonumber(inputRadius.Text) or 20
    local steps = tonumber(inputSteps.Text) or 30
    local sizeY = tonumber(inputSizeY.Text) or 2
    local circumference = 2 * math.pi * radius
    local sizeZ = circumference / steps
    local sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02
    
    inputSizeX.Text, inputSizeZ.Text = string.format("%.3f", sizeX), string.format("%.3f", sizeZ)
    if not showLivePreview then return end
    
    for i = 1, steps do
        local angle = (i / steps) * math.pi * 2
        local targetPlacementPos = Vector3.new(center.X + math.cos(angle) * radius, center.Y, center.Z + math.sin(angle) * radius)
        local hPart = Instance.new("Part")
        hPart.Size = Vector3.new(sizeX, sizeY, sizeZ)
        hPart.CFrame = CFrame.lookAt(targetPlacementPos, center)
        hPart.Color = colorData.ColorObject
        hPart.Transparency = 0.5
        hPart.Anchored = true
        hPart.CanCollide = false
        hPart.Material = Enum.Material.SmoothPlastic
        hPart.Parent = previewFolder
        
        local sb = Instance.new("SelectionBox", hPart)
        sb.Adornee = hPart
        sb.Color3 = colorData.ColorObject
        sb.LineThickness = 0.02
    end
end

local function applyColorTransformations()
    colorData.ColorObject = Color3.new(colorData.CurrentR, colorData.CurrentG, colorData.CurrentB)
    ColorIndicator.BackgroundColor3 = colorData.ColorObject
    btnColorPicker.BackgroundColor3 = colorData.ColorObject
    updateRealtimeVisualizerRing()
end

local function attachSliderPhysics(button, track, label, prefix, channelCallback)
    local isDragging = false
    button.MouseButton1Down:Connect(function() 
        isDragging = true 
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            button.Position = UDim2.new(relativeX, -7, 0.5, -7)
            label.Text = prefix .. ": " .. string.format("%.0f", relativeX * 255)
            channelCallback(relativeX)
            applyColorTransformations()
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

attachSliderPhysics(rBtn, rTrack, rLabel, "Red Input", function(val) colorData.CurrentR = val end)
attachSliderPhysics(gBtn, gTrack, gLabel, "Green Input", function(val) colorData.CurrentG = val end)
attachSliderPhysics(bBtn, bTrack, bLabel, "Blue Input", function(val) colorData.CurrentB = val end)

hexBox.FocusLost:Connect(function()
    local text = hexBox.Text:gsub("#", "")
    if #text == 6 then
        local r = tonumber(text:sub(1, 2), 16)
        local g = tonumber(text:sub(3, 4), 16)
        local b = tonumber(text:sub(5, 6), 16)
        
        if r and g and b then
            colorData.CurrentR = r / 255
            colorData.CurrentG = g / 255
            colorData.CurrentB = b / 255
            
            rBtn.Position = UDim2.new(colorData.CurrentR, -7, 0.5, -7)
            gBtn.Position = UDim2.new(colorData.CurrentG, -7, 0.5, -7)
            bBtn.Position = UDim2.new(colorData.CurrentB, -7, 0.5, -7)
            
            rLabel.Text = "Red Input: " .. tostring(r)
            gLabel.Text = "Green Input: " .. tostring(g)
            bLabel.Text = "Blue Input: " .. tostring(b)
            applyColorTransformations()
        end
    end
end)

for _, box in ipairs({inputRadius, inputSteps, inputSizeY}) do
    box:GetPropertyChangedSignal("Text"):Connect(updateRealtimeVisualizerRing)
end

btnPreview.MouseButton1Click:Connect(function()
    not showLivePreview = not showLivePreview
    if showLivePreview then
        btnPreview.Text = "Hologram Preview Configuration: Active"
        btnPreview.BackgroundColor3 = Color3.fromRGB(155, 80, 180)
    else
        btnPreview.Text = "Hologram Preview Configuration: Disabled"
        btnPreview.BackgroundColor3 = Color3.fromRGB(110, 110, 115)
    end
    updateRealtimeVisualizerRing()
end)

uiData.updateRealtimeVisualizerRing = updateRealtimeVisualizerRing
uiData.previewFolder = previewFolder
uiData.btnSelect = btnSelect
uiData.statusLabel = statusLabel
uiData.selectionBox = selectionBox
uiData.Mouse = Mouse
uiData.RunService = RunService
uiData.LocalPlayer = LocalPlayer
-- // END OF FILE: Part_3_Physics.lua //
