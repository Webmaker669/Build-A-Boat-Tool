local P, cCF, mP = game:GetService("Players").LocalPlayer, nil, game:GetService("Players").LocalPlayer:GetMouse()
local sG = Instance.new("ScreenGui", P:WaitForChild("PlayerGui")) sG.Name = "StudioUI" sG.ResetOnSpawn = false

-- Main Drag Container Frame
local m = Instance.new("Frame", sG) m.Size, m.Position = UDim2.new(0,340,0,460), UDim2.new(0.05,0,0.2,0)
m.BackgroundTransparency = 1 m.BorderSizePixel = 0

-- Header Bar (Locked for Dragging Only)
local hb = Instance.new("Frame", m) hb.Size, hb.Position = UDim2.new(1,0,0,38), UDim2.new(0,0,0,0)
hb.BackgroundColor3, hb.BorderSizePixel, hb.Active = Color3.fromRGB(24,24,28), 0, true
Instance.new("UICorner", hb).CornerRadius = UDim.new(0,10)

-- Header Visual Patch to smooth bottom corners
local hp = Instance.new("Frame", hb) hp.Size, hp.Position = UDim2.new(1,0,0,10), UDim2.new(0,0,0,28)
hp.BackgroundColor3, hp.BorderSizePixel = Color3.fromRGB(24,24,28), 0

local t = Instance.new("TextLabel", hb) t.Size, t.Text = UDim2.new(1,-80,1,0), "  Seamless Circle Studio"
t.TextColor3, t.TextSize, t.Font, t.TextXAlignment = Color3.fromRGB(240,240,245), 14, 4, 0 t.BackgroundTransparency = 1

-- Side Open Button Panel (Initially Hidden)
local oB = Instance.new("TextButton", sG) oB.Size, oB.Position = UDim2.new(0,90,0,32), UDim2.new(0,0,0.5,-16)
oB.BackgroundColor3, oB.Text, oB.TextColor3, oB.Font, oB.TextSize, oB.Visible = Color3.fromRGB(30,30,35), "Open Studio", Color3.new(1,1,1), 4, 13, false
Instance.new("UICorner", oB).CornerRadius = UDim.new(0,6)

-- Main Body Content Frame (Holds everything to fix minimize glitch)
local cf = Instance.new("Frame", m) cf.Size, cf.Position = UDim2.new(1,0,0,422), UDim2.new(0,0,0,38)
cf.BackgroundColor3, cf.BorderSizePixel = Color3.fromRGB(30,30,35), 0
local cc = Instance.new("UICorner", cf) cc.CornerRadius = UDim.new(0,10)
local cp2 = Instance.new("Frame", cf) cp2.Size, cp2.Position = UDim2.new(1,0,0,10), UDim2.new(0,0,0,0)
cp2.BackgroundColor3, cp2.BorderSizePixel = Color3.fromRGB(30,30,35), 0

-- Custom Precise Dragging Engine Engine (Headers Only)
local dragging, dragInput, dragStart, startPos
hb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = m.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
hb.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Header Windows Controls Mini/Close
local minBtn = Instance.new("TextButton", hb) minBtn.Size, minBtn.Position = UDim2.new(0,26,0,26), UDim2.new(1,-62,0,6)
minBtn.BackgroundColor3, minBtn.Text, minBtn.TextColor3, minBtn.Font, minBtn.TextSize = Color3.fromRGB(42,42,48), "-", Color3.new(1,1,1), 4, 18
minBtn.BorderSizePixel = 0 Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local clsBtn = Instance.new("TextButton", hb) clsBtn.Size, clsBtn.Position = UDim2.new(0,26,0,26), UDim2.new(1,-32,0,6)
clsBtn.BackgroundColor3, clsBtn.Text, clsBtn.TextColor3, clsBtn.Font, clsBtn.TextSize = Color3.fromRGB(150,50,50), "X", Color3.new(1,1,1), 4, 14
clsBtn.BorderSizePixel = 0 Instance.new("UICorner", clsBtn).CornerRadius = UDim.new(0,6)

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        cf.Visible = false minBtn.Text = "+"
    else
        cf.Visible = true minBtn.Text = "-"
    end
end)

clsBtn.MouseButton1Click:Connect(function() m.Visible = false oB.Visible = true end)
oB.MouseButton1Click:Connect(function() m.Visible = true oB.Visible = false end)

local cP = Instance.new("Frame", cf) cP.Size, cP.Position = UDim2.new(0,42,0,42), UDim2.new(0,278,0,14)
cP.BackgroundColor3, cP.BorderSizePixel = Color3.new(1,1,1), 0 Instance.new("UICorner", cP).CornerRadius = UDim.new(0,8)

-- Palette Element Grid Structure
local pF = Instance.new("Frame", cf) pF.Size, pF.Position = UDim2.new(0,250,0,42), UDim2.new(0,20,0,14)
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
    local l = Instance.new("TextLabel", cf) l.Size, l.Position = UDim2.new(0,65,0,24), UDim2.new(0,x,0,y)
    l.Text, l.TextColor3, l.TextSize, l.Font, l.TextXAlignment = n, Color3.fromRGB(180,180,185), 13, 3, 0 l.BackgroundTransparency = 1
    local b = Instance.new("TextBox", cf) b.Size, b.Position = UDim2.new(0,80,0,24), UDim2.new(0,x+65,0,y)
    b.BackgroundColor3 = r and Color3.fromRGB(36,36,40) or Color3.fromRGB(44,44,50)
    b.TextColor3 = r and Color3.fromRGB(140,140,145) or Color3.new(1,1,1) b.BorderSizePixel = 0
    b.Text, b.ClearTextOnFocus, b.Font, b.TextSize, b.TextEditable = p, false, 3, 13, not r
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5) return b
end

local iR = cI("Radius:", "30", 20, 77) local iB = cI("Blocks:", "120", 170, 77)
local aX = cI("Thick (X):", "0.05", 20, 110, true) local iY = cI("Height (Y):", "2.0", 170, 110)
local aZ = cI("Length (Z):", "Calculated", 20, 143, true) local iC = cI("RGB Val:", "1,1,1", 170, 143)

local function cB(n, x, y, w, h, c)
    local btn = Instance.new("TextButton", cf) btn.Size, btn.Position = UDim2.new(0,w,0,h), UDim2.new(0,x,0,y)
    btn.BackgroundColor3, btn.Text, btn.TextColor3, btn.Font, btn.TextSize, btn.BorderSizePixel = c, n, Color3.new(1,1,1), 4, 13, 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6) return btn
end

local sC = cB("SELECT CENTER", 20, 182, 145, 32, Color3.fromRGB(130,85,180))
local pV = cB("PREVIEW: OFF", 175, 182, 145, 32, Color3.fromRGB(58,62,68))
local tB = cB("PAINTING: ON", 20, 222, 300, 32, Color3.fromRGB(0,110,185))
local bD = cB("BUILD SEAMLESS CIRCLE", 20, 267, 300, 40, Color3.fromRGB(0,135,85))

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
