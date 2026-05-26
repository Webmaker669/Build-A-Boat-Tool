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

print("Executing logic with safe human-emulated delay windows...")

-- Caching variables for our tracking system
local newlySpawnedBlock = nil
local uniqueBatchID = "ProcessedBlock_" .. tostring(os.time())

-- Active event listener that catches the EXACT block that falls into your folder
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
    
    -- Clear tracking variable for the new loop iteration
    newlySpawnedBlock = nil
    
    -- ============================================================================
    -- STEP 1: EQUIP BUILDING TOOL AND PLACE
    -- ============================================================================
    local buildingTool = backpack:FindFirstChild("BuildingTool") or character:FindFirstChild("BuildingTool")
    if buildingTool then
        humanoid:EquipTool(buildingTool)
        task.wait(0.15) -- Safe delay: Let the tool completely initialize on the server
        
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
    
    -- HARD PAUSE FOR SERVER REPLICATION: Wait up to 1 full second for the block to exist
    local startTime = os.clock()
    while not newlySpawnedBlock and (os.clock() - startTime < 1.0) do
        task.wait()
    end
    
    -- ============================================================================
    -- STEP 2: EQUIP SCALING TOOL AND RESIZE
    -- ============================================================================
    if newlySpawnedBlock then
        local targetBlock = newlySpawnedBlock
        local scalingTool = backpack:FindFirstChild("ScalingTool") or character:FindFirstChild("ScalingTool")
        
        if scalingTool then
            humanoid:EquipTool(scalingTool)
            task.wait(0.15) -- Safe delay: Give server time to switch tools
            
            -- Rename it to a unique ID so subsequent loop iterations never touch it again
            targetBlock.Name = uniqueBatchID
            
            local scaleArgs = {
                targetBlock,
                targetSize,
                blockPosition
            }
            scalingTool:WaitForChild("RF"):InvokeServer(unpack(scaleArgs))
        end
        
        task.wait(0.1) -- Settle delay before painting
        
        -- ============================================================================
        -- STEP 3: EQUIP PAINTING TOOL AND COLOR
        -- ============================================================================
        if useColor then
            local paintingTool = backpack:FindFirstChild("PaintingTool") or character:FindFirstChild("PaintingTool")
            if paintingTool then
                humanoid:EquipTool(paintingTool)
                task.wait(0.15) -- Safe delay: Give server time to switch tools
                
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
    else
        warn("Block placement skipped on loop number: " .. i .. " due to replication lag.")
    end
    
    -- Cleanly drop tools and clear character hands before beginning next segment
    humanoid:UnequipTools()
    task.wait(0.15) -- Global cooldown delay to prevent anticheat detection flagging
end

-- Cleanup routine: Disconnect listener and revert temporary IDs back to standard names
connection:Disconnect()
for _, block in ipairs(blocksFolder:GetChildren()) do
    if block.Name == uniqueBatchID then
        block.Name = "PlasticBlock"
    end
end

print("Circle complete with zero tool tracking lockups!")
