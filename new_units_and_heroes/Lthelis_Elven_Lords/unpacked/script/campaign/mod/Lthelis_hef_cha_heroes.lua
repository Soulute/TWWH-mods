events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = 
function(context) 
	Lthelis_hef_characters();
	Lthelis_def_characters();
	Lthelis_wef_characters();
	return true;
end


-----------------------------------------------------------------------------------
----------------- High Elves Characters -----------------------------
------------------------------------------------------------------------------------

function Lthelis_hef_characters()
	if cm:model():campaign_name("main_warhammer") then
		if cm:is_new_game() then
			cm:create_force_with_general(
				"wh2_main_hef_saphery",
				"wh2_main_hef_inf_spearmen_0",
				"wh2_main_saphery_tor_finu",
				260,
				356,
				"general",
				"wh2_main_hef_cha_aurelion",
				"names_name_1201181105",
				"",
				"names_name_1201181106",
				"",
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_trait_immortality_lord", false);
				end
			);
--[[		cm:create_agent(
				"wh2_main_hef_avelorn",
				"champion",
				"wh2_main_hef_lirazel",
				229,
				366,
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_hef_trait_name_dummy_lirazel", false);
					cm:replenish_action_points(cm:char_lookup_str(cqi));
				end
			);]]            
		end
	elseif cm:model():campaign_name("wh2_main_great_vortex") then
		if cm:is_new_game() then
			cm:create_force_with_general(
				"wh2_main_hef_saphery",
				"wh2_main_hef_inf_spearmen_0",
				"wh2_main_vor_saphery_tor_finu",
				579,
				545,
				"general",
				"wh2_main_hef_cha_aurelion",
				"names_name_1201181105",
				"",
				"names_name_1201181106",
				"",
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_trait_immortality_lord", false);
				end
			);
--[[		cm:create_agent(
				"wh2_main_hef_avelorn",
				"champion",
				"wh2_main_hef_lirazel",
				527,
				546,
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_hef_trait_name_dummy_lirazel", false);
					cm:replenish_action_points(cm:char_lookup_str(cqi));
				end
			);]]
		end
	end
end

-----------------------------------------------------------------------------------
----------------- Dark Elves Characters -----------------------------
------------------------------------------------------------------------------------


function Lthelis_def_characters()
	if cm:model():campaign_name("main_warhammer") then
		if cm:is_new_game() then
			cm:create_force_with_general(
				"wh2_main_def_naggarond",
				"",
				"wh2_main_iron_mountains_naggarond",
				80,
				630,
				"general",
				"wh2_main_def_cha_lilaeth",
				"names_name_1201181103",
				"",
				"names_name_1201181104",
				"",
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_trait_immortality_lord", false);
				end
			);
--[[			cm:create_agent(
				"wh2_main_def_naggarond",
				"champion",
				"wh2_main_def_kouran_darkhand",
				76,
				632,
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_def_trait_name_dummy_kouran_darkhand", false);
					cm:replenish_action_points(cm:char_lookup_str(cqi));
				end
			);]]
		end
	elseif cm:model():campaign_name("wh2_main_great_vortex") then
		if cm:is_new_game() then
			cm:create_force_with_general(
				"wh2_main_def_naggarond",
				"",
				"wh2_main_vor_naggarond_naggarond",
				205,
				657,
				"general",
				"wh2_main_def_cha_lilaeth",
				"names_name_1201181103",
				"",
				"names_name_1201181104",
				"",
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_trait_immortality_lord", false);
				end
			);
--[[			cm:create_agent(
				"wh2_main_def_naggarond",
				"champion",
				"wh2_main_def_kouran_darkhand",
				207,
				652,
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_def_trait_name_dummy_kouran_darkhand", false);
					cm:replenish_action_points(cm:char_lookup_str(cqi));
				end
			);]]
		end
	end
end


-----------------------------------------------------------------------------------
----------------- Wood Elves Characters -----------------------------
------------------------------------------------------------------------------------

function Lthelis_wef_characters()
	if cm:model():campaign_name("main_warhammer") then
		if cm:is_new_game() then
				cm:create_force_with_general(
				"wh_dlc05_wef_wood_elves",
				"",
				"wh_main_athel_loren_yn_edryl_korian",
				490,
				336,
				"general",
				"wh2_main_wef_cha_draya",
				"names_name_1201181109",
				"",
				"names_name_1201181110",
				"",
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "wh2_main_trait_immortality_lord", false);
				end
		                );
		end;

	end;
end;

