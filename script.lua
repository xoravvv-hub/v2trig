-- Settings
local Hotkey = "t"
local HotkeyToggle = true
local HoldClick = true

-- Scope Detection (NEW)
local ScopedFOV = 30 -- adjust (25–40 depending on game)

-- Webhook
local WebhookURL = "https://discord.com/api/webhooks/1483425946961973308/fPVWe9pRrLskkkhnI-qF8RKHjCiSOCiKd__Kk6lwr5Vg4lvd8Fb0pQR9G26bttteIdBi"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local RightClickHeld = false
local CurrentlyPressed = false

-- 🔹 Webhook Embed Logger
pcall(function()
    if request or http_request or syn and syn.request then
        local req = request or http_request or syn.request

        local currentTime = os.date("%B %d, %Y | %I:%M %p")

        local gameName = "Unknown"
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)

        local data = {
            ["embeds"] = {{
                ["title"] = "Trigger Bot Made by : Bep & Exil ",
                ["color"] = 00000,

                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="
                        .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
                },

                ["fields"] = {
                    {
                        ["name"] = "User",
                        ["value"] = "```" .. LocalPlayer.Name .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Time",
                        ["value"] = "```" .. currentTime .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🎮 Game",
                        ["value"] = "```" .. gameName .. "```",
                        ["inline"] = false
                    }
                },

                ["footer"] = {
                    ["text"] = "Execution Logger"
                }
            }}
        }

        req({
            Url = WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end
end)

Mouse.KeyDown:Connect(function(key)
    key = key:lower()

    if key == Hotkey:lower() then
        if HotkeyToggle then
            Enabled = not Enabled
            print("Autotrigger:", Enabled and "ON" or "OFF")
        else
            Enabled = true
        end
    end
end)

Mouse.KeyUp:Connect(function(key)
    key = key:lower()

    if not HotkeyToggle and key == Hotkey:lower() then
        Enabled = false
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = false

        if HoldClick and CurrentlyPressed then
            CurrentlyPressed = false
            mouse1release()
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera

    if Enabled and RightClickHeld and camera and camera.FieldOfView <= ScopedFOV then
        if Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") then
            if HoldClick then
                if not CurrentlyPressed then
                    CurrentlyPressed = true
                    mouse1press()
                end
            else
                mouse1click()
            end
        else
            if HoldClick and CurrentlyPressed then
                CurrentlyPressed = false
                mouse1release()
            end
        end
    else
        if HoldClick and CurrentlyPressed then
            CurrentlyPressed = false
            mouse1release()
        end
    end
end)
