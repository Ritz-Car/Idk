function createESP(parent, name)
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
    nameLabel.FontSize = Enum.FontSize.Size14
    nameLabel.TextColor3 = Color3.new(0, 1, 0) -- green text
    nameLabel.TextStrokeColor3 = Color3.new(1, 0, 0) -- red stroke
    nameLabel.TextStrokeTransparency = 0
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = esp

    -- create health bar background
    local healthBarBg = Instance.new("Frame")
    healthBarBg.Size = UDim2.new(1, 0, 0.3, 0)
    healthBarBg.Position = UDim2.new(0, 0, 0.3, 0)
    healthBarBg.BackgroundColor3 = Color3.new(1, 0, 0) -- red background
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = esp

    -- create health bar
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- green bar
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg

    -- create distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.FontSize = Enum.FontSize.Size14
    distanceLabel.TextColor3 = Color3.new(0, 1, 0) -- green text
    distanceLabel.TextStrokeColor3 = Color3.new(1, 0, 0) -- red stroke
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Parent = esp

    -- add highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Parent = parent
    highlight.FillColor = Color3.new(1, 0, 0) -- red highlight
    highlight.OutlineColor = Color3.new(0, 0, 0)

    return esp, nameLabel, healthBar, distanceLabel
end

function addESPToPlayersAndItems()
    for _, object in pairs(workspace:GetDescendants()) do
        if object:IsA("Model") then
            local head = object:FindFirstChild("Head")
            if head then
                local esp, nameLabel, healthBar, distanceLabel = createESP(head, object.Name)

                -- Check if the model has a humanoid (for players and NPCs)
                local humanoid = object:FindFirstChild("Humanoid")
                if humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                else
                    -- If no humanoid, hide the health bar
                    healthBar.Parent.Visible = false
                end

                -- Calculate distance
                local localPlayer = game.Players.LocalPlayer
                if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (object.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    distanceLabel.Text = "Distance: " .. math.floor(distance) .. " studs"
                end

                nameLabel.Text = object.Name
            end
        elseif object:IsA("Tool") then
            local handle = object:FindFirstChild("Handle")
            if handle then
                local esp, nameLabel, healthBar, distanceLabel = createESP(handle, object.Name)
                healthBar.Parent.Visible = false -- Hide health bar for tools

                -- Calculate distance
                local localPlayer = game.Players.LocalPlayer
                if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (handle.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    distanceLabel.Text = "Distance: " .. math.floor(distance) .. " studs"
                end

                nameLabel.Text = object.Name
            end
        end
    end
end

addESPToPlayersAndItems()
