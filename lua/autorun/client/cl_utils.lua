local tblEnts = {}

hook.Add("Tick", "entityRemovedHelper", function()
  if(table.Count(tblEnts) <= 0) then return end

  for k,v in pairs(tblEnts) do
    if(not IsValid(v.ent)) then
      hook.Call("OnPlayerRemoved", nil, v)
      table.remove(tblEnts, k)
    end
  end
end)

hook.Add("EntityRemoved", "entityRemovedHelper", function(objEnt)
  if(objEnt:IsPlayer()) then
    table.insert(tblEnts, {
      ["ent"]   = objEnt,
    })
  end
end)
