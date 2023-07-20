core:add_listener(
	"faction_turn_end_rogue_enable_movement",
	"FactionTurnEnd",
	function(context) return context:faction():is_human() end,
	function()
	cm:enable_movement_for_faction("wh2_dlc09_rogue_black_creek_raiders")
	cm:enable_movement_for_faction("wh2_dlc09_rogue_dwellers_of_zardok")
	cm:enable_movement_for_faction("wh2_dlc09_rogue_eyes_of_the_jungle")
	cm:enable_movement_for_faction("wh2_dlc09_rogue_pilgrims_of_myrmidia")
	cm:enable_movement_for_faction("wh2_main_rogue_abominations")
	cm:enable_movement_for_faction("wh2_main_rogue_beastcatchas")
	cm:enable_movement_for_faction("wh2_main_rogue_bernhoffs_brigands")
	cm:enable_movement_for_faction("wh2_main_rogue_black_spider_tribe")
	cm:enable_movement_for_faction("wh2_main_rogue_boneclubbers_tribe")
	cm:enable_movement_for_faction("wh2_main_rogue_celestial_storm")
	cm:enable_movement_for_faction("wh2_main_rogue_college_of_pyrotechnics")
	cm:enable_movement_for_faction("wh2_main_rogue_def_chs_vashnaar")
	cm:enable_movement_for_faction("wh2_main_rogue_def_mengils_manflayers")
	cm:enable_movement_for_faction("wh2_main_rogue_doomseekers")
	cm:enable_movement_for_faction("wh2_main_rogue_gerhardts_mercenaries")
	cm:enable_movement_for_faction("wh2_main_rogue_pirates_of_trantio")
	cm:enable_movement_for_faction("wh2_main_rogue_hef_tor_elithis")
	cm:enable_movement_for_faction("wh2_main_rogue_hung_warband")
	cm:enable_movement_for_faction("wh2_main_rogue_jerrods_errantry")
	cm:enable_movement_for_faction("wh2_main_rogue_morrsliebs_howlers")
	cm:enable_movement_for_faction("wh2_main_rogue_scourge_of_aquitaine")
	cm:enable_movement_for_faction("wh2_main_rogue_stuff_snatchers")
	cm:enable_movement_for_faction("wh2_main_rogue_troll_skullz")
	cm:enable_movement_for_faction("wh2_main_rogue_vmp_heirs_of_mourkain")
	cm:enable_movement_for_faction("wh2_main_rogue_wef_hunters_of_kurnous")
	cm:enable_movement_for_faction("wh2_main_rogue_wrath_of_nature")
	--for vortex only rogues
	if cm:model():campaign_name("wh2_main_great_vortex") then 
	cm:enable_movement_for_faction("wh2_main_rogue_mangy_houndz") 
	cm:enable_movement_for_faction("wh2_main_rogue_worldroot_rangers") 
	cm:enable_movement_for_faction("wh2_main_rogue_vauls_expedition")
	cm:enable_movement_for_faction("wh2_main_rogue_teef_snatchaz") 
	cm:enable_movement_for_faction("wh2_main_rogue_the_wandering_dead")
	cm:enable_movement_for_faction("wh2_main_rogue_pirates_of_the_far_sea")
	cm:enable_movement_for_faction("wh2_main_rogue_scions_of_tesseninck")	
	end;
	end,
	true
);

