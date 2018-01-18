function job_handle_equipping_gear(playerStatus, eventArgs)
	local lockables = T{'Mecisto. Mantle', 'Aptitude Mantle', 'Nexus Cape', 'Aptitude Mantle +1', 'Warp Ring', 'Vocation Ring', 'Reraise Earring', 'Capacity Ring', 'Trizek Ring', 'Echad Ring', 'Facility Ring', 'Dim. Ring (Holla)', 'Dim. Ring (Dem)', 'Dim. Ring (Mea)'}
	
	if lockables:contains(player.equipment.back) then
		disable('back')
		
		if has_charges(player.equipment.back) and (not is_enchant_ready(player.equipment.back)) then
			enable('back')
		end
	end
		
	if lockables:contains(player.equipment.ring1) then
		disable('ring1')

		if has_charges(player.equipment.ring1) and (not is_enchant_ready(player.equipment.ring1)) then
			enable('ring1')
		end
	end

	if lockables:contains(player.equipment.ring2) then
		disable('ring2')

		if has_charges(player.equipment.ring2) and (not is_enchant_ready(player.equipment.ring2)) then
			enable('ring2')
		end
	end
end
