-- Includes
include("autorun/inflamous_utils.lua")

-- Download
AddCSLuaFile()

if CLIENT then

-- Variables
local crosshairWidth = 12
local crosshairGlow = false
local crosshairGlowColor = 0
local crosshairGlowOutTime = 5
local crosshairAngle = 10

-- Coroutines


-- Networking
net.Receive("txInflexHudEntityTakeDamage", function()
    crosshairGlow = true
    crosshairGlowColor = 255
    crosshairAngle = math.Rand(0, 360) % 360
end)

-- Functions
function HUDPaint() 
    local center = Vector(ScrW() / 2, ScrH() / 2)

    -- Blackbars (Maybe optional?)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, ScrH() - 64, ScrW(), 64)
    surface.DrawRect(0, 0, ScrW(), 64)

    -- Crosshair
    if crosshairGlow then
        surface.SetDrawColor(crosshairGlowColor, crosshairGlowColor, crosshairGlowColor, 255)
    else
        surface.SetDrawColor(0, 0, 0, 255)
    end

    -- Glowout
    GlowOutCrosshair()

    inflamous.UI:DrawTriangle(10, 0, crosshairAngle)
    inflamous.UI:DrawTriangle(11, 0, crosshairAngle)
    inflamous.UI:DrawTriangle(12, 0, crosshairAngle)
    inflamous.UI:DrawTriangle(13, 0, crosshairAngle)

    -- Call drawing method
    -- inflamous.UI:DrawText(128, 128, lfo1Value)
end

function GlowOutCrosshair()
    -- Glowout
    if crosshairGlow then
        crosshairGlowColor = Lerp(FrameTime() * crosshairGlowOutTime, crosshairGlowColor, 0)
    end

    if crosshairGlowColor < 0.1 then
        crosshairGlow = false
    end
end

function HUDShouldDraw(name)
    local flagsDefaultHUD = {
        ["CHudVehicle"] = true,
        ["CHudCrosshair"] = true,
        ["CHudHealth"] = true
    }

    if flagsDefaultHUD[name] then return false end
end

function Think()

end

-- Hooks
hook.Add("HUDPaint", "InflexHUDPaint", HUDPaint)
hook.Add("HUDShouldDraw", "InflexHUDShouldDraw", HUDShouldDraw)
hook.Add("Think", "InflexHudThink", Think)

end

if SERVER then

-- Networking
util.AddNetworkString("txInflexHudEntityTakeDamage")

-- Functions
function EntityTakeDamage(ent, dmg)
    if dmg:GetAttacker():IsPlayer() then
        net.Start("txInflexHudEntityTakeDamage")
        net.WriteDouble(dmg:GetDamage())
        net.Send(dmg:GetAttacker())
        return
    end
end

-- Hooks
hook.Add("EntityTakeDamage", "InflexHudTakeDamage", EntityTakeDamage)

end