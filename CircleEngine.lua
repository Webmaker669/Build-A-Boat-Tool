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

print("Executing automated sequence centered on selected block...")

for i = 1, numberOfBlocks do
    -- Precise step calculations from your template relative to Selected Center
    local angle = (i / numberOfBlocks) * (2 * math.pi)
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    local blockPosition = centerCFrame * CFrame.new(offsetX, 0, offsetZ) * CFrame.Angles(0, -angle, 0)
    
    -- ============================================================================
    -- STEP 1: EQUIP BUILDING TOOL AND PLACE
    -- ============================================================================
    local buildingTool = backpack:FindFirstChild("BuildingTool") or character:FindFirstChild("BuildingTool")
    if buildingTool then
        humanoid:EquipTool(buildingTool)
        task.wait(0.12) -- Safe delay: Let the tool completely register on the server
        
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
    
    -- INSTANT SELECTION BYPASS: Grab the exact block that was just created at the end of the folder
    task.wait(0.05) -- Microsecond pause for the folder to update
    local currentChildren = blocksFolder:GetChildren()
    local targetBlock = currentChildren[#currentChildren] -- Grabs the absolute newest block
    
    -- Verify the block is valid and hasn't been processed yet
    if targetBlock and targetBlock.Name == "PlasticBlock" then
        
        -- ============================================================================
        -- STEP 2: EQUIP SCALING TOOL AND RESIZE
        -- ============================================================================
        local scalingTool = backpack:FindFirstChild("ScalingTool") or character:FindFirstChild("ScalingTool")
        if scalingTool then
            humanoid:EquipTool(scalingTool)
            task.wait(0.12) -- Safe delay: Give server time to switch tools
            
            targetBlock.Name = "ProcessedBlock" -- Lock it down so next loop ignores it
            local scaleArgs = {
                targetBlock,
                targetSize,
                blockPosition
            }
            scalingTool:WaitForChild("RF"):InvokeServer(unpack(scaleArgs))
        end
        
        task.wait(0.08) -- Settle delay before painting
        
        -- ============================================================================
        -- STEP 3: EQUIP PAINTING TOOL AND COLOR
        -- ============================================================================
        if useColor then
            local paintingTool = backpack:FindFirstChild("PaintingTool") or character:FindFirstChild("PaintingTool")
            if paintingTool then
                humanoid:EquipTool(paintingTool)
                task.wait(0.12) -- Safe delay: Give server time to switch tools
                
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
    
    -- Cleanly drop tools and clear character hands before moving to the next segment position
    humanoid:UnequipTools()
    task.wait(0.1) -- Cooldown delay to keep the server layout smooth and continuous
end

-- Revert item names back to normal cleanup routine
for _, block in ipairs(blocksFolder:GetChildren()) do
    if block.Name == "ProcessedBlock" then
        block.Name = "PlasticBlock"
    end
end

print("Center-relative continuous circle complete!")
