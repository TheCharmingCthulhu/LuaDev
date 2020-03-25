-- Client Download
AddCSLuaFile()

-- Messaging
util.AddNetworkString("txAdminMenu")
util.AddNetworkString("rxAdminMenu")

util.AddNetworkString("txPing")
util.AddNetworkString("rxPing")

-- Receiving
net.Receive("rxAdminMenu", function()
    MsgN("Client has received a call to the admin menu.")
end)

net.Receive("rxPing", function()
    MsgN("Server shout's out: Received a client's message.")
end)

-- Data
inflexCommands = {
    ["/kill"] = inflexPlayerKill,
    ["/admin"] = inflexAdminMenu,
    ["/ping"] = inflexPing
}

-- Functions
function inflexPlayerKill(ply, text) 
    ply:Kill()
end

function inflexAdminMenu(ply, text)
    if ply:IsAdmin() then
        net.Start("txAdminMenu")
        net.Send(ply)
    end
end

function inflexPing(ply, text) 
    if ply:IsAdmin() then
        net.Start("txPing")
        net.Send(ply)
    end
end