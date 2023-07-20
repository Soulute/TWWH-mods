local ROGUE_PIRATE_AGGRO_CHECK = 7;
local ROGUE_PIRATE_WAR_MAX = 9;
local ROGUE_PIRATE_HATE = 8; --increase to make less likely
local AGGRO_DISTANCE_SQUARED_LIMIT = 5000;
local AGGRO_DISTANCE_SQUARED_LIMIT_FOR_VAMPIRATES = 5000;
    


local is_rogue_pirate = {
	["wh2_dlc11_cst_rogue_bleak_coast_buccaneers"] = true,
	["wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast"] = true,
	["wh2_dlc11_cst_rogue_the_churning_gulf_raiders"] = true,
	["wh2_dlc11_cst_rogue_freebooters_of_port_royale"] = true,
	["wh2_dlc11_cst_rogue_grey_point_scuttlers"] = true,
	["wh2_dlc11_cst_rogue_terrors_of_the_dark_straights"] = true,
	["wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean"] = true,
	["wh2_dlc11_cst_harpoon_the_sunken_land_corsairs"] = true,
}


local function is_potential_plunder_candidate (rogue_pirate_faction, target_faction)
	--out ("ENCOUNTERSATDERP DEBUG considering war with " .. target_faction:name());
	if not cm:faction_is_alive (target_faction) then
		--out ("ENCOUNTERSATDERP DEBUG faction is dead, skipping.");
		return false;
	--elseif target_faction:is_human() then
		--out ("I WANT IT TO TARGET HUMANS, ergo: commented out");
		--return false;
	elseif is_rogue_pirate[target_faction:name()] then
		--out ("ENCOUNTERSATDERP DEBUG no war with fellow rogue pirate faction, skipping.");
		return false;
	elseif rogue_pirate_faction:at_war_with (target_faction) then
		--out ("ENCOUNTERSATDERP DEBUG already at war with this faction, skipping.");
		return false;
	elseif target_faction:is_vassal() then
		--out ("ENCOUNTERSATDERP DEBUG nope, this actually makes it look like the *vassal* is declaring war on the pirate!");
		return false;
	end

	return true;
end


local function get_closest_at_sea_character_to_position_from_faction (faction_obj, x, y)
	local current_closest_distance_squared = 999999999;
	local winner = false;
	local character_list = faction_obj:character_list();

	for j = 0, character_list:num_items() - 1 do
		local char_obj = character_list:item_at(j);
		if char_obj:is_at_sea()	then

			local cds = distance_squared (
				x,
				y,
				char_obj:logical_position_x(),
				char_obj:logical_position_y()
			);

			--out ("ENCOUNTERSATDERP DEBUG character from " .. candidate:name() .. " is at sea " .. tostring (cds) .. " squared units away from " .. faction:name());
			if cds < current_closest_distance_squared then
				current_closest_distance_squared = cds;
				winner = char_obj;
			end
		end
	end

	if winner then
		return winner, current_closest_distance_squared;
	end
	return false, 999999999;
end


local function ead_declare_war_quietly (pirate_faction_key, target_faction_key)
	--cm:force_declare_war (pirate_faction_key, target_faction_key, true, true, true);

	local invasion = invasion_manager:get_invasion (pirate_faction_key .. "_PIRATE");
	if not invasion then
		out ("ENCOUNTERSATDERP ERROR tried to find invasion for " .. pirate_faction_key .. " but no joy.");
		return;
	end

	for i = 1, #(invasion.aggro_targets) do
		if target_faction_key == invasion.aggro_targets[i] then
			return;
		end
	end
	out ("ENCOUNTERSATDERP adding " .. target_faction_key .. " to " .. pirate_faction_key .. "'s list of aggro targets.");
	table.insert (invasion.aggro_targets, target_faction_key);
end


local function rogue_pirate_discovery_listener (context)
	local faction = context:faction();

	local turn_number = cm:model():turn_number();
	if (turn_number + 1) % ROGUE_PIRATE_AGGRO_CHECK ~= 0 then
		--we want this to fire one turn before the actual FactionTurnStart
		return;
	end

	--out ("ENCOUNTERSATDERP doing diplomacy discoverer for " .. faction:name());

	local fac_x = faction:military_force_list():item_at(0):general_character():logical_position_x();
	local fac_y = faction:military_force_list():item_at(0):general_character():logical_position_y();

	local ds_limit = AGGRO_DISTANCE_SQUARED_LIMIT * 2;

	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
		local candidate = faction_list:item_at(i);
		
		if cm:faction_is_alive (candidate) and
		   (not candidate:is_human()) and
		   (not is_rogue_pirate[candidate:name()]) and
		   (not faction:at_war_with (candidate))
		then
			local standing_with = faction:diplomatic_standing_with (candidate:name());
			local attitude_towards = faction:diplomatic_attitude_towards (candidate:name());

			if standing_with == 0 or attitude_towards == 0 then
				--out ("ENCOUNTERSATDERP DEBUG looks like no contact yet with " .. candidate:name());

				local char_obj, cds = get_closest_at_sea_character_to_position_from_faction (candidate, fac_x, fac_y);
				if char_obj and (cds < ds_limit) then
					out ("ENCOUNTERSATDERP " .. candidate:name() .. " has someone in the water " .. tostring (cds^0.5) .. " units away from " .. faction:name() .. ", let's make diplomacy available.");
					cm:make_diplomacy_available (faction:name(), candidate:name());
				end
			end
		end
	end
end


local function rogue_pirate_listener (context)
	local faction = context:faction();

	--TODO change to something less aggressive? or base it on personality?
	local turn_number = cm:model():turn_number();
	if turn_number % ROGUE_PIRATE_AGGRO_CHECK ~= 0 then
		return;
	end

	--out ("ENCOUNTERSATDERP New war check for " .. faction:name());
	if faction:factions_at_war_with():num_items() >= ROGUE_PIRATE_WAR_MAX then
		out ("ENCOUNTERSATDERP " .. faction:name() .. " is at war with " .. tostring (faction:factions_at_war_with():num_items()) .. " factions already, skipping.");
		return;
	end

	local candidate_keys = {};
	local fac_x = faction:military_force_list():item_at(0):general_character():logical_position_x();
	local fac_y = faction:military_force_list():item_at(0):general_character():logical_position_y();

	local faction_list = faction:factions_met();
	for i = 0, faction_list:num_items() - 1 do
		local candidate = faction_list:item_at(i);

		if is_potential_plunder_candidate (faction, candidate) then

			local ds_limit = AGGRO_DISTANCE_SQUARED_LIMIT;
			if "wh2_dlc11_sc_cst_vampire_coast" == candidate:subculture() then
				--vampirates have to get extra close before rogue pirates will care.
				ds_limit = AGGRO_DISTANCE_SQUARED_LIMIT_FOR_VAMPIRATES;
			end

			local char_obj, cds = get_closest_at_sea_character_to_position_from_faction (candidate, fac_x, fac_y);
			if char_obj then 
				out ("ENCOUNTERSATDERP closest character at sea is " .. tostring (cds^0.5) .. " units away.");
				if cds < ds_limit then

					if cm:char_is_mobile_general_with_army (char_obj) or cm:char_is_general_with_navy (char_obj) then
						out ("ENCOUNTERSATDERP closest character is within range, will put on short list.");
						table.insert (candidate_keys, candidate:name());
					else
						if 1 == cm:random_number (ROGUE_PIRATE_HATE) then
							out ("ENCOUNTERSATDERP closest character doesn't have an army, will frown hard at them instead.");
							cm:apply_dilemma_diplomatic_bonus (faction:name(), candidate:name(), -1);
						end
					end
				end				
			end
		elseif candidate:is_human() then
			if 1 == cm:random_number (ROGUE_PIRATE_HATE) then
				out ("ENCOUNTERSATDERP will frown hard at human faction instead.");
				cm:apply_dilemma_diplomatic_bonus (faction:name(), candidate:name(), -1);
			end
		end
	end

	out ("ENCOUNTERSATDERP identified " .. tostring (#candidate_keys) .. " potential victim factions out of " .. tostring (faction_list:num_items()) .. " total factions met.");
	if #candidate_keys > 0 then
		local target_key = candidate_keys[cm:random_number (#candidate_keys)];
		out ("ENCOUNTERSATDERP Selected " .. target_key .. " for war!");
		ead_declare_war_quietly (faction:name(), target_key);
	else
		out ("ENCOUNTERSATDERP not declaring war this turn.");
	end
end


function avast_ye_hearty()

	for faction_key, v in pairs (is_rogue_pirate) do
		--hi viryu9
		out ("ENCOUNTERSATDERP adding FactionTurnStart listener for " .. faction_key);
		cm:add_faction_turn_start_listener_by_name (
			"ead_" .. faction_key .. "_fts",
			faction_key,
			rogue_pirate_listener,
			true
		);

		--hi Lysander
		out ("ENCOUNTERSATDERP adding BS diplomacy discovery listener for " .. faction_key);
		cm:add_faction_turn_start_listener_by_name (
			"ead_bsdd_" .. faction_key .. "_fts",
			faction_key,
			rogue_pirate_discovery_listener,
			true
		);
	end

	--reduce pirate cove cooldown at faction level.
	--character level is handled in db.
	core:remove_listener ("vampire_coast_CharacterGarrisonTargetAction");
	core:add_listener(
		"vampire_coast_CharacterGarrisonTargetAction",
		"CharacterGarrisonTargetAction",
		function (context)
			return context:agent_action_key() == "wh2_dlc11_agent_action_dignitary_hinder_settlement_establish_pirate_cove";
		end,
		function(context)
			local agent_faction = context:character():faction():name();
		
			if context:mission_result_success() then
				out ("ENCOUNTERSATDERP pirate cove established for " .. agent_faction);
				cm:remove_effect_bundle("wh2_dlc11_bundle_pirate_cove_created", agent_faction);
				cm:apply_effect_bundle("wh2_dlc11_bundle_pirate_cove_created", agent_faction, 4);
			elseif context:mission_result_critial_success() then
				out ("ENCOUNTERSATDERP pirate cove established for " .. agent_faction .. " with no cooldown!");
				cm:remove_effect_bundle("wh2_dlc11_bundle_pirate_cove_created", agent_faction);
			end
		end,
		true
	);

end


function pierce_revived_anyndel_roguier_rogues_expanded()
---deactivate script if player is Vampire Coast
local hf = cm:get_human_factions()
local is_anyone_vampirate = false;
for i = 1, #hf do
    local human_faction = hf[i];
    if human_faction:culture() == "wh2_dlc11_cst_vampire_coast" then
        is_anyone_vampirate = true;
    end
end

if is_anyone_vampirate then
    ---player is vampire coast, do nothing
else
    ---player is not vampire coast
    avast_ye_hearty();
end
end
