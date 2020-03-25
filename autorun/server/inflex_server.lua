-- Messaging

-- Includes
include("autorun/server/inflex/inflex_commands.lua")

-- Functions
function PlayerSay(ply, text, teamChat) 
    if ply:Alive() then
        if (inflexCommands[text]) then
            inflexCommands[text](ply, text)
			
			return ""
		end		
    end

    return text
end

function PlayerSpawn(ply) 
    ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 0.2)
end

function AllowPlayerPickup(ply, ent)
	local physObj = ent:GetPhysicsObject()
	
	MsgN(physObj:GetMass())

	if (physObj:GetMass() <= 10) then
		return true 
	else 
		return false 
	end
	
	return false
end

-- Hooks
hook.Add("PlayerSay", "InflexPlayerSay", PlayerSay)
hook.Add("PlayerSpawn", "InflexPlayerSpawn", PlayerSpawn)
hook.Add("AllowPlayerPickup", "InflexAllowPlayerPickup", AllowPlayerPickup)