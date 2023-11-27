# Roact Radial

This is a Roblox roact component that creates a radial menu

As you probably know Roblox doesn't easily allow for circles or other shapes in their GUI, so this radial menu is created by using a combination of CanvasGroup, UICorners, Triangle images within ImageLabels to create the appearance of a circle.

Currently the radial menu accepts a table of option elements which can include a Label, Icon and Color.

Example of how the radial menu looks:

![Alt text](Example/example.png?raw=true "Radial Menu Example")

## Installation

1) You need roact installed

2) Install this package through wally or copy the source from src/init.lua to your Roblox project

3) Look at the Example/openradial.client.lua to see how to use the Radial component


Available Props:

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
    Size = UDim2.fromScale(0.7,0.7),
    Position = UDim2.fromScale(0.5, 0.5),
	label = { -- Set this to label = false if you don't want labels
        font = "Oswald",
        color = Color3.new(0,0,0),
        transparency = 0
	},
	holeSize = 0.5, -- This is the size of the hole in the middle of the radial.  If you want no hole set to 0 or a big hole would would something like 0.9 (but you probably don't want bigger than 0.5)
	subSectionCount = 20, -- Each radial section is made up of smaller sections to give a smooth curve appearance.  Decreasing this will improve performance but look less smooth
	click = function(selected)
		print("The user has clicked on option: "..selected)
	end
