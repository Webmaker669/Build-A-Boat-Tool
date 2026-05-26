local radius = _G.CircleRadius or 30
local numberOfBlocks = _G.CircleBlocks or 120
local sizeY = _G.CircleHeightY or 2
local sizeX = _G.CircleThickX or 0.05
local sizeZ = _G.CircleLengthZ or 0.5
local useColor = _G.CircleUseColor
local finalColor = _G.CircleColor3 or Color3.new(1,1,1)
local centerCFrame = _G.CircleCenterCFrame

local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local blocksFolder = workspace:WaitForChild("Blocks"):WaitForChild(player.Name)

local targetSize = Vector3.new(sizeX, sizeY, sizeZ) 

-- PHYSICAL ZONE DETECTOR
local detectedZoneName = "WhiteZone"
local shortestDistance = math.huge
local zoneNames = {"WhiteZone", "BlackZone", "MagentaZone", "BlueZone", "GreenZone", "YellowZone", "RedZone"}

for _, zoneName in ipairs(zoneNames) do
    local zoneFolder = workspace:FindFirstChild(zoneName)
    if zoneFolder then
        local basePart = zoneFolder:FindFirstChildWhichIsA("BasePart") or zoneFolder
        if basePart then
            local distance = (rootPart.Position - basePart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                detectedZoneName = zoneName
            end
        end
    end
end

print("Building Loop Active on Zone Part: " .. detectedZoneName)

for i = 1, numberOfBlocks do
    local angle = (i / numberOfBlocks) * (2 * math.pi)
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    local blockPosition = centerCFrame * CFrame.new(offsetX, 0, offsetZ) * CFrame.Angles(0, -angle, 0)
    
    -- 1. Build
    local buildingTool = backpack:FindFirstChild("BuildingTool") or character:FindFirstChild("BuildingTool")
    if buildingTool then
        humanoid:EquipTool(buildingTool)
        task.wait(0.06)
        
        local buildArgs = {
            "PlasticBlock",
            8001,
            workspace:WaitForChild(detectedZoneName),
            CFrame.new(-10, 6.1, -20) * CFrame.Angles(0, -angle, 0),
            true,
            blockPosition,
            false
        }
        buildingTool:WaitForChild("RF"):InvokeServer(unpack(buildArgs))
    end
    
    task.wait(0.06)
    
    -- 2. Scale
    local placedBlock = blocksFolder:FindFirstChild("PlasticBlock")
    local scalingTool = backpack:FindFirstChild("ScalingTool") or character:FindFirstChild("ScalingTool")
    if placedBlock and scalingTool then
        humanoid:EquipTool(scalingTool)
        task.wait(0.06)
        
        placedBlock.Name = "ProcessedBlock"
        local scaleArgs = {
            placedBlock,
            targetSize,
            blockPosition
        }
        scalingTool:WaitForChild("RF"):InvokeServer(unpack(scaleArgs))
    end
    
    task.wait(0.06)
    
    -- 3. Paint
    if useColor and placedBlock then
        local paintingTool = backpack:FindFirstChild("PaintingTool") or character:FindFirstChild("PaintingTool")
        if paintingTool then
            humanoid:EquipTool(paintingTool)
            task.wait(0.06)
            
            local paintArgs = {
                {
                    {
                        placedBlock,
                        finalColor
                    }
                }
            }
            paintingTool:WaitForChild("RF"):InvokeServer(unpack(paintArgs))
        end
    end
    
    humanoid:UnequipTools()
    task.wait(0.06)
end

for _, block in ipairs(blocksFolder:GetChildren()) do
    if block.Name == "ProcessedBlock" then
        block.Name = "PlasticBlock"
    end
end
print("Circle built successfully.")
