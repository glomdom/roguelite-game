local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logger = require(ReplicatedStorage.shared.logger)

Knit.AddControllers(script.controllers)

Knit.Start():andThen(function()
    Logger.log("knit started")
end):catch(warn)