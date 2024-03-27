local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logger = require(ReplicatedStorage.shared.logger)

local Utils = {}

function Utils.genericTween<T>(inst: Instance, val: T, time: number, prop: string, easing: Enum.EasingStyle?, dir: Enum.EasingDirection?)
    prop = prop or nil
    easing = easing or Enum.EasingStyle.Linear
    dir = dir or Enum.EasingDirection.InOut

    if not inst or not val or not prop then
        Logger.log("ummm ur missing a few non-optional parameters!!", 3, warn)

        return
    end

    local tween = TweenService:Create(inst, TweenInfo.new(time, easing, dir), {[prop] = val})

    return tween
end

return Utils