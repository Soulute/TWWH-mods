local WHY_LLH_DEFEATED_TRAITS = {
	["zacharias"] = "wh2_main_trait_defeated_zac",         -- Zacharias the Everliving
	["dieter"] = "wh2_main_trait_defeated_dieter",         -- Dieter Helsnicht
};


events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();

	if cm:char_is_general_with_army(character) and character:won_battle() then
		local LLH_enemies = Why_LLH_Get_Enemy_Legendary_Lords_In_Last_Battle(character);
		
		for i = 1, #LLH_enemies do
			local LLH_trait = WHY_LLH_DEFEATED_TRAITS[LLH_enemies[i]];
			
			if LLH_trait ~= nil then
				Give_Trait(character, LLH_trait);
			end
		end
	end
end

function Why_LLH_Get_Enemy_Legendary_Lords_In_Last_Battle(character)
	local LLH_attackers = {};
	local LLH_defenders = {};
	local was_attacker = false;
	
	for i = 1, cm:pending_battle_cache_num_attackers() do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
		local char_obj = cm:model():character_for_command_queue_index(this_char_cqi);
		
		if this_char_cqi == character:cqi() then
			was_attacker = true;
			break;
		end
		
		if char_obj:is_null_interface() == false then
			local char_subtype = char_obj:character_subtype_key();
			
			if WHY_LLH_DEFEATED_TRAITS[char_subtype] ~= nil then
				table.insert(LLH_attackers, char_subtype);
			end
		end
	end
	
	if was_attacker == false then
		return LLH_attackers;
	end
	
	for i = 1, cm:pending_battle_cache_num_defenders() do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
		local char_obj = cm:model():character_for_command_queue_index(this_char_cqi);
		
		if char_obj:is_null_interface() == false then
			local char_subtype = char_obj:character_subtype_key();
			
			if WHY_LLH_DEFEATED_TRAITS[char_subtype] ~= nil then
				table.insert(LLH_defenders, char_subtype);
			end
		end
	end
	return LLH_defenders;
end