local PLACE_ID = "13634602267" 
local MAX_PLAYERS = 3
local WAIT_TIME = 40
local TELEPORTING_TEXT = "0"

local TeleportService = game:GetService("TeleportService")
local Players = game.Players

local leaveGuiEvent = game.ReplicatedStorage:FindFirstChild("LeaveGuiEvent")
local guideChangeEvent = game.ReplicatedStorage:FindFirstChild("GuideChangeEvent")
if not leaveGuiEvent then
	leaveGuiEvent = Instance.new("RemoteEvent")
	leaveGuiEvent.Name = "LeaveGuiEvent"
	leaveGuiEvent.Parent = game.ReplicatedStorage
end

local Model = script.Parent
local Floor = Model.Floor
local Entrance = Model.Entrance
local BillBoardGui = Entrance.BillBoardGui
local playerCountGui = BillBoardGui.playerCount
local timeLeftGui = BillBoardGui.timeLeft
local playerFaceGui = BillBoardGui.playerFace
local playerFaceTemplate = playerFaceGui.imageTemplate

local playersInsideList = {}
local teleporting = false
local timeLeft = WAIT_TIME


--TELEPORT----------------------------------------------------------------------
local ATTEMPT_LIMIT = 5
local RETRY_DELAY = 1
local FLOOD_DELAY = 15

local function SafeTeleport(placeId, players, options)
	local attemptIndex = 0
	local success, result
	repeat
		success, result = pcall(function()
			return TeleportService:TeleportAsync(placeId, players, options)
		end)
		attemptIndex += 1
		if not success then
			task.wait(RETRY_DELAY)
		end
	until success or attemptIndex == ATTEMPT_LIMIT

	if not success then
		warn(result)
	end

	return success, result
end

local function handleFailedTeleport(player, teleportResult, errorMessage, targetPlaceId, teleportOptions)
	if teleportResult == Enum.TeleportResult.Flooded then
		task.wait(FLOOD_DELAY)
	elseif teleportResult == Enum.TeleportResult.Failure then
		task.wait(RETRY_DELAY)
	else
		-- if the teleport is invalid, don't retry, just report the error
		error(("Invalid teleport [%s]: %s"):format(teleportResult.Name, errorMessage))
	end

	SafeTeleport(targetPlaceId, {player}, teleportOptions)
end

TeleportService.TeleportInitFailed:Connect(handleFailedTeleport)


--FUNCTIONS----------------------------------------------------------------------


local function AddPlayerFace(player)
	local imageLabel = playerFaceTemplate:Clone()
	imageLabel.Name = player.Name
	imageLabel.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
	imageLabel.Visible = true
	imageLabel.Parent = playerFaceGui
end
local function RemovePlayerFace(player)
	local TextLabel = playerFaceGui:FindFirstChild(player.Name)
	if TextLabel then
		TextLabel:Destroy()
	else
		warn(Model:GetFullName()..":"..player.Name.."not found!")
	end
end
local function updatePlayerCountGUI()
	playerCountGui.Text = #playersInsideList.. " / "..MAX_PLAYERS 
end
updatePlayerCountGUI()

local function updateTimeLeftGUI()
	timeLeftGui.Text = math.ceil(timeLeft) --set text
	if timeLeft == 0 then
		timeLeftGui.Text = TELEPORTING_TEXT
	end
	if #playersInsideList == 0 then
		timeLeftGui.Visible = false -- hide when no players
	else
		timeLeftGui.Visible = true
	end
end

function IsPlayerInList(name)
	for i, player in ipairs(playersInsideList) do
		if player.Name == name then
			return true
		end
	end
	return false
end

local function removePlayerFromList(name)
	for i, player in ipairs(playersInsideList) do
		if player.Name == name then
			table.remove(playersInsideList, i)
			return
		end
	end
end

local function exitPlayer(player)	
	updatePlayerCountGUI()
	updateTimeLeftGUI()
	RemovePlayerFace(player)
	
	local character = player.Character
	if character then
		local YPos = character:GetPivot().Position.Y
		character:PivotTo(Entrance.CFrame * CFrame.new(0,-Entrance.CFrame.Y + YPos,8))
	end
	
	task.wait(0.2) -- delay to prevent going back in by touching entrance
	removePlayerFromList(player.Name)
end

local function enterPlayer(player)
	if not IsPlayerInList(player.Name) then
		table.insert(playersInsideList, player)
		
		leaveGuiEvent:FireClient(player) -- show leave gui
		guideChangeEvent:FireClient(player)
		
		updatePlayerCountGUI()
		updateTimeLeftGUI()
		AddPlayerFace(player)

		player.Character:PivotTo(Floor.CFrame * CFrame.new(0,4,0))
	end
end

local function addLoadingScreen(players)
	if not script:FindFirstChild("LoadingScreen") then return end
	for i, player in ipairs(players)do
		script.LoadingScreen:Clone().Parent = player.PlayerGui
	end
end

--MAIN----------------------------------------------------------------------

local Enabled = true
Entrance.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:FindFirstChild(character.Name)
	if Enabled and player and character.Humanoid.Health > 0 then
		Enabled = false
		if not IsPlayerInList(player.Name) and #playersInsideList < MAX_PLAYERS and teleporting == false then
			enterPlayer(player)
			
			character.Humanoid.Died:connect(function(character)
				exitPlayer(player)
			end)
		end
		Enabled = true
	end
end)

local function OnPlayerLeaving(player)
	if IsPlayerInList(player.Name) then
		guideChangeEvent:FireClient(player)
		exitPlayer(player)
	end
end
leaveGuiEvent.OnServerEvent:Connect(OnPlayerLeaving)
Players.PlayerRemoving:Connect(OnPlayerLeaving)
Players.PlayerAdded:Connect(function(player)
	-- Preload face
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
end)


while true do
	local step = task.wait()
	if #playersInsideList == 0 then
		timeLeft = WAIT_TIME
	elseif timeLeft > 5 and #playersInsideList == MAX_PLAYERS then
		timeLeft = 5 -- start after 5 seconds
	else
		timeLeft -= step
	end
	if timeLeft <= 0 then
		teleporting = true
		timeLeft = 0
		updateTimeLeftGUI()
		
		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.ShouldReserveServer = true
		
		local randomPlace  = math.random(1, 2)

		if randomPlace == 1 then
			PLACE_ID = "13634602267"
		else
			PLACE_ID = "13788014287"
		end
		
		local success, result = SafeTeleport(PLACE_ID, playersInsideList, teleportOptions)	
		if success then
			
			addLoadingScreen(playersInsideList)
			for i, player in ipairs(playersInsideList)do
				if player.Character then
					player.Character:Destroy()
				end
			end
			
			playersInsideList = {} -- emptying list
		end
		timeLeft = WAIT_TIME
		teleporting = false
	end
	updatePlayerCountGUI()
	updateTimeLeftGUI()
end	