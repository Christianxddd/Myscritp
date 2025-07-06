-- By ChristianSebas 🦅
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ChristianSebasUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Botón flotante "C"
local cBtn = Instance.new("TextButton")
cBtn.Size = UDim2.new(0, 60, 0, 60)
cBtn.Position = UDim2.new(0.5, -30, 0.5, -30)
cBtn.Text = "C"
cBtn.TextScaled = true
cBtn.Font = Enum.Font.SourceSansBold
cBtn.TextColor3 = Color3.new(1, 1, 1)
cBtn.BackgroundColor3 = Color3.new(0, 0, 0)
cBtn.BorderSizePixel = 0
cBtn.Active = true
cBtn.Draggable = true
cBtn.Parent = gui

-- Bordes redondos
local corner = Instance.new("UICorner", cBtn)
corner.CornerRadius = UDim.new(1, 0)

-- Menú oculto
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 200, 0, 250)
menu.Position = UDim2.new(0.5, -100, 0.5, -125)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.Visible = false
menu.Parent = gui

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "By ChristianSebas"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local function crearBoton(nombre, y)
    local btn = Instance.new("TextButton", menu)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, y, 0)
    btn.Text = nombre
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    return btn
end

local speedBtn = crearBoton("Velocidad +", 0.2)
local flyBtn = crearBoton("Fly V3", 0.4)
local xrayBtn = crearBoton("Ver nombres", 0.6)
local cerrarBtn = crearBoton("Cerrar", 0.8)
cerrarBtn.TextColor3 = Color3.fromRGB(255, 50, 50)

-- Toggle menú
cBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

cerrarBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- Funciones
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

speedBtn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 100 -- Cambia aquí si deseas otra velocidad
end)

flyBtn.MouseButton1Click:Connect(function()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local flying = true
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.new(0, 0, 0)

    local UIS = game:GetService("UserInputService")
    local flySpeed = 50
    local dir = Vector3.new()

    local conn = UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then dir = Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then dir = Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then dir = Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then dir = Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then dir = Vector3.new(0, 1, 0) end
    end)

    spawn(function()
        while flying do
            wait()
            bv.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(dir) * flySpeed
        end
    end)

    wait(10)
    flying = false
    bv:Destroy()
    conn:Disconnect()
end)

xrayBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") and not v.Character.Head:FindFirstChild("NameTag") then
            local billboard = Instance.new("BillboardGui", v.Character.Head)
            billboard.Name = "NameTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.Adornee = v.Character.Head
            billboard.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel", billboard)
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = v.Name
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextScaled = true
        end
    end
end)
