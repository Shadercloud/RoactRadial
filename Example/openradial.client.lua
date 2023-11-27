local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("roact"))

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui

local path_to_roact_radial = script.Parent

local Radial = require(path_to_roact_radial)(Roact)

Roact.mount(Roact.createElement("ScreenGui", {
    IgnoreGuiInset = true,
    DisplayOrder = 1,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, {
    Radial = Roact.createElement(Radial, {
        options = {
            {
                label = "Roblox",
                icon = 10885644041,
                color = Color3.new(1,0,0),
            },
            {
                label = "Sound",
                icon = 6824925193,
                color = Color3.new(0.301960, 1, 0),
            },
            {
                label = "Cart",
                icon = 11385395241,
                color = Color3.new(0.866666, 1, 0),
            }
        },
        label = { -- Set this to label = false if you don't want labels
            font = "Oswald",
            color = Color3.new(1,1,1),
            transparency = 0
        },
        holeSize = 0.5, -- This is the size of the hole in the middle of the radial.  If you want no hole set to 0 or a big hole would would something like 0.9 (but you probably don't want bigger than 0.5)
        subSectionCount = 20, -- Each radial section is made up of smaller sections to give a smooth curve appearance.  Decreasing this will improve performance but look less smooth
        click = function(selected)
            print("The user has clicked on option: "..selected)
        end
    })
}), PlayerGui, "Radial Menu")