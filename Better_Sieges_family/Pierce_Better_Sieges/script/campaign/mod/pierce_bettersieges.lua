
core:add_listener(
  "JSIEGES_PENDING_BATTLE",
  "PendingBattle",
  function(context)
    return true
  end,
  function(context)
    local battle = context:pending_battle()
    local attacker = battle:attacker()
    if battle:seige_battle() and attacker:faction():is_human() and battle:has_contested_garrison() then
      local garrison_residence = battle:contested_garrison()
      local garrison_commander = cm:get_garrison_commander_of_region(garrison_residence:region())
      if garrison_commander then
        local army = garrison_commander:military_force()
        local army_cqi = army:command_queue_index()
        cm:apply_effect_bundle_to_force("jsieges_defender_buff", army_cqi, 1)
      end
    end
end,
true
)
