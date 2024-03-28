local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local ContextAction = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logger = require(ReplicatedStorage.shared.logger)
local Utils = require(ReplicatedStorage.shared.utils)

local MovementController2D = Knit.CreateController({
    Name = "MovementController2D"
})

local Left = 0
local Right = 0
local Up = 0
local Down = 0

MovementController2D.RenderName = "MovementControl"
MovementController2D.RenderPriority = Enum.RenderPriority.Input.Value
MovementController2D.LookTime = 0.0175

function _onLeft(_, inputState: Enum.UserInputState)
    if inputState == Enum.UserInputState.Begin then
        Left = 1
    elseif inputState == Enum.UserInputState.End then
        Left = 0
    end
end

function _onRight(_, inputState: Enum.UserInputState)
    if inputState == Enum.UserInputState.Begin then
        Right = 1
    elseif inputState == Enum.UserInputState.End then
        Right = 0
    end
end

function _onUp(_, inputState: Enum.UserInputState)
    if inputState == Enum.UserInputState.Begin then
        Up = 1
    elseif inputState == Enum.UserInputState.End then
        Up = 0
    end
end

function _onDown(_, inputState: Enum.UserInputState)
    if inputState == Enum.UserInputState.Begin then
        Down = 1
    elseif inputState == Enum.UserInputState.End then
        Down = 0
    end
end

function _lookUpdate()
	local plr = Players.LocalPlayer
	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local lookDir = nil

	if (Right == 0 and Left == 0) or (Right == 1 and Left == 1) then
		lookDir = -workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
    elseif (Right == 1 and Left == 0) then
		lookDir = workspace.CurrentCamera.CFrame.RightVector
    elseif (Right == 0 and Left == 1) then
        lookDir = -workspace.CurrentCamera.CFrame.RightVector
	end

    local tween = Utils.genericTween(hrp, CFrame.lookAt(hrp.Position, hrp.Position + lookDir), MovementController2D.LookTime, "CFrame", Enum.EasingStyle.Circular)
    tween:Play()
end

function _update(_dt: number)
    local plr = Players.LocalPlayer

    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local hum = plr.Character.Humanoid

        local moveDir = Right - Left
        local moveVec = Vector3.new(moveDir, 0, 0)

        _lookUpdate()
        hum:Move(moveVec, true)
    end
end

function MovementController2D:KnitStart()
    ContextAction:BindAction("movementLeft", _onLeft, false, Enum.KeyCode.A, Enum.KeyCode.Left)
    ContextAction:BindAction("movementRight", _onRight, false, Enum.KeyCode.D, Enum.KeyCode.Right)
    ContextAction:BindAction("movementUp", _onUp, false, Enum.KeyCode.W, Enum.KeyCode.Up)
    ContextAction:BindAction("movementDown", _onDown, false, Enum.KeyCode.S, Enum.KeyCode.Down)

    RunService:BindToRenderStep(self.RenderName, self.RenderPriority, _update)

    Logger.log("started controller")
end

return MovementController2D