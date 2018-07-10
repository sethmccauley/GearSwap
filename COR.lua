-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
--[[
    gs c toggle luzaf -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    Acc on offense mode (which is intended for melee) will currently use .Acc weaponskill
    mode for both melee and ranged weaponskills.  Need to fix that in core.
--]]

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.QDMode = M(false, 'STP')
	state.FlurryMode = M{['description']='Flurry Mode', 'Flurry I', 'Flurry II'}
	
	-- Whether to use Luzaf's Ring
	state.LuzafRing = M(false, "Luzaf's Ring")
	-- Whether a warning has been given for low ammo
	state.warned = M(false)

	define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Ranged', 'Melee', 'Acc', 'Mage')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Mod')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'PDT', 'Mage')

	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
	state.GeoMode = M{['description']='Geo Haste', 'Dunna', 'Idris'}
	include('Mote-TreasureHunter')
	state.TreasureMode:set('Tag')
	
	gear.RAbullet = "Chrono Bullet"
	gear.WSbullet = "Chrono Bullet"
	gear.MAbullet = "Orichalcum Bullet"
	gear.QDbullet = "Animikii Bullet"
	options.ammo_warning_limit = 15

	gear.ElementalObi = {name="Hachirin-no-Obi"}
	gear.default.obi_waist = "Eschan Stone"
	
	-- Additional local binds
	send_command('bind !` gs c cycle LuzafRing')
	send_command('bind @` gs c cycle QDMode')
	send_command('bind ^` gs c cycle FlurryMode')
	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- Capacity Set
	sets.CapacityMantle = {back="Mecistopins Mantle"}
	
	Camulus = {}
	Camulus.MAtk = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%','AGI+10'}}
	Camulus.RAcc = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}}
	Camulus.Snap = {name="Camulus's Mantle", augments={'"Snapshot"+10',}}
	Camulus.DW = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Occ. inc. resist. to stat. ailments+10'}}
	Camulus.STR = {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%','STR+10'}}
	
	-- Precast Sets

	-- Precast sets to enhance JAs
	sets.TreasureHunter = { head="White Rarab Cap +1", body=gear.HerculeanBodyTH, hands="Volte Bracers", waist="Chaac Belt" }
	sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
	sets.precast.JA['Snake Eye'] = {legs="Lanun Culottes"}
	sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
	sets.precast.JA['Random Deal'] = {body="Lanun Frac +1"}

	-- Enmity - and Roll Potency/Duration +
	sets.precast.CorsairRoll = {
		head="Lanun Tricorne +1",neck="Regal Necklace",ear1="Enervating Earring",ear2="Domesticator's Earring",
		body="Adhemar Jacket +1",hands="Chasseur's Gants +1",ring1="Persis Ring",ring2="Lebeche Ring",
		back="Camulus's Mantle",waist="Reiki Yotai",legs="Desultor Tassets",feet="Pursuer's Gaiters"}
	
	sets.precast.JA['Double-Up'] = set_combine(sets.precast.CorsairRoll, {head="Lanun Tricorne +1",neck="Regal Necklace",hands="Chasseur's Gants +1"})
    
	sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Navarch's Culottes +2"})
	sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chasseur's Bottes +1"})
	sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chasseur's Tricorne"})
	sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
	sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
	sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
	sets.precast.Barataria = {ring1="Barataria Ring"}
	
	sets.precast.CorsairShot = {ammo=gear.QDbullet,
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Lanun Frac +3",hands="Carmine Finger Gauntlets +1",ring1="Weatherspoon Ring",ring2="Dingir Ring",
		back=Camulus.MAtk,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet="Lanun Bottes +3"}

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
		head=gear.HerculeanHelmMAB,neck="Orunmila's Torque",ear1="Loquacious Earring",
		body="Dread Jupon",hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Prolix Ring",
		waist="Hurch'lan Sash",legs="Blood Cuisses",feet="Lanun Bottes +3"}
        
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	sets.precast.FC = {
		head="Carmine Mask +1",neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
		body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Prolix Ring",
		waist="Hurch'lan Sash",legs=gear.HerculeanLegsFC,feet="Carmine Greaves +1"}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

	sets.precast.RA = {ammo=gear.RAbullet,
		head=gear.TaeonChapSnap,
		body="Pursuer's Doublet",hands="Carmine Finger Gauntlets +1",
		back=Camulus.Snap,waist="Impulse Belt",legs="Adhemar Kecks",feet="Meghanada Jambeaux +2"}

	sets.precast.RA.Flurry = set_combine(sets.precast.RA, {
		head="Chass. Tricorne +1", 
		body="Laksa. Frac +3"})
	
	sets.precast.RA.FlurryII = set_combine(sets.precast.RA.Flurry, {
		legs="Pursuer's Pants"})
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {ammo=gear.WSbullet,
		head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Dingir Ring",ring2="Regal Ring",
		back=Camulus.MAtk,waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"}
	sets.precast.WS.Moonshade = {ear2="Moonshade Earring"}

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {head="Mummu Bonnet +2",neck="Caro Necklace",ear1="Brutal Earring",ear2="Moonshade Earring",
		body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Mummu Ring",ring2="Regal Ring",
		back=Camulus.DA,waist="Grunfeld Rope",legs="Mummu Kecks +2",feet="Mummu Gamashes +2"})

	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {legs="Nahtirah Trousers"})
	sets.precast.WS['Savage Blade'] = {ammo=gear.WSbullet,
		head=gear.HerculeanHeadWS,neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Shukuyu Ring",ring2="Regal Ring",
		back=Camulus.STR,waist="Metalsinger Belt",legs="Meghanada Chausses +2",feet="Lanun Bottes +3"}
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {})

	sets.precast.WS['Last Stand'] = {ammo=gear.WSbullet,
		head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Dingir Ring",ring2="Regal Ring",
		back=Camulus.MAtk,waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Lanun Bottes +3"}
	sets.precast.WS['Last Stand'].Acc = {ammo=gear.WSbullet,
		head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Telos Earring",ear2="Enervating Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
		back=Camulus.RAtk,waist="Kwahu Kachina Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"}
	sets.precast.WS['Split Shot'] = set_combine(sets.precast.WS['Last Stand'], {})
	
	sets.precast.WS['Detonator'] = {ammo=gear.WSbullet,
		head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Dingir Ring",ring2="Regal Ring",
		back=Camulus.MAtk,waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Lanun Bottes +3"}
	sets.precast.WS['Detonator'].Acc = {ammo=gear.WSbullet,
		head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Dingir Ring",ring2="Regal Ring",
		back=Camulus.MAtk,waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Lanun Bottes +3"}

	sets.precast.WS['Wildfire'] = {ammo=gear.MAbullet,
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Lanun Frac +3",hands="Carmine Fin. Ga. +1",ring1="Dingir Ring",ring2="Regal Ring",
		back=Camulus.MAtk,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet="Lanun Bottes +3"}
	sets.precast.WS['Wildfire'].Brew = {ammo=gear.MAbullet,
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Lanun Frac +3",hands="Carmine Fin. Ga. +1",ring1="Dingir Ring",ring2="Regal Ring",
		back=Camulus.MAtk,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet="Lanun Bottes +3"}
	
	sets.precast.WS['Leaden Salute'] = set_combine(sets.precast.WS['Wildfire'], {
		head="Pixie Hairpin +1",ear2="Moonshade Earring",
		body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",ring1="Dingir Ring",ring2="Archon Ring", waist=gear.ElementalObi})
    
  sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {})
	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Leaden Salute'], {})
	sets.precast.WS['Hot Shot'] = set_combine(sets.precast.WS['Wildfire'], {})
	
	-- Midcast Sets
	sets.midcast.FastRecast = {
		head="Whirlpool Mask", neck="Orunmila's Torque",
		body="Dread Jupon",hands="Leyline Gloves",
		waist="Hurch'lan Sash",legs="Samnuha Tights",feet="Lanun Bottes +3"}
        
	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.FastRecast
	
	sets.midcast.Cure = set_combine(sets.midcast.FastRecast, {neck="Phalaina Locket",ring1="Leviathan Ring",ring2="Sirona's Ring",})

	sets.midcast.CorsairShot = {ammo=gear.QDbullet,
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Samnuha Coat",hands="Carmine Finger Gauntlets +1",ring1="Weatherspoon Ring",ring2="Dingir Ring",
		back=Camulus.MAtk,waist=gear.ElementalObi,legs=gear.HerculeanLegsMAB,feet="Lanun Bottes +3"}
		
	sets.midcast.CorsairShot.STP = {ammo=gear.QDbullet,
		head="Pursuer's Beret",neck="Iskur Gorget",ear1="Telos Earring",ear2="Dedition Earring",
		body="Mummu Jacket +2",hands="Mrigavyadha Gloves",ring1="K'ayres Ring",ring2="Ilabrat Ring",
		back=Camulus.RAcc,waist="Reiki Yotai",legs="Navarch's Culottes +2",feet="Carmine Greaves +1"}

	sets.midcast.CorsairShot.Acc = {ammo=gear.QDbullet,
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Lanun Frac +1",hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Sangoma Ring",
		back="Navarch's Mantle",waist="Eschan Stone",legs=gear.HerculeanLegsMAB,feet="Chasseur's Bottes +1"}

	sets.midcast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
		head="Oshosi Mask",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Dignitary's Earring",
		body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Weatherspoon Ring",ring2="Sangoma Ring",
		back=Camulus.MAtk,waist="Eschan Stone",legs="Mummu Kecks +2",feet="Mummu Gamashes +2"}

	sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']

	-- Ranged gear
	sets.midcast.RA = {ammo=gear.RAbullet,
		head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
		body="Laksa. Frac +3",hands="Lanun Gants +3",ring1="Regal Ring",ring2="Ilabrat Ring",
		back=Camulus.RAcc,waist="Yemaya Belt",legs="Adhemar Kecks",feet="Meghanada Jambeaux +2"}
		
	sets.midcast.RA.Triple = set_combine(sets.midcast.RA, {
		head="Oshosi Mask",
		body="Chasseur's Frac +1",hands="Lanun Gants +3",ring1="Cacoethic Ring",
		legs="Oshosi Trousers",})
		
	sets.midcast.RA.Acc = {ammo=gear.RAbullet,
		head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
		body="Laksa. Frac +3",hands="Meghanada Gloves +2",ring1="Regal Ring",ring2="Cacoethic Ring +1",
		back=Camulus.RAcc,waist="Kwahu Kachina Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"}

    
    -- Sets to return to when not performing an action.
    
	-- Resting sets
	sets.resting = {neck="Sanctity Necklace",ring1="Sheltered Ring",ring2="Paguroidea Ring"}
	

	-- Idle sets
	sets.idle = {main="",ammo=gear.RAbullet,
		head="Lanun Tricorne +1",neck="Sanctity Necklace",ear1="Genmei Earring",ear2="Etiolation Earring",
		body="Mekosuchinae Harness",hands=gear.HerculeanHandsRefresh,ring1="Defending Ring",ring2="Roller's Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs=gear.HerculeanLegsRefresh,feet=gear.HerculeanBootsDT}
	
	sets.idle.Regen = {
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",hands="Meghanada Gloves +2",
		legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2",}
		
	sets.idle.Mage = {main="",ammo=gear.RAbullet,
		head="Lanun Tricorne +1",neck="Sanctity Necklace",ear1="Genmei Earring",ear2="Etiolation Earring",
		body="Mekosuchinae Harness",hands=gear.HerculeanHandsRefresh,ring1="Defending Ring",ring2="Paguroidea Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs=gear.HerculeanLegsRefresh,feet=gear.HerculeanBootsDT}
		
	sets.idle.Town = {main="",ammo=gear.RAbullet,
		head="Lanun Tricorne +1",neck="Sanctity Necklace",ear1="Genmei Earring",ear2="Etiolation Earring",
		body="Mekosuchinae Harness",hands=gear.HerculeanHandsRefresh,ring1="Defending Ring",ring2="Roller's Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs="Carmine Cuisses +1",feet=gear.HerculeanBootsDT}
    
	-- Defense sets
	sets.defense.PDT = {
		head=gear.HerculeanHeadDT,neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
		body="Emet Harness +1",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Dark Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Mummu Kecks +2",feet=gear.HerculeanBootsDT}

	sets.defense.MDT = {
		head="Oshosi Mask",neck="Loricate Torque +1",ear1="Flashward Earring",ear2="Eabani Earring",
		body="Laksamana's Frac +3",hands="Kurys Gloves",ring1="Defending Ring",ring2="Shadow Ring",
		back="Engulfer Cape +1",waist="Flume Belt",legs="Oshosi Trousers",feet="Lanun Bottes +3"}
		
    sets.MEva = {ammo="",
		head="Adhemar Bonnet",neck="Warder's Charm +1",ear1="Eabani Earring",ear2="Flashward Earring",
		body="Mummu Jacket +2",hands="Leyline Gloves",ring1="Defending Ring",ring2="Purity Ring",
		back="Solemnity Cape",waist="Flume Belt",legs="Mummu Kecks +2",feet="Carmine Greaves +1"
	}
	
	sets.Resist = {ammo="",
		head="Adhemar Bonnet",neck="Warder's Charm +1",ear1="Eabani Earring",ear2="Flashward Earring",
		body="Adhemar Jacket +1",hands="Leyline Gloves",ring1="Defending Ring",ring2="Purity Ring",
		back="Solemnity Cape",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Carmine Greaves +1"
	}
	
	sets.Kiting = {legs="Blood Cuisses"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
	-- Normal melee group
	sets.engaged.Melee = {ammo=gear.RAbullet,
		head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Telos Earring",ear2="Suppanomimi",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Hetairoi Ring",ring2="Epona's Ring",
		back=Camulus.DW,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	sets.engaged.Melee.Haste_30 = set_combine(sets.engaged.Melee, {})
	sets.engaged.Melee.MaxHaste = set_combine(sets.engaged.Melee.Haste_30, {})
	
	sets.engaged.Acc = {ammo=gear.RAbullet,
		head="Mummu Bonnet +2",neck="Ej Necklace",ear1="Telos Earring",ear2="Cessance Earring",
		body="Mummu Jacket +2",hands="Adhemar Wristbands +1",ring1="Cacoethic Ring +1",ring2="Cacoethic Ring",
		back=Camulus.DW,waist="Olseni Belt",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	sets.engaged.Acc.Haste_30 = set_combine(sets.engaged.Acc, {})
	sets.engaged.Acc.MaxHaste = set_combine(sets.engaged.Acc.Haste_30, {})
	
	sets.engaged.DW = {}
	-- Melee Acc 1121/1121 base --
	sets.engaged.DW.Melee = {ammo=gear.RAbullet,
		head="Adhemar Bonnet +1",neck="Ainia Collar",ear1="Telos Earring",ear2="Suppanomimi",
		body="Adhemar Jacket +1",hands="Floral Gauntlets",ring1="Hetairoi Ring",ring2="Epona's Ring",
		back=Camulus.DW,waist="Reiki Yotai",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	-- 25% DW in Traits Needs ~31 DW in gear --
	sets.engaged.DW.Melee.Haste_30 = set_combine(sets.engaged.DW.Melee, {})
	-- 25% DW in Traits Needs 11 DW in gear --
	sets.engaged.DW.Melee.MaxHaste = set_combine(sets.engaged.DW.Melee.Haste_30, {
		ear2="Cessance Earring",
		body="Mummu Jacket +2",hands="Adhemar Wristbands +1",ring1="Mummu Ring",
		waist="Windbuffet Belt +1"})
	
	-- Melee Acc 1264/1264 base --
	sets.engaged.DW.Acc = {ammo=gear.RAbullet,
		head="Mummu Bonnet +2",neck="Ej Necklace",ear1="Telos Earring",ear2="Cessance Earring",
		body="Mummu Jacket +2",hands="Adhemar Wristbands +1",ring1="Cacoethic Ring +1",ring2="Mummu Ring",
		back=Camulus.DW,waist="Olseni Belt",legs="Mummu Kecks +2",feet="Mummu Gamashes +2"}
	sets.engaged.DW.Acc.Haste_30 = set_combine(sets.engaged.DW.Acc, {})
	sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc.Haste_30, {})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end
    -- gear sets
    if spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' or spell.type == 'Magic' then
		if moonshade_WS:contains(spell.english) and (player.tp < 2749) then 
			equip(sets.precast.WS.Moonshade)
		end
    end
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
	end
	if spell.action_type == 'Ranged Attack' then
		if buffactive['flurry'] then
			if state.FlurryMode.value == "Flurry I" then
				equip(sets.precast.RA.Flurry)
			else
				equip(sets.precast.RA.FlurryII)
			end
		end
	end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.type == 'CorsairShot' and state.QDMode.value then
		equip(sets.midcast.CorsairShot.STP)
	end
	if spell.action_type == 'Ranged Attack' and buffactive['Triple Shot'] then
		equip(sets.midcast.RA.Triple)
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if player.sub_job == "NIN" then
		idleSet = set_combine(sets.idle, sets.idle.Regen)
	end
	return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    return meleeSet
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	update_combat_form()
	determine_haste_group()
end

function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
		state.Buff[buff] = gain
	end
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
end

function update_melee_groups()

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
		add_to_chat('Haste Group: 15%-30% -- From Haste Total: '..h)
	elseif h >= 30 and h < 40 then 
		classes.CustomMeleeGroups:append('Haste_30')
		add_to_chat('Haste Group: 30%-40% -- From Haste Total: '..h)
	elseif h >= 40 then
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	end
end

function update_combat_form()
	-- Check for single-wielding
	if player.equipment.sub == "Nusku Shield" then
		state.CombatForm:reset()
	else
		state.CombatForm:set('DW')
	end
end

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

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = ''
    
	msg = msg .. 'Off.: '..state.OffenseMode.current
	msg = msg .. ', Rng.: '..state.RangedMode.current
	msg = msg .. ', WS.: '..state.WeaponskillMode.current
	msg = msg .. ', QD.: '..state.CastingMode.current
	msg = msg .. ', QD. STP: '..state.QDMode.current

	if state.DefenseMode.value ~= 'None' then
			local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
			msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
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

    --msg = msg .. ', Roll Size: ' .. (state.LuzafRing.value and 'Large') or 'Small'
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
	rolls = {
		["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
		["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
		["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
		["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
		["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
		["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
		["Puppet Roll"]      = {lucky=3, unlucky=7, bonus="Pet Magic Accuracy/Attack"},
		["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
		["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
		["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
		["Runeist's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Evasion"},
		["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
		["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
		["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
		["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
		["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
		["Drachen Roll"]     = {lucky=4, unlucky=8, bonus="Pet Accuracy"},
		["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
		["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
		["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
		["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
		["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
		["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
		["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
		["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
		["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
		["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
		["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
		["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
		["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
		["Naturalist's Roll"]= {lucky=3, unlucky=7, bonus="Buff Duration"},
	}
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end

function determine_preshot()

end

-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(2, 6)
end
