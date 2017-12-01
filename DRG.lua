-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
 
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end
 
 
-- Setup vars that are user-independent.
function job_setup()
	state.Buff['Aftermath'] = buffactive['Aftermath: Lv.1'] or
	buffactive['Aftermath: Lv.2'] or
	buffactive['Aftermath: Lv.3']
	or false

	LugraWSList = S{}

 
    -- Weaponskills you do NOT want Gavialis helm used with
    wsList = S{'Spiral Hell', 'Torcleaver', 'Insurgency', 'Quietus'}
    -- Greatswords you use. 
    gsList = S{'Malfeasance', 'Macbain', 'Kaquljaan', 'Mekosuchus Blade', 'Ragnarok', 'Zulfiqar',}
    shields = S{'Adapa Shield'}

    get_combat_form()
    get_combat_weapon()
    update_melee_groups()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc', 'Acc2')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.MagicalDefenseMode:options('MDT')
    
    war_sj = player.sub_job == 'WAR' or false
 
    include('Mote-TreasureHunter')
    state.TreasureMode:set('Tag')

    state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
 
    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` gs c cycle HasteMode')
	send_command('bind @` gs c cycle MarchMode')
    send_command('bind ^[ input /lockstyle on')
    send_command('bind ![ input /lockstyle off')

	update_melee_groups()
	select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
		if binds_on_unload then
				binds_on_unload()
		end
 
		send_command('unbind ^`')
		send_command('unbind !-')
end
 
	   
-- Define sets and vars used by this job file.
function init_gear_sets()
--------------------------------------
-- Start defining the sets
--------------------------------------
	-- Precast Sets
	-- Precast sets to enhance JAs
	sets.precast.JA['Jump'] = {hands=""}
	sets.precast.JA['High Jump'] = {feet=""}
	sets.precast.JA['Spirit Jump'] = set_combine(sets.engaged.Ryu, {legs="Peltast's Cuissots",feet="Pelt. Schynbalds"})
	sets.precast.JA['Soul Jump'] = set_combine(sets.engaged.Ryu, {legs="Peltast's Cuissots",})
	sets.precast.JA['Spirit Link'] = {head=""}
	sets.precast.JA['Angon'] = {ammo="Angon"}
	   
    sets.WSDayBonus     = {}
    sets.TreasureHunter = { head="White Rarab Cap +1", body=gear.ValorousBodyTH, waist="Chaac Belt" }
	
	-----------------------------
	-- Brigantia Mantles
	-----------------------------
	
	Brig = {}
	Brig.FC = {name="Brigantia Mantle", augments={"'Fast Cast'+10",}}
	Brig.DA = {name="Brigantia Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}}
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
		   
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
   
    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Sapience Orb",
        head="Carmine Mask",neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
        body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Prolix Ring",
		back=Brig.FC,waist="",legs="",feet="Carmine Greaves"}
	 
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck="Magoraga Beads" })
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})
    sets.precast.FC['Absorb-TP'] = set_combine(sets.precast.FC, { hands="Bale Gauntlets +2" })
    sets.precast.FC['Dark Magic'] = set_combine(sets.precast.FC, { head="Fallen's Burgeonet" })
		 
	-- Midcast Sets
	sets.midcast.FastRecast = set_combine(sets.precast.FC, {waist="Ioskeha Belt"})
		   
	-- Specific spells
	sets.midcast.Utsusemi = {ammo="Staunch Tathlum",
        head="Carmine Mask",neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
        body="Odyssean Chestplate",hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Kishar Ring",
		waist=Brig.FC,legs="Eschite Cuisses",feet="Carmine Greaves"}
	
	-----------------------------
	-- Ryunohige Sets
	-----------------------------
	
	sets.engaged = {}
	sets.engaged.Ryu = {ammo="ginsen",
		head="Flamma Zucchetto +2",neck="Ainia Collar",ear1="Dedition Earring",ear2="Sherida Earring",
		body="Flamma Korazin +1",hands="Flamma Manopolas +1",ring1="Niqmaddu Ring",ring2="Petrov Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Flamma Dirs +1",feet="Flamma Gambieras +2"}
	sets.engaged.Ryu.Acc = set_combine(sets.engaged.Ryu, {})
	sets.engaged.Ryu.Acc2 = set_combine(sets.engaged.Ryu.Acc, {})
	
	-----------------------------
	-- Ryunohige Sets AM3
	-----------------------------
	
	sets.engaged.Ryu.AM3 = {ammo="ginsen",
		head="Flamma Zucchetto +2",neck="Ainia Collar",ear1="Dedition Earring",ear2="Sherida Earring",
		body="Peltast's Plackart +1",hands="Flamma Manopolas +1",ring1="Niqmaddu Ring",ring2="Flamma Ring",
		back="Brigantia's Mantle",waist="Windbuffet Belt +1",legs="Flamma Dirs +1",feet="Flamma Gambieras +2"}
	sets.engaged.Ryu.Acc.AM3 = set_combine(sets.engaged.Ryu.AM3, {})
	sets.engaged.Ryu.Acc2.AM3 = set_combine(sets.engaged.Ryu.AM3.Acc, {})
	
	-----------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	-----------------------------
	
	sets.precast.WS = {main="",sub="",ammo="Knobkierrie",
		head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Sherida Earring",
		body=gear.ValorousBodyAcc,hands="Argosy Mufflers",ring1="Niqmaddu Ring",ring2="Regal Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs="Sulevia's Cuisses",feet=gear.ValorousFeetWS}
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-----------------------------
	-- Ryunohige WS
	-----------------------------

	sets.precast.WS['Drakesbane'] = {ammo="Knobkierrie",
		head=gear.ValorousHeadCrit,neck="Fotia Gorget",ear1="Brutal Earring",ear2="Sherida Earring",
		body=gear.ValorousBodyAcc,hands="Flamma Manopolas +1",ring1="Niqmaddu Ring",ring2="Begrudging Ring",
		back="Brigantia's Mantle",waist="Grunfeld Rope",legs="Sulevia Cuisses +2",feet=gear.ValorousFeetWS}
	-- Acc + Macc for Stun Effect
	sets.precast.WS['Leg Sweep'] = {ammo="Pemphredo Tathlum",
		head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Dignitary's Earring",
		body="Flamma Korazin +1",hands="Flamma Manopolas +1",ring1="Sangoma Ring",ring2="Weatherspoon Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs="Flamma Dirs +1",feet="Flamma Gambieras +2"}
	sets.precast.WS['Stardiver'] = {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Sherida Earring",
		body=gear.ValorousBodyAcc,hands="Sulevia's Gauntlets +2",ring1="Niqmaddu Ring",ring2="Regal Ring",
		back="Brigantia's Mantle",waist="Fotia Belt",legs=gear.ValorousLegsDA,feet="Flamma Gambieras +2"}
	sets.precast.WS["Camlann's Torment"] = {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Sherida Earring",
		body=gear.ValorousBodyAcc,hands="Flamma Manopolas +1",ring1="Niqmaddu Ring",ring2="Regal Ring",
		back="Brigantia's Mantle",waist="Grunfeld Rope",legs="Sulevia Cuisses +2",feet=gear.ValorousFeetWS}
	sets.precast.WS["Sonic Thrust"] = {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Sherida Earring",
		body=gear.ValorousBodyAcc,hands="Flamma Manopolas +1",ring1="Niqmaddu Ring",ring2="Regal Ring",
		back="Brigantia's Mantle",waist="Grunfeld Rope",legs="Sulevia Cuisses +2",feet=gear.ValorousFeetWS}
	
	-- Sets to return to when not performing an action.
	-- Resting sets
	sets.resting = {ammo="Staunch Tathlum",
		head="Sulevia's Mask +1",neck="Sanctity Necklace",ear1="Impreg. Earring",ear2="Etiolation Earring",
		body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +2",ring1="Defending Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Carmine Cuisses",feet="Amm Greaves"}
   
	-- Idle sets
	sets.idle = {ammo="Staunch Tathlum",
		head="Sulevia's Mask +1",neck="Sanctity Necklace",ear1="Impreg. Earring",ear2="Etiolation Earring",
		body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +2",ring1="Defending Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Carmine Cuisses",feet="Amm Greaves"}

	sets.idle.Weak = {ammo="Staunch Tathlum",
		head="",neck="Sanctity Necklace",ear1="Impreg. Earring",ear2="Etiolation Earring",
		body="Sulevia Plate. +2",hands="Founder's Gauntlets",ring1="Defending Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Carmine Cuisses",feet="Amm Greaves"}

	-----------------------------
	-- Defense sets
	-----------------------------
	
	sets.defense.PDT = {ammo="Staunch Tathlum",
    head="Flamma Zucchetto",neck="Loricate Torque +1",ear1="Impreg. Earring",ear2="Handler's Earring +1",
	body="Sulevia's Plate. +2",hands="Sulevia's Gauntlets +2",ring1="Defending Ring",ring2="Dark Ring",
	back="Shadow Mantle",waist="Flume Belt",legs="Sulev. Cuisses +2",feet="Amm Greaves"}
	sets.defense.PDT.AM3 = sets.defense.PDT
	
	sets.defense.Reraise = set_combine(sets.defense.PDT, {head="Twilight Helm",body="Twilight Mail"})
	sets.defense.Reraise.AM3 = sets.defense.Reraise
	
	sets.defense.MDT = {ammo="Staunch Tathlum",
    head="Flamma Zucchetto",neck="Loricate Torque +1",ear1="Impreg. Earring",ear2="Handler's Earring +1",
	body="Sulevia's Plate. +2",hands="Sulevia's Gauntlets +2",ring1="Defending Ring",ring2="Shadow Ring",
	back="Engulfer's Cape",waist="Flume Belt",legs="Sulev. Cuisses +2",feet="Amm Greaves"}

	sets.MEva = {ammo="Staunch Tathlum",
    head="Flamma Zucchetto +2",neck="Warder's Charm +1",ear1="Eabani Earring",ear2="Hearty Earring",
    body="Flamma Korazin +1",hands="Leyline Gloves",ring1="Purity Ring",ring2="Vengeful Ring",
	back="Solemnity Cape",waist="Asklepian Belt",legs="Flamma Dirs +1",feet="Founder's Greaves"}
	sets.MEva.AM3 = sets.MEva

	sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}

	-- Engaged sets
	sets.engaged.Acc = set_combine(sets.engaged, {ammo=gear.AccAmmo,
		neck="Sanctity Necklace",ear1="Zennaroi Earring",ring1="Patricius Ring",ring2="Ramuh Ring",
		back="Agema Cape",waist="Olseni Belt",feet="Founder's Greaves"})
	sets.engaged.Acc2 = set_combine(sets.engaged.Acc, {neck="Iqabi Necklace",ring2="Mars's Ring",waist="Anguinus Belt"})
	sets.engaged.Reraise = {ammo="Fire Bomblet",
		head="Twilight Helm",neck="Loricate Torque +1",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Twilight Mail",hands="Cizin Muffler",ring1="Dark Ring",ring2="Dark Ring",
		back="Letalis Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Cizin Greaves"}
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

 function is_sc_element_today(spell)
    if spell.type ~= 'WeaponSkill' then
        return
    end

   local weaponskill_elements = S{}:
    union(skillchain_elements[spell.skillchain_a]):
    union(skillchain_elements[spell.skillchain_b]):
    union(skillchain_elements[spell.skillchain_c])

    if weaponskill_elements:contains(world.day_element) then
        return true
    else
        return false
    end

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    if spell.action_type == 'Magic' then
        equip(sets.precast.FC)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' or spell.type == 'Magic' then
        if is_sc_element_today(spell) then
            if state.OffenseMode.current == 'Normal' and wsList:contains(spell.english) then
                -- use normal head piece
            else
                equip(sets.WSDayBonus)
            end
        end
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		equip(sets.midcast.FastRecast)
	end
end
 
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.HybridMode.current == 'Reraise' or
    (state.HybridMode.current == 'Physical' and state.PhysicalDefenseMode.current == 'Reraise') then
        equip(sets.Reraise)
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)    	
    if player.equipment.back == 'Mecisto. Mantle' or player.equipment.back == 'Aptitude Mantle' or player.equipment.back == 'Aptitude Mantle +1' or player.equipment.back == 'Nexus Cape' then
        disable('back')
    else
        enable('back')
    end
    if player.equipment.ring1 == 'Warp Ring' or player.equipment.ring1 == 'Vocation Ring' or player.equipment.ring1 == 'Capacity Ring' or player.equipment.ring1 == 'Echad Ring' or player.equipment.ring1 == 'Trizek Ring' then
        disable('ring1')
    else
        enable('ring1')
    end
    if player.equipment.ring2 == 'Warp Ring' or player.equipment.ring2 == 'Vocation Ring' or player.equipment.ring2 == 'Capacity Ring'  or player.equipment.ring2 == 'Echad Ring' or player.equipment.ring2 == 'Trizek Ring' then
        disable('ring2')
    else
        enable('ring2')
    end
end
 
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 50 then
        idleSet = set_combine(idleSet, sets.refresh)
    end
    if player.hpp < 90 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    end
    return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    return meleeSet
end
 
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == "Engaged" then
        if player.equipment.main == 'Ryunohige'then
            state.CombatWeapon:set('Ryu')
        elseif player.equipment.main == 'Trishula' then
            state.CombatWeapon:set('Trish')
        elseif player.equipment.main == 'Sword' then
            state.CombatWeapon:set('Sword')
        else
            state.CombatWeapon:reset()
        end
    end
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- AM custom group
    if buff:startswith('Aftermath') then
        if player.equipment.main == 'Ryunohige' then
            classes.CustomMeleeGroups:clear()
            if (buff == "Aftermath: Lv.3" and gain) or buffactive['Aftermath: Lv.3'] then
                classes.CustomMeleeGroups:append('AM3')
                add_to_chat(8, '-------------AM3 UP-------------')
            end
            if not midaction() then
                handle_equipping_gear(player.status)
            end
		end
    end
	get_combat_form()
	get_combat_weapon()
	update_melee_groups()
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	war_sj = player.sub_job == 'WAR' or false
	handle_equipping_gear(player.status)
	update_melee_groups()
    get_combat_form()
    get_combat_weapon()
    th_update(cmdParams, eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function get_combat_form()
    if S{'NIN', 'DNC'}:contains(player.sub_job) and war_sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    elseif S{'SAM', 'WAR'}:contains(player.sub_job) and player.equipment.sub == 'Adapa Shield' then
        state.CombatForm:set("SW")
    else
        state.CombatForm:reset()
    end
end

function update_combat_form()
    if newStatus == "Engaged" then
        if player.equipment.main == 'Ryunohige'then
            state.CombatWeapon:set('Ryu')
        elseif player.equipment.main == 'Sword' then
            state.CombatWeapon:set('Sword')
        else -- use regular set, which caters to Liberator
            state.CombatWeapon:reset()
        end
    end
end

function get_combat_weapon()
        if player.equipment.main == 'Ryunohige'then
            state.CombatWeapon:set('Ryu')
        elseif player.equipment.main == 'Sword' then
            state.CombatWeapon:set('Sword')
        else -- use regular set, which caters to Liberator
            state.CombatWeapon:reset()
        end
end

function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current.." + "..state.CombatWeapon.value
	
    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.HasteMode.value ~= 'Normal' then
        msg = msg .. ', Haste: '..state.HasteMode.current
    end
	if state.MarchMode.value ~= 'Normal' then
        msg = msg .. ', March Mode: '..state.MarchMode.current
    end
    if state.RangedMode.value ~= 'Normal' then
        msg = msg .. ', Rng: '..state.RangedMode.current
    end
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(123, msg)
    eventArgs.handled = true
end

function determine_haste_group()
   
	classes.CustomMeleeGroups:clear()
	h = 0
	-- Spell Haste 15/30
	if buffactive[33] then
		if state.HasteMode.value == 'Haste I' then
			h = h + 15
		elseif state.HasteMode.value == 'Haste II' then
			h = h + 30
		end
	end
	-- Geo Haste 30
	if buffactive[580] then
		h = h + 30
	end
	-- Mighty Guard 15
	if buffactive[604] then
		h = h + 15
	end
	-- Embrava 15
	if buffactive.embrava then
		h = h + 15
	end
	-- March(es) 
	if buffactive.march then
		if state.MarchMode.value == 'Honor' then
			if buffactive.march == 2 then
				h = h + 27 + 16
			elseif buffactive.march == 1 then
				h = h + 16
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == 'Trusts' then
			if buffactive.march == 2 then
				h = h + 26
			elseif buffactive.march == 1 then
				h = h + 16
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == '7' then
			if buffactive.march == 2 then
				h = h + 27 + 17
			elseif buffactive.march == 1 then
				h = h + 27
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == '3' then
			if buffactive.march == 2 then
				h = h + 13.5 + 20.6
			elseif buffactive.march == 1 then
				h = h + 20.6
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		end
	end

	-- Determine CustomMeleeGroups
	--if h >= 15 and h < 30 then 
	--	classes.CustomMeleeGroups:append('Haste_15')
	--	add_to_chat('Haste Group: 15% -- From Haste Total: '..h)
	--elseif h >= 30 and h < 35 then 
	--	classes.CustomMeleeGroups:append('Haste_30')
	--	add_to_chat('Haste Group: 30% -- From Haste Total: '..h)
	--elseif h >= 35 and h < 40 then 
	--	classes.CustomMeleeGroups:append('Haste_35')
	--	add_to_chat('Haste Group: 35% -- From Haste Total: '..h)
	--elseif h >= 40 then
	--	classes.CustomMeleeGroups:append('MaxHaste')
	--	add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	--end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    -- mythic AM	
    if player.equipment.main == 'Ryunohige' then
        if buffactive['Aftermath: Lv.3'] then
            classes.CustomMeleeGroups:append('AM3')
        end
	end
end
 
function select_default_macro_book()
	-- Default macro set/book
	set_macro_page(1, 10)
end