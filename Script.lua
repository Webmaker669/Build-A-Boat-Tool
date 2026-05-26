local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local PlayerGui = Player:WaitForChild("PlayerGui")

local cCF = nil
local uC = true
local showPrev = false
local isMinimized = false

local playerFolder = workspace:WaitForChild("Blocks"):WaitForChild(Player.Name)
local previewFolder = Instance.new("Folder", workspace)
previewFolder.Name = "CircleHologram"

if PlayerGui:FindFirstChild("StudioUI") then
    PlayerGui.StudioUI:Destroy()
end

local sG = Instance.new("ScreenGui")
sG.Name = "StudioUI"
sG.ResetOnSpawn = false
sG.Parent = PlayerGui

local m = Instance.new("Frame", sG)
m.Size = UDim2.new(0, 340, 0, 320)
m.Position = UDim2.new(0.05, 0, 0.2, 0)
m.BackgroundTransparency = 1
m.BorderSizePixel = 0

local hb = Instance.new("Frame", m)
hb.Size = UDim2.new(1, 0, 0, 32)
hb.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
hb.BorderSizePixel = 0
hb.Active = true
Instance.new("UICorner", hb).CornerRadius = UDim.new(0, 8)

local t = Instance.new("TextLabel", hb)
t.Size = UDim2.new(1, -80, 1, 0)
t.Text = "  Seamless Circle Studio"
t.TextColor3 = Color3.fromRGB(240, 240, 245)
t.TextSize = 13
t.Font = 4
t.TextXAlignment = 0
t.BackgroundTransparency = 1

local oB = Instance.new("TextButton", sG)
oB.Size = UDim2.new(0, 90, 0, 30)
oB.Position = UDim2.new(0, 0, 0.5, -15)
oB.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
oB.Text = "Open Studio"
oB.TextColor3 = Color3.new(1, 1, 1)
oB.Font = 4
oB.TextSize = 13
oB.Visible = false
Instance.new("UICorner", oB).CornerRadius = UDim.new(0, 6)

local cf = Instance.new("Frame", m)
cf.Size = UDim2.new(1, 0, 0, 285)
cf.Position = UDim2.new(0, 0, 0, 32)
cf.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
cf.BorderSizePixel = 0
Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 8)

local drag, dInp, dStart, sPos
hb.InputBegan:Connect(function(i)
    local t = i.UserInputType
    if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
        drag = true
        dStart = i.Position
        sPos = m.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                drag = false
            end
        end)
    end
end)

hb.InputChanged:Connect(function(i)
    local t = i.UserInputType
    if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
        dInp = i
    end
end)

UIS.InputChanged:Connect(function(i)
    if i == dInp and drag then
        local d = i.Position - dStart
        local xO = sPos.X.Offset + d.X
        local yO = sPos.Y.Offset + d.Y
        m.Position = UDim2.new(sPos.X.Scale, xO, sPos.Y.Scale, yO)
    end
end)

local function cBtn(n, x, y, w, h, c, p)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0, w, 0, h)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = c
    b.Text = n
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = 4
    b.TextSize = 13
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local minBtn = cBtn("-", 260, 4, 24, 24, Color3.fromRGB(42, 42, 48), hb)
local clsBtn = cBtn("X", 288, 4, 24, 24, Color3.fromRGB(150, 50, 50), hb)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    cf.Visible = not isMinimized
    minBtn.Text = isMinimized and "+" or "-"
end)

clsBtn.MouseButton1Click:Connect(function()
    m.Visible, oB.Visible = false, true
end)

oB.MouseButton1Click:Connect(function()
    m.Visible, oB.Visible = true, false
end)
local cP = Instance.new("Frame", cf)
cP.Size = UDim2.new(0, 40, 0, 40)
cP.Position = UDim2.new(0, 280, 0, 12)
cP.BackgroundColor3 = Color3.new(1, 1, 1)
cP.BorderSizePixel = 0
Instance.new("UICorner", cP).CornerRadius = UDim.new(0, 6)

local pF = Instance.new("Frame", cf)
pF.Size = UDim2.new(0, 250, 0, 40)
pF.Position = UDim2.new(0, 18, 0, 12)
pF.BackgroundTransparency = 1

local uG = Instance.new("UIGridLayout", pF)
uG.CellSize = UDim2.new(0, 23, 0, 19)
uG.CellPadding = UDim2.new(0, 2, 0, 2)

local robloxColors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0),
    Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,255,255), Color3.fromRGB(163,162,165),
    Color3.fromRGB(0,0,0), Color3.fromRGB(255,170,0),
    Color3.fromRGB(170,85,0), Color3.fromRGB(0,85,0),
    Color3.fromRGB(85,0,127), Color3.fromRGB(170,0,0),
    Color3.fromRGB(85,170,255), Color3.fromRGB(255,170,255),
    Color3.fromRGB(100,20,20), Color3.fromRGB(20,100,20),
    Color3.fromRGB(20,20,100), Color3.fromRGB(245,205,48)
}

local function cI(n, p, x, y, r)
    local l = Instance.new("TextLabel", cf)
    l.Size = UDim2.new(0, 65, 0, 22)
    l.Position = UDim2.new(0, x, 0, y)
    l.Text = n
    l.TextColor3 = Color3.fromRGB(180, 180, 185)
    l.TextSize = 12
    l.Font = 3
    l.TextXAlignment = 0
    l.BackgroundTransparency = 1

    local b = Instance.new("TextBox", cf)
    b.Size = UDim2.new(0, 80, 0, 22)
    b.Position = UDim2.new(0, x + 65, 0, y)
    b.BackgroundColor3 = r and Color3.fromRGB(36, 36, 40) or Color3.fromRGB(44, 44, 50)
    b.TextColor3 = r and Color3.fromRGB(140, 140, 145) or Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.Text = p
    b.ClearTextOnFocus = false
    b.Font = 3
    b.TextSize = 13
    b.TextEditable = not r
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local iR = cI("Radius:", "30", 20, 68)
local iB = cI("Blocks:", "120", 170, 68)
local aX = cI("Thick (X):", "0.05", 20, 96, true)
local iY = cI("Height (Y):", "2.0", 170, 96)
local aZ = cI("Length (Z):", "Calculated", 20, 124, true)
local iC = cI("RGB Val:", "1,1,1", 170, 124)

local sC = cBtn("SELECT CENTER", 20, 158, 145, 28, Color3.fromRGB(130, 85, 180), cf)
local pV = cBtn("PREVIEW: OFF", 175, 158, 145, 28, Color3.fromRGB(58, 62, 68), cf)
local tB = cBtn("PAINTING: ON", 20, 194, 300, 28, Color3.fromRGB(0, 110, 185), cf)
local bD = cBtn("BUILD SEAMLESS CIRCLE", 20, 232, 300, 36, Color3.fromRGB(0, 135, 85), cf)

local function uP()
    local r = tonumber(iR.Text) or 30
    local b = tonumber(iB.Text) or 120
    local y = tonumber(iY.Text) or 2
    local sZ = ((2 * math.pi * r) / b) + 0.02
    aZ.Text = string.format("%.3f", sZ)
    previewFolder:ClearAllChildren()
    if cCF and showPrev then
        local maxRender = math.min(b, 80)
        for i = 1, maxRender do
            local step = (i / maxRender) * (2 * math.pi)
            local p = Instance.new("Part", previewFolder)
            p.Size = Vector3.new(0.05, y, sZ * (b / maxRender))
            p.CFrame = cCF * CFrame.new(math.cos(step) * r, 0, math.sin(step) * r) * CFrame.Angles(0, -step, 0)
            p.Anchored = true
            p.CanCollide = false
            p.Color = cP.BackgroundColor3
            p.Transparency = 0.5
            p.Material = Enum.Material.ForceField
        end
    end
end

for _, c in ipairs(robloxColors) do
    local sw = Instance.new("TextButton", pF)
    sw.BackgroundColor3 = c
    sw.Text = ""
    sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 4)
    sw.MouseButton1Click:Connect(function()
        cP.BackgroundColor3 = c
        iC.Text = string.format("%.2f, %.2f, %.2f", c.R, c.G, c.B)
        uP()
    end)
end

local function pC()
    local rS, gS, bS = iC.Text:match("([^,]+),([^,]+),([^,]+)")
    if rS and gS and bS then
        local red = tonumber(rS) or 1
        local grn = tonumber(gS) or 1
        local blu = tonumber(bS) or 1
        cP.BackgroundColor3 = Color3.new(red, grn, blu)
        uP()
    end
end

iR:GetPropertyChangedSignal("Text"):Connect(uP)
iB:GetPropertyChangedSignal("Text"):Connect(uP)
iY:GetPropertyChangedSignal("Text"):Connect(uP)
iC:GetPropertyChangedSignal("Text"):Connect(pC)

sC.MouseButton1Click:Connect(function()
    sC.Text = "CLICK PLOT PART..."
    sC.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    local conn
    conn = Mouse.Button1Down:Connect(function()
        if Mouse.Target then
            cCF = Mouse.Target.CFrame
            sC.Text = "CENTER SET"
            sC.BackgroundColor3 = Color3.fromRGB(0, 135, 85)
            conn:Disconnect()
            uP()
        end
    end)
end)

pV.MouseButton1Click:Connect(function()
    if not cCF then
        pV.Text = "Select A Center Before Previewing"
        pV.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        task.delay(2, function()
            if not showPrev then
                pV.Text = "PREVIEW: OFF"
                pV.BackgroundColor3 = Color3.fromRGB(58, 62, 68)
            end
        end)
        return
    end
    showPrev = not showPrev
    pV.Text = showPrev and "PREVIEW: ON" or "PREVIEW: OFF"
    local c1 = Color3.fromRGB(0, 135, 85)
    local c2 = Color3.fromRGB(58, 62, 68)
    pV.BackgroundColor3 = showPrev and c1 or c2
    uP()
end)

tB.MouseButton1Click:Connect(function()
    uC = not uC
    tB.Text = uC and "PAINTING: ON" or "PAINTING: OFF"
    local c1 = Color3.fromRGB(0, 110, 185)
    local c2 = Color3.fromRGB(85, 88, 94)
    tB.BackgroundColor3 = uC and c1 or c2
    iC.TextEditable = uC
    iC.BackgroundColor3 = uC and Color3.fromRGB(44, 44, 50) or Color3.fromRGB(36, 36, 40)
    if not uC then
        cP.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
    end
    uP()
end)

bD.MouseButton1Click:Connect(function()
    if not cCF then
        sC.Text = "SET CENTER FIRST!"
        sC.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        return
    end
    previewFolder:ClearAllChildren()
    local r = tonumber(iR.Text) or 30
    local nB = tonumber(iB.Text) or 120
    local sY = tonumber(iY.Text) or 2
    local sX = tonumber(aX.Text) or 0.05
    local sZ = tonumber(aZ.Text) or 0.5
    local ch = Player.Character or Player.CharacterAdded:Wait()
    local h = ch:WaitForChild("Humanoid")
    local gID = "R_" .. tostring(os.time())
    local rS = 0
    
    for i = 1, nB do
        local a = (i / nB) * (2 * math.pi)
        local cosA = math.cos(a) * r
        local sinA = math.sin(a) * r
        local bP = cCF * CFrame.new(cosA, 0, sinA) * CFrame.Angles(0, -a, 0)
        
        local t1 = Player.Backpack:FindFirstChild("BuildingTool") or ch:FindFirstChild("BuildingTool")
        if t1 then
            h:EquipTool(t1)
            local wZ = workspace:WaitForChild("WhiteZone")
            local rot = CFrame.new(-10, 6.1, -20) * CFrame.Angles(0, -a, 0)
            t1:WaitForChild("RF"):InvokeServer("PlasticBlock", 8001, wZ, rot, true, bP, false)
            rS = rS + 1
        end
        task.wait(0.05)
        
        local pB = playerFolder:FindFirstChild("PlasticBlock")
        local t2 = Player.Backpack:FindFirstChild("ScalingTool") or ch:FindFirstChild("ScalingTool")
        if pB and t2 then
            h:EquipTool(t2)
            pB.Name = gID
            t2:WaitForChild("RF"):InvokeServer(pB, Vector3.new(sX, sY, sZ), bP)
            rS = rS + 1
        end
        task.wait(0.05)
        
        if uC then
            local t3 = Player.Backpack:FindFirstChild("PaintingTool") or ch:FindFirstChild("PaintingTool")
            if pB and t3 then
                h:EquipTool(t3)
                t3:WaitForChild("RF"):InvokeServer({{{pB, cP.BackgroundColor3}}})
                rS = rS + 1
            end
            task.wait(0.05)
        end
        h:UnequipTools()
        if rS >= 15 then
            task.wait(0.5)
            rS = 0
        end
    end
    for _, b in ipairs(playerFolder:GetChildren()) do
        if b.Name == gID then
            b.Name = "PlasticBlock"
        end
    end
end)
uP()
