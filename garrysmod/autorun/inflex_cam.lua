-- Download
AddCSLuaFile()

-- Variables
local headBoppSpeed = 0.006

local headBoppX = 0
local incrementX = true
local headBoppMaxX = 0.3
local headBoppMinX = -0.3

local headBoppY = 0
local headBoppMaxY = 0.2
local headBoppMinY = -0.2
local incrementY = true

-- Client
if CLIENT then

function CalcViewHeadBoppX()
    if incrementX then headBoppX = headBoppX + headBoppSpeed else headBoppX = headBoppX - headBoppSpeed end
    if headBoppX > headBoppMaxX then incrementX = false end
    if headBoppX < headBoppMinX then incrementX = true end
end

function CalcViewHeadBoppY()
    if incrementY then headBoppY = headBoppY + headBoppSpeed else headBoppY = headBoppY - headBoppSpeed end
    if headBoppY > headBoppMaxY then incrementY = false end
    if headBoppY < headBoppMinY then incrementY = true end
end

function CalcView(ply, pos, angles, fov, znear, zfar)
    local view = {}

    view.angles = Angle(angles[1] + headBoppY, angles[2], angles[3] + headBoppX)
    view.origin = pos-(angles:Forward()*-8)

    if (ply:KeyDown(IN_SPEED)) then
        headBoppSpeed = 0.005
    else
        headBoppSpeed = 0.0025
    end

    if (ply:KeyDown(IN_FORWARD)) then
        CalcViewHeadBoppX()
        CalcViewHeadBoppY()
    end

    if (ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)) then
        CalcViewHeadBoppX()
    end


    return view
end

function Think()
end

-- Hooks
hook.Add("CalcView", "InflexCamCalcView", CalcView)
hook.Add("Think", "InflexCamThink", Think)

end