-- Download
AddCSLuaFile()

inflamous = {
    ready = false,
    UI = {},
    TOOLS = {}
}

-- Client functions
if CLIENT then

function inflamous.UI:DrawText(x, y, text, font, color)
    font = font or "Default"
    color = color or Color(255, 255, 255)
    
    surface.SetFont(font)
	surface.SetTextColor(color)
	surface.SetTextPos(x, y) 
    surface.DrawText(text)
end

function inflamous.UI:DrawTriangle(dist, vel, ang)
    local center = Vector(ScrW() / 2, ScrH() / 2)
    local distance = dist or 16
    local velocity = vel or FrameTime() / 1.5
    local angle = ang or 2

    local lfo1 = inflamous.TOOLS:MODULATE(1, angle, velocity)
    local lfo2 = inflamous.TOOLS:MODULATE(2, angle + 90, velocity)
    local lfo3 = inflamous.TOOLS:MODULATE(3, angle - 90, velocity)

    -- Point A
    -- surface.DrawCircle(center.x + distance * lfo1[2], center.y + distance * lfo1[3], 1, 0, 0, 0)
    -- Point B
    -- surface.DrawCircle(center.x + distance * lfo2[2], center.y + distance * lfo2[3], 1, 0, 0, 0)
    -- Point C
    -- surface.DrawCircle(center.x + distance * lfo3[2], center.y + distance * lfo3[3], 1, 0, 0, 0)
    
    surface.DrawLine(
        center.x + distance * lfo1[2], center.y + distance * lfo1[3], 
        center.x + distance * lfo2[2], center.y + distance * lfo2[3]
    )
    surface.DrawLine(
        center.x + distance * lfo2[2], center.y + distance * lfo2[3], 
        center.x + distance * lfo3[2], center.y + distance * lfo3[3]
    )
    surface.DrawLine(
        center.x + distance * lfo3[2], center.y + distance * lfo3[3], 
        center.x + distance * lfo1[2], center.y + distance * lfo1[3]
    )
end

function inflamous.UI:DrawAlienaticSymbol(dist, vel, ang)
    local center = Vector(ScrW() / 2, ScrH() / 2)
    local distance = dist or 16
    local velocity = vel or FrameTime() / 1.5
    local angle = ang or 2

    local lfo1 = inflamous.TOOLS:MODULATE(1, angle, velocity)
    local lfo2 = inflamous.TOOLS:MODULATE(2, angle + 90, velocity)
    local lfo3 = inflamous.TOOLS:MODULATE(3, angle - 90, velocity)

    surface.DrawLine(
        center.x + distance * lfo1[2], center.y + distance * lfo1[3], 
        center.x + distance * lfo2[2], center.y + distance * lfo2[3]
    )
    surface.DrawLine(
        center.x + distance * lfo2[2] - 16 % 10, center.y + distance * lfo2[3], 
        center.x + distance * lfo3[2], center.y + distance * lfo3[3]
    )
    surface.DrawLine(
        center.x + distance * lfo3[2] + 16, center.y + distance * lfo3[3], 
        center.x + distance * lfo1[2], center.y + distance * lfo1[3]
    )
end
end

-- Server functions
if SERVER then

end

-- Global functions
inflamous.TOOLS.MODULATORS = {}
function inflamous.TOOLS:MODULATE(index, offsetAngle, speed, negate)
    if index == 0 then return end
    local offset = offsetAngle or 0
    local velocity = speed or FrameTime()
    local negate = negate or true

    if not inflamous.TOOLS.MODULATORS[index] then
        table.Add(inflamous.TOOLS.MODULATORS, {index = {0, 0, 0}})
    end

    inflamous.TOOLS.MODULATORS[index][1] = ((inflamous.TOOLS.MODULATORS[index][1] + velocity) % 360)

    if negate then
        inflamous.TOOLS.MODULATORS[index][2] = -math.sin(inflamous.TOOLS.MODULATORS[index][1] + offset)
        inflamous.TOOLS.MODULATORS[index][3] = -math.cos(inflamous.TOOLS.MODULATORS[index][1] + offset)
    else
        inflamous.TOOLS.MODULATORS[index][2] = math.sin(inflamous.TOOLS.MODULATORS[index][1] + offset)
        inflamous.TOOLS.MODULATORS[index][3] = math.cos(inflamous.TOOLS.MODULATORS[index][1] + offset)
    end

    return inflamous.TOOLS.MODULATORS[index]
end

-- Main
if not inflamous.ready then
    inflamous.ready = true
    -- MsgN("- inflamous_utilities.lua: loaded.")
end