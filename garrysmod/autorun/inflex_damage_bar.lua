-- Download
AddCSLuaFile()

-- Global Functions
if CLIENT then

-- Variables
local crosshair = false
local crosshairAlpha = 0
local lerpTime = 0.001
local damage = 0
local damageRed = 0
local damageWhite = 0
local damageType = nil
local damageModifier = 0
local motionBlur = 50
local blur = 0
local releaseTime = 0.25
local colorLocked = false
local locked = false;

-- Coroutines
local coDamageRelease = nil
local coColorRelease = nil
local coCrosshairThink = nil

-- Client Receive
net.Receive("txInflexDamageBarEntityTakeDamage", function()
    triggerCrosshair(net.ReadDouble())
    damageWhite = 200
    damageType = "enemy"

    coroutineDamageRelease()
    coroutineColorRelease()
    coroutineCrosshairThink()
end)

net.Receive("txInflexDamageBarPlayerTakeDamage", function()
    triggerCrosshair(net.ReadDouble())
    damageRed = 255
    damageType = "player"

    coroutineDamageRelease()
    coroutineColorRelease()
    coroutineCrosshairThink()
end)

-- Functions
function coroutineDamageRelease()
    coDamageRelease = coroutine.create(function()
        while damage > 0 or damageModifier > 0 do
            coroutine.yield()
            damage = Lerp(lerpTime, damage, 0)
            damageModifier = Lerp(lerpTime, damageModifier, 0)
        end
    end)
end

function coroutineColorRelease()
    coColorRelease = coroutine.create(function()
        coroutine.wait(0.5)

        colorLocked = false
    end)
end

function coroutineCrosshairThink()
    coCrosshairThink = coroutine.create(function()
        while crosshair do
            coroutine.yield()
            if crosshairAlpha < 0.1 then
                crosshair = false -- Disable crosshair
                locked = false
            else
                crosshairAlpha = Lerp(FrameTime() / 1, crosshairAlpha, 0)
            end
        end
    end)
end

function triggerCrosshair(dmg)
    crosshair = true
    crosshairAlpha = 255
    damage = math.min(dmg, 50)
    damageModifier = (math.random() + 1) * 2
    colorLocked = true
    motionBlur = 50
    blur = 0
    if not locked then locked = true end
end

function HUDPaint()
    local center = Vector(ScrW() / 2, ScrH() / 2, 0)

    if not colorLocked then
        if damageRed > 0 then
            damageRed = Lerp(lerpTime, damageRed, 0)
        end
        
        if damageWhite > 0 then
            damageWhite = Lerp(lerpTime, damageWhite, 0)
        end
    end

    local damageRadiusA = math.max(math.min(damage + (8 * damageModifier), 80), 20)
    local damageRadiusB = math.max(math.min(damage + (12 * damageModifier), 160), 30)
    local damageRadiusC = math.max(math.min(damage + (16 * damageModifier), 240), 40)

    if crosshair then
        if damageType == "player" then
            surface.DrawCircle(center.x, center.y, damageRadiusA, damageRed, 0, 0, crosshairAlpha)
            surface.DrawCircle(center.x, center.y, damageRadiusB, damageRed, 0, 0, crosshairAlpha)
            surface.DrawCircle(center.x, center.y, damageRadiusC, damageRed, 0, 0, crosshairAlpha)
        elseif damageType == "enemy" then
            surface.DrawCircle(center.x, center.y, damageRadiusA, damageWhite, damageWhite, damageWhite, crosshairAlpha)
            surface.DrawCircle(center.x, center.y, damageRadiusB, damageWhite, damageWhite, damageWhite, crosshairAlpha)
            surface.DrawCircle(center.x, center.y, damageRadiusC, damageWhite, damageWhite, damageWhite, crosshairAlpha)
        end
    end
end

function Think()
    if coDamageRelease then
        coroutine.resume(coDamageRelease)
    end

    if coColorRelease then
        coroutine.resume(coColorRelease)
    end

    if coCrosshairThink then
        coroutine.resume(coCrosshairThink)
    end
end

function RenderScreenspaceEffects() 
    if damage > 0.0 then
        motionBlur = Lerp(0.03, motionBlur, 0)
        blur = Lerp(0.1, blur + lerpTime, 0.25)

        DrawMotionBlur(blur, motionBlur, 0)
    end
end

-- Hooks
hook.Add("Think", "InflexDamageBarThink", Think)
hook.Add("HUDPaint", "InflexDamageBarHUDPaint", HUDPaint)
hook.Add("RenderScreenspaceEffects", "InflexRenderScreenspaceEffects", RenderScreenspaceEffects)

end

if SERVER then

-- Networking
util.AddNetworkString("txInflexDamageBarEntityTakeDamage")
util.AddNetworkString("txInflexDamageBarPlayerTakeDamage")

-- Functions
function EntityTakeDamage(ent, dmg)
    if ent:IsPlayer() then
        net.Start("txInflexDamageBarPlayerTakeDamage")
        net.WriteDouble(dmg:GetDamage())
        net.Send(ent)
        return
    end

    if dmg:GetAttacker():IsPlayer() then
        net.Start("txInflexDamageBarEntityTakeDamage")
        net.WriteDouble(dmg:GetDamage())
        net.Send(dmg:GetAttacker())
        return
    end
end

-- Hooks
hook.Add("EntityTakeDamage", "InflexDamageBarTakeDamage", EntityTakeDamage)

end