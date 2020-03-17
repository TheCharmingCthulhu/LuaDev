-- Download
AddCSLuaFile()

-- Global Functions
if CLIENT then

-- Variables
local crosshair = false
local crosshairAlpha = 0
local lerpTime = 0.01
local damage = 0
local damageRed = 0
local damageWhite = 0
local damageType = nil
local damageModifier = 0
local motionBlur = 50
local motionTimer = 0
local blur = 0.01
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

net.Receive("txInflexDamageBarEntityTakeDamageBlur", function()
    local enemyHealth = net.ReadInt(16)

    motionTimer = 2
    motionBlur = 50
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
                crosshairAlpha = Lerp(FrameTime() * 2, crosshairAlpha, 0)
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

    local damageRadiusA = math.max(math.min(damage + (8 * damageModifier), 150), 30)
    local damageRadiusB = math.max(math.min(damage + (10 * damageModifier), 100), 40)
    local damageRadiusC = math.max(math.min(damage + (12 * damageModifier), 50), 50)

    if crosshair then
        if damageType == "player" then
            for i=1,2 do
                surface.DrawCircle(center.x, center.y - 1, damageRadiusA+i, damageRed, 0, 0, crosshairAlpha)
                surface.DrawCircle(center.x, center.y - 1, damageRadiusB+i, damageRed, 0, 0, crosshairAlpha)
                surface.DrawCircle(center.x, center.y - 1, damageRadiusC+i, damageRed, 0, 0, crosshairAlpha)
            end
        elseif damageType == "enemy" then
            for i=1,2 do
                surface.DrawCircle(center.x, center.y - 1, damageRadiusA+i, damageWhite, damageWhite, damageWhite, crosshairAlpha)
                surface.DrawCircle(center.x, center.y - 1, damageRadiusB+i, damageWhite, damageWhite, damageWhite, crosshairAlpha)
                surface.DrawCircle(center.x, center.y - 1, damageRadiusC+i, damageWhite, damageWhite, damageWhite, crosshairAlpha)
            end
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
    if motionTimer > 0 then
        motionTimer = motionTimer - FrameTime() * 2
        motionBlur = Lerp(0.1, motionBlur, 0)

        DrawMotionBlur(0.1, motionBlur, 0)
    end

    MsgN(motionTimer)
end

-- Hooks
hook.Add("Think", "InflexDamageBarThink", Think)
hook.Add("HUDPaint", "InflexDamageBarHUDPaint", HUDPaint)
hook.Add("RenderScreenspaceEffects", "InflexRenderScreenspaceEffects", RenderScreenspaceEffects)

end

if SERVER then

-- Networking
util.AddNetworkString("txInflexDamageBarEntityTakeDamage")
util.AddNetworkString("txInflexDamageBarEntityTakeDamageBlur")
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

function Think()
end

function OnNPCKilled(npc, att, inf)
    InflexSendEntityKillToPlayer(npc, att)
end

function PropBreak(att, prop)
    InflexSendEntityKillToPlayer(prop, att)
end

function InflexSendEntityKillToPlayer(ent, ply)
    if not ent:IsPlayer() then
        net.Start("txInflexDamageBarEntityTakeDamageBlur")
        net.WriteInt(math.abs(ent:Health()), 16)
        net.Send(ply)
    end
end

-- Hooks
hook.Add("EntityTakeDamage", "InflexDamageBarTakeDamage", EntityTakeDamage)
hook.Add("OnNPCKilled", "InflexDamageBarNPCKilled", OnNPCKilled)
hook.Add("PropBreak", "InflexDamageBarPropBreak", PropBreak)
hook.Add("Think", "InflexDamageBarThinkServer", Think)

end