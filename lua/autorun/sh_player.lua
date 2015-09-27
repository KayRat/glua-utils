local pl = FindMetaTable("Player")

if(SERVER) then
  util.AddNetworkString("utils.player.sendMessage")

  function pl:sendMessage(...)
    net.Start("utils.player.sendMessage")
      net.WriteTable({...})
    net.Send(self)
  end
else
  net.Receive("utils.player.sendMessage", function(len)
    local data = net.ReadTable()

    chat.AddText(unpack(data))
  end)
end
