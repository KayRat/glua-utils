dyndb = dyndb or {}
dyndb.m_Connection = dyndb.m_Connection or nil
dyndb.m_QueryCount = dyndb.m_QueryCount or 0

require("tmysql4")

if(not tmysql) then error("tmysql4 failed to load; no database functionality, aka a lot of crap will be broken") end

local function getConnectionSettings()
  local tblSettings = {
    ["hostname"]  = "",
    ["username"]  = "",
    ["password"]  = "",
    ["database"]  = "",
    ["port"]      = 3306,
    ["socket"]    = nil,
  }

  if(file.Exists("dyndb_config.txt", "DATA")) then
    local strData = file.Read("dyndb_config.txt", "DATA")
    local tblData = util.JSONToTable(strData or "")

    tblSettings["hostname"] = tblData["hostname"] or ""
    tblSettings["username"] = tblData["username"] or ""
    tblSettings["password"] = tblData["password"] or ""
    tblSettings["database"] = tblData["database"] or ""
    tblSettings["port"]     = tblData["port"] or 3306
    tblSettings["socket"]   = tblData["socket"] or nil
  else
    error("[dyndb] config file not found")
  end

  return tblSettings
end

dyndb.connect = function(objCallback)
  local tblSettings = getConnectionSettings()

  local objConnection, strError = tmysql.Connect(
    tblSettings["hostname"],
    tblSettings["username"],
    tblSettings["password"],
    tblSettings["database"],
    tblSettings["port"],
    tblSettings["socket"]
  )

  if(objCallback and type(objCallback) == "function") then
    objCallback(objConnection, strError)
  end

  dyndb.m_Connection = objConnection
end

dyndb.escape = function(str)
  return dyndb.m_Connection:Escape(str)
end

dyndb.query = function(strQuery, tblFormatData, objCallback)
  if(type(tblFormatData) == "table") then
    for k,v in pairs(tblFormatData) do
      strQuery = strQuery:gsub("{(%d+)}", function(iIndex)
        local objValue = tblFormatData[tonumber(iIndex)]
        return type(objValue) == "string" and dyndb.escape(objValue) or objValue
      end)
    end
  end

  dyndb.m_Connection:Query(strQuery, (type(tblFormatData) == "table" and objCallback or tblFormatData))
  dyndb.m_QueryCount = dyndb.m_QueryCount+1
end

dyndb.getQueryCount = function()
  return dyndb.m_QueryCount
end

hook.Add("InitPostEntity", "dyndb.connect", function()
  dyndb.connect(function(objConnection, strError)
    if(strError) then
      error("[dyndb] "..strError)
    end
  end)
end)
