local P, cCF, mP = game:GetService("Players").LocalPlayer, nil, game:GetService("Players").LocalPlayer:GetMouse()
local sG = Instance.new("ScreenGui", P:WaitForChild("PlayerGui")) sG.Name = "StudioUI" sG.ResetOnSpawn = false
local m = Instance.new("Frame", sG) m.Size, m.Position = UDim2.new(0,340,0,460), UDim2.new(0.05,0,0.2,0)
m.BackgroundColor3, m.Active, m.Draggable, m.BorderSizePixel = Color3.fromRGB(30,30,35), true, true, 0
Instance.new("UICorner", m).CornerRadius = UDim.new(0,10)

-- Header/Title Layout Banner 
local hb = Instance.new("Frame", m) hb.Size, hb.Position = UDim2.new(1,0,0,38), UDim2.new(0,0,0,0)
hb.BackgroundColor3, hb.BorderSizePixel = Color3.fromRGB(24,24,28), 0 Instance.new("UICorner", hb).CornerRadius = UDim.new(0,10)
local t = Instance.new("TextLabel", hb) t.Size, t.Text = UDim2.new(1,-40,1,0), "  Seamless Circle Studio"
t.TextColor3, t.TextSize, t.Font, t.TextXAlignment = Color3.fromRGB(240,240,245), 14, 4, 0 t.BackgroundTransparency = 1

-- Minimize Button Layout Component
local minBtn = Instance.new("TextButton", hb) minBtn.Size, minBtn.Position = UDim2.new(0,26,0,26), UDim2.new(1,-32,0,6)
minBtn.BackgroundColor3, minBtn.Text, minBtn.TextColor3, minBtn.Font, minBtn.TextSize = Color3.fromRGB(42,42,48), "-", Color3.new(1,1,1), 4, 18
minBtn.BorderSizePixel = 0 Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local isMinimized, originalSize = false, m.Size
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        m:TweenSize(UDim2.new(0, 340, 0, 38), "Out", "Quad", 0.2, true) minBtn.Text = "+"
    else
        m:TweenSize(originalSize, "Out", "Quad", 0.2, true) minBtn.Text = "-"
    end
end)

local cP = Instance.new("Frame", m) cP.Size, cP.Position = UDim2.new(0,42,0,42), UDim2.new(0,278,0,52)
cP.BackgroundColor3, cP.BorderSizePixel = Color3.new(1,1,1), 0 Instance.new("UICorner", cP).CornerRadius = UDim.new(0,8)

-- Grid-Based Color Palette Setup
local pF = Instance.new("Frame", m) pF.Size, pF.Position = UDim2.new(0,250,0,42), UDim2.new(0,20,0,52)
pF.BackgroundTransparency = 1 local uG = Instance.new("UIGridLayout", pF)
uG.CellSize, uG.CellPadding = UDim2.new(0,23,0,20), UDim2.new(0,2,0,2)

local robloxColors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0),
    Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(163,162,165),
    Color3.fromRGB(0,0,0), Color3.fromRGB(255,170,0), Color3.fromRGB(170,85,0), Color3.fromRGB(0,85,0),
    Color3.fromRGB(85,0,127), Color3.fromRGB(170,0,0), Color3.fromRGB(85,170,255), Color3.fromRGB(255,170,255),
    Color3.fromRGB(100,20,20), Color3.fromRGB(20,100,20), Color3.fromRGB(20,20,100), Color3.fromRGB(245,205,48)
}

local function cI(n, p, x, y, r)
    local l = Instance.new("TextLabel", m) l.Size, l.Position = UDim2.new(0,65,0,24), UDim2.new(0,x,0,y)
    l.Text, l.TextColor3, l.TextSize, l.Font, l.TextXAlignment = n, Color3.fromRGB(180,180,185), 13, 3, 0 l.BackgroundTransparency = 1
    local b = Instance.new("TextBox", m) b.Size, b.Position = UDim2.new(0,80,0,24), UDim2.new(0,x+65,0,y)
    b.BackgroundColor3 = r and Color3.fromRGB(36,36,40) or Color3.fromRGB(44,44,50)
    b.TextColor3 = r and Color3.fromRGB(140,140,145) or Color3.new(1,1,1) b.BorderSizePixel = 0
    b.Text, b.ClearTextOnFocus, b.Font, b.TextSize, b.TextEditable = p, false, 3, 13, not r
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5) return b
end

local iR = cI("Radius:", "30", 20, 115) local iB = cI("Blocks:", "120", 170, 115)
local aX = cI("Thick (X):", "0.05", 20, 148, true) local iY = cI("Height (Y):", "2.0", 170, 148)
local aZ = cI("Length (Z):", "Calculated", 20, 181, true) local iC = cI("RGB Val:", "1,1,1", 170, 181)

local function cB(n, x, y, w, h, c)
    local btn = Instance.new("TextButton", m) btn.Size, btn.Position = UDim2.new(0,w,0,h), UDim2.new(0,x,0,y)
    btn.BackgroundColor3, btn.Text, btn.TextColor3, btn.Font, btn.TextSize, btn.BorderSizePixel = c, n, Color3.new(1,1,1), 4, 13, 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6) return btn
end

-- Beautiful Grid-Aligned Compact Action Controls
local sC = cB("SELECT CENTER", 20, 220, 145, 32, Color3.fromRGB(130,85,180))
local pV = cB("PREVIEW: OFF", 175, 220, 145, 32, Color3.fromRGB(58,62,68))
local tB = cB("PAINTING: ON", 20, 260, 300, 32, Color3.fromRGB(0,110,185))
local bD = cB("BUILD SEAMLESS CIRCLE", 20, 305, 300, 40, Color3.fromRGB(0,135,85))

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

for _, color in ipairs(robloxColors) do
    local sw = Instance.new("TextButton", pF) sw.BackgroundColor3, sw.Text, sw.BorderSizePixel = color, "", 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0,4)
    sw.MouseButton1Click:Connect(function()
        cP.BackgroundColor3 = color iC.Text = string.format("%.2f, %.2f, %.2f", color.R, color.G, color.B) uP()
    end)
end

local function parseColor()
    local rS, gS, bS = iC.Text:match("([^,]+),([^,]+),([^,]+)")
    if rS and gS and bS then cP.BackgroundColor3 = Color3.new(tonumber(rS) or 1, tonumber(gS) or 1, tonumber(bS) or 1) uP() end
end

iR:GetPropertyChangedSignal("Text"):Connect(uP) iB:GetPropertyChangedSignal("Text"):Connect(uP) iY:GetPropertyChangedSignal("Text"):Connect(uP) iC:GetPropertyChangedSignal("Text"):Connect(parseColor)

sC.MouseButton1Click:Connect(function()
    sC.Text, sC.BackgroundColor3 = "CLICK PLOT PART...", Color3.fromRGB(180,50,50)
    local conn; conn = mP.Button1Down:Connect(function()
        if mP.Target then cCF = mP.Target.CFrame sC.Text, sC.BackgroundColor3 = "CENTER SET", Color3.fromRGB(0,135,85) conn:Disconnect() uP() end
    end)
end)

pV.MouseButton1Click:Connect(function()
    if not cCF then
        pV.Text = "Select A Center Before Previewing" pV.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        task.delay(2, function() if not showPrev then pV.Text = "PREVIEW: OFF" pV.BackgroundColor3 = Color3.fromRGB(58,62,68) end end) return
    end
    showPrev = not showPrev pV.Text = showPrev and "PREVIEW: ON" or "PREVIEW: OFF"
    pV.BackgroundColor3 = showPrev and Color3.fromRGB(0,135,85) or Color3.fromRGB(58,62,68) uP()
end)

tB.MouseButton1Click:Connect(function()
    uC = not uC tB.Text = uC and "PAINTING: ON" or "PAINTING: OFF"
    tB.BackgroundColor3 = uC and Color3.fromRGB(0,110,185) or Color3.fromRGB(85,88,94)
    iC.TextEditable = uC iC.BackgroundColor3 = uC and Color3.fromRGB(44,44,50) or Color3.fromRGB(36,36,40)
    if not uC then cP.BackgroundColor3 = Color3.fromRGB(163,162,165) end uP()
end)

bD.MouseButton1Click:Connect(function()
    if not cCF then sC.Text, sC.BackgroundColor3 = "SET CENTER FIRST!", Color3.fromRGB(180,50,50) return end
    clearHologram() local r, nB, sY, sX, sZ = tonumber(iR.Text) or 30, tonumber(iB.Text) or 120, tonumber(iY.Text) or 2, tonumber(aX.Text) or 0.05, tonumber(aZ.Text) or 0.5
    local ch = P.Character or P.CharacterAdded:Wait() local h = ch:WaitForChild("Humanoid")
    local f = workspace:WaitForChild("Blocks"):WaitForChild(P.Name) local gID = "R_" .. tostring(os.time())
    
    local requestsSent = 0
    for i = 1, nB do
        local a = (i / nB) * (2 * math.pi)
        local bP = cCF * CFrame.new(math.cos(a)*r, 0, math.sin(a)*r) * CFrame.Angles(0, -a, 0)
        
        local t1 = P.Backpack:FindFirstChild("BuildingTool") or ch:FindFirstChild("BuildingTool")
        if t1 then h:EquipTool(t1) t1:WaitForChild("RF"):InvokeServer("PlasticBlock", 8001, workspace:WaitForChild("WhiteZone"), CFrame.new(-10, 6.1, -20) * CFrame.Angles(0,-a,0), true, bP, false) requestsSent = requestsSent + 1 end
        task.wait(0.05)
        local pB = f:FindFirstChild("PlasticBlock") local t2 = P.Backpack:FindFirstChild("ScalingTool") or ch:FindFirstChild("ScalingTool")
        if pB and t2 then h:EquipTool(t2) pB.Name = gID t2:WaitForChild("RF"):InvokeServer(pB, Vector3.new(sX, sY, sZ), bP) requestsSent = requestsSent + 1 end
        task.wait(0.05)
        if uC then local t3 = P.Backpack:FindFirstChild("PaintingTool") or ch:FindFirstChild("PaintingTool")
            if pB and t3 then h:EquipTool(t3) t3:WaitForChild("RF"):InvokeServer({{{pB, cP.BackgroundColor3}}}) requestsSent = requestsSent + 1 end
            task.wait(0.05)
        end
        h:UnequipTools()
        if requestsSent >= 15 then task.wait(0.5) requestsSent = 0 end
    end
    for _, b in ipairs(f:GetChildren()) do if b.Name == gID then b.Name = "PlasticBlock" end end
end)
uP()
