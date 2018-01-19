# GearSwap
Collection of lua files for GearSwap.

# determine_haste_group:
  Built to interact with 3 toggles within gearswap. Detects buffs you currently have and based on your toggles, adds up your total amount of haste and modifies your melee groups.
  
# langly_include:
  Houses the two functions job_handle_equipping_gear uses. These two functions detect if an item is enchanted, and if it is, do any charges remain. The other function checks to see if the specific piece of gear is 'ready' to be used (provided it's an enchanted item). The only way to detect this is to have the gear equipped. The values stored in the extdata are not usable unless the item is equipped.
  
# job_handle_equipping_gear:
  New logic to prevent any 'lockables' you don't want removed by gearswap should they be either 'enchanted items' you intend to use or augmented items like a Mecisto. Cape you always want to have on during CP. Will allow the items with cooldown timers you've used to be swapped to your appropriate gear within gearswap.
