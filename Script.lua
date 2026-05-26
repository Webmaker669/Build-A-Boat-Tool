-- UI and Visual Subsystem Initialization
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- Clear previous suite instances safely
if CoreGui:FindFirstChild("CircleBuilderUI") then CoreGui.CircleBuilderUI:Destroy() end
if CoreGui:FindFirstChild("CirclePreviewFolder") then CoreGui.CirclePreviewFolder:Destroy() end

-- Screen Container
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CircleBuilderUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 500)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Reopen Side Panel Button Configuration
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

-- Header Styling
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "AUTOMATED CIRCLE ENGINE PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

-- Title Bar Close Button Implementation
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(240, 90, 90)
CloseBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Workspace Active Hologram Visual Elements Instantiations
local previewFolder = Instance.new("Folder", workspace)
previewFolder.Name = "CirclePreviewFolder"

local selectionBox = Instance.new("SelectionBox", CoreGui)
selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
selectionBox.LineThickness = 0.04

-- Global States
local selectedCenterPos = nil
local blockName = "PlasticBlock"
local isSelecting = false
local showLivePreview = false
local currentColor = Color3.new(1, 1, 1)

local colorPalette = {
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 50, 50), 
    Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 100, 255), 
    Color3.fromRGB(255, 255, 50), Color3.fromRGB(255, 50, 255),
    Color3.fromRGB(50, 255, 255), Color3.fromRGB(255, 128, 0)
}
local currentColorIndex = 1

-- Input Fields Factory
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

-- Interactive Active Color Picker Interface Setup
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
btnColorPicker.Text = "Pure White"
btnColorPicker.Font = Enum.Font.GothamBold
btnColorPicker.TextSize = 12
btnColorPicker.BackgroundColor3 = currentColor
btnColorPicker.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", btnColorPicker).CornerRadius = UDim.new(0, 5)

btnColorPicker.MouseButton1Click:Connect(function()
    currentColorIndex = (currentColorIndex % #colorPalette) + 1
    currentColor = colorPalette[currentColorIndex]
    btnColorPicker.BackgroundColor3 = currentColor
    btnColorPicker.TextColor3 = (currentColor.R + currentColor.G + currentColor.B < 1.5) and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
    btnColorPicker.Text = "Color Selected"
end)

-- Status Readings Output Labels
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

-- Professional Interface Window Closing Routines
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ReopenButton.Visible = true
end)

ReopenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ReopenButton.Visible = false
end)

-- Holographic Proportional Matrix Calculation Engine with Live Modeling Updates
local function updateRealtimeVisualizerRing()
    previewFolder:ClearAllChildren()
    
    local radius = tonumber(inputRadius.Text) or 20
    local steps  = tonumber(inputSteps.Text) or 30
    local sizeY  = tonumber(inputSizeY.Text) or 2
    
    -- Geometric Auto-Sizing Calculations
    local circumference = 2 * math.pi * radius
    local sizeZ = circumference / steps
    local sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02
    
    inputSizeX.Text = string.format("%.3f", sizeX)
    inputSizeZ.Text = string.format("%.3f", sizeZ)
    
    if not selectedCenterPos or not showLivePreview then return end
    
    for i = 1, steps do
        local angle = (i / steps) * math.pi * 2
        local xOffset = math.cos(angle) * radius
        local zOffset = math.sin(angle) * radius
        
        local targetPlacementPos = Vector3.new(selectedCenterPos.X + xOffset, selectedCenterPos.Y, selectedCenterPos.Z + zOffset)
        
        local hPart = Instance.new("Part")
        hPart.Size = Vector3.new(sizeX, sizeY, sizeZ)
        hPart.CFrame = CFrame.lookAt(targetPlacementPos, selectedCenterPos)
        hPart.Color = currentColor
        hPart.Transparency = 0.7 -- Heightened Transparency for Clear Holographic Aesthetics
        hPart.Anchored = true
        hPart.CanCollide = false
        hPart.Material = Enum.Material.ForceField -- Clean Holographic Lattice Texture Map Mesh
        hPart.Parent = previewFolder
    end
end

-- Value field update state tracking hooks
for _, box in ipairs({inputRadius, inputSteps, inputSizeY}) do
    box:GetPropertyChangedSignal("Text"):Connect(updateRealtimeVisualizerRing)
end
btnColorPicker:GetPropertyChangedSignal("BackgroundColor3"):Connect(updateRealtimeVisualizerRing)

-- Blueprint visibility state controller switch
btnPreview.MouseButton1Click:Connect(function()
    showLivePreview = not showLivePreview
    if showLivePreview then
        btnPreview.Text = "Hologram Preview Configuration: Active"
        btnPreview.BackgroundColor3 = Color3.fromRGB(155, 80, 180)
    else
        btnPreview.Text = "Hologram Preview Configuration: Disabled"
        btnPreview.BackgroundColor3 = Color3.fromRGB(110, 110, 115)
    end
    updateRealtimeVisualizerRing()
end)

-- Interactive Workspace Node Selector
local renderConnection, clickConnection
btnSelect.MouseButton1Click:Connect(function()
    if isSelecting then return end
    isSelecting = true
    statusLabel.Text = "Hover over canvas plot area and select node..."
    statusLabel.TextColor3 = Color3.fromRGB(240, 180, 20)
    btnSelect.Text = "Awaiting Target Confirmation..."
    
    renderConnection = RunService.RenderStepped:Connect(function()
        local target = Mouse.Target
        if target and target:IsA("BasePart") then selectionBox.Adornee = target else selectionBox.Adornee = nil end
    end)
    
    clickConnection = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target:IsA("BasePart") then
            selectedCenterPos = target.Position
            statusLabel.Text = "Anchor Node Position Synchronized: " .. target.Name
            statusLabel.TextColor3 = Color3.fromRGB(80, 240, 80)
            
            renderConnection:Disconnect()
            clickConnection:Disconnect()
            selectionBox.Adornee = nil
            isSelecting = false
            btnSelect.Text = "Select Center Target Block"
            updateRealtimeVisualizerRing()
        end
    end)
end)

-- Remote Invoking Build Execution Operations Thread
btnBuild.MouseButton1Click:Connect(function()
    if isSelecting or not selectedCenterPos then return end
    
    local radius = tonumber(inputRadius.Text) or 20
    local steps  = tonumber(inputSteps.Text) or 30
    local sizeY  = tonumber(inputSizeY.Text) or 2
    
    local circumference = 2 * math.pi * radius
    local sizeZ = circumference / steps
    local sizeX = (2 * radius * math.tan(math.pi / steps)) + 0.02
    
    local function findRemote(toolName)
        local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(toolName))
        return tool and tool:FindFirstChild("RF")
    end
    
    local buildingRF = findRemote("BuildingTool")
    local scalingRF  = findRemote("ScalingTool")
    local paintingRF = findRemote("PaintingTool")
    
    if not buildingRF or not scalingRF or not paintingRF then
        statusLabel.Text = "Hardware Fault: Missing active utilities!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    -- Professional Hologram Suppression: Immediately drops preview during runtime compilation
    showLivePreview = false
    btnPreview.Text = "Hologram Preview Configuration: Disabled"
    btnPreview.BackgroundColor3 = Color3.fromRGB(110, 110, 115)
    previewFolder:ClearAllChildren()
    
    btnBuild.Text = "Constructing Active Sector Matrix..."
    btnBuild.Active = false
    
    local blocksContainer = workspace:WaitForChild("Blocks", 5)
    local playerBlocksFolder = blocksContainer and blocksContainer:WaitForChild(LocalPlayer.Name, 5)
    
    for i = 1, steps do
        local angle = (i / steps) * math.pi * 2
        local xOffset = math.cos(angle) * radius
        local zOffset = math.sin(angle) * radius
        
        local targetPlacementPos = Vector3.new(selectedCenterPos.X + xOffset, selectedCenterPos.Y, selectedCenterPos.Z + zOffset)
        local placementCFrame = CFrame.lookAt(targetPlacementPos, selectedCenterPos)
        local hitPositionCFrame = CFrame.new(targetPlacementPos) * CFrame.Angles(0, angle, 0)
        
        local initialChildren = playerBlocksFolder:GetChildren()
        
        local placeArgs = { blockName, 8001, Instance.new("Part", nil), placementCFrame, true, hitPositionCFrame, false }
        buildingRF:InvokeServer(unpack(placeArgs))
        
        local dynamicBlockPath = nil
        local retries = 0
        while not dynamicBlockPath and retries < 30 do
            task.wait(0.01)
            local currentChildren = playerBlocksFolder:GetChildren()
            if #currentChildren > #initialChildren then dynamicBlockPath = currentChildren[#currentChildren] end
            retries = retries + 1
        end
        
        if dynamicBlockPath then
            local targetSize = Vector3.new(sizeX, sizeY, sizeZ)
            local scaleVector = (vector and vector.create) and vector.create(targetSize.X, targetSize.Y, targetSize.Z) or targetSize
            local scaleArgs = { dynamicBlockPath, scaleVector, placementCFrame }
            scalingRF:InvokeServer(unpack(scaleArgs))
            task.wait(0.01)
            
            local paintArgs = { { { dynamicBlockPath, currentColor }, { dynamicBlockPath, currentColor }, { dynamicBlockPath, currentColor } } }
            paintingRF:InvokeServer(unpack(paintArgs))
        end
        task.wait(0.03)
    end
    
    btnBuild.Text = "Commence Circle Construction"
    btnBuild.Active = true
    statusLabel.Text = "Matrix Sequence Completed!"
