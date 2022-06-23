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
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.fromOffset(350,450)

NotificationFrame.BackgroundColor3 = Color3.new(0,0,0)
NotificationFrame.BackgroundTransparency = 0.85
NotificationFrame.Size = UDim2.fromScale(1,1)

EnableButton.AnchorPoint = Vector2.new(0,1)
EnableButton.Position = UDim2.fromScale(0,1)
EnableButton.Size = UDim2.new(1,0,0,50)
EnableButton.TextSize = 25
EnableButton.Font = Enum.Font.ArialBold
EnableButton.Text = "Enable Auto-Report"

function Report(plr, ctx, abusetype)
    spawn(function()
        wait(Random.new():NextNumber(0.1,2))
        Players:ReportAbuse(plr, abusetype, string.format("said \"%s\" which is inappropriate", ctx))
    end)
end

function NotifyAboutReport(plr, ctx, abusetype, word, parent)
    local Notification = Instance.new("TextLabel", parent)
    Notification.TextSize = 16
    Notification.TextWrapped = true
    Notification.Font = Enum.Font.ArialBold
    Notification.BackgroundTransparency = 1
    Notification.TextColor3 = Color3.new(1,1,1)
    Notification.TextStrokeTransparency = 0
    Notification.Size = UDim2.new(1,0,0,65)
    Notification.Text = "Reported "..plr.." for saying the word '"..word.."' in the context of '"..ctx.."', because it counted as '"..abusetype.."'."
    wait(8)
    Notification:Destroy()
end

function TrackPlayerChat(player)
    player.Chatted:Connect(function(message)
        if player == Players.LocalPlayer or EnableAutoReport == false then return end
        
        for word,abusetype in pairs(Dictionary) do
            for seperateword in string.gmatch(message, "%w+") do
                if seperateword == word then
                    Report(player, message, abusetype)
                    spawn(function()
                        NotifyAboutReport(player.Name, message, abusetype, word, NotificationFrame)
                    end)
                end
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

EnableButton.MouseButton1Click:Connect(function()
    EnableAutoReport = not EnableAutoReport
    EnableButton.Text = EnableAutoReport and "Disable Auto-Report" or "Enable Auto-Report"
end)
