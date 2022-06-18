---@diagnostic disable: unused-local
---@diagnostic disable: undefined-global

setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Dictionary = loadstring(game:HttpGet("https://raw.githubusercontent.com/safariragoli2/Auto-Report-Not-Dumb/main/Dictionary.lua"))()

local EnableAutoReport = false

local NotificationGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", NotificationGui)
local NotificationFrame = Instance.new("Frame", MainFrame)
local EnableButton = Instance.new("TextButton", MainFrame)
local UIListLayout = Instance.new("UIListLayout", NotificationFrame)
MainFrame.AnchorPoint = Vector2.new(0.5,0.05)
MainFrame.Position = UDim2.fromScale(0.5,0.05)
MainFrame.BackgroundColor3 = Color3.new(0,0,0)
MainFrame.BackgroundTransparency = 0.85
MainFrame.Size = UDim2.fromOffset(350,450)

NotificationFrame.BackgroundColor3 = Color3.new(0,0,0)
NotificationFrame.BackgroundTransparency = 0.85
NotificationFrame.Size = UDim2.fromScale(1,1)

function Report(plr, ctx, abusetype)
    Players:ReportAbuse(plr, abusetype, string.format("said \"%s\" which is inappropriate", ctx))
end

function NotifyAboutReport(plr, ctx, abusetype, parent)
    local Notification = Instance.new("TextLabel", parent)
    Notification.TextSize = 16
    Notification.TextWrapped = true
    Notification.Font = Enum.Font.ArialBold
    Notification.BackgroundTransparency = 1
    Notification.TextColor3 = Color3.new(1,1,1)
    Notification.TextStrokeTransparency = 0
    Notification.Size = UDim2.new(1,0,0,50)
    Notification.Text = "Reported "..plr.." for saying '"..ctx.."', because it counted as '"..abusetype.."'."
    wait(3)
    Notification:Destroy()
end

function TrackPlayerChat(player)
    if player == Players.LocalPlayer then return end

    player.Chatted:Connect(function(message)
        for word,abusetype in pairs(Dictionary) do
            if string.match(message, word) then
                Report(player, message, abusetype)
                spawn(function()
                    NotifyAboutReport(player.Name, message, abusetype, NotificationFrame)
                end)
            end
        end
    end)
end

for _,player in pairs(Players:GetPlayers()) do
    TrackPlayerChat(player)
end

Players.PlayerAdded:Connect(function(player)
    TrackPlayerChat(player)
end)
