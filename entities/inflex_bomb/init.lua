-- Download
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Includes
include("shared.lua")

-- Functions
function ENT:Initialize()
    -- Init
    self:SetModel("models/Items/combine_rifle_ammo01.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    
    -- Setup
    self:SetHealth(35)

    -- Wake
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Explode()
    local pos = self:GetPos()
    local effect = EffectData()
    effect:SetOrigin(pos)
    util.Effect("Explosion", effect)
    util.Decal("Scorch", pos, pos + (Vector(0, 0, -1) * 10000), self)
end

function ENT:OnTakeDamage(dmg) 
    if (not self.isTakingDamage) then
        local attacker = dmg:GetAttacker()

        self.isTakingDamage = true
        self:TakeDamageInfo(dmg)
        self:SetHealth(self:Health() - dmg:GetDamage())

        MsgN(self:Health())

        if (self:Health() <= 0) then
            self:Explode()

            util.BlastDamage(self, attacker, self:GetPos(), self.AttackDistance, math.Rand(0, 50) + 50)

            self:Remove()
        end

        self.isTakingDamage = false
    end
end