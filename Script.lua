local P = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local M = P:GetMouse()

local sG = Instance.new("ScreenGui")
sG.Name = "StudioUI"
sG.ResetOnSpawn = false
sG.Parent = P:WaitForChild("PlayerGui")

local cCF = nil
local uC = true
local sP = false
local isMin = false
local isBuilding = false
local cancelBuild = false

local f = workspace:WaitForChild("Blocks"):WaitForChild(P.Name)

local function getZone()
    local team = P.Team
    if team then
        local zoneName = team.TeamColor.Name .. "Zone"
        local zone = workspace:FindFirstChild(zoneName)
        if zone then return zone end
    end
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name:sub(-4) == "Zone" then return v end
    end
    return workspace
end

-- Finds a tool by name in backpack OR character
local function getTool(name)
    local ch = P.Character
    if not ch then return nil end
    return P.Backpack:FindFirstChild(name)
        or ch:FindFirstChild(name)
end

local pFld = Instance.new("Folder")
pFld.Name = "CircleHologram"
pFld.Parent = workspace

local m = Instance.new("Frame")
m.Parent = sG
m.Size = UDim2.new(0, 340, 0, 340)
m.Position = UDim2.new(0.05, 0, 0.2, 0)
m.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
m.BorderSizePixel = 0

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 8)
mCorner.Parent = m

local hb = Instance.new("Frame")
hb.Parent = m
hb.Size = UDim2.new(1, 0, 0, 32)
hb.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
hb.BorderSizePixel = 0
hb.Active = true
hb.ZIndex = 2

local tLbl = Instance.new("TextLabel")
tLbl.Parent = hb
tLbl.Size = UDim2.new(1, -80, 1, 0)
tLbl.Text = "  Seamless Circle Studio"
tLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
tLbl.TextSize = 13
tLbl.Font = Enum.Font.SourceSansBold
tLbl.TextXAlignment = Enum.TextXAlignment.Left
tLbl.BackgroundTransparency = 1
tLbl.ZIndex = 2

local oB = Instance.new("TextButton")
oB.Parent = sG
oB.Size = UDim2.new(0, 110, 0, 30)
oB.Position = UDim2.new(0, 10, 1, -45)
oB.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
oB.Text = "Open Studio"
oB.TextColor3 = Color3.new(1, 1, 1)
oB.Font = Enum.Font.SourceSansBold
oB.TextSize = 13
oB.Visible = false

local oBCorner = Instance.new("UICorner")
oBCorner.CornerRadius = UDim.new(0, 6)
oBCorner.Parent = oB

local cf = Instance.new("Frame")
cf.Parent = m
cf.Size = UDim2.new(1, 0, 0, 308)
cf.Position = UDim2.new(0, 0, 0, 32)
cf.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
cf.BorderSizePixel = 0

local cfCorner = Instance.new("UICorner")
cfCorner.CornerRadius = UDim.new(0, 8)
cfCorner.Parent = cf

local drag = false
local dInp, dStart, sPos

hb.InputBegan:Connect(function(i)
    local typ = i.UserInputType
    if typ == Enum.UserInputType.MouseButton1 or typ == Enum.UserInputType.Touch then
        drag = true
        dStart = i.Position
        sPos = m.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then drag = false end
        end)
    end
end)

hb.InputChanged:Connect(function(i)
    local typ = i.UserInputType
    if typ == Enum.UserInputType.MouseMovement or typ == Enum.UserInputType.Touch then
        dInp = i
    end
end)

UIS.InputChanged:Connect(function(i)
    if i == dInp and drag then
        local d = i.Position - dStart
        m.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
    end
end)

local function cBtn(n, x, y, w, h, c, p)
    local b = Instance.new("TextButton")
    b.Parent = p
    b.Size = UDim2.new(0, w, 0, h)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = c
    b.Text = n
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.ZIndex = 3
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = b
    return b
end

local minBtn = cBtn("-", 260, 4, 24, 24, Color3.fromRGB(42, 42, 48), hb)
local clsBtn = cBtn("X", 288, 4, 24, 24, Color3.fromRGB(150, 50, 50), hb)

minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    cf.Visible = not isMin
    minBtn.Text = isMin and "+" or "-"
    m.Size = isMin and UDim2.new(0, 340, 0, 32) or UDim2.new(0, 340, 0, 340)
end)

clsBtn.MouseButton1Click:Connect(function()
    m.Visible = false
    oB.Visible = true
end)

oB.MouseButton1Click:Connect(function()
    m.Visible = true
    oB.Visible = false
end)

local cP = Instance.new("Frame")
cP.Parent = cf
cP.Size = UDim2.new(0, 40, 0, 40)
cP.Position = UDim2.new(0, 282, 0, 12)
cP.BackgroundColor3 = Color3.new(1, 1, 1)
cP.BorderSizePixel = 0

local cpCorner = Instance.new("UICorner")
cpCorner.CornerRadius = UDim.new(0, 6)
cpCorner.Parent = cP

local pF = Instance.new("Frame")
pF.Parent = cf
pF.Size = UDim2.new(0, 260, 0, 44)
pF.Position = UDim2.new(0, 14, 0, 10)
pF.BackgroundTransparency = 1

local uG = Instance.new("UIGridLayout")
uG.Parent = pF
uG.CellSize = UDim2.new(0, 23, 0, 20)
uG.CellPadding = UDim2.new(0, 2, 0, 2)

local robloxColors = {
    Color3.fromRGB(255,0,0),    Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,0,255),    Color3.fromRGB(255,255,0),
    Color3.fromRGB(255,0,255),  Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,255,255),Color3.fromRGB(163,162,165),
    Color3.fromRGB(0,0,0),      Color3.fromRGB(255,170,0),
    Color3.fromRGB(170,85,0),   Color3.fromRGB(0,85,0),
    Color3.fromRGB(85,0,127),   Color3.fromRGB(170,0,0),
    Color3.fromRGB(85,170,255), Color3.fromRGB(255,170,255),
    Color3.fromRGB(100,20,20),  Color3.fromRGB(20,100,20),
    Color3.fromRGB(20,20,100),  Color3.fromRGB(245,205,48)
}

local function cI(n, p, x, y, readOnly)
    local l = Instance.new("TextLabel")
    l.Parent = cf
    l.Size = UDim2.new(0, 72, 0, 22)
    l.Position = UDim2.new(0, x, 0, y)
    l.Text = n
    l.TextColor3 = Color3.fromRGB(180, 180, 185)
    l.TextSize = 12
    l.Font = Enum.Font.SourceSans
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1

    local b = Instance.new("TextBox")
    b.Parent = cf
    b.Size = UDim2.new(0, 73, 0, 22)
    b.Position = UDim2.new(0, x + 73, 0, y)
    b.BackgroundColor3 = readOnly and Color3.fromRGB(36,36,40) or Color3.fromRGB(44,44,50)
    b.TextColor3 = readOnly and Color3.fromRGB(140,140,145) or Color3.new(1,1,1)
    b.BorderSizePixel = 0
    b.Text = p
    b.ClearTextOnFocus = false
    b.Font = Enum.Font.SourceSans
    b.TextSize = 13
    b.TextEditable = not readOnly

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = b
    return b
end

local iR = cI("Radius:",     "30",         18,  68,  false)
local iB = cI("Blocks:",     "120",        168, 68,  false)
local aX = cI("Thick (X):",  "0.05",       18,  96,  false)
local iY = cI("Height (Y):", "2.0",        168, 96,  false)
local aZ = cI("Length (Z):", "Calculated", 18,  124, true)
local iC = cI("RGB Val:",    "1,1,1",      168, 124, false)

-- Tool name inputs
local function cIFull(n, p, x, y)
    local l = Instance.new("TextLabel")
    l.Parent = cf
    l.Size = UDim2.new(0, 85, 0, 22)
    l.Position = UDim2.new(0, x, 0, y)
    l.Text = n
    l.TextColor3 = Color3.fromRGB(180, 180, 185)
    l.TextSize = 12
    l.Font = Enum.Font.SourceSans
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1

    local b = Instance.new("TextBox")
    b.Parent = cf
    b.Size = UDim2.new(0, 205, 0, 22)
    b.Position = UDim2.new(0, x + 87, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(44,44,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    b.Text = p
    b.ClearTextOnFocus = false
    b.Font = Enum.Font.SourceSans
    b.TextSize = 13

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = b
    return b
end

local tN1 = cIFull("Build Tool:",   "BuildingTool", 18, 152)
local tN2 = cIFull("Scale Tool:",   "ScalingTool",  18, 178)
local tN3 = cIFull("Paint Tool:",   "PaintingTool", 18, 204)

local function cB(n, x, y, w, h, c)
    local btn = Instance.new("TextButton")
    btn.Parent = cf
    btn.Size = UDim2.new(0, w, 0, h)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = c
    btn.Text = n
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local sC = cB("SELECT CENTER",         20,  232, 145, 28, Color3.fromRGB(130,85,180))
local pV = cB("PREVIEW: OFF",          175, 232, 145, 28, Color3.fromRGB(58,62,68))
local tB = cB("PAINTING: ON",          20,  265, 300, 28, Color3.fromRGB(0,110,185))
local bD = cB("BUILD SEAMLESS CIRCLE", 20,  300, 300, 36, Color3.fromRGB(0,135,85))

-- Progress bar background
local pbBg = Instance.new("Frame")
pbBg.Parent = cf
pbBg.Size = UDim2.new(0, 300, 0, 6)
pbBg.Position = UDim2.new(0, 20, 0, 295)
pbBg.BackgroundColor3 = Color3.fromRGB(50,50,56)
pbBg.BorderSizePixel = 0
pbBg.Visible = false

local pbBgCorner = Instance.new("UICorner")
pbBgCorner.CornerRadius = UDim.new(0, 3)
pbBgCorner.Parent = pbBg

-- Progress bar fill
local pbFill = Instance.new("Frame")
pbFill.Parent = pbBg
pbFill.Size = UDim2.new(0, 0, 1, 0)
pbFill.BackgroundColor3 = Color3.fromRGB(0,200,100)
pbFill.BorderSizePixel = 0

local pbFillCorner = Instance.new("UICorner")
pbFillCorner.CornerRadius = UDim.new(0, 3)
pbFillCorner.Parent = pbFill

local function uP()
    local r  = tonumber(iR.Text) or 30
    local b  = tonumber(iB.Text) or 120
    local y  = tonumber(iY.Text) or 2
    local sZ = ((2 * math.pi * r) / b) + 0.02
    aZ.Text = string.format("%.3f", sZ)
    pFld:ClearAllChildren()

    if cCF and sP then
        local maxRender = math.min(b, 80)
        for i = 1, maxRender do
            local step = (i / maxRender) * (2 * math.pi)
            local p = Instance.new("Part")
            p.Parent = pFld
            p.Size = Vector3.new(0.05, y, sZ)
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
    local sw = Instance.new("TextButton")
    sw.Parent = pF
    sw.BackgroundColor3 = c
    sw.Text = ""
    sw.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = sw
    sw.MouseButton1Click:Connect(function()
        cP.BackgroundColor3 = c
        iC.Text = string.format("%.2f,%.2f,%.2f", c.R, c.G, c.B)
        uP()
    end)
end

local function pC()
    local rS, gS, bS = iC.Text:match("([^,]+),([^,]+),([^,]+)")
    if rS and gS and bS then
        cP.BackgroundColor3 = Color3.new(tonumber(rS) or 1, tonumber(gS) or 1, tonumber(bS) or 1)
        uP()
    end
end

iR:GetPropertyChangedSignal("Text"):Connect(uP)
iB:GetPropertyChangedSignal("Text"):Connect(uP)
iY:GetPropertyChangedSignal("Text"):Connect(uP)
iC:GetPropertyChangedSignal("Text"):Connect(pC)

sC.MouseButton1Click:Connect(function()
    if isBuilding then return end
    sC.Text = "CLICK PLOT PART..."
    sC.BackgroundColor3 = Color3.fromRGB(180,50,50)
    local conn
    conn = M.Button1Down:Connect(function()
        if M.Target then
            cCF = M.Target.CFrame
            sC.Text = "CENTER SET ✓"
            sC.BackgroundColor3 = Color3.fromRGB(0,135,85)
            conn:Disconnect()
            uP()
        end
    end)
end)

pV.MouseButton1Click:Connect(function()
    if isBuilding then return end
    if not cCF then
        pV.Text = "SELECT CENTER FIRST"
        pV.BackgroundColor3 = Color3.fromRGB(180,50,50)
        task.delay(2, function()
            if not sP then
                pV.Text = "PREVIEW: OFF"
                pV.BackgroundColor3 = Color3.fromRGB(58,62,68)
            end
        end)
        return
    end
    sP = not sP
    pV.Text = sP and "PREVIEW: ON" or "PREVIEW: OFF"
    pV.BackgroundColor3 = sP and Color3.fromRGB(0,135,85) or Color3.fromRGB(58,62,68)
    uP()
end)

tB.MouseButton1Click:Connect(function()
    if isBuilding then return end
    uC = not uC
    tB.Text = uC and "PAINTING: ON" or "PAINTING: OFF"
    tB.BackgroundColor3 = uC and Color3.fromRGB(0,110,185) or Color3.fromRGB(85,88,94)
    if not uC then cP.BackgroundColor3 = Color3.fromRGB(163,162,165) end
    uP()
end)

bD.MouseButton1Click:Connect(function()
    -- CANCEL if already building
    if isBuilding then
        cancelBuild = true
        bD.Text = "CANCELLING..."
        bD.BackgroundColor3 = Color3.fromRGB(140,50,50)
        return
    end

    if not cCF then
        sC.Text = "SET CENTER FIRST!"
        sC.BackgroundColor3 = Color3.fromRGB(180,50,50)
        return
    end

    -- Validate tool names are filled in
    local buildName = tN1.Text ~= "" and tN1.Text or "BuildingTool"
    local scaleName = tN2.Text ~= "" and tN2.Text or "ScalingTool"
    local paintName = tN3.Text ~= "" and tN3.Text or "PaintingTool"

    isBuilding = true
    cancelBuild = false
    pFld:ClearAllChildren()

    bD.Text = "CANCEL BUILD"
    bD.BackgroundColor3 = Color3.fromRGB(180,50,50)
    pbBg.Visible = true
    pbFill.Size = UDim2.new(0, 0, 1, 0)

    local r  = tonumber(iR.Text)  or 30
    local nB = tonumber(iB.Text)  or 120
    local sY = tonumber(iY.Text)  or 2.0
    local sX = tonumber(aX.Text)  or 0.05
    local sZ = tonumber(aZ.Text)  or 0.5

    local ch = P.Character or P.CharacterAdded:Wait()
    local h  = ch:WaitForChild("Humanoid")
    local wZ = getZone()

    for i = 1, nB do
        -- Check cancel flag at top of every iteration
        if cancelBuild then break end

        local a   = (i / nB) * (2 * math.pi)
        local bCF = cCF
                  * CFrame.new(math.cos(a) * r, 0, math.sin(a) * r)
                  * CFrame.Angles(0, -a, 0)

        -- STEP 1: Place — find tool by user-supplied name
        local t1 = getTool(buildName)
        if not t1 then
            bD.Text = "TOOL NOT FOUND: " .. buildName
            bD.BackgroundColor3 = Color3.fromRGB(180,50,50)
            break
        end

        h:EquipTool(t1)
        task.wait(0.08)

        if cancelBuild then h:UnequipTools() break end

        local beforeCount = #f:GetChildren()

        t1:WaitForChild("RF"):InvokeServer(
            "PlasticBlock",
            8001,
            wZ,
            CFrame.new(-10, 6.1, -20) * CFrame.Angles(0, -a, 0),
            true,
            bCF,
            false
        )

        -- STEP 2: Wait for new block
        local pB = nil
        local elapsed = 0
        repeat
            task.wait(0.05)
            elapsed += 0.05
            if cancelBuild then break end
            local children = f:GetChildren()
            if #children > beforeCount then
                for idx = #children, 1, -1 do
                    if children[idx].Name == "PlasticBlock" then
                        pB = children[idx]
                        break
                    end
                end
            end
        until pB ~= nil or elapsed >= 3

        if cancelBuild then h:UnequipTools() break end

        if pB then
            -- STEP 3: Scale
            local t2 = getTool(scaleName)
            if t2 then
                h:EquipTool(t2)
                task.wait(0.08)
                if not cancelBuild then
                    t2:WaitForChild("RF"):InvokeServer(pB, Vector3.new(sX, sY, sZ), bCF)
                end
                task.wait(0.08)
            end

            -- STEP 4: Paint
            if uC and not cancelBuild then
                local t3 = getTool(paintName)
                if t3 then
                    h:EquipTool(t3)
                    task.wait(0.08)
                    if not cancelBuild then
                        t3:WaitForChild("RF"):InvokeServer({{{pB, cP.BackgroundColor3}}})
                    end
                    task.wait(0.08)
                end
            end
        end

        h:UnequipTools()
        task.wait(0.08)

        -- Update progress bar
        pbFill.Size = UDim2.new(i / nB, 0, 1, 0)
    end

    -- Cleanup
    isBuilding = false
    cancelBuild = false
    h:UnequipTools()
    pbBg.Visible = false
    pbFill.Size = UDim2.new(0, 0, 1, 0)
    bD.Text = "BUILD SEAMLESS CIRCLE"
    bD.BackgroundColor3 = Color3.fromRGB(0,135,85)
end)

uP()
