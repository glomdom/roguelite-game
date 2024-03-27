local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logger = require(ReplicatedStorage.shared.logger)
local Utils = require(ReplicatedStorage.shared.utils)

local CameraController = Knit.CreateController({
    Name = "CameraController"
})

CameraController.RenderName = "CameraLock"
CameraController.RenderPriority = Enum.RenderPriority.Camera.Value
CameraController.Locked = false
CameraController.Distance = 30
CameraController.HeightOffset = 5
CameraController.FOV = 40

-- The rotation applied to the Y axis of the camera. Value is in degrees.
CameraController.Rotation = 0

-- Construct the CFrame used for positioning the camera.
function _constructCameraCFrame(lockPart: Part)
    local angle = math.rad(CameraController.Rotation)
    local originalOffset = Vector3.new(0, CameraController.HeightOffset, CameraController.Distance)
    local rotationCFrame = CFrame.new(lockPart.Position) * CFrame.Angles(0, angle, 0)
    local rotatedOffset = rotationCFrame:PointToWorldSpace(originalOffset) - lockPart.Position
    local cameraPosition = lockPart.Position + rotatedOffset

    return CFrame.new(cameraPosition, lockPart.Position)
end

-- Locks the default camera to the player's HumanoidRootPart.
function CameraController:lockToPlayer()
    local cam = workspace.CurrentCamera
    local plrCharacter = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local lockPart = plrCharacter:FindFirstChild("HumanoidRootPart")

    cam.CameraType = Enum.CameraType.Scriptable
    self.Locked = true

    RunService:BindToRenderStep(self.RenderName, self.RenderPriority, function()
        local tween = Utils.genericTween(cam, _constructCameraCFrame(lockPart), 0.015, "CFrame")
        tween:Play()
    end)
end

-- Rotates the player's camera.
function CameraController:rotateCamera(degrees: number, time: number?)
    local shit = Instance.new("IntValue")
    time = time or 0.25

    local tween = Utils.genericTween(shit, degrees, time, "Value", Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    tween:Play()

    -- dumbass handler
    shit:GetPropertyChangedSignal("Value"):Connect(function()
        CameraController.Rotation = shit.Value
    end)

    Logger.log("rotating the goddamn camera")
end

-- Lifecycle

function CameraController:KnitStart()
    local cam = workspace.CurrentCamera
    cam.FieldOfView = self.FOV

    self:lockToPlayer()

    Logger.log("started controller")
end

return CameraController