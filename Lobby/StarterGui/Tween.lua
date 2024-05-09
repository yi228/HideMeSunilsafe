local TweenService = game:GetService("TweenService")

local info = TweenInfo.new(1, Enum.EasingStyle.Bounce)

local properties = {Position = UDim2.new(0, 0,  1, 0)}

local tween = TweenService:Create(script.Parent, info, properties)

tween:Play()
