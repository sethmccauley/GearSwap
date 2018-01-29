-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
-- Haste II has the same buff ID [33], so we have to use a toggle. 
-- Macro for Haste: //gs c toggle hastemode 
-- Toggles whether or not you're getting Haste II
-- for Rune Fencer sub, you need to create two macros. One cycles runes, and gives you descrptive text in the log.
-- The other macro will use the actual rune you cycled to.
-- Macro #1 //gs c cycle Runes
-- Macro #2 //gs c toggle UseRune
function get_sets()
	mote_include_version = 2
	include('Mote-Include.lua')
	include('organizer-lib')
	require('vectors')
end

-- Setup vars that are user-independent.
function job_setup()
	state.Buff.Migawari = buffactive.migawari or false
	state.Buff.Doomed = buffactive.doomed or false
	state.Buff.Sange = buffactive.Sange or false
	state.Buff.Yonin = buffactive.Yonin or false
	state.Buff.Innin = buffactive.Innin or false
	state.Buff.Futae = buffactive.Futae or false

	include('Mote-TreasureHunter')
	state.TreasureMode:set('Tag')
	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
	state.GeoMode = M{['description']='Geo Haste', 'Cornelia', 'Dunna', 'Idris'}
	
	state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
	state.UseRune = M(false, 'Use Rune')

	run_sj = player.sub_job == 'RUN' or false

	select_ammo()
	LugraWSList = S{'Blade: Shun', 'Blade: Ku', 'Blade: Jin', 'Blade: Chi'}
	wsList = S{'Blade: Hi', 'Blade: Metsu'}

	gear.RegularAmmo = 'Seki Shuriken'
	gear.SangeAmmo = 'Happo Shuriken'
	gear.MovementFeet = {name="Danzo Sune-ate"}
	gear.DayFeet = "Danzo Sune-ate"
	gear.NightFeet = "Hachiya Kyahan +3"
	gear.ElementalObi = {name="Hachirin-no-Obi"}
	gear.default.obi_waist = "Eschan Stone"
	
	update_combat_form()

	state.warned = M(false)
	options.ammo_warning_limit = 25
	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	windower.register_event('time change', time_change)	
	-- Options: Override default values
	state.OffenseMode:options ('Normal', 'Acc', 'Acc2', 'Acc3')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.HybridMode:options('Normal', 'Crit', 'Multi')
	state.CastingMode:options('Normal', 'Resistant', 'Burst')
	state.IdleMode:options('Normal')
	
	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds
	send_command('bind ^= gs c cycle treasuremode')
	send_command('bind ^[ input /lockstyle on')
	send_command('bind ![ input /lockstyle off')
	send_command('bind !` gs c cycle HasteMode')
	send_command('bind @` gs c cycle MarchMode')
	send_command('bind @1 gs c cycle HybridMode')
	send_command('bind @[ gs c cycle Runes')
	send_command('bind ^] gs c toggle UseRune')
	send_command('bind ` input /jump')
	
	select_movement_feet()
	select_default_macro_book()
end


function file_unload()
	send_command('unbind ^[')
	send_command('unbind ![')
	send_command('unbind ^=')
	send_command('unbind !=')
	send_command('unbind @f9')
	send_command('unbind @[')
	send_command('unbind `')
end

-- Define sets and vars used by this job file.
-- sets.engaged[state.CombatForm][state.CombatWeapon][state.OffenseMode][state.HybridMode][classes.CustomMeleeGroups] (any number)
-- Ninjutsu tips
-- To stick Slow (Hojo) lower earth resist with Raiton: Ni
-- To stick poison (Dokumori) or Attack down (Aisha) lower water resist with Katon: Ni
-- To stick paralyze (Jubaku) lower ice resistence with Huton: Ni
function init_gear_sets()
	--------------------------------------
	-- Augments
	--------------------------------------
	Andartia = {}
	Andartia.DEX = {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}}
	Andartia.AGI = {name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
	Andartia.STR = {name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	Andartia.INT = {name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10',}}
	Andartia.MEva = {name="Andartia's Mantle", augments={'INT+10','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10',}}
	
	--------------------------------------
	-- Job Abilties
	--------------------------------------
	sets.precast.JA['Mijin Gakure'] = {legs="Mochizuki Hakama +1"}
	sets.precast.JA['Futae'] = {hands="Iga Tekko +2"}
	sets.precast.JA['Sange'] = {ammo="Happo Shuriken",body="Mochizuki Chainmail +1"}
	sets.precast.JA['Provoke'] = {ammo="",
		head="",neck="Unmoving Collar +1",ear1="Trux Earring",ear2="Cryptic Earring",
		body="Emet Harness +1",hands="Kurys Gloves",ring1="Petrov Ring",ring2="Begrudging Ring",
		back="Agema Cape",waist="Chaac Belt",legs="Arjuna Breeches",feet="Mochizuki Kyahan +2"}
	sets.midcast.Flash = set_combine(sets.precast.JA['Provoke'], {ammo="Impatiens",head=gear.HerculeanHeadDT,waist="Hurch'lan Sash"})

	-- Waltz (chr and vit)
	sets.precast.Waltz = {ammo="Yamarang",
		head="Mummu Bonnet +2",neck="Unmoving Collar +1",ear1="Handler's Earring",ear2="Handler's Earring +1",
		body="Hachiya Chainmail +3",hands="Hachiya Tekko +2",ring1="Regal Ring",ring2="Petrov Ring",
		back="Shadow Mantle",waist="Chaac Belt",legs="Hizamaru Hizayoroi +2",feet="Hachiya Kyahan +3"}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
	
    -- Set for acc on steps, since Yonin can drop acc
	sets.precast.Step = {ammo="Yamarang",
		head="Mummu Bonnet +2",neck="Moonbeam Nodowa",ear1="Zennaroi Earring",ear2="Dignitary's Earring",
		body="Hachiya Chainmail +3",hands="Adhemar Wristbands +1",ring1="Cacoethic Ring +1",ring2="Regal Ring",
		back=Andartia.DEX,waist="Olseni Belt",legs="Hachiya Hakama +3",feet="Mummu Gamashes +1"}
		
	sets.precast.Flourish1 = set_combine(sets.precast.Step, {waist="Chaac Belt"})
	
	sets.midcast["Apururu (UC)"] = {body="Apururu Unity shirt"}

	--------------------------------------
	-- Utility Sets for rules below
	--------------------------------------
	sets.TreasureHunter = {head="White Rarab Cap +1", body=gear.HerculeanBodyTH, hands=gear.HerculeanHandsTH, waist="Chaac Belt"}
	sets.WSDayBonus     = {head="Gavialis Helm"}
	sets.BrutalLugra    = {ear1="Cessance Earring", ear2="Lugra Earring +1"}
	sets.BrutalTrux     = {ear1="Cessance Earring", ear2="Trux Earring"}
	sets.BrutalMoon     = {ear1="Brutal Earring", ear2="Moonshade Earring"}
	sets.IshvaraMoon		= {ear1="Ishvara Earring", ear2="Moonshade Earring"}
	sets.LugraMoon			= {ear1="Lugra Earring +1", ear2="Moonshade Earring"}
	sets.DualLugra			= {ear1="Lugra Earring",ear2="Lugra Earring +1"}
	sets.IshvaraCessance= {ear1="Ishvara Earring", ear2="Cessance Earring"}
	
	sets.RegularAmmo    = {ammo=gear.RegularAmmo}
	sets.SangeAmmo      = {ammo=gear.SangeAmmo}

	--------------------------------------
	-- Ranged
	--------------------------------------
	-- Snapshot for ranged
	sets.precast.RA = {ammo="Happo Shuriken",
		head=gear.TaeonChapSnap,
		legs="Adhemar Kecks"}
	
	sets.midcast.RA = {
		head="Mummu Bonnet +2",neck="Iskur Gorget", ear1="Enervating Earring", ear2="Neritic Earring",
		body="Mummu Jacket +2",hands="Hachiya Tekko +2",ring1="Cacoethic Ring +1", ring2="Regal Ring",
		waist="Eschan Stone",legs="Mummu Kecks +2",feet="Mummu Gamashes +1"}
    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {})
    sets.midcast.RA.TH = set_combine(sets.midcast.RA, sets.TreasureHunter)

	----------------------------------
    -- Casting
	----------------------------------
	-- Precasts
	sets.precast.FC = {ammo="Sapience Orb",
		head=gear.HerculeanHelmMAB,neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
		body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Kishar Ring",ring2="Weatherspoon Ring",
		back=Andartia.INT,legs=gear.HerculeanLegsFC,}
	
	sets.precast.FC.ElementalNinjutsuSan = set_combine(sets.precast.FC, {feet="Mochizuki Kyahan +2"})
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {ammo="Impatiens",neck="Magoraga Beads",body="Mochizuki Chainmail +1",back=Andartia.INT,feet="Hattori Kyahan"})
	
	-- Midcasts
	-- FastRecast (A set to end in when no other specific set is built to reduce recast time)
	sets.midcast.FastRecast = {
		head=gear.HerculeanHelmMAB,neck="Orunmila's Torque",ear2="Loquacious Earring",
		body=gear.TaeonBodyFC,hands="Mochizuki Tekko +2",ring1="Kishar Ring",ring2="Weatherspoon Ring",
		back=Andartia.INT,waist="Hurch'lan Sash",legs="Arjuna Breeches",feet=gear.HerculeanBootsTA}

	-- Magic Accuracy Focus 
	sets.midcast.Ninjutsu = {ammo="Yamarang",
		head="Hachiya Hatsuburi +3",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Dignitary's Earring",
		body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Regal Ring",ring2="Weather. Ring",
		back=Andartia.INT,waist="Eschan Stone",legs="Mummu Kecks +2",feet="Hachiya Kyahan +3"}
	
	-- Any ninjutsu cast on self - Recast Time Focus
	sets.midcast.SelfNinjutsu = set_combine(sets.midcast.Ninjutsu, {ammo="Sapience Orb",
		head=gear.HerculeanHelmMAB,neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
		body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Kishar Ring",ring2="Weatherspoon Ring",
		back=Andartia.INT,waist="Hurch'lan Sash",legs="Arjuna Breeches",})
	
	-- FC Needs for capped recasts on Utsusemi assuming capped magical haste
	-- Ichi 52	w/Shigi 	36
	-- Ni 	58						48
	-- San	62						56
	sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu, {ammo="Impatiens",back=Andartia.INT,feet="Hattori Kyahan"})
	
	-- Needs 68 FC for capped recast with capped magical haste.
	sets.midcast.Migawari = set_combine(sets.midcast.SelfNinjutsu, {body=gear.TaeonBodyFC, back=Andartia.INT})

	-- Nuking Ninjutsu (skill & magic attack)
	sets.midcast.ElementalNinjutsu = {ammo="Pemphredo Tathlum",
		head="Hachiya Hatsuburi +3",neck="Sanctity Necklace",ear1="Hecate's Earring",ear2="Friomisi Earring",
		body="Samnuha Coat",hands="Leyline Gloves",ring1="Dingir Ring",ring2="Shiva Ring",
		back=Andartia.INT,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet="Hachiya Kyahan +3",}

	sets.midcast.ElementalNinjutsu.Burst = set_combine(sets.midcast.ElementalNinjutsu, {ring1="Locus Ring",ring2="Mujin Band",})
	
	sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {body="Samnuha Coat"})
	
	sets.midcast.ElementalNinjutsuSan = set_combine(sets.midcast.ElementalNinjutsu, {head="Mochizuki Hatsuburi +1",})
	sets.midcast.ElementalNinjutsuSan.Burst = set_combine(sets.midcast.ElementalNinjutsuSan, {ring1="Locus Ring", ring2="Mujin Band",})
	sets.midcast.ElementalNinjutsuSan.Resistant = set_combine(sets.midcast.ElementalNinjutsu.Resistant, {})

	-- Effusions
	sets.precast.Effusion = {}
	sets.precast.Effusion.Lunge = sets.midcast.ElementalNinjutsu
	sets.precast.Effusion.Swipe = sets.midcast.ElementalNinjutsu

	----------------------------------
	-- Idle Sets
	----------------------------------
	sets.idle = {ammo="Seki Shuriken",
		head="Adhemar Bonnet +1",neck="Sanctity Necklace",ear1="Impregnable Earring",ear2="Etiolation Earring",
		body="Hizamaru Haramaki +2",hands=gear.HerculeanHandsTA,ring1="Defending Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Hachiya Hakama +3",feet=gear.MovementFeet}

	----------------------------------
    -- Defense sets
	----------------------------------
	-- 51% PDT + Nullification(Mantle)
	sets.defense.PDT = {ammo="Staunch Tathlum",
		head=gear.HerculeanHeadDT,neck="Loricate Torque +1",ear1="Impregnable Earring",ear2="Handler's Earring +1",
		body="Emet Harness +1",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Dark Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Mummu Kecks +2",feet="Amm Greaves"}

	-- 37% MDT + Absorb + Nullification
    sets.defense.MDT = {ammo="Staunch Tathlum",
		head=gear.HerculeanHeadDT,neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
		body="Kendatsuba Samue +1",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Shadow Ring",
		back="Engulfer Cape +1",waist="Flume Belt",legs="Mummu Kecks +2",feet="Amm Greaves"}
		
	sets.MEva = {ammo="Staunch Tathlum",
		head="Mummu Bonnet +2",neck="Warder's Charm +1",ear1="Eabani Earring",ear2="Flashward Earring",
		body="Kendatsuba Samue +1",hands="Leyline Gloves",ring1="Vengeful Ring",ring2="Purity Ring",
		back=Andartia.MEva,waist="Flume Belt",legs="Mummu Kecks +2",feet="Mummu Gamashes +1"}
	
	sets.Resist = set_combine(sets.MEva, {ear2="Hearty Earring",})
	sets.Resist.Stun = set_combine(sets.MEva, {back="", body="",})
	
	sets.DayMovement = {feet="Danzo sune-ate"}
	sets.NightMovement = {feet="Hachiya Kyahan +3"}

	----------------------------------
	-- Engaged Sets (No Haste)
	----------------------------------
	-- Variations for TP weapon and (optional) offense/deafense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Acc 1177/1152 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1218/1181 (Heishi/Shigi|Kikoku/Shigi)
	-- DW Total in Gear: 37 DW / 39 DW Needed to Cap Delay Reduction
	sets.engaged = {ammo="Seki Shuriken",
		head="Ryuo Somen",neck="Moonbeam Nodowa",ear1="Suppanomimi",ear2="Dedition Earring",
		body="Adhemar Jacket",hands="Floral Gauntlets",ring1="Petrov Ring",ring2="Epona's Ring",
		back=Andartia.DEX,waist="Reiki Yotai",legs="Samnuha Tights",feet="Hizamaru Sune-Ate +2"}
		
	sets.engaged.Crit = set_combine(sets.engaged, {
		body="Kendatsuba Samue +1",ring1="Mummu Ring",
		legs="Mummu Kecks +2",})

	sets.engaged.Multi = set_combine(sets.engaged, {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Asperity Necklace",ear1="Brutal Earring",ear2="Cessance Earring",
		body="Kendatsuba Samue +1",hands=gear.HerculeanHandsTA,ring1="Epona's Ring",ring2="Hetairoi Ring",
		back=Andartia.DA,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet=gear.HerculeanBootsTA})
		
	-- Acc Tier 1: 1200/1175 (Heishi/Ochu|Kikoku/Ochu) :: Acc 1240/1203 (Heishi/Shigi|Kikoku/Shigi)
	-- DW Total in Gear: 37 DW
	sets.engaged.Acc = set_combine(sets.engaged, {ear2="Dignitary's Earring",ring1="Cacoethic Ring +1",ring2="Cacoethic Ring"})

	-- Acc Tier 2: 1226/1201 (Heishi/Ochu|Kikoku/Ochu) :: Acc 1267/1230 (Heishi/Shigi|Kikoku/Shigi)
	-- DW Total in Gear: 37 DW
	sets.engaged.Acc2 = set_combine(sets.engaged.Acc, {legs="Mummu Kecks +2"})
	
	-- Acc Tier 3: 1275/1250 (Heishi/Ochu|Kikoku/Ochu) :: Acc 1316/1279 (Heishi/Shigi|Kikoku/Shigi)
	-- DW Total in Gear: 37 DW
	sets.engaged.Acc3 = set_combine(sets.engaged.Acc2, {hands="Adhemar Wristbands +1",ring2="Regal Ring",legs="Hachiya Hakama +3"})
	
	sets.engaged.Innin 	   = sets.engaged
	sets.engaged.Innin.Acc = sets.engaged.Acc
	sets.engaged.Innin.Acc2 = sets.engaged.Acc2
	sets.engaged.Innin.Acc3 = sets.engaged.Acc3

	----------------------------------
	-- Defensive Sets
	----------------------------------
	--Flesh These "Hybrid" sets out? I never use Hybrid sets... low priority.
	sets.NormalPDT =  sets.engaged.PDT
	sets.AccPDT =  sets.engaged.PDT
	sets.engaged.PDT 		= sets.defense.PDT
	sets.engaged.Acc.PDT 	= set_combine(sets.engaged.Acc, sets.defense.PDT)
	sets.engaged.Acc2.PDT 	= set_combine(sets.engaged.Acc2, sets.defense.PDT)
	sets.engaged.Acc3.PDT 	= set_combine(sets.engaged.Acc3, sets.defense.PDT)
	sets.engaged.Innin.PDT 	= set_combine(sets.engaged.Innin, sets.defense.PDT)
	sets.engaged.Innin.Acc.PDT = sets.engaged.Acc.PDT
	sets.engaged.Innin.Acc2.PDT = sets.engaged.Acc2.PDT
	sets.engaged.Innin.Acc3.PDT = sets.engaged.Acc3.PDT

	----------------------------------
    -- MaxHaste Sets (0%DW Needed)
	----------------------------------
	-- Acc 1084/1059 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1125/1079 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 0 DW / 1 DW Needed to Cap Delay Reduction
	sets.engaged.MaxHaste = {ammo="Seki Shuriken",
		head="Adhemar Bonnet +1",neck="Moonbeam Nodowa",ear1="Dedition Earring",ear2="Telos Earring",
		body="Kendatsuba Samue +1",hands="Adhemar Wristbands +1",ring1="Petrov Ring",ring2="Epona's Ring",
		back=Andartia.DEX,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	
	sets.engaged.Crit.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		head="Mummu Bonnet +2",
		hands="Mummu Wrists +2",ring1="Mummu Ring",
		legs="Mummu Kecks +2",feet="Mummu Gamashes +1",})
	
	sets.engaged.Multi.MaxHaste = sets.engaged.Multi
		
	-- Acc 1105/1080 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1146/1100 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 0 DW
	sets.engaged.Acc.MaxHaste = set_combine(sets.engaged.MaxHaste, {ammo="Seki Shuriken", neck="Moonbeam Nodowa",ear1="Dignitary's Earring",})
	
	-- Acc 1151/1126 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1192/1146 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 5 DW / 1 DW Needed to Cap Delay Reduction
	sets.engaged.Acc2.MaxHaste = set_combine(sets.engaged.Acc.MaxHaste, {head="Mummu Bonnet +2",ear1="Zennaroi Earring",ring1="Patricius Ring",body="Adhemar Jacket",})
	
	-- Acc 1211/1188 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1252/1208 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 5 DW / 1 DW Needed to Cap Delay Reduction
	sets.engaged.Acc3.MaxHaste = set_combine(sets.engaged.Acc2.MaxHaste, {neck="Moonbeam Nodowa",hands="Ryuo Tekko",ring2="Ramuh Ring +1",waist="Olseni Belt",legs="Hizamaru Hizayoroi +2"})
	
	sets.engaged.Innin.MaxHaste     = sets.engaged.MaxHaste
	sets.engaged.Innin.Acc.MaxHaste = sets.engaged.Acc.MaxHaste
	sets.engaged.Innin.Acc2.MaxHaste = sets.engaged.Acc2.MaxHaste
	sets.engaged.Innin.Acc3.MaxHaste = sets.engaged.Acc3.MaxHaste

	-- Defensive sets
	sets.engaged.PDT.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.engaged.HastePDT)
	sets.engaged.Acc.PDT.MaxHaste 	= set_combine(sets.engaged.Acc.MaxHaste, sets.engaged.HastePDT)
	sets.engaged.Acc2.PDT.MaxHaste 	= set_combine(sets.engaged.Acc2.MaxHaste, sets.engaged.HastePDT)
	sets.engaged.Acc3.PDT.MaxHaste 	= set_combine(sets.engaged.Acc3.MaxHaste, sets.AccPDT)
	sets.engaged.Innin.PDT.MaxHaste = set_combine(sets.engaged.Innin.MaxHaste, sets.NormalPDT)
	sets.engaged.Innin.Acc.PDT.MaxHaste = sets.engaged.Acc.PDT.MaxHaste
	sets.engaged.Innin.Acc2.PDT.MaxHaste = sets.engaged.Acc2.PDT.MaxHaste
	sets.engaged.Innin.Acc3.PDT.MaxHaste = sets.engaged.Acc3.PDT.MaxHaste

	----------------------------------
    -- 35% Haste (~10-12%DW Needed)
	----------------------------------
	-- Acc 1095/1070 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1136/1099 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_35 = set_combine(sets.engaged.MaxHaste, {waist="Reiki Yotai",ear1="Suppanomimi",})
	
	sets.engaged.Crit.Haste_35 = set_combine(sets.engaged, {
		body="Kendatsuba Samue +1",ring1="Mummu Ring",
		legs="Mummu Kecks +2",})
	
	sets.engaged.Multi.Haste_35 = sets.engaged.Multi

	-- Acc 1127/1102 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1168/1122 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Acc.Haste_35 = set_combine(sets.engaged.Acc.MaxHaste, {body="Adhemar Jacket",waist="Reiki Yotai",ear1="Brutal Earring",})
	
	-- Acc 1159/1134 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1200/1154 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Acc2.Haste_35 = set_combine(sets.engaged.Acc2.MaxHaste, {waist="Reiki Yotai"})
	
	-- Acc 1217/1192 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1258/1212 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 20 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Acc3.Haste_35 = set_combine(sets.engaged.Acc3.MaxHaste, {head="Ryuo Somen",waist="Olseni Belt"})

	sets.engaged.Innin.Haste_35 	= sets.engaged.Haste_35
	sets.engaged.Innin.Acc.Haste_35 = sets.engaged.Acc.Haste_35
	sets.engaged.Innin.Acc2.Haste_35 = sets.engaged.Acc2.Haste_35
	sets.engaged.Innin.Acc3.Haste_35 = sets.engaged.Acc3.Haste_35

	sets.engaged.PDT.Haste_35 = set_combine(sets.engaged.Haste_35, sets.engaged.HastePDT)
	sets.engaged.Acc.PDT.Haste_35 = set_combine(sets.engaged.Acc.Haste_35, sets.engaged.HastePDT)
	sets.engaged.Acc2.PDT.Haste_35 = set_combine(sets.engaged.Acc2.Haste_35, sets.engaged.HastePDT)
	sets.engaged.Acc3.PDT.Haste_35 = set_combine(sets.engaged.Acc3.Haste_35, sets.engaged.AccPDT)

	sets.engaged.Innin.PDT.Haste_35 = set_combine(sets.engaged.Innin.Haste_35, sets.engaged.HastePDT)
	sets.engaged.Innin.Acc.PDT.Haste_35 = sets.engaged.Acc.PDT.Haste_35
	sets.engaged.Innin.Acc2.PDT.Haste_35 = sets.engaged.Acc2.PDT.Haste_35
	sets.engaged.Innin.Acc3.PDT.Haste_35 = sets.engaged.Acc3.PDT.Haste_35

	----------------------------------
    -- 30% Haste (~21-22%DW Needed)
	----------------------------------
	-- Acc  (Heishi/Ochu|Kikoku/Ochu)) :: Acc  (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 20 DW / 21 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_30 = {ammo="Seki Shuriken",
		head="Ryuo Somen",neck="Moonbeam Nodowa",ear1="Brutal Earring",ear2="Cessance Earring",
		body="Adhemar Jacket",hands="Adhemar Wristbands +1",ring1="Petrov Ring",ring2="Epona's Ring",
		back=Andartia.DEX,waist="Reiki Yotai",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	
	sets.engaged.Crit.Haste_30 = set_combine(sets.engaged, {
		body="Kendatsuba Samue +1",ring1="Mummu Ring",
		legs="Mummu Kecks +2",})

	sets.engaged.Multi.Haste_35 = sets.engaged.Multi

	sets.engaged.Acc.Haste_30 = set_combine(sets.engaged.Haste_30, {neck="Moonbeam Nodowa",ring1="Patricius Ring"})

	sets.engaged.Acc2.Haste_30 = set_combine(sets.engaged.Acc.Haste_30, {hands="Ryuo Tekko",ear1="Zennaroi Earring",ring2="Ramuh Ring"})
	
	sets.engaged.Acc3.Haste_30 = set_combine(sets.engaged.Acc2.Haste_30, {waist="Olseni Belt",legs="Hizamaru Hizayoroi +2",feet="Hizamaru Sune-Ate +2",})

	sets.engaged.Innin.Haste_30 = sets.engaged.Haste_30
	sets.engaged.Innin.Acc.Haste_30 = sets.engaged.Acc.Haste_30
	sets.engaged.Innin.Acc2.Haste_30 = sets.engaged.Acc2.Haste_30
	sets.engaged.Innin.Acc3.Haste_30 = sets.engaged.Acc3.Haste_30

	sets.engaged.PDT.Haste_30 = set_combine(sets.engaged.Haste_30, sets.engaged.HastePDT)
	sets.engaged.Acc.PDT.Haste_30 = set_combine(sets.engaged.Acc.Haste_30, sets.engaged.HastePDT)
	sets.engaged.Acc2.PDT.Haste_30 = set_combine(sets.engaged.Acc2.Haste_30, sets.engaged.HastePDT)
	sets.engaged.Acc3.PDT.Haste_30 = set_combine(sets.engaged.Acc3.Haste_30, sets.engaged.AccPDT)

	sets.engaged.Innin.PDT.Haste_30 = set_combine(sets.engaged.Innin.Haste_30, sets.engaged.HastePDT)
	sets.engaged.Innin.Acc.PDT.Haste_30 = sets.engaged.Acc.PDT.Haste_30
	sets.engaged.Innin.Acc2.PDT.Haste_30 = sets.engaged.Acc2.PDT.Haste_30
	sets.engaged.Innin.Acc3.PDT.Haste_30 = sets.engaged.Acc3.PDT.Haste_30

	----------------------------------
	-- 15% Haste (~32%DW Needed)
	----------------------------------
	-- Acc 1145/1120 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1186/1140 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_15 = {ammo="Seki Shuriken",
		head="Ryuo Somen",neck="Moonbeam Nodowa",ear1="Suppanomimi",ear2="Cessance Earring",
		body="Adhemar Jacket",hands="Adhemar Wristbands +1",ring1="Petrov Ring",ring2="Epona's Ring",
		back=Andartia.DEX,waist="Reiki Yotai",legs="Samnuha Tights",feet="Hizamaru Sune-Ate +2"}

	sets.engaged.Crit.Haste_15 = set_combine(sets.engaged, {
		body="Kendatsuba Samue +1",ring1="Mummu Ring",
		legs="Mummu Kecks +2",})
		
	sets.engaged.Multi.Haste_15 = sets.engaged.Multi

	-- Acc Tier 1: 1166/1141 (Heishi/Ochu|Kikoku/Ochu) :: Acc 1207/1161 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Acc.Haste_15 = set_combine(sets.engaged.Haste_15, {neck="Moonbeam Nodowa",ear2="Zennaroi Earring"})

	-- Acc Tier 2: 1183/1158 (Heishi/Ochu|Kikoku/Ochu) :: Acc 1224/1178 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Acc2.Haste_15 = set_combine(sets.engaged.Acc.Haste_15, {ring1="Patricius Ring",legs="Hizamaru Hizayoroi +2"})
	
	-- Acc Tier 3: 1223/1198 (Heishi/Ochu|Kikoku/Ochu) :: Acc 1264/1218 (Heishi/Shigi|Kikoku/Shigi) :: Acc ??? (Heishi/Kanaria)
	-- DW Total in Gear: 20 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Acc3.Haste_15 = set_combine(sets.engaged.Acc2.Haste_15, {
		ear1="Cessance Earring",
		hands="Ryuo Tekko",ring2="Ramuh Ring",
		waist="Olseni Belt"})
    
	sets.engaged.Innin.Haste_15 = sets.engaged.Haste_15
	sets.engaged.Innin.Acc.Haste_15 = sets.engaged.Acc.Haste_15
	sets.engaged.Innin.Acc2.Haste_15 = sets.engaged.Acc2.Haste_15
	sets.engaged.Innin.Acc3.Haste_15 = sets.engaged.Acc3.Haste_15
    
	sets.engaged.PDT.Haste_15 = set_combine(sets.engaged.Haste_15, sets.engaged.HastePDT)
	sets.engaged.Acc.PDT.Haste_15 = set_combine(sets.engaged.Acc.Haste_15, sets.engaged.HastePDT)
	sets.engaged.Acc2.PDT.Haste_15 = set_combine(sets.engaged.Acc2.Haste_15, sets.engaged.HastePDT)
	sets.engaged.Acc3.PDT.Haste_15 = set_combine(sets.engaged.Acc3.Haste_15, sets.engaged.AccPDT)
    
	sets.engaged.Innin.PDT.Haste_15 = set_combine(sets.engaged.Innin.Haste_15, sets.engaged.HastePDT)
	sets.engaged.Innin.Acc.PDT.Haste_15 = sets.engaged.Acc.PDT.Haste_15
	sets.engaged.Innin.Acc2.PDT.Haste_15 = sets.engaged.Acc2.PDT.Haste_15
	sets.engaged.Innin.Acc3.PDT.Haste_15 = sets.engaged.Acc3.PDT.Haste_15
 
	----------------------------------
	-- Weaponskills (General)
	----------------------------------
	sets.precast.WS = {ammo="Seething Bomblet +1",
		head="Hachiya Hatsuburi +3",neck="Caro Necklace",ear1="Brutal Earring",ear2="Cessance Earring",
		body=gear.HerculeanVestAcc,hands="Ryuo Tekko",ring1="Petrov Ring",ring2="Epona's Ring",
		back=Andartia.STR,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
    
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {ammo="Yetshila",
		head="Hachiya Hatsuburi +3",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Kendatsuba Samue +1",hands="Ryuo Tekko",ring1="Ilabrat Ring",ring2="Begrudging Ring",
		back=Andartia.STR,waist="Windbuffet Belt +1",legs="Kendatsuba Hakama",feet=gear.HerculeanBootsTA})
	sets.precast.WS['Blade: Hi'].Acc = set_combine(sets.precast.WS['Blade: Hi'], {waist="Fotia Belt"})

	sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {ammo="Seething Bomblet +1",
		head="Hachiya Hatsuburi +3",neck="Caro Necklace",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands=gear.HerculeanHandsWS,ring1="Regal Ring",ring2="Ilabrat Ring",
		back=Andartia.STR,waist="Grunfeld Rope",legs="Hizamaru Hizayoroi +2",feet=gear.HerculeanFeetWS})
	sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS['Blade: Shun'], {})
	sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS, {ammo="Jukukik Feather",ring1="Regal Ring",back="Andartia's Mantle"})
	
	sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS['Blade: Ten'], {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.precast.WS['Blade: Kamu'].Acc = set_combine(sets.precast.WS['Blade: Kamu'], {waist="Fotia Belt"})

	sets.precast.WS['Blade: Metsu'] = set_combine(sets.precast.WS['Blade: Ten'], {ammo="Jukukik Feather",
		neck="Fotia Necklace",ear1="Ishvara Earring",ear2="Brutal Earring",
		body=gear.HerculeanBodyWS,hands=gear.HerculeanHandsWS,ring1="Regal Ring",ring2="Ilabrat Ring",
		back=Andartia.DEX,waist="Fotia Belt",legs="Jokushu Haidate",feet=gear.HerculeanFeetWS})
	sets.precast.WS['Blade: Metsu'].Acc = set_combine(sets.precast.WS['Blade: Metsu'], {waist="Fotia Belt"})
	
	sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {ammo="Jukukik Feather",
		head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Moonshade Earring", ear2="Cessance Earring",
		body="Kendatsuba Samue +1",hands="Adhemar Wristbands +1",ring1="Regal Ring",ring2="Ilabrat Ring",
		back=Andartia.DEX,waist="Fotia Belt", legs="Samnuha Tights", feet=gear.HerculeanBootsTA})
	
	sets.precast.WS['Blade: Yu'] = {ammo="Pemphredo Tathlum",
    head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
    body="Samnuha Coat",hands="Leyline Gloves",ring1="Dingir Ring",ring2="Shiva Ring",
	back=Andartia.INT,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet=gear.HerculeanBootsMAB,}
	
	sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Yu']
	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Yu']
	sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS, {
		neck="Fotia Gorget",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands="Adhemar Wristbands +1",ring1="Regal Ring",ring2="Hetairoi Ring",
		waist="Fotia Belt",legs="Hiza. Hizayoroi +2",feet=gear.HerculeanFeetWS})
	
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Blade: Yu']
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS['Blade: Hi'], {head="Mummu Bonnet +2",
		body="Kendatsuba Samue +1",
		back=Andartia.DEX,})
	
	sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS['Blade: Ten'], {})
	sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS['Blade: Yu'],{})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
	if state.Buff[spell.english] ~= nil then
		state.Buff[spell.english] = true
	end
	if (spell.type:endswith('Magic') or spell.type == "Ninjutsu") and buffactive.silence then
		cancel_spell()
		send_command('input /item "Echo Drops" <me>')
	end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "Utsusemi" then
		if spell.english == "Migawari" then
			classes.CustomClass = "Migawari"
		else
			classes.CustomClass = "SelfNinjutsu"
		end
	end
	if spell.name == 'Spectral Jig' and buffactive.sneak then
		send_command('cancel 71')
	end
	if string.find(spell.english, 'Utsusemi') then
		if buffactive['Copy Image (4)'] then
			cancel_spell()
			eventArgs.cancel = true
			return
		end
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Ranged Attacks 
	if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'Acc' then
		equip( sets.SangeAmmo )
	end
	-- protection for lag
	if spell.name == 'Sange' and player.equipment.ammo == gear.RegularAmmo then
		state.Buff.Sange = false
		eventArgs.cancel = true
	end
	if spell.type == 'WeaponSkill' then
		if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
			equip(sets.TreasureHunter)
		end
		-- Gavialis Helm rule
		--if is_sc_element_today(spell) then
			--if state.OffenseMode.current == 'Normal' and wsList:contains(spell.english) then
				-- do nothing
			--else
				-- equip(sets.WSDayBonus)
			--end
		--end
		-- Swap in special ammo for WS in high Acc mode
		if state.OffenseMode.value == 'Acc' then
			equip(select_ws_ammo())
		end
		-- Lugra Earring for some WS
		if LugraWSList:contains(spell.english) then
			if world.time >= (17*60) or world.time <= (7*60) then
				equip(sets.LugraMoon)
			else
				equip(sets.BrutalMoon)
			end
		elseif spell.english == 'Blade: Hi' then
			if world.time >= (17*60) or world.time <= (7*60) then
				equip(sets.IshvaraMoon)
			else
				equip(sets.IshvaraMoon)
			end
		elseif spell.english == 'Blade: Ten' then
			if world.time >= (17*60) or world.time <= (7*60) then
				equip(sets.LugraMoon)
			else
				equip(sets.IshvaraMoon)
			end
		elseif spell.english == 'Blade: Metsu' then
			if world.time >= (17*60) or world.time <= (7*60) then
				equip(sets.DualLugra)
			else
				equip(sets.IshvaraCessance)
			end
		end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.english == "Monomi: Ichi" then
		if buffactive['Sneak'] then
			send_command('@wait 1;cancel 71')
		end
	end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	--if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
	--    equip(sets.TreasureHunter)
	--end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if midaction() then
		return
	end
	-- Aftermath timer creation
	aw_custom_aftermath_timers_aftercast(spell)
	--if spell.type == 'WeaponSkill' then
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
	local lockables = T{'Mecisto. Mantle', 'Aptitude Mantle', 'Nexus Cape', 'Aptitude Mantle +1', 'Warp Ring', 'Vocation Ring', 'Reraise Earring', 'Capacity Ring', 'Trizek Ring', 'Echad Ring', 'Facility Ring', 'Dim. Ring (Holla)', 'Dim. Ring (Dem)', 'Dim. Ring (Mea)'}
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
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.HybridMode.value == 'PDT' then
		if state.Buff.Migawari then
			idleSet = set_combine(idleSet, sets.buff.Migawari)
		else 
			idleSet = set_combine(idleSet, sets.defense.PDT)
		end
	else
		idleSet = idleSet
	end
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end
	if state.Buff.Migawari and state.HybridMode.value == 'PDT' then
		meleeSet = set_combine(meleeSet, sets.buff.Migawari)
	end
	if player.equipment.sub == 'empty' then
		meleeSet = set_combine(meleeSet, sets.NoDW)
	end
	meleeSet = set_combine(meleeSet, select_ammo())
	return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
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

	if (buff == 'Innin' and gain or buffactive['Innin']) then
		state.CombatForm:set('Innin')
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	else
		state.CombatForm:reset()
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

function job_status_change(newStatus, oldStatus, eventArgs)
	if newStatus == 'Engaged' then
		update_combat_form()
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	select_ammo()
	select_movement_feet()
	determine_haste_group()
	update_combat_form()
	run_sj = player.sub_job == 'RUN' or false
	th_update(cmdParams, eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Facing ratio
-------------------------------------------------------------------------------------------------------------------
function facing_away(spell)
	if spell.target.type == 'MONSTER' then
		local dir = V{spell.target.x, spell.target.y} - V{player.x, player.y}
		local heading = V{}.from_radian(player.facing)
		local angle = V{}.angle(dir, heading):degree():abs()
		if angle > 90 then
			add_to_chat(8, 'Aborting... angle > 90')
			return true
		else
			return false
		end
	end
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
		then 
			return true
    end
end

function select_movement_feet()
	if world.time >= (17*60) or world.time < (7*60) then
		gear.MovementFeet.name = gear.NightFeet
	else
		gear.MovementFeet.name = gear.DayFeet
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
	-- Geo Haste 20/35/40 (assunes dunna and idris have 900 skill)
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
	elseif h >= 30 and h < 35 then 
		classes.CustomMeleeGroups:append('Haste_30')
		add_to_chat('Haste Group: 30% -- From Haste Total: '..h)
	elseif h >= 35 and h < 40 then 
		classes.CustomMeleeGroups:append('Haste_35')
		add_to_chat('Haste Group: 35% -- From Haste Total: '..h)
	elseif h >= 40 then
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Runes' then
		local msg = ''
		if newValue == 'Ignis' then
			msg = msg .. 'Increasing resistence against ICE and deals FIRE damage.'
		elseif newValue == 'Gelus' then
			msg = msg .. 'Increasing resistence against WIND and deals ICE damage.'
		elseif newValue == 'Flabra' then
			msg = msg .. 'Increasing resistence against EARTH and deals WIND damage.'
		elseif newValue == 'Tellus' then
			msg = msg .. 'Increasing resistence against LIGHTNING and deals EARTH damage.'
		elseif newValue == 'Sulpor' then
			msg = msg .. 'Increasing resistence against WATER and deals LIGHTNING damage.'
		elseif newValue == 'Unda' then
			msg = msg .. 'Increasing resistence against FIRE and deals WATER damage.'
		elseif newValue == 'Lux' then
			msg = msg .. 'Increasing resistence against DARK and deals LIGHT damage.'
		elseif newValue == 'Tenebrae' then
			msg = msg .. 'Increasing resistence against LIGHT and deals DARK damage.'
		end
		add_to_chat(123, msg)
	elseif stateField == 'Use Rune' then
			send_command('@input /ja '..state.Runes.value..' <me>')
	end
end

-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
	if spell.type == 'Trust' then
		return 'Trust'
	end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = ''
	msg = msg .. 'Offense: '..state.OffenseMode.current

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

-- Call from job_precast() to setup aftermath information for custom timers.
function aw_custom_aftermath_timers_precast(spell)
	if spell.type == 'WeaponSkill' then
		info.aftermath = {}

		local empy_ws = "Blade: Hi"

		info.aftermath.weaponskill = empy_ws
		info.aftermath.duration = 0

		info.aftermath.level = math.floor(player.tp / 1000)
		if info.aftermath.level == 0 then
			info.aftermath.level = 1
		end

		if spell.english == empy_ws and player.equipment.main == 'Kannagi' then
			-- nothing can overwrite lvl 3
			if buffactive['Aftermath: Lv.3'] then
				return
			end
			-- only lvl 3 can overwrite lvl 2
			if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
				return
			end

			-- duration is based on aftermath level
			info.aftermath.duration = 30 * info.aftermath.level
		end
	end
end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
	-- prevent gear being locked when it's currently impossible to cast 
	if not spell.interrupted and spell.type == 'WeaponSkill' and
		info.aftermath and info.aftermath.weaponskill == spell.english and info.aftermath.duration > 0 then

		local aftermath_name = 'Aftermath: Lv.'..tostring(info.aftermath.level)
		send_command('timers d "Aftermath: Lv.1"')
		send_command('timers d "Aftermath: Lv.2"')
		send_command('timers d "Aftermath: Lv.3"')
		send_command('timers c "'..aftermath_name..'" '..tostring(info.aftermath.duration)..' down abilities/aftermath'..tostring(info.aftermath.level)..'.png')

		info.aftermath = {}
	end
end

function select_ammo()
	if state.Buff.Sange then
		return sets.SangeAmmo
	else
		return sets.RegularAmmo
	end
end

function update_combat_form()
	if state.Buff.Innin then
		state.CombatForm:set('Innin')
	else
		state.CombatForm:reset()
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(4, 1)
	elseif player.sub_job == 'THF' then
		set_macro_page(4, 1)
	else
		set_macro_page(4, 1)
	end
end
