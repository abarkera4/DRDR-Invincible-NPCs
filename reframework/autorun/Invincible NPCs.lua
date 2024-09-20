local WriteInfoLogs = false

local function log_info(info_message)
  if WriteInfoLogs then
    log.info("[Mr. Grimaldus > Invincible NPCs]: " .. info_message)
  end
end

local npcMapping = {
  Npc00_Burt = "NPC_00",
  Npc01_Heather = "NPC_01",
  Npc02_Natalie = "NPC_02",
  Npc03_Gordon = "NPC_03",
  Npc04_Aaron = "NPC_04",
  Npc05_Jeff = "NPC_05",
  Npc06_Pamela = "NPC_06",
  Npc07_Kindell = "NPC_07",
  Npc08_Jolie = "NPC_08",
  Npc09_Rachel = "NPC_09",
  Npc10_Shinji = "NPC_10",
  Npc11_Tonya = "NPC_11",
  Npc12_Ross = "NPC_12",
  Npc13_Wayne = "NPC_13",
  Npc14_Bill = "NPC_14",
  Npc15_Sally = "NPC_15",
  Npc16_Nick = "NPC_16",
  Npc17_Leroy = "NPC_17",
  Npc18_Simone = "NPC_18",
  Npc19_Gil = "NPC_19",
  Npc1A_Brett = "NPC_1a",
  Npc1B_Jonathan = "NPC_1b",
  Npc1C_Alyssa = "NPC_1c",
  Npc1D_Paul = "NPC_1d",
  Npc1E_Sophie = "NPC_1e",
  Npc1F_Jennifer = "NPC_1f",
  Npc20_Kent = "NPC_20",
  Npc2A_Brad = "NPC_2a",
  Npc2B_Isabela = "NPC_2b", -- THIS IS GOOD ISABELA
  Npc2C_Isabela = "NPC_2c", -- ALSO GOOD ISABELA
  Npc2D_Isabela = "NPC_2d",
  Npc2E_Brad = "NPC_2e",
  Npc2F_Carlito = "NPC_2f",
  Npc30_Brad = "NPC_30",
  Npc31_Jessie = "NPC_31",
  Npc33_DrBarnaby = "NPC_33",
  Npc34_Otis = "NPC_34",
  Npc40_Ray = "NPC_40",
  Npc42_Nathan = "NPC_42",
  Npc44_Michelle = "NPC_44",
  Npc45_Cheryl = "NPC_45",
  Npc46_Beth = "NPC_46",
  Npc4A_Calvin = "NPC_4a",
  Npc4B_Wayne = "NPC_4b",
  Npc4C_Josh = "NPC_4c",
  Npc4D_Barbara = "NPC_4d",
  Npc4E_Rich = "NPC_4e",
  Npc4F_Mindy = "NPC_4f",
  Npc50_Debbie = "NPC_50",
  Npc52_Tad = "NPC_52",
  Npc54_Greg = "NPC_54",
  Npc56_Kay = "NPC_56",
  Npc57_Lilly = "NPC_57",
  Npc59_Kelly = "NPC_59",
  Npc5A_Janet = "NPC_5a",
  Npc70_SpecialForce = "NPC_70",
  Npc80_Brad = "NPC_80",
  Npc81_Jessie = "NPC_81",
  Npc82_Carlito = "NPC_82",
  Npc83_Isabela = "NPC_83",
  Npc84_DrBarnaby = "NPC_84",
  Npc85_Lindsay = "NPC_85",
  Npc86_Otis = "NPC_86",
  Npc89_Carlito = "NPC_89",
  Npc8A_Brad = "NPC_8a",
  Npc8B_Brad = "NPC_8b",
  Npc8C_Brad = "NPC_8c",
  Npc8E_Carlito = "NPC_8e",
  Npc8F_DrBarnaby = "NPC_8f",
  Npc90_Ryan = "NPC_90",
  Npc91_Chris = "NPC_91",
  Npc92_Todd = "NPC_92",
  Npc93_Brian = "NPC_93",
  Npc94_Dana = "NPC_94",
  Npc95_Verlene = "NPC_95",
  Npc96_Mark = "NPC_96",
  Npc97_Kathy = "NPC_97",
  Npc98_Alan = "NPC_98",
  Npc99_James = "NPC_99",
  Npc9A_Sid = "NPC_9A",
  Npc9C_Freddie = "NPC_9c",
  PLO0_FRANK = "NPC_100",
  PLO0_FRANK_UI = "NPC_101",
  Npc84_Hanged = "NPC_84_Hanged",

}

local currentScene = nil
local playerFound = false

re.on_pre_application_entry("LockScene", function()
  local sceneManager = sdk.get_native_singleton("via.SceneManager")
  if not sceneManager then
    log_info("SceneManager not found")
    return
  end

  local scene = sdk.call_native_func(sceneManager, sdk.find_type_definition("via.SceneManager"), "get_CurrentScene")
  if not scene or scene == currentScene and playerFound then
    return
  end


  if scene ~= currentScene then
    currentScene = scene
    playerFound = false
    log_info("Scene changed, searching for player and NPCs...")
  end


  local player = scene:call("findGameObject(System.String)", "Pl_Frank")
  if not player then
    log_info("Player not found, continuing to search...")
    return
  end


  playerFound = true
  log_info("Player found, setting NPCs to invincible...")

  for npcEnum, gameObjectName in pairs(npcMapping) do
    local npc = scene:call("findGameObject(System.String)", gameObjectName)
    if npc then
      local npcController = npc:call("getComponent(System.Type)", sdk.typeof("app.solid.survivor.NpcController"))
      if npcController then
        local hitPointField = npcController:get_field("<HitPoint>k__BackingField")
        if hitPointField then
          hitPointField:set_Invincible(true)
          hitPointField:set_NoDamage(true)
          log_info(npcEnum .. " set to invincible")
        else
          log_info("HitPoint field not found for " .. npcEnum)
        end
      else
        log_info("NpcController not found for " .. npcEnum)
      end
    else
      log_info(gameObjectName .. " (" .. npcEnum .. ") not found in scene")
    end
  end
end)
