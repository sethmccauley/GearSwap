-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime
--]]

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
	include('organizer-lib')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Trick Attack'] = buffactive['trick attack'] or false
	state.Buff['Feint'] = buffactive['feint'] or false
	
	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
	state.GeoMode = M{['description']='Geo Haste', 'Cornelia', 'Dunna', 'Idris'}
	
	include('Mote-TreasureHunter')

	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Acc2')
	state.HybridMode:options('Normal', 'Multi')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.PhysicalDefenseMode:options('PDT')
	state.IdleMode:options('Normal', 'Regen', 'PDT')

	-- Additional local binds
	send_command('bind ^` input /ja "Flee" <me>')
	send_command('bind ^= gs c cycle GeoMode')
	send_command('bind !- gs c cycle TreasureMode')
	send_command('bind !` gs c cycle HasteMode')
	send_command('bind @` gs c cycle MarchMode')

	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------
	Toutatis = {}
	Toutatis.DA = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','DEX+10'}}
	Toutatis.WSD = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%','DEX+10'}}
	
	sets.TreasureHunter = {
		hands="Plunderer's Armlets +1", 
		feet="Skulker's Poulaines +1"}
		
	sets.ExtraRegen = {neck="Sanctity Necklace",ring2="Paguroidea ring"}
	sets.Kiting = {}

	sets.buff['Sneak Attack'] = {ammo="Yetshila",
		head="Mummu Bonnet +1",neck="Caro Necklace",ear1="Telos Earring",ear2="Sherida Earring",
		body="Meghanada Cuirie +2",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Regal Ring",
		back="Toutatis's Cape",waist="Chiner's Belt +1",legs="Samnuha Tights",feet="Mummu Gamashes +1"}

	sets.buff['Trick Attack'] = {ammo="Yetshila",
		head="Pursuer's Beret",neck="Combatant's Torque",ear1="Assuage Earring",ear2="Cessance Earring",
		body="Pillager's Vest +1",hands="Adhemar Wristbands",ring1="Epona's Ring",ring2="Rajas Ring",
		waist="Chiner's Belt +1",}

	-- Actions we want to use to tag TH.
	sets.precast.Step = sets.TreasureHunter
	sets.precast.Flourish1 = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter

--------------------------------------
-- Precast sets
--------------------------------------

-- Precast sets to enhance JAs
	sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +1"}
	sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
	sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +1"}
	sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
	sets.precast.JA['Conspirator'] = {body="Raider's Vest +2"}
	sets.precast.JA['Steal'] = {feet="Pillager's Poulaines +1"}
	sets.precast.JA['Despoil'] = {feet="Skulker's Poulaines +1"}
	sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
	sets.precast.JA['Feint'] = {legs="Plunderer's Culottes"}
	sets.precast.JA['Mug'] = {ammo="Expeditious Pinion",head="Pursuer's Beret",neck="Magoraga bead necklace",ear2="Suppanomimi",
		body="Adhemar Jacket +1",hands="Pursuer's cuffs",ring1="Apate Ring",ring2="Ramuh Ring +1 +1",
		back="Toutatis's Cape",waist="Chaac Belt",legs="Pursuer's Pants",feet="Pursuer's Gaiters"}
	sets.precast.JA['Lunge'] = {ammo="Seething Bomblet +1",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Hecate's Earring",ear2="Friomisi Earring",
		body="Samnuha Coat",hands="Leyline Gloves",ring1="",ring2="",
		back="Toro Cape",waist="Eschan Stone",legs=gear.HerculeanLegsMAB,feet=gear.HerculeanBootsMAB} 
	sets.precast.JA['Swipe'] = {sets.precast.JA['Lunge']} 
	
	sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
		body="Emet harness +1",hands="Plunderer's Armlets +1",waist="Chaac belt",legs="Gyve Trousers",feet=DWBoots}

	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {feet="Rawhide boots"}

	-- Fast cast sets for spells
	sets.precast.FC = {ammo="Impatiens",
        head=gear.HerculeanHelmMAB,neck="Orunmila's Torque",ear1="",ear2="Loquacious Earring",
        body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Defending Ring",
        waist="Flume Belt",legs=""}
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {ammo="Jukukik Feather",
		head=gear.HerculeanHeadWS,neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands=gear.HerculeanHandsWS,ring1="Ilabrat Ring",ring2="Regal Ring",
		back=Toutatis.WSD,waist="Fotia Belt",legs="Samnuha Tights",feet="Lustr. Leggings +1"}
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo=""})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Exenterator'] = {ammo="Yamarang",
		head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Brutal Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Regal Ring",
		back=Toutatis.DA,waist="Fotia Belt",legs="Meghanada Chausses +2",feet=gear.HerculeanBootsTA}
	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})

	sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {})
	sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {ammo="Jukukik Feather"})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo="Yetshila",
		head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Sherida Earring",
		body="Meghanada Cuirie +2",hands="Mummu Wrists +2",ring1="Mummu Ring",ring2="Regal Ring",
		back=Toutatis.DA,waist="Fotia Belt",legs="Lustr. Subligar +1",feet=gear.HerculeanBootsTA})
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})

	sets.precast.WS['Rudra\'s Storm'] = {ammo="Jukukik Feather",
		head="Pill. Bonnet +3",neck="Caro Necklace",ear1="Sherida Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands="Meghanada Gloves +2",ring1="Ilabrat Ring",ring2="Regal Ring",
		back=Toutatis.WSD,waist="Grunfeld Rope",legs="Lustr. Subligar +1",feet="Lustra. Leggings +1"}
	sets.precast.WS['Rudra\'s Storm'].Mod = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila",
			body="Meghanada Cuirie +2"})
	sets.precast.WS['Rudra\'s Storm'].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {})
	sets.precast.WS['Rudra\'s Storm'].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {})
	sets.precast.WS['Rudra\'s Storm'].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {})

	sets.precast.WS['Shark Bite'] = {ammo="Jukukik Feather",
		head="Pillager's Bonnet +3",neck="Caro Necklace",ear1="Sherida Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands="Meghanada Gloves +2",ring1="Ilabrat Ring",ring2="Regal Ring",
		back=Toutatis.WSD,waist="Grunfeld Rope",legs="Lustr. Subligar +1",feet="Lustra. Leggings +1"}
	sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'], {ammo="Yetshila",
		body="Meghanada Cuirie +2"})
	sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {})
	sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {})
	sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {})

	sets.precast.WS['Mandalic Stab'] = {ammo="Jukukik Feather",
		head="Pillager's Bonnet +3",neck="Caro Necklace",ear1="Sherida Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands="Meghanada Gloves +2",ring1="Ilabrat Ring",ring2="Regal Ring",
		back=Toutatis.WSD,waist="Grunfeld Rope",legs="Lustr. Subligar +1",feet="Lustra. Leggings +1"}
	sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Yetshila",
		body="Meghanada Cuirie +2"})
	sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {})
	sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {})
	sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {})

	sets.precast.WS['Aeolian Edge'] = {ammo="Pemphredo Tathlum",
    head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
    body="Samnuha Coat",hands="Leyline Gloves",ring1="Dingir Ring",ring2="Regal Ring",
		back=Toutatis.WSD,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet=gear.HerculeanBootsMAB,}

--------------------------------------
-- Midcast sets
--------------------------------------
	sets.midcast.FastRecast = {ammo="Sapience Orb",
		head=gear.HerculeanHelmMAB,neck="Orunmila's Torque",ear1="Etiolation Earring",ear2="Loquacious Earring",
		body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Defending Ring",
		legs=gear.HerculeanLegsFC}

	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.FastRecast

	sets.midcast['Enhancing Magic'] = {neck="Incanter's Torque",ear1="Andoaa Earring",waist="Olympus Sash"}

--------------------------------------
-- Idle/defense sets
--------------------------------------
-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = {ammo="Staunch Tathlum",
		head=gear.HerculeanHeadDT,neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Genmei Earring",
		body="Emet Harness +1",hands="Umuthi Gloves",ring1="Dark Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs="Mummu Kecks +2",feet=gear.HerculeanBootsDT}
	
-- Defense sets
	sets.defense.PDT = {ammo="Staunch Tathlum",
		head=gear.HerculeanBootsDT,neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
		body="Emet harness +1",hands="Umuthi Gloves",ring1="Dark Ring",ring2="Defending Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Mummu Kecks +2",feet=gear.HerculeanBootsDT}

	sets.defense.MDT = {ammo="Staunch Tathlum",
		head=gear.HerculeanBootsDT,neck="Warder's Charm +1",ear1="Flashward Earring",ear2="Etiolation Earring",
		body="Mummu Jacket +2",hands="Floral Gauntlets",ring1="Shadow Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Engraved Belt",legs="Mummu Kecks +2",feet=gear.HerculeanBootsDT}
	
	sets.MEva = {ammo="Staunch Tathlum",
		head=gear.HerculeanHeadDT,neck="Warder's Charm +1",ear1="Eabani Earring",ear2="Flashward Earring",
		body="Herculean Vest",hands="Leyline Gloves",ring1="Defending Ring",ring2="Shadow Ring",
		back="Solemnity Cape",waist="Flume Belt",legs="Gyve Trousers",feet=gear.HerculeanBootsDT}

--------------------------------------
-- Melee sets  
--------------------------------------
-- Normal melee group (No Haste) (~44 DW to cap)
	sets.engaged = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Eabani Earring",ear2="Suppanomimi",
		body="Adhemar Jacket +1",hands="Floral Gauntlets",ring1="Epona's Ring",ring2="Hetairoi Ring",
		back=Toutatis.DA,waist="Reiki Yotai",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
		
	sets.engaged.Multi = set_combine(sets.engaged, {})
	
	sets.engaged.Acc = set_combine(sets.engaged, {ammo="Honed Tathlum",
		neck="Ej Necklace",ear1="Cessance Earring",
		hands="Adhemar Wristbands",})
    
	sets.engaged.Acc2 = set_combine(sets.engaged.Acc, {
		head="Dampening Tam",ear2="Zennaroi Earring",
		body="Adhemar Jacket +1",ring1="Cacoethic Ring +1",ring2="Ramuh Ring +1",
		waist="Olseni Belt",legs="Meghanada Chausses +1",feet="Meghanada Jambeaux +1"})
    
----------------------------------
-- MaxHaste Sets (~6%DW Needed)
----------------------------------
	sets.engaged.MaxHaste = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Sherida Earring",ear2="Dedition Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Epona's Ring",ring2="Hetairoi Ring",
		back=Toutatis.DA,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}

	sets.engaged.Multi.MaxHaste = set_combine(sets.engaged.MaxHaste, {ammo="Focal Orb",
		neck="Asperity Necklace",ear2="Brutal Earring",
		hands=gear.HerculeanHandsTA,legs="Meghanada Chausses +2"})

	sets.engaged.Acc.MaxHaste = set_combine(sets.engaged.MaxHaste, {ammo="Honed Tathlum",
		neck="Ej Necklace",
		hands="Adhemar Wristbands",})
	
	sets.engaged.Acc2.MaxHaste = set_combine(sets.engaged.Acc.MaxHaste, {
		head="Dampening Tam",ear2="Zennaroi Earring",
		body="Adhemar Jacket +1",ring1="Cacoethic Ring +1",ring2="Ramuh Ring +1",
		waist="Olseni Belt",legs="Meghanada Chausses +1",feet="Meghanada Jambeaux +1"})
	
----------------------------------
-- 30% Haste (~26DW Needed)
----------------------------------
	sets.engaged.Haste_30 = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Eabani Earring",ear2="Suppanomimi",
		body="Adhemar Jacket +1",hands="Floral Gauntlets",ring1="Epona's Ring",ring2="Hetairoi Ring",
		back=Toutatis.DA,waist="Reiki Yotai",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
		
	sets.engaged.Multi.Haste_30 = set_combine(sets.engaged.Haste_30, {})
	
	sets.engaged.Acc.Haste_30 = set_combine(sets.engaged.Haste_30, {ammo="Honed Tathlum",
		neck="Ej Necklace",
		hands="Adhemar Wristbands",})
	
	sets.engaged.Acc2.Haste_30 = set_combine(sets.engaged.Acc.Haste_30, {
		head="Dampening Tam",ear2="Zennaroi Earring",
		body="Adhemar Jacket +1",ring1="Cacoethic Ring +1",ring2="Ramuh Ring +1",
		waist="Olseni Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +1"})
	
----------------------------------
-- 15% Haste (~37DW Needed)
----------------------------------
	sets.engaged.Haste_15 = {ammo="Focal Orb",
		head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Eabani Earring",ear2="Suppanomimi",
		body="Adhemar Jacket +1",hands="Floral Gauntlets",ring1="Epona's Ring",ring2="Hetairoi Ring",
		back=Toutatis.DA,waist="Reiki Yotai",legs="Meghanada Chausses +2",feet=gear.HerculeanBootsTA}

	sets.engaged.Multi.Haste_15 = set_combine(sets.engaged.Haste_15, {})
	
	sets.engaged.Acc.Haste_15 = set_combine(sets.engaged.Haste_15, {ammo="Honed Tathlum",
		neck="Ej Necklace",
		hands="Adhemar Wristbands",})
	
	sets.engaged.Acc2.Haste_15 = set_combine(sets.engaged.Acc.Haste_15, {
		head="Dampening Tam",ear2="Zennaroi Earring",
		body="Adhemar Jacket +1",ring1="Cacoethic Ring +1",ring2="Ramuh Ring +1",
		waist="Olseni Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +1"})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
	
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)   	
	local lockables = T{'Mecisto. Mantle', 'Aptitude Mantle', 'Nexus Cape', 'Aptitude Mantle +1', 'Warp Ring', 
		'Vocation Ring', 'Reraise Earring', 'Capacity Ring', 'Trizek Ring', 'Echad Ring', 'Facility Ring', 
		'Dim. Ring (Holla)', 'Dim. Ring (Dem)', 'Dim. Ring (Mea)'}
	local watch_slots = T{'lear','rear','ring1','ring2','back','head'}

	for _,v in pairs(watch_slots) do
		if lockables:contains(player.equipment[v]) then
			disable(v)
			if has_charges(player.equipment[v]) and (not is_enchant_ready(player.equipment[v])) then
				enable(v)
			end
		else
			enable(v)
		end
	end
	-- Check that ranged slot is locked, if necessary
	check_range_lock()

	-- Check for SATA when equipping gear.  If either is active, equip
	-- that gear specifically, and block equipping default gear.
	check_buff('Sneak Attack', eventArgs)
	check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	th_update(cmdParams, eventArgs)
	determine_haste_group()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
	
	if state.HasteMode.value ~= 'Normal' then
        msg = msg .. ', Haste: '..state.HasteMode.current
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(4, 5)
    elseif player.sub_job == 'WAR' then
        set_macro_page(4, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 5)
    else
        set_macro_page(4, 5)
    end
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
	-- Geo Haste 20/35/40
	if buffactive[580] then
		if state.GeoMode.value == 'Cornelia' then
			h = h + 20
		elseif state.HasteMode.value == 'Dunna' then
			h = h + 35.4
		elseif state.GeoMode.value == 'Idris' then
			h = h + 40
		end
	end
	-- Mighty Guard 15
	if buffactive[604] then
		h = h + 15
	end
	-- Embrava 15
	if buffactive.embrava then
		h = h + 21
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
	if h >= 15 and h < 30 then 
		classes.CustomMeleeGroups:append('Haste_15')
		add_to_chat('Haste Group: 15% -- From Haste Total: '..h)
	elseif h >= 30 and h < 40 then 
		classes.CustomMeleeGroups:append('Haste_30')
		add_to_chat('Haste Group: 30% -- From Haste Total: '..h)
	elseif h >= 40 then
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	end
end

