local done = 0
local waitTime = workspace.WaitTime.Value
local imageLabel
local function moveCameraToTaggerCamera()
	local taggerScreenGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TaggerScreenGui")
	if taggerScreenGui and taggerScreenGui:FindFirstChild("ImageLabel") then
		imageLabel = taggerScreenGui.ImageLabel
		imageLabel.Size = UDim2.new(1, 0, 1, 0)
		imageLabel.Position = UDim2.new(0, 0, 0, 0)
		imageLabel.Visible = true
		print("술래 눈 가리기!")
	end
end

local function monitorTaggerName()
	local taggerNameValue = game.Workspace:FindFirstChild("TaggerName")
	if taggerNameValue and taggerNameValue.Value == script.Parent.Parent.Name then
		moveCameraToTaggerCamera()
		done = 1
	end
end

local function startMonitoring()
	while true do
		if(done == 1) then
			break
		end
		monitorTaggerName()
		wait(0.5)
	end
end

workspace.Time.Changed:Connect(function(newValue)
	if workspace.Time.Value == workspace.WaitTime.Value and imageLabel ~= nil then
		imageLabel.Visible = false
	end
end)

startMonitoring()






