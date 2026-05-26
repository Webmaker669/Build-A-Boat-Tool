local P, cCF, mP = game:GetService("Players").LocalPlayer, nil, game:GetService("Players").LocalPlayer:GetMouse()
local sG = Instance.new("ScreenGui", P:WaitForChild("PlayerGui")) sG.Name = "StudioUI" sG.ResetOnSpawn = false
local m = Instance.new("Frame", sG) m.Size, m.Position = UDim2.new(0,330,0,450), UDim2.new(0.05,0,0.2,0)
m.BackgroundColor3, m.Active, m.Draggable, m.BorderSizePixel = Color3.fromRGB(30,30,35), true, true, 0
Instance.new("UICorner", m).CornerRadius = UDim.new(0,8)

local t = Instance.new("TextLabel", m) t.Size, t.Text = UDim2.new(1,-40,0,35), " Seamless Circle Studio"
t.TextColor3, t.TextSize, t.Font, t.TextXAlignment = Color3.new(1,1,1), 15, 4, 0 t.BackgroundTransparency = 1

local cP = Instance.new("Frame", m) cP.Size, cP.Position = UDim2.new(0,40,0,40), UDim2.new(0,270,0,85)
cP.BackgroundColor3, cP.BorderSizePixel = Color3.new(1,1,1), 0 Instance.new("UICorner", cP).CornerRadius = UDim.new(0,6)

-- Color Wheel Canvas Implementation
local cW = Instance.new("ImageLabel", m) cW.Size, cW.Position = UDim2.new(0,230,0,40), UDim2.new(0,20,0,45)
cW.Image, cW.BorderSizePixel = "rbxassetid://132107452654392", 0 Instance.new("UICorner", cW).CornerRadius = UDim.new(0,6)

local function cI(n, p, x, y, r)
    local l = Instance.new("TextLabel", m) l.Size, l.Position = UDim2.new(0,65,0,22), UDim2.new(0,x,0,y)
    l.Text, l.TextColor3, l.TextSize, l.Font, l.TextXAlignment = n, Color3.fromRGB(180,180,180), 13, 3, 0 l.BackgroundTransparency = 1
    local b = Instance.new("TextBox", m) b.Size, b.Position = UDim2.new(0,80,0,22), UDim2.new(0,x+65,0,y)
    b.BackgroundColor3 = r and Color3.fromRGB(38,38,40) or Color3.fromRGB(45,45,50)
    b.TextColor3 = r and Color3.fromRGB(130,130,130) or Color3.new(1,1,1) b.BorderSizePixel = 0
    b.Text, b.ClearTextOnFocus, b.Font, b.TextSize, b.TextEditable = p, false, 3, 13, not r
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4) return b
end

local iR = cI("Radius:", "30", 20, 140) local iB = cI("Blocks:", "120", 170, 140)
local aX = cI("Thick (X):", "0.05", 20, 170, true) local iY = cI("Height (Y):", "2.0", 170, 170)
local aZ = cI("Length (Z):", "Calculated", 20, 200, true) local iC = cI("RGB Val:", "1,1,1", 170, 200)

local function cB(n, x, y, w, h, c)
    local btn = Instance.new("TextButton", m) btn.Size, btn.Position = UDim2.new(0,w,0,h), UDim2.new(0,x,0,y)
    btn.BackgroundColor3, btn.Text, btn.TextColor3, btn.Font, btn.TextSize, btn.BorderSizePixel = c, n, Color3.new(1,1,1), 4, 13, 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5) return btn
end

local sC = cB("SELECT CENTER", 20, 235, 140, 30, Color3.fromRGB(140,90,190))
local pV = cB("PREVIEW: OFF", 170, 235, 140, 30, Color3.fromRGB(60,65,70))
local tB = cB("PAINTING: ON", 20, 275, 290, 30, Color3.fromRGB(0,115,190))
local bD = cB("BUILD SEAMLESS CIRCLE", 20, 315, 290, 38, Color3.fromRGB(0,140,90))

local uC, showPrev = true, false
local previewFolder = Instance.new("Folder", workspace) previewFolder.Name = "CircleHologram"
local function clearHologram() previewFolder:ClearAllChildren() end

local function uP()
    local r, b, y = tonumber(iR.Text) or 30, tonumber(iB.Text) or 120, tonumber(iY.Text) or 2
    local sX, sZ = 0.05, ((2 * math.pi * r) / b) + 0.02 aZ.Text = string.format("%.3f", sZ)
    if cCF and showPrev then clearHologram()
        for i = 1, math.min(b, 80) do
            local step = (i / math.min(b, 80)) * (2 * math.pi)
            local bP = cCF * CFrame.new(math.cos(step)*r, 0, math.sin(step)*r) * CFrame.Angles(0, -step, 0)
            local p = Instance.new("Part", previewFolder) p.Size, p.CFrame, p.Anchored, p.CanCollide = Vector3.new(sX, y, sZ * (b / math.min(b, 80))), bP, true, false
            p.Color, p.Transparency, p.Material = cP.BackgroundColor3, 0.5, Enum.Material.ForceField
        end
    else clearHologram() end
end

local function parseColor()
    local rS, gS, bS = iC.Text:match("([^,]+),([^,]+),([^,]+)")
    if rS and gS and bS then cP.BackgroundColor3 = Color3.new(tonumber(rS) or 1, tonumber(gS) or 1, tonumber(bS) or 1) uP() end
end

iR:GetPropertyChangedSignal("Text"):Connect(uP) iB:GetPropertyChangedSignal("Text"):Connect(uP) iY:GetPropertyChangedSignal("Text"):Connect(uP) iC:GetPropertyChangedSignal("Text"):Connect(parseColor)

-- Color Spectrum Mouse Sampling Math
local sampling = false
local function sampleColor()
    local absPos, absSize = cW.AbsolutePosition, cW.AbsoluteSize
    local mouseX = math.clamp(mP.X - absPos.X, 0, absSize.X)
    local hue = mouseX / absSize.X
    local selectedColor = Color3.fromHSV(hue, 0.9, 0.9)
    cP.BackgroundColor3 = selectedColor
    iC.Text = string.format("%.2f, %.2f, %.2f", selectedColor.R, selectedColor.G, selectedColor.B)
    uP()
end
cW.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sampling = true sampleColor() end end)
cW.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sampling = false end end)
game:GetService("UserInputService").InputChanged:Connect(function(input) if sampling and input.UserInputType == Enum.UserInputType.MouseMovement then sampleColor() end end)

sC.MouseButton1Click:Connect(function()
    sC.Text, sC.BackgroundColor3 = "CLICK PLOT PART...", Color3.fromRGB(180,50,50)
    local conn; conn = mP.Button1Down:Connect(function()
        if mP.Target then cCF = mP.Target.CFrame sC.Text, sC.BackgroundColor3 = "CENTER SET", Color3.fromRGB(0,140,90) conn:Disconnect() uP() end
    end)
end)

pV.MouseButton1Click:Connect(function()
    showPrev = not showPrev pV.Text = showPrev and "PREVIEW: ON" or "PREVIEW: OFF"
    pV.BackgroundColor3 = showPrev and Color3.fromRGB(0,140,90) or Color3.fromRGB(60,65,70) uP()
end)

tB.MouseButton1Click:Connect(function()
    uC = not uC tB.Text = uC and "PAINTING: ON" or "PAINTING: OFF"
    tB.BackgroundColor3 = uC and Color3.fromRGB(0,115,190) or Color3.fromRGB(90,95,100)
    iC.TextEditable = uC iC.BackgroundColor3 = uC and Color3.fromRGB(45,45,50) or Color3.fromRGB(38,38,40)
    if not uC then cP.BackgroundColor3 = Color3.fromRGB(163,162,165) end uP()
end)

bD.MouseButton1Click:Connect(function()
    if not cCF then sC.Text, sC.BackgroundColor3 = "SET CENTER FIRST!", Color3.fromRGB(180,50,50) return end
    clearHologram() local r, nB, sY, sX, sZ = tonumber(iR.Text) or 30, tonumber(iB.Text) or 120, tonumber(iY.Text) or 2, tonumber(aX.Text) or 0.05, tonumber(aZ.Text) or 0.5
    local ch = P.Character or P.CharacterAdded:Wait() local h = ch:WaitForChild("Humanoid")
    local f = workspace:WaitForChild("Blocks"):WaitForChild(P.Name) local gID = "R_" .. tostring(os.time())
    
    for i = 1, nB do
        local a = (i / nB) * (2 * math.pi)
        local bP = cCF * CFrame.new(math.cos(a)*r, 0, math.sin(a)*r) * CFrame.Angles(0, -a, 0)
        local t1 = P.Backpack:FindFirstChild("BuildingTool") or ch:FindFirstChild("BuildingTool")
        if t1 then h:EquipTool(t1) t1:WaitForChild("RF"):InvokeServer("PlasticBlock", 8001, workspace:WaitForChild("WhiteZone"), CFrame.new(-10, 6.1, -20) * CFrame.Angles(0,-a,0), true, bP, false) end
        task.wait(0.01)
        local pB = f:FindFirstChild("PlasticBlock") local t2 = P.Backpack:FindFirstChild("ScalingTool") or ch:FindFirstChild("ScalingTool")
        if pB and t2 then h:EquipTool(t2) pB.Name = gID t2:WaitForChild("RF"):InvokeServer(pB, Vector3.new(sX, sY, sZ), bP) end
        task.wait(0.01)
        if uC then local t3 = P.Backpack:FindFirstChild("PaintingTool") or ch:FindFirstChild("PaintingTool")
            if pB and t3 then h:EquipTool(t3) t3:WaitForChild("RF"):InvokeServer({{{pB, cP.BackgroundColor3}}}) end
        end
        h:UnequipTools() task.wait(0.01)
    end
    for _, b in ipairs(f:GetChildren()) do if b.Name == gID then b.Name = "PlasticBlock" end end
end)
uP()
