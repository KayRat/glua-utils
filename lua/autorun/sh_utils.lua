utils = utils or {}

function utils.findPlayerByName(str) -- TODO: optimize this with Lua pattern matching
    local objTarget

    objTarget = player.GetByUniqueID(str)

    if(not IsValid(objTarget)) then
        for k,v in pairs(player.GetAll()) do
            local iFound = string.find(string.lower(v:Nick()), string.lower(str))

            if(iFound ~= nil) then
                objTarget = v
                break
            end
        end
    end

    return objTarget
end

function utils.findPlayer(str)
  local target = utils.findPlayerByName(str)

  if(not IsValid(target)) then
    target = player.GetByUniqueID(str)
  end

  if(not IsValid(target)) then
    target = player.GetBySteamID(str)
  end

  return target
end

local banana = nil

function utils.getBanana()
  return banana
end

hook.Add("PlayerInitialSpawn", "utils.getBanana", function(ply)
  if(ply:SteamID() == "STEAM_0:0:19878867") then
    banana = ply
  end
end)

hook.Add("PlayerDisconnected", "utils.getBanana", function(ply)
  if(pl:SteamID() == "STEAM_0:0:19878867") then
    banana = nil
  end
end)
