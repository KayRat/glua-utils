serverid = serverid or {}

local tblIDs = {
  [1] = {
    ["name"]            = "TTT",
    ["check"]           = function()
      return GAMEMODE.Name == "Trouble in Terrorist Town"
    end,
    ["getHostname"]  = function()
      local strHostname = "TBD"

      strHostname = table.Random({
        "Vanilla TTT!",
        "Super Fast Download!",
        "Help",
      })

      return strHostname
    end,
    ["config"]          = {
      "ttt_firstpreptime              45",
      "ttt_posttime_seconds           20",
      "ttt_round_limit                5",
      "ttt_time_limit_minutes         50",
      "ttt_traitor_pct                0.3",
      "ttt_detective_pct              0.2",
      "ttt_detective_karma_min        750",
      "ttt_postround_dm               1",
      "ttt_dyingshot                  1",
      "ttt_teleport_telefrags         1",
      "ttt_ragdoll_pinning            1",
      "ttt_ragdoll_pinning_innocents  1",
      "ttt_karma_persist              1",
      "ttt_det_credits_traitorkill    1",
      "ttt_det_credits_traitorkill    160",
      "ttt_spec_prop_rechargetime     0.2",
      "ttt_namechange_kick            0",
      "ttt_detective_hats             1",
      "ttt_playercolor_mode           2",
      "ttt_locational_voice           1",
      "ttt_allow_discomb_jump         1",
    },
    ["postStart"]   = function()
      if(string.lower(game.GetMap()) == "gm_flatgrass") then
        local tblFiles,_ = file.Find("maps/ttt_*.bsp", "GAME")

        RunConsoleCommand("changelevel", table.Random(tblFiles))
      end
    end,
  }
}

local function updateHostname()
  local objServer = serverid.get()

  RunConsoleCommand("hostname", "Hippie's "..objServer.name..": "..objServer.getHostname())
end

timer.Create("serverid.setHostname", 60 * 2, 0, updateHostname)

local function setupServerID()
  for k,v in pairs(tblIDs) do
    if(v.check and v.check()) then
      serverid.m_currentServer = k

      if(v.config) then
        for _,strCmd in pairs(v.config) do
          game.ConsoleCommand(strCmd.."\n");
        end
      end

      return
    end
  end
end

serverid.get = function()
  return table.Copy(tblIDs[serverid.m_currentServer or 1] or {})
end

hook.Add("InitPostEntity", "serverid.setup", function()
  setupServerID()
  updateHostname()

  local objServer = serverid.get()
  if(objServer and objServer["postStart"]) then
    objServer["postStart"]()
  end
end)
