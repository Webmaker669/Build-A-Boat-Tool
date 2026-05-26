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
