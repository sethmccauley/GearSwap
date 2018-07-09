-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['Aftermath'] = buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or	buffactive['Aftermath: Lv.3']	or false
	state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
	state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
	state.Buff.Convergence = buffactive.Convergence or false
	state.Buff.Diffusion = buffactive.Diffusion or false
	state.Buff.Efflux = buffactive.Efflux or false
	state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
	
	include('Mote-TreasureHunter')
	state.TreasureMode:set('Tag')
	
	state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
	state.GeoMode = M{['description']='Geo Haste', 'Cornelia', 'Dunna', 'Idris'}
	
	gear.ElementalObi = {name="Hachirin-no-Obi"}
	
	--------------------------------------
	-- Augments
	--------------------------------------
	Rosmerta = {}
	Rosmerta.DEX = {name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl. Atk."+10','DEX+10',}}
	Rosmerta.STR = {name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%','STR+10'}}
	Rosmerta.INT = {name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10',}}
	Rosmerta.MEva = {name="Rosmerta's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10',}}

	-- All Augmented gear used in sets below   
	gear.RunCuisses = { name='Carmine Cuisses'}

	blue_magic_maps = {}
	-- Mappings for gear sets to use for various blue magic spells.
	-- While Str isn't listed for each, it's generally assumed as being at least
	-- moderately signficant, even for spells with other mods.
    
	-- Physical Spells --
	-- Physical spells with no particular (or known) stat mods
	blue_magic_maps.Physical = S{
		'Bilgestorm'
	}

	-- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
	blue_magic_maps.PhysicalAcc = S{
		'Heavy Strike',
	}

	-- Physical spells with Str stat mod
	blue_magic_maps.PhysicalStr = S{
		'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
		'Empty Thrash','Quadrastrike','Spinal Cleave',
		'Uppercut','Vertical Cleave'
	}

	-- Physical spells with Dex stat mod
	blue_magic_maps.PhysicalDex = S{
		'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone','Disseverment',
		'Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
		'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault',
		'Vanity Dive'
	}

	-- Physical spells with Vit stat mod
	blue_magic_maps.PhysicalVit = S{
		'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
		'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'
	}

	-- Physical spells with Agi stat mod
	blue_magic_maps.PhysicalAgi = S{
		'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
		'Pinecone Bomb','Spiral Spin','Wild Oats'
	}

	-- Physical spells with Int stat mod
	blue_magic_maps.PhysicalInt = S{
		'Mandibular Bite','Queasyshroom'
	}

	-- Physical spells with Mnd stat mod
	blue_magic_maps.PhysicalMnd = S{
		'Ram Charge','Screwdriver','Tourbillion'
	}

	-- Physical spells with Chr stat mod
	blue_magic_maps.PhysicalChr = S{
		'Bludgeon'
	}

	-- Physical spells with HP stat mod
	blue_magic_maps.PhysicalHP = S{
		'Final Sting'
	}

	-- Magical Spells --
	-- Magical spells with the typical Int mod
	blue_magic_maps.Magical = S{
		'Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere','Dark Orb','Death Ray',
		'Droning Whirlwind','Embalming Earth','Firespit','Foul Waters','Ice Break',
		'Leafstorm','Maelstrom','Regurgitation','Rending Deluge','Retinal Glare',
		'Subduction','Tem. Upheaval','Water Bomb','Tenebral Crush','Entomb','Spectral Floe',
		'Blinding Fulgor'
	}

	-- Magical spells with a primary Mnd mod
	blue_magic_maps.MagicalMnd = S{
		'Acrid Stream','Evryone. Grudge','Magic Hammer','Mind Blast','Scouring Spate'
	}

	-- Magical spells with a primary Chr mod
	blue_magic_maps.MagicalChr = S{
		'Eyes On Me','Mysterious Light'
	}

	-- Magical spells with a primary AGI mod
	blue_magic_maps.MagicalAgi = S{
		'Silent Storm','Palling Salvo'
	}

	-- Magical spells with a primary STR mod
	blue_magic_maps.MagicalStr = S{
		'Searing Tempest'
	}

	-- Magical spells with a Vit stat mod (on top of Int)
	blue_magic_maps.MagicalVit = S{
		'Thermal Pulse','Entomb'
	}

	-- Magical spells with a Dex stat mod (on top of Int)
	blue_magic_maps.MagicalDex = S{
		'Charged Whisker','Gates of Hades','Anvil Lightning'
	}

	-- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
	-- Add Int for damage where available, though.
	blue_magic_maps.MagicAccuracy = S{
		'1000 Needles','Absolute Terror','Actinic Burst','Auroral Drape','Awful Eye',
		'Blank Gaze','Blistering Roar','Blood Drain','Blood Saber','Chaotic Eye',
		'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest',
		'Dream Flower','Enervation','Feather Tickle','Filamented Hold','Frightful Roar',
		'Geist Wall','Hecatomb Wave','Infrasonics','Jettatura','Light of Penance',
		'Lowing','Mind Blast','Mortal Ray','MP Drainkiss','Osmosis','Reaving Wind',
		'Sandspin','Sandspray','Sheep Song','Spectral Floe','Soporific','Sound Blast','Stinking Gas',
		'Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'
	}

	-- Breath-based spells
	blue_magic_maps.Breath = S{
		'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath',
		'Hecatomb Wave','Magnetite Cloud','Poison Breath','Radiant Breath','Self-Destruct',
		'Thunder Breath','Vapor Spray','Wind Breath'
	}

	-- Stun spells
	blue_magic_maps.Stun = S{
		'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
		'Thunderbolt','Whirl of Rage'
	}

	-- Healing spells
	blue_magic_maps.Healing = S{
		'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','White Wind',
		'Wild Carrot'
	}
    
	-- Buffs that depend on blue magic skill
	blue_magic_maps.SkillBasedBuff = S{
		'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
		'Pyric Bulwark','Reactor Cool',
	}

	-- Other general buffs
	blue_magic_maps.Buff = S{
		'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
		'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
		'Memento Mori','Nat. Meditation','Occultation','Orcish Counterstance','Refueling',
		'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
		'Zephyr Mantle','Mighty Guard'
	}

	-- Spells that require Unbridled Learning to cast.
	unbridled_spells = S{
		'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve',
		'Droning Whirlwind','Gates of Hades','Harden Shell','Pyric Bulwark','Thunderbolt',
		'Tourbillion','Mighty Guard'
	}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal','Acc', 'Acc2')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'PDT')

	-- Additional local binds
	send_command('bind ^` gs c cycle GeoMode')
	send_command('bind !` gs c cycle HasteMode')
	send_command('bind @` gs c cycle MarchMode')
	
	update_combat_form()
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end

-- Set up gear sets.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	sets.TreasureHunter = { head="White Rarab Cap +1", body=gear.HerculeanBodyTH, hands="Volte Bracers", waist="Chaac Belt" }
	sets.buff['Burst Affinity'] = {feet="Hashishin Basmak"}
	sets.buff['Chain Affinity'] = {head="Hashishin Kavuk",feet="Assimilator's Charuqs +1"}
	sets.buff.Convergence = {head="Luhlaza Keffiyeh"}
	sets.buff.Diffusion = {feet="Luhlaza Charuqs"}
	sets.buff.Enchainment = {body="Luhlaza Jubbah +1"}
	sets.buff.Efflux = {legs="Hashishin Tayt +1"}

	-- Precast Sets 
	-- Precast JAs
	sets.precast.JA['Azure Lore'] = {hands="Mirage Bazubands +2"}
	sets.precast.JA['Box Step']	= set_combine(sets.engaged.Acc, {})
	sets.precast.JA['Stutter Step']	= set_combine(sets.engaged.Acc, {})
	sets.precast.JA['Violent Flourish'] = set_combine(sets.engaged.Acc, {})
	sets.precast.JA['Diffusion'] = sets.buff.Diffusion

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
        
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells (80% FC)
	sets.precast.FC = {ammo="Impatiens",
		head="Carmine Mask +1",neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
		body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Kishar Ring",
		back=Rosmerta.INT,waist="Witful Belt",legs="Pinga Pants",feet="Carmine Greaves +1"}

	sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})

	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {ammo="Falcon Eye",
		head="Dampening Tam",neck="Fotia Gorget",ear1="Telos Earring",ear2="Cessance Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Fotia Belt",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}

	sets.precast.WS.acc = set_combine(sets.precast.WS, {})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ammo="Honed Tathlum",
		head="Dampening Tam",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
		body="Jhakri Robe +2",hands="Adhemar Wristbands +1",ring1="Leviathan Ring",ring2="Epona's Ring",
		waist="Fotia Belt",legs="Jhakri Slops +2",feet=gear.HerculeanBootsAcc})
		
	sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS, {})
		
	sets.precast.WS['Circle Blade'] = set_combine(sets.precast.WS, {ammo="Honed Tathlum",
		head=gear.HerculeanHeadWS,neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands="Jhakri Cuffs +2",ring1="Shukuyu Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Fotia Belt",legs="Samnuha Tights",feet=gear.HerculeanFeetWS})
		
	sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS, {ear1="Moonshade Earring",ear2="Brutal Earring",waist="Fotia Belt"})
	
	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {ammo="Jukukik Feather",
		head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
		body=gear.HerculeanVestAcc,hands="Adhemar Wristbands +1",ring1="Begrudging Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Fotia Belt",legs="Samnuha Tights",feet=gear.HerculeanBootsTA})
		
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {ammo="Honed Tathlum",
		head=gear.HerculeanHeadWS,neck="Caro Necklace",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body="Assimilator's Jubbah +3",hands="Jhakri Cuffs +2",ring1="Shukuyu Ring",ring2="Epona's Ring",
		back=Rosmerta.STR,waist="Metalsinger Belt",legs="Samnuha Tights",feet=gear.HerculeanFeetWS})
		
	sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS, {ammo="Falcon Eye",
		head=gear.HerculeanHeadWS,neck="Caro Necklace",ear1="Ishvara Earring",ear2="Moonshade Earring",
		body=gear.HerculeanBodyWS,hands="Jhakri Cuffs +2",ring1="Apate Ring",ring2="Epona's Ring",
		back=Rosmerta.STR,waist="Wanion Belt",legs="Samnuha Tights",feet=gear.HerculeanFeetWS})	

	sets.precast.WS['Sanguine Blade'] = {ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Shiva Ring +1",ring2="Archon Ring",
		back="Cornflower Cape",waist="Eschan Stone",legs="Amalric Slops +1",feet="Amalric Nails +1"}
		
	sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {head=gear.HerculeanHelmMAB,ring2="Shiva Ring"}) 

	-- Midcast Sets
	sets.midcast.FastRecast = {ammo="Sapience Orb",
		head="Carmine Mask +1",neck="Orunmila's Torque",ear1="Loquacious Earring",ear2="Etiolation Earring",
		body=gear.TaeonBodyFC,hands="Leyline Gloves",ring1="Weatherspoon Ring",ring2="Kishar Ring",
		back=Rosmerta.INT,waist="Witful Belt",legs="Pinga Pants",feet="Carmine Greaves +1"}

	sets.midcast['Blue Magic'] = {}

	-- Physical Spells --
	sets.midcast['Blue Magic'].Physical = {ammo="Honed Tathlum",
		head="Aya. Zucchetto +2",neck="Ej Necklace",ear1="Dignitary's Earring",ear2="Zennaroi Earring",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Cacoethic Ring +1",ring2="Ilabrat Ring",
		back=Rosmerta.DEX,waist="Eschan Stone",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}
	sets.midcast['Blue Magic'].PhysicalAcc = {ammo="Honed Tathlum",
		head="Aya. Zucchetto +2",neck="Ej Necklace",ear1="Dignitary's Earring",ear2="Zennaroi Earring",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Cacoethic Ring +1",ring2="Ilabrat Ring",
		back=Rosmerta.DEX,waist="Eschan Stone",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}

	-- Can further define stat mods for physical spells, I just don't care to --
	sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
		{})
	sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical)

	-- Magical Spells --
	sets.midcast['Blue Magic'].Magical = {ammo="Pemphredo Tathlum",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Shiva Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}

	sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical,
		{body="Jhakri Robe +2",ring1="Weatherspoon Ring",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	
	-- Can further define specifically modded magical spells by stat, I don't care to --
	sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,
		{ring1="Leviathan Ring"})
	sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)
	sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical)
	sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical)
	sets.midcast['Blue Magic'].MagicalStr = set_combine(sets.midcast['Blue Magic'].Magical)
	sets.midcast['Blue Magic'].MagicalAgi = set_combine(sets.midcast['Blue Magic'].Magical)

	sets.midcast['Blue Magic'].MagicAccuracy = {ammo="Pemphredo Tathlum",
		head="Ayanmo Zucchetto +2",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Dignitary's Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Weatherspoon Ring",ring2="Sangoma Ring",
		back=Rosmerta.INT,waist="Eschan Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"}
		
	-- Breath Spells --
	sets.midcast['Blue Magic'].Breath = {}

	-- Other Types --
	sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,{})
	
	-- Affected by Total HP and Cure Potency+
	sets.midcast['Blue Magic']['White Wind'] = {ammo="Falcon Eye",
		head="Aya. Zucchetto +1",neck="Sanctity Necklace",ear1="Etiolation Earring",ear2="Mendicant's Earring",
		body="Assimilator's Jubbah +3",hands="Telchine Gloves",ring1="K'ayres Ring",ring2="Ilabrat Ring",
		back="Moonbeam Cape",waist="Eschan Stone",legs="Pinga Pants",feet="Medium's Sabots"}
		
	sets.midcast['Blue Magic']['Mighty Guard'] = set_combine(sets.midcast.FastRecast, {feet="Luhlaza Charuqs"})

	sets.midcast['Blue Magic']['Subduction'] = {ammo="Pemphredo Tathlum",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Shiva Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}

	sets.midcast['Blue Magic']['Searing Tempest'] = {ammo="Pemphredo Tathlum",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Shiva Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}

	sets.midcast['Blue Magic']['Spectral Floe'] = {ammo="Pemphredo Tathlum",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Shiva Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}
		
	sets.midcast['Blue Magic']['Absolute Terror'] = {ammo="Pemphredo Tathlum",
		head="Ayanmo Zucchetto +2",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Dignitary's Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Weatherspoon Ring",ring2="Sangoma Ring",
		back=Rosmerta.INT,waist="Eschan Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"}

	sets.midcast['Blue Magic']['Entomb'] = {ammo="Pemphredo Tathlum",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Shiva Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}

	sets.midcast['Blue Magic']['Tenebral Crush'] = {ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Archon Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}

	sets.midcast['Blue Magic']['Palling Salvo'] = sets.midcast['Blue Magic']['Tenebral Crush']
	
	sets.midcast['Blue Magic']['Magic Hammer'] = {ammo="Pemphredo Tathlum",
		head=gear.HerculeanHelmMAB,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Regal Earring",
		body="Jhakri Robe +2",hands="Amalric Gages +1",ring1="Weatherspoon Ring",ring2="Shiva Ring +1",
		back="Cornflower Cape",waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}
		
	sets.midcast['Blue Magic'].Healing = {
		head="Carmine Mask +1",neck="Phalaina Locket",ear1="Flashward Earring",ear2="Mendicant's Earring",
		body="Vrikodara Jupon",hands="Telchine Gloves",ring1="Leviathan Ring",ring2="Sirona's Ring",
		back="Cornflower Cape",waist="Gishdubar Sash",legs="Pinga Pants",feet="Medium's Sabots"}

	sets.midcast['Blue Magic'].SkillBasedBuff = {ammo="Mavi Tathlum",
		head="Luhlaza Keffiyeh",
		body="Assimilator's Jubbah +3",
		back="Cornflower Cape",legs="Hashishin Tayt +1",feet="Luhlaza Charuqs"}

	sets.midcast['Blue Magic'].Buff = {}
    
	sets.midcast.Protect = {ring1="Sheltered Ring"}
	sets.midcast.Protectra = {ring1="Sheltered Ring"}
	sets.midcast.Shell = {ring1="Sheltered Ring"}
	sets.midcast.Shellra = {ring1="Sheltered Ring"}

	-- Sets to return to
	sets.latent_refresh = {waist="Fucho-no-obi"}

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})
    
	-- Idle sets
	sets.idle = {ammo="Staunch Tathlum",
		head="Rawhide Mask",neck="Sanctity Necklace",ear1="Genmei Earring",ear2="Etiolation Earring",
		body="Jhakri Robe +2",hands=gear.HerculeanHandsRefresh,ring1="Defending Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Lengo Pants",feet=gear.HerculeanBootsDT}

	-- Defense sets
	sets.defense.PDT = {ammo="Staunch Tathlum",
		head="Ayanmo Zucchetto +2",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Handler's Earring +1",
		body="Ayanmo Corazza +2",hands="Ayanmo Manopolas +2",ring1="Defending Ring",ring2="Dark Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Ayanmo Cosciales +2",feet="Ayanmo Gambieras +2"}

	sets.defense.MDT = {ammo="Staunch Tathlum",
		head=gear.HerculeanHeadDT,neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Flashward Earring",
		body="Ayanmo Corazza +2",hands="Volte Bracers",ring1="Defending Ring",ring2="Shadow Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs="Pinga Pants",feet=gear.HerculeanBootsDT}

	sets.MEva = {ammo="Staunch Tathlum",
		head=gear.HerculeanHeadDT,neck="Warder's Charm +1",ear1="Eabani Earring",ear2="Flashward Earring",
		body="Ayanmo Corazza +2",hands="Leyline Gloves",ring1="Vengeful Ring",ring2="Purity Ring",
		back="Solemnity Cape",waist="Flume Belt",legs="Amalric Slops +1",feet="Medium's Sabots"}
		
	sets.Kiting = {legs="Carmine Cuisses +1"}

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	-- Engaged Sets (No Haste)
	----------------------------------
	sets.engaged = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Ainia Collar",ear1="Suppanomimi",ear2="Telos Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Petrov Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Reiki Yotai",legs="Carmine Cuisses +1",feet=gear.HerculeanBootsTA}
	sets.engaged.Acc = set_combine(sets.engaged, {ammo="Ginsen",head="Carmine Mask +1",neck="Ej Necklace",hands="Adhemar Wristbands"})
	sets.engaged.Acc2 = set_combine(sets.engaged.Acc, {ear1="Zennaroi Earring",ring1="Patricius Ring",ring2="Regal Ring",waist="Olseni Belt"})

	-- Acc 1232/1208 base --
	sets.engaged.DW = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Ainia Collar",ear1="Suppanomimi",ear2="Telos Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Hetairoi Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Reiki Yotai",legs="Carmine Cuisses +1",feet=gear.HerculeanBootsTA}
	-- Acc 1275/1251 base --
	sets.engaged.DW.Acc = set_combine(sets.engaged.DW, {neck="Ej Necklace",ring1="Cacoethic Ring +1",ring2="Cacoethic Ring"})
	-- Acc 1346/1322 base --
	sets.engaged.DW.Acc2 = set_combine(sets.engaged.DW.Acc, {head="Carmine Mask +1",feet="Ayanmo Gambieras +2"})

	----------------------------------
    -- 15% Haste DWIV (~37%DW Needed) 
	----------------------------------
	sets.engaged.DW.Haste_15 = set_combine(sets.engaged.DW, {})
	sets.engaged.DW.Acc.Haste_15 = set_combine(sets.engaged.DW.Acc, {})
	sets.engaged.DW.Acc2.Haste_15 = set_combine(sets.engaged.DW.Acc2, {})
	
	----------------------------------
    -- 30% Haste DWIV (~27%DW Needed)
	----------------------------------
	sets.engaged.DW.Haste_30 = set_combine(sets.engaged.DW, {})
	sets.engaged.DW.Acc.Haste_30 = set_combine(sets.engaged.DW.Acc, {})
	sets.engaged.DW.Acc2.Haste_30 = set_combine(sets.engaged.DW.Acc2, {})
	
	----------------------------------
    -- 35% Haste DWIV (~20%DW Needed)
	----------------------------------
	sets.engaged.DW.Haste_35 = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Ainia Collar",ear1="Suppanomimi",ear2="Cessance Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Hetairoi Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Reiki Yotai",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	sets.engaged.DW.Acc.Haste_35 = set_combine(sets.engaged.DW.Haste_35, {neck="Ej Necklace",ring1="Cacoethic Ring +1",ring2="Cacoethic Ring"})
	sets.engaged.DW.Acc2.Haste_35 = set_combine(sets.engaged.DW.Acc.Haste_35, {head="Carmine Mask +1",ear1="Telos Earring",legs="Carmine Cuisses +1",feet="Ayanmo Gambieras +2"})
	
	----------------------------------
    -- MaxHaste Sets DWIV (6%DW Needed)
	----------------------------------
	-- Acc 1182/1157 base --
	sets.engaged.DW.MaxHaste = {ammo="Ginsen",
		head="Adhemar Bonnet +1",neck="Ainia Collar",ear1="Dedition Earring",ear2="Telos Earring",
		body="Adhemar Jacket +1",hands="Adhemar Wristbands +1",ring1="Hetairoi Ring",ring2="Epona's Ring",
		back=Rosmerta.DEX,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet=gear.HerculeanBootsTA}
	-- Acc 1250/1225 base --
	sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {neck="Ej Necklace",ear1="Cessance Earring",ring1="Cacoethic Ring +1",feet="Ayanmo Gambieras +2"})
	-- Acc 1320/1295 base --
	sets.engaged.DW.Acc2.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, {ammo="Honed Tathlum",head="Carmine Mask +1",ring2="Cacoethic Ring",waist="Olseni Belt",})

	sets.self_healing = {ring1="Sirona's Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
		eventArgs.cancel = true
		windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
	end
	if spell.skill == 'Blue Magic' then
		equip(sets.precast.FC['Blue Magic'])
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Add enhancement gear for Chain Affinity, etc.
	if spell.skill == 'Blue Magic' then
		for buff,active in pairs(state.Buff) do
			if active and sets.buff[buff] then
				equip(sets.buff[buff])
			end
		end
		if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
			equip(sets.self_healing)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
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
	-- AM custom group
	if buff:startswith('Aftermath') then
		if player.equipment.main == 'Tizona' then
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
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Blue Magic' then
		for category,spell_list in pairs(blue_magic_maps) do
			if spell_list:contains(spell.english) then
				return category
			end
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if player.mpp < 51 then
		set_combine(idleSet, sets.latent_refresh)
	end
	return idleSet
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
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
	
	if player.equipment.hands == "Assimilator's Bazubands" then
		disable('hands')
	end
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	update_melee_groups()
	update_combat_form()
	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function update_melee_groups()
	classes.CustomMeleeGroups:clear()
	-- mythic AM	
	if player.equipment.main == 'Tizona' then
		if buffactive['Aftermath: Lv.3'] then
			classes.CustomMeleeGroups:append('AM3')
		end
	end
end

function update_combat_form()
	-- Check for H2H or single-wielding
	if player.equipment.sub == "Genbu's Shield" or player.equipment.sub == 'empty' then
		state.CombatForm:reset()
	else
		state.CombatForm:set('DW')
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

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 7)
	else
		set_macro_page(1, 7)
	end
end
