local Roact = nil
local Radial = nil

local function createNewComponent()
    Radial = Roact.Component:extend("Radial")

    local function calculateOpposite(adjacent, angleDegrees)
        local angleRadians = math.rad(angleDegrees)
        local opposite = adjacent * math.tan(angleRadians)
        return opposite
    end


    local function findSection(x, y, N)
        local x_c = 0.5 - x
        local y_c = 0.5 - y
        local theta = math.atan2(y_c, x_c)
        theta = theta - math.pi / 2

        if theta < 0 then
            theta = theta + 2 * math.pi
        end
        local anglePerSection = 2 * math.pi / N
        local section = math.floor(theta / anglePerSection) + 1

        if section > N then
            section = N
        end

        return section
    end

    local function stripSpaces(str)
        -- Replace normal spaces with "En Space" to fix roblox textwrapping with textscaling
        return string.gsub(str, " ", " ")
    end

    function Radial:init()
        self:setState({
            selected = 1
        })

    end


    local function SubSection(props)
        local posfactor = (props.holeSize*0.5)
        local scalefactor = 0.5 - posfactor

        local rotationScale = 1000

        local s = 0.5/scalefactor
        
        local angle = props.angle
        
        local subangle = angle / props.subsections
        local sectionangle = angle/props.subsections
        local overlap = 1 + math.clamp(((props.subsections-1) / 20) * 0.3, 0, 0.3)
        local sectionangle = sectionangle * overlap
        local rotation = angle*(props.index-1) + (subangle * (props.subindex-1)) + (subangle/2)
        return Roact.createElement("Frame", {
            Size = UDim2.fromScale(1/rotationScale,1/rotationScale),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundTransparency = 1,
            Rotation = rotation,
        }, {
            Cutter = Roact.createElement("CanvasGroup", { -- CanvasGroup
                Size = UDim2.fromScale(calculateOpposite(0.5,(sectionangle)/2) * 2 * rotationScale, scalefactor * rotationScale),
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, -posfactor * rotationScale),
                BackgroundTransparency = 1,
            }, {
                Pie = Roact.createElement("ImageLabel", {
                    BorderSizePixel = 0,
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Size = UDim2.fromScale(1, s),
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://1074545642",
                    ImageColor3 = props.selected and props.color or Color3.new(0.5, 0.5, 0.5),
                    ImageTransparency = 0,
                    Position = UDim2.fromScale(0.5, 0)
                }),
            }),
            
        })
    end

    local function Section(props)
        local subsections = {}

        local angle = (360/props.total)

        for i = 1, props.subSectionCount do
            table.insert(subsections, Roact.createElement(SubSection, {
                index = props.index,
                subindex = i,
                angle = angle,
                color = props.element.color,
                selected = props.selected,
                subsections = props.subSectionCount,
                holeSize = props.holeSize
            }))
        end

        local children = {
            Subsections = Roact.createElement("CanvasGroup", { -- CanvasGroup
                Size = UDim2.fromScale(1,1),
                BackgroundTransparency = 1,
                ZIndex = 1,
                GroupTransparency = props.transparency,
            }, subsections)
        }

        if props.element.icon ~= nil then
            local maxIconSize = 0.4
            if props.holeSize > 0.6 then
                maxIconSize = 0.5
            elseif props.holeSize > 0.4 then
                maxIconSize = 0.45
            end
            local iconScale = maxIconSize - (0.5 * props.holeSize)

            local distance = (0.25*props.holeSize) + 0.25
            local angle_in_degrees = (angle * (props.index-1)) + (angle / 2)

            local angle_in_radians = math.rad(90 - angle_in_degrees)

            local delta_x = distance * math.cos(angle_in_radians)
            local delta_y = distance * math.sin(angle_in_radians)

            local end_x = 0.5 + delta_x
            local end_y = 0.5 - delta_y

            children["Icon"] = Roact.createElement("ImageLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromScale(iconScale, iconScale),
                Image = "rbxassetid://"..props.element.icon,
                Position = UDim2.fromScale(end_x, end_y),
                ImageColor3 = props.element.iconColor or Color3.new(1, 1, 1),
                ZIndex = 2,
                BackgroundTransparency = 1,
            })
        end

        return Roact.createElement("Frame", {
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
        }, children)
    end


    function Radial:render()
        local sections = {}
        for i, o in pairs(self.props.options) do
            table.insert(sections, Roact.createElement(Section, {
                total = #self.props.options,
                element = o,
                index = i,
                holeSize = self.props.holeSize or 0.5,
                subSectionCount = self.props.subSectionCount or 8,
                selected = i == self.state.selected,
                transparency = self.props.transparency or 0.5
            }))
        end

        local children = {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0.5, 0)
            }),
            UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1
            }),
            
            Button = Roact.createElement("ImageButton", {
                ImageTransparency = 1,
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Size = UDim2.fromScale(1,1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                [Roact.Event.MouseButton1Click] = function(rbx)
                    if self.props.click ~= nil then
                        self.props.click(self.state.selected)
                    end
                end,
                [Roact.Event.MouseMoved] = function(rbx, x, y)
                    local s = rbx.AbsoluteSize
                    local p = rbx.AbsolutePosition
                    local sx = (x - p.X)/s.X
                    local sy = (y - p.Y)/s.Y
                    local f = findSection(sx, sy, #self.props.options)
                    self:setState(function()
                        return {selected = f}
                    end)
                end
            }, 
                sections
            )
        }

        if self.props.label ~= false and self.props.options[self.state.selected].label ~= nil then
            local labelsize = self.props.label and self.props.label.size or 0.4
            children["Label"] = Roact.createElement("TextLabel", {
                Text = stripSpaces(self.props.options[self.state.selected].label),
                Size = UDim2.fromScale(labelsize, labelsize),
                TextScaled = true,
                RichText = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                FontFace = Font.fromName(self.props.label and self.props.label.font or "Oswald"),
                TextColor3 = self.props.label and self.props.label.color or Color3.new(0,0,0),
                TextTransparency = self.props.label and self.props.label.transparency or 0,
            })
        end

        return Roact.createElement("CanvasGroup", { -- CanvasGroup
            Size = self.props.Size or UDim2.fromScale(0.7,0.7),
            Position = self.props.Position or UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
        }, children)
    end
end

return function (roact)
    assert(typeof(roact) == "table" and roact.createElement ~= nil, "You should give a Roact reference to RoactRadial!")

    if not Roact then
        Roact = roact
        createNewComponent()
    end
    return Radial
end