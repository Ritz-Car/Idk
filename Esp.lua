local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function createESP(parent, name)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP"
    esp.Parent = parent
    esp.Size = UDim2.new(0, 100, 0, 50)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    esp.AlwaysOnTop = true

    -- Create name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextScaled = true
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black stroke
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = esp

    -- Create health bar background
    local healthBarBg = Instance.new("Frame")
    healthBarBg.Size = UDim2.new(1, 0, 0.3, 0)
    healthBarBg.Position = UDim2.new(0, 0, 0.3, 0)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Dark gray background
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = esp

    -- Create health bar
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green bar
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg

    -- Create distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextScaled = true
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black stroke
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Parent = esp

    -- Add highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Parent = parent
    highlight.FillColor = Color3.fromRGB(0, 170, 255) -- Light blue highlight
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0) -- Black outline

    return esp, nameLabel, healthBar, distanceLabel
end

function updateHealthBar(humanoid, healthBar)
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
end

function updateDistanceLabel(object, distanceLabel)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (object.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        distanceLabel.Text = "Distance: " .. math.floor(distance) .. " studs"
    end
end

function addESPToModel(model)
    local head = model:FindFirstChild("Head")
    if head then
        local esp, nameLabel, healthBar, distanceLabel = createESP(head, model.Name)

        -- Check if the model has a humanoid (for players and NPCs)
        local humanoid = model:FindFirstChild("Humanoid")
        if humanoid then
            updateHealthBar(humanoid, healthBar)
            humanoid.HealthChanged:Connect(function()
                updateHealthBar(humanoid, healthBar)
            end)
        else
            -- If no humanoid, hide the health bar
            healthBar.Parent.Visible = false
        end

        -- Update distance dynamically
        RunService.RenderStepped:Connect(function()
            updateDistanceLabel(head, distanceLabel)
        end)

        nameLabel.Text = model.Name
        print("h") -- Indicate ESP was added to a model
    end
end

function addESPToTool(tool)
    local handle = tool:FindFirstChild("Handle")
    if handle then
        local esp, nameLabel, healthBar, distanceLabel = createESP(handle, tool.Name)
        healthBar.Parent.Visible = false -- Hide health bar for tools

        -- Update distance dynamically
        RunService.RenderStepped:Connect(function()
            updateDistanceLabel(handle, distanceLabel)
        end)

        nameLabel.Text = tool.Name
        print("h") -- Indicate ESP was added to a tool
    end
end

function onDescendantAdded(descendant)
    if descendant:IsA("Model") then
        addESPToModel(descendant)
    elseif descendant:IsA("Tool") then
        addESPToTool(descendant)
    end
end

function addESPToPlayersAndItems()
    for _, object in pairs(workspace:GetDescendants()) do
        if object:IsA("Model") then
            addESPToModel(object)
        elseif object:IsA("Tool") then
            addESPToTool(object)
        end
    end
end

workspace.DescendantAdded:Connect(onDescendantAdded)
addESPToPlayersAndItems()
