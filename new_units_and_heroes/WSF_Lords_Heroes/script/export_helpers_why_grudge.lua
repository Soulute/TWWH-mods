cm.first_tick_callbacks[#cm.first_tick_callbacks+1] =
function(context) 
	Why_Vampires_add();

	Why_Lords_Listeners();
	return true;
end;

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Spawn Zacharias and Genevieve from the start
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function Why_Vampires_add()
	if cm:model():campaign_name("main_warhammer") then
		if cm:is_new_game() then
			cm:create_force_with_general(
				"wh2_main_vmp_necrarch_brotherhood",
				"wh_main_vmp_inf_zombie",
				"wh2_main_ash_river_springs_of_eternal_life",
				690,
				35,
				"general",
				"zacharias",
				"names_name_3330891160",
				"",
				"names_name_3330891161",
				"",
				false,
				function(cqi)
					-- cm:add_agent_experience(cm:char_lookup_str(cqi), 1000);
				end
			);
			cm:create_agent(
				"wh_main_emp_empire",
				"wizard",
				"genevieve",
				491,
				454,
				false,
				function(cqi)
					cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_genevieve", false);
					cm:replenish_action_points(cm:char_lookup_str(cqi));
				end
			);
		end;
	end;
end;


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- LISTENERS
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local dilemma = "why_lords_helsnicht_dilemma"
local lyonesse = "wh_main_lyonesse_lyonesse"

function Why_Lords_Listeners()



-- Dieter Helsnicht dilemma and spawn
	
	core:add_listener(
		"HelsnichtDilemma",
		"FactionTurnStart",
		function(context) return context:faction():is_human() and context:faction():name() == "wh_main_vmp_vampire_counts" and cm:model():turn_number() == 16 end,
		function(context) cm:trigger_dilemma("wh_main_vmp_vampire_counts", dilemma) end, 		
		false
	);

    core:add_listener(
        "WhyHelsnichtDilemmaChoice",
        "DilemmaChoiceMadeEvent",
        function(context)
            return context:dilemma() == dilemma
        end,
        function(context)
            local choice = context:choice()

            if choice == 0 then
                cm:spawn_character_to_pool("wh_main_vmp_vampire_counts", "names_name_3330891143", "names_name_3330891144", "", "", 18, true, "general", "helsnicht", true, "");
				cm:show_message_event(
					"wh_main_vmp_vampire_counts",
					"event_feed_strings_text_wh_dieter_unlocked_title",
					"event_feed_strings_text_wh_dieter_unlocked_primary_detail",
					"event_feed_strings_text_wh_dieter_unlocked_secondary_detail",
					true,
					585
				);
            elseif choice == 1 then
				cm:create_force_with_general(
					"wh_main_vmp_vampire_counts",
					"wh_main_vmp_cav_black_knights_3,wh_main_vmp_cav_black_knights_1,wh_main_vmp_inf_skeleton_warriors_0,wh_main_vmp_inf_zombie",
					"wh_main_ostland_wolfenburg",
					551,
					575,
					"general",
					"helsnicht",
					"names_name_3330891143",
					"",
					"names_name_3330891144",
					"",
					false,
					function(cqi)
						-- cm:add_agent_experience(cm:char_lookup_str(cqi), 1000);
					end
				);
				cm:show_message_event(
					"wh_main_vmp_vampire_counts",
					"event_feed_strings_text_wh_dieter_unlocked_title",
					"event_feed_strings_text_wh_dieter_unlocked_primary_detail",
					"event_feed_strings_text_wh_dieter_unlocked_alt_secondary_detail",
					true,
					585
				);              
            end;
        end,
        false       	
	);


end;