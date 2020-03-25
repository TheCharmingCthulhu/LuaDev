ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Inflex Bomb"
ENT.Spawnable = true

-- Data
ENT.AttackDistance = 300

-- Setup
-- game.AddParticles("particles/combineball.pcf")

-- Testing
-- PrecacheParticleSystem( "combineball" )

if ( SERVER ) then
	-- A test console command to see if the particle works, spawns the particle where the player is looking at. 
    concommand.Add( "particleitup", function( ply, cmd, args )

        MsgN(ply:GetEyeTrace().HitPos)

		ParticleEffect( "combineball", ply:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
	end )
end