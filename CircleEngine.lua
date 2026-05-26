-- Bypasses the local variables and hooks your original logic straight to the global GUI memory
local radius = _G.CircleRadius or 30
local numberOfBlocks = _G.CircleBlocks or 120
local sizeY = _G.CircleHeightY or 2
local sizeX = _G.CircleThickX or 0.05
local useColor = _G.CircleUseColor
local finalColor = _G.CircleColor3 or Color3.new(1,1,1)
local centerCFrame = _G.CircleCenterCFrame

-- Services and Original Environmental Hierarchy References
local player = game:GetService("Players").LocalPlayer
local teamsService = game:GetService("Teams")
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local blocksFolder = workspace:WaitForChild("Blocks"):WaitForChild(player.Name)

-- Math: Exact local circumference calculation from your working logic template
local perfectZWidth = (2 * math.pi * radius) / numberOfBlocks
local targetSize = Vector3.new(sizeX, sizeY, perfectZWidth + 0.02) 

-- DYNAMIC TEAM ZONE DETECTOR
local detectedZoneName = "WhiteZone" -- Fallback default
for _, team in ipairs(teamsService:GetTeams()) do
    if player.Team == team or (team:FindFirstChild("TeamLeader") and team.TeamLeader.Value == player.Name) then
        -- Converts the standard team name into the matching workspace workspace zone folder naming format
        detectedZoneName = tostring(team.Name) .. "Zone"
        break
    end
end

print("Dynamic Team Zone Activated: " .. detectedZoneName)
print("Processing automated center matrix loop...")

for i = 1, numberOfBlocks do
    local angle = (i / numberOfBlocks) * (2 * math.pi)
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    local blockPosition = centerCFrame * CFrame.new(offsetX, 0, offsetZ) * CFrame.Angles(0, -angle, 0)
    
    -- 1. Build Placement Block
    local buildingTool = backpack:FindFirstChild("BuildingTool") or character:FindFirstChild("BuildingTool")
    if buildingTool then
        humanoid:EquipTool(buildingTool)
        task.wait(0.04) -- Gives tool state system sync window room
        
        local buildArgs = {
            "PlasticBlock",
            8001,
            workspace:WaitForChild(detectedZoneName), -- Dynamically targets your current team zone setup
            CFrame.new(-10, 6.1, -20) * CFrame.Angles(0, -angle, 0),
            true,
            blockPosition,
            false
        }
        buildingTool:WaitForChild("RF"):InvokeServer(unpack(buildArgs))
    end
    
    task.wait(0.04)
    
    -- 2. Target Isolation and Scaling
    local placedBlock = blocksFolder:FindFirstChild("PlasticBlock")
    local scalingTool = backpack:FindFirstChild("ScalingTool") or character:FindFirstChild("ScalingTool")
    if placedBlock and scalingTool then
        humanoid:EquipTool(scalingTool)
        task.wait(0.04)
        
        placedBlock.Name = "ProcessedBlock"
        local scaleArgs = {
            placedBlock,
            targetSize,
            blockPosition
        }
        scalingTool:WaitForChild("RF"):InvokeServer(unpack(scaleArgs))
    end
    
    task.wait(0.04)
    
    -- 3. Color Paint
    if useColor and placedBlock then
        local paintingTool = backpack:FindFirstChild("PaintingTool") or character:FindFirstChild("PaintingTool")
        if paintingTool then
            humanoid:EquipTool(paintingTool)
            task.wait(0.04)
            
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
    task.wait(0.05)
end

for _, block in ipairs(blocksFolder:GetChildren()) do
    if block.Name == "ProcessedBlock" then
        block.Name = "PlasticBlock"
    end
end
print("Circle built successfully.")
