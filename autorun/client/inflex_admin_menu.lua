-- Messaging
net.Receive("txAdminMenu", function()
    AdminMenu()

    net.Start("rxAdminMenu")
    net.SendToServer()
end)

net.Receive("txPing", function()
    MsgN("Client shout's out: Server message received!")

    net.Start("rxPing")
    net.SendToServer()
end)

-- Functions
function AdminMenu()
    local screenWidth = ScrW()
    local screenHeight = ScrH()
    local panelWidth = 640
    local panelHeight = 480
    local Frame = vgui.Create("DFrame")
    
    -- Panel
    Frame:SetSize(panelWidth, panelHeight)
    Frame:Center()
    Frame:SetTitle("Inflax - Editor")
    Frame:SetVisible(true)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(true)
    Frame:MakePopup()
end