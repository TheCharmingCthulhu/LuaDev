-- Download
AddCSLuaFile()

-- Global Functions
if CLIENT then

-- Variables
local lerpTime = 0.01
local motionBlur = 50
local motionTimer = 0
local blur = 0.01

-- Networking
net.Receive("txInflexMotionBlur", function()
    local enemyHealth = net.ReadInt(16)

    motionTimer = 2
    motionBlur = 50
end)

function RenderScreenspaceEffects()
    if motionTimer > 0 then
        motionTimer = motionTimer - FrameTime() * 2
        motionBlur = Lerp(0.1, motionBlur, 0)

        DrawMotionBlur(0.1, motionBlur, 0)
    end
end

-- Hooks
hook.Add("RenderScreenspaceEffects", "InflexRenderScreenspaceEffects", RenderScreenspaceEffects)

end

if SERVER then

-- Networking
util.AddNetworkString("txInflexMotionBlur")

-- Functions
function OnNPCKilled(npc, att, inf)
    InflexSendEntityKillToPlayer(npc, att)
end

function PropBreak(att, prop)
    InflexSendEntityKillToPlayer(prop, att)
end

function InflexSendEntityKillToPlayer(ent, ply)
    if not ent:IsPlayer() then
        net.Start("txInflexMotionBlur")
        net.WriteInt(math.abs(ent:Health()), 16)
        net.Send(ply)
    end
end

-- Hooks
hook.Add("OnNPCKilled", "InflexDamageBarNPCKilled", OnNPCKilled)
hook.Add("PropBreak", "InflexDamageBarPropBreak", PropBreak)
end