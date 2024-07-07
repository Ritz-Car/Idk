local ESP_ENABLED = true

-- Function to toggle ESP on/off
function toggleESP()
    ESP_ENABLED = not ESP_ENABLED
    print(ESP_ENABLED and "ESP On" or "ESP Off")
    if not ESP_ENABLED then
        for _, esp in pairs(workspace:GetDescendants()) do
            if esp:IsA("BillboardGui") and esp.Name == "ESP" then
                esp:Destroy()
            end
        end
    else
        addESPToPlayersAndItems()
    end
end

local function createESP(parent, name)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP"
    esp.Parent = parent
    esp.Size = UDim2.new(0, 100, 0, 50)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    esp.AlwaysOnTop = true

    -- create name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- green text
    nameLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0) -- red stroke
    nameLabel.TextStrokeTransparency = 0
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = esp

    -- create health bar background
    local healthBarBg = Instance.new("Frame")
    healthBarBg.Size = UDim2.new(1, 0, 0.3, 0)
    healthBarBg.Position = UDim2.new(0, 0, 0.3, 0)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- red background
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = esp

    -- create health bar with rounded corners
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- green bar
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = healthBar

    -- create distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- green text
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0) -- red stroke
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Parent = esp

    return esp, nameLabel, healthBar, distanceLabel
end

local function updateHealthBar(humanoid, healthBar)
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
end

local function addESPToObject(object)
    local head = object:FindFirstChild("Head") or object:FindFirstChild("Handle")
    if head then
        local esp, nameLabel, healthBar, distanceLabel = createESP(head, object.Name)

        -- Check if the model has a humanoid (for players and NPCs)
        local humanoid = object:FindFirstChild("Humanoid")
        if humanoid then
            updateHealthBar(humanoid, healthBar)
            humanoid.HealthChanged:Connect(function()
                if ESP_ENABLED then
                    updateHealthBar(humanoid, healthBar)
                end
            end)
        else
            healthBar.Parent.Visible = false -- Hide health bar for tools
        end

        -- Calculate distance
        local localPlayer = game.Players.LocalPlayer
        if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = localPlayer.Character.HumanoidRootPart
            game:GetService("RunService").Heartbeat:Connect(function()
                if ESP_ENABLED and object.Parent then
                    local distance = (object.PrimaryPart.Position - hrp.Position).Magnitude
                    distanceLabel.Text = "Distance: " .. math.floor(distance) .. " studs"
                end
            end)
        end

        nameLabel.Text = object.Name
    end
end

local function addESPToPlayersAndItems()
    if not ESP_ENABLED then return end
    for _, object in pairs(workspace:GetDescendants()) do
        if (object:IsA("Model") and (object:FindFirstChild("Humanoid") or object:FindFirstChild("Tool"))) or object:IsA("Tool") then
            addESPToObject(object)
        end
    end
end

-- Refresh ESP periodically
game:GetService("RunService").Stepped:Connect(function()
    if ESP_ENABLED then
        addESPToPlayersAndItems()
        print("ESP refreshed")
    end
end)

-- Create a button to toggle ESP on/off
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 100, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Toggle ESP"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.MouseButton1Click:Connect(toggleESP)

addESPToPlayersAndItems()
