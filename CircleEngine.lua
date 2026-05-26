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
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local blocksFolder = workspace:WaitForChild("Blocks"):WaitForChild(player.Name)

-- Math: Exact local circumference calculation from your working logic template
local perfectZWidth = (2 * math.pi * radius) / numberOfBlocks
local targetSize = Vector3.new(sizeX, sizeY, perfectZWidth + 0.02) 

print("Executing original loop core logic with fixed frame validation...")

-- Active tracker to catch the exact piece that lands in your folder
local newlySpawnedBlock = nil
local connection = blocksFolder.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "PlasticBlock" then
        newlySpawnedBlock = child
    end
end)

for i = 1, numberOfBlocks do
    -- Precise step calculations from your template
    local angle = (i / numberOfBlocks) * (2 * math.pi)
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    local blockPosition = centerCFrame * CFrame.new(offsetX, 0, offsetZ) * CFrame.Angles(0, -angle, 0)
    
    -- Reset the tracker before placing
    newlySpawnedBlock = nil
    
    -- 1. Equip BuildingTool and drop block
    local buildingTool = backpack:FindFirstChild("BuildingTool") or character:FindFirstChild("BuildingTool")
    if buildingTool then
        humanoid:EquipTool(buildingTool)
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
    
    -- FRAME VALIDATOR WAIT: Forces the code to pause until the block physically exists in your folder
    local startTime = os.clock()
    repeat 
        task.wait() 
    until newlySpawnedBlock or (os.clock() - startTime > 0.4) -- 0.4s safety timeout if a block fails
    
    -- 2. Equip ScalingTool and apply dimensions to the fresh block captured by the listener
    if newlySpawnedBlock then
        local targetBlock = newlySpawnedBlock
        local scalingTool = backpack:FindFirstChild("ScalingTool") or character:FindFirstChild("ScalingTool")
        
        if scalingTool then
            humanoid:EquipTool(scalingTool)
            targetBlock.Name = "ProcessedBlock" -- Safe rename now that we are 100% sure it's the right block
            
            local scaleArgs = {
                targetBlock,
                targetSize,
                blockPosition
            }
            scalingTool:WaitForChild("RF"):InvokeServer(unpack(scaleArgs))
        end
        
        task.wait(0.01)
        
        -- 3. Equip PaintingTool and apply color palette
        if useColor then
            local paintingTool = backpack:FindFirstChild("PaintingTool") or character:FindFirstChild("PaintingTool")
            if paintingTool then
                humanoid:EquipTool(paintingTool)
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
    
    humanoid:UnequipTools()
    task.wait(0.015)
end

-- Disconnect the tracker after the circle is done building
connection:Disconnect()

-- Revert item names back to normal cleanup routine
for _, block in ipairs(blocksFolder:GetChildren()) do
    if block.Name == "ProcessedBlock" then
        block.Name = "PlasticBlock"
    end
end

print("Z-axis circle complete using verified legacy execution matrix!")
