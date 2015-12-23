local tblMissing = {}

local function checkForError(strModel)
  if(not strModel or type(strModel) ~= "string") then return end

  if(not string.EndsWith(strModel, ".mdl")) then return end

  if(not file.Exists(strModel, "GAME") and not tblMissing[strModel]) then
    tblMissing[strModel] = tblMissing[strModel] and tblMissing[strModel] + 1 or 1
    error("missing model: "..strModel.." ["..tblMissing[strModel]..", "..table.Count(tblMissing).."]")
  end
end

hook.Add("OnEntityCreated", "missingmodels", function(objEnt)
  if(IsValid(objEnt)) then
    checkForError(objEnt:GetModel())
  end
end)

hook.Add("InitPostEntity", "missingmodels", function()
  for k,v in pairs(ents.GetAll()) do
    if(IsValid(v)) then
      checkForError(v:GetModel())
    end
  end
end)
