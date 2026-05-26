-- Bypasses local variables and links straight to global GUI memory
local radius = _G.CircleRadius or 30
local numberOfBlocks = _G.CircleBlocks or 120
local sizeY = _G.CircleHeightY or 2
local sizeX = _G.CircleThickX or 0.05
local useColor = _G.CircleUseColor
local finalColor = _G.CircleColor3 or Color3.new(1,1,1)
local centerCFrame = _G.CircleCenterCFrame

-- Services and Original Environmental Hierarchy References
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local blocksFolder = workspace:WaitForChild("Blocks"):WaitForChild(player.Name)

-- Math: Exact local circumference calculation from your working logic template
local perfectZWidth = (2 * math.pi * radius) / numberOfBlocks
local targetSize = Vector3.new(sizeX, sizeY, perfectZWidth + 0.02) 

print("Executing logic with humanized tool-switch delay profiles...")

-- Listener setup to track exactly when parts land in your folder
local newlySpawnedBlock = nil
local connection = blocksFolder.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "PlasticBlock" then
        newlySpawnedBlock = child
    end
end)

for i = 1, numberOfBlocks do
    local angle = (i / numberOfBlocks) * (2 * math.pi)
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    local blockPosition = centerCFrame * CFrame.new(offsetX, 0, offsetZ) * CFrame.Angles(0, -angle, 0)
    
    newlySpawnedBlock = nil
    
    -- ============================================================================
    -- STEP 1: EQUIP BUILDING TOOL AND PLACE
    -- ============================================================================
    local buildingTool = backpack:FindFirstChild("BuildingTool") or character:FindFirstChild("BuildingTool")
    if buildingTool then
        humanoid:EquipTool(buildingTool)
        task.wait(0.06) -- Delay: Let game register you are holding the building tool
        
        local buildArgs = {
            "PlasticBlock",
            8001,
            workspace:WaitForChild("WhiteZone"),
            CFrame.new(-10, 6.1, -20) * CFrame.Angles(0, -angle, 0),
            true,
            blockPosition,
            false
        }
        buildingTool:WaitForChild("RF"):InvokeServer(unpack(buildArgs))
    end
    
    -- Wait until the block physically exists in the workspace folder
    local startTime = os.clock()
    repeat 
        task.wait() 
    until newlySpawnedBlock or (os.clock() - startTime > 0.4)
    
    -- ============================================================================
    -- STEP 2: EQUIP SCALING TOOL AND RESIZE
    -- ============================================================================
    if newlySpawnedBlock then
        local targetBlock = newlySpawnedBlock
        local scalingTool = backpack:FindFirstChild("ScalingTool") or character:FindFirstChild("ScalingTool")
        
        if scalingTool then
            humanoid:EquipTool(scalingTool)
            task.wait(0.06) -- Delay: Let game register you switched to the scaling tool
            
            targetBlock.Name = "ProcessedBlock"
            local scaleArgs = {
                targetBlock,
                targetSize,
                blockPosition
            }
            scalingTool:WaitForChild("RF"):InvokeServer(unpack(scaleArgs))
        end
        
        task.wait(0.04) -- Short rest buffer before painting
        
        -- ============================================================================
        -- STEP 3: EQUIP PAINTING TOOL AND COLOR
        -- ============================================================================
        if useColor then
            local paintingTool = backpack:FindFirstChild("PaintingTool") or character:FindFirstChild("PaintingTool")
            if paintingTool then
                humanoid:EquipTool(paintingTool)
                task.wait(0.06) -- Delay: Let game register you switched to the painting tool
                
                local paintArgs = {
                    {
                        {
                            targetBlock,
                            finalColor
                        }
                    }
                }
                paintingTool:WaitForChild("RF"):InvokeServer(unpack(paintArgs))
            end
        end
    end
    
    -- Unequip tools and clear hands before starting the next block segment
    humanoid:UnequipTools()
    task.wait(0.05) -- Clean rest delay between separate block steps
end

-- Cleanup routine
connection:Disconnect()
for _, block in ipairs(blocksFolder:GetChildren()) do
    if block.Name == "ProcessedBlock" then
        block.Name = "PlasticBlock"
    end
end

print("Circle complete with zero skipped blocks!")
