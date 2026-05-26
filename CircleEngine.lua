-- Bypasses the local GUI entirely and grabs values dynamically from global memory
local radius = _G.CircleRadius or 30
local numberOfBlocks = _G.CircleBlocks or 120
local sizeY = _G.CircleHeightY or 2
local sizeX = _G.CircleThickX or 0.05
local sizeZ = _G.CircleLengthZ or 0.5
local finalColor = _G.CircleColor3 or Color3.new(1,1,1)
local useColor = _G.CircleUseColor
local cCF = _G.CircleCenterCFrame

local P = game:GetService("Players").LocalPlayer
local ch = P.Character or P.CharacterAdded:Wait()
local h = ch:WaitForChild("Humanoid")
local f = workspace:WaitForChild("Blocks"):WaitForChild(P.Name)
local gID = "R_" .. tostring(os.time())
local requestsSent = 0

-- Instantly track whatever item spawns into your plot folder
local newlySpawnedBlock = nil
local listener = f.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "PlasticBlock" then
        newlySpawnedBlock = child
    end
end)

for i = 1, numberOfBlocks do
    local a = (i / numberOfBlocks) * (2 * math.pi)
    local cosA = math.cos(a) * radius
    local sinA = math.sin(a) * radius
    local bP = cCF * CFrame.new(cosA, 0, sinA) * CFrame.Angles(0, -a, 0)
    
    newlySpawnedBlock = nil
    
    -- 1. Deploy
    local t1 = P.Backpack:FindFirstChild("BuildingTool") or ch:FindFirstChild("BuildingTool")
    if t1 then
        h:EquipTool(t1)
        local wZ = workspace:WaitForChild("WhiteZone")
        local rot = CFrame.new(-10, 6.1, -20) * CFrame.Angles(0, -a, 0)
        t1:WaitForChild("RF"):InvokeServer("PlasticBlock", 8001, wZ, rot, true, bP, false)
        requestsSent = requestsSent + 1
    end
    task.wait(0.05)
    
    -- Frame-catch validator
    local scanTime = os.clock()
    repeat task.wait() until newlySpawnedBlock or (os.clock() - scanTime > 0.5)
    
    if newlySpawnedBlock then
        local targetBlock = newlySpawnedBlock
        targetBlock.Name = gID
        
        -- 2. Scale
        local t2 = P.Backpack:FindFirstChild("ScalingTool") or ch:FindFirstChild("ScalingTool")
        if t2 then
            h:EquipTool(t2)
            t2:WaitForChild("RF"):InvokeServer(targetBlock, Vector3.new(sizeX, sizeY, sizeZ), bP)
            requestsSent = requestsSent + 1
        end
        task.wait(0.04)
        
        -- 3. Paint
        if useColor then
            local t3 = P.Backpack:FindFirstChild("PaintingTool") or ch:FindFirstChild("PaintingTool")
            if t3 then
                h:EquipTool(t3)
                t3:WaitForChild("RF"):InvokeServer({{{targetBlock, finalColor}}})
                requestsSent = requestsSent + 1
            end
            task.wait(0.04)
        end
    end
    
    h:UnequipTools()
    if requestsSent >= 15 then
        task.wait(0.5)
        requestsSent = 0
    end
end

listener:Disconnect()
for _, b in ipairs(f:GetChildren()) do
    if b.Name == gID then
        b.Name = "PlasticBlock"
    end
end
