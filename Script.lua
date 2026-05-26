local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("CircleBuilderUI") then CoreGui.CircleBuilderUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CircleBuilderUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 600)
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

local inputRadius = createInputField("Circle Radius / Range:", 55, "20", true)
local inputSteps = createInputField("Total Parts Count:", 97, "30", true)
local inputSizeY = createInputField("Block Height (Y):", 139, "2", true)
local inputBlockType = createInputField("Active Block Type:", 181, "PlasticBlock", true)
local inputSizeX = createInputField("Calculated Width (X):", 223, "0.00", false)
local inputSizeZ = createInputField("Calculated Depth (Z):", 265, "0.00", false)

_G.CircleBuilderUI_SharedData = {
	MainFrame = MainFrame, inputRadius = inputRadius, inputSteps = inputSteps,
	inputSizeY = inputSizeY, inputBlockType = inputBlockType, inputSizeX = inputSizeX,
	inputSizeZ = inputSizeZ, CloseBtn = CloseBtn, HelpBtn = HelpBtn, ReopenButton = ReopenButton
}
_G.ActiveCircleBuilderColorData = { CurrentR = 1, CurrentG = 1, CurrentB = 1, ColorObject = Color3.new(1, 1, 1) }
