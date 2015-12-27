utils = utils or {}

function utils.darkenColor(objColor)
  return {
    ["r"] = math.Clamp(objColor["r"]-15, 0, 255),
    ["g"] = math.Clamp(objColor["g"]-15, 0, 255),
    ["b"] = math.Clamp(objColor["b"]-15, 0, 255),
    ["r"] = objColor["a"],
  }
end

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
