extends Node

enum Drop_Type { Blurry, X, Water, Sun, 
Carrot_Seed, Carrot, Onion_Seed, Onion, Turnip_Seed, Turnip, Potato_Seed, Potato, Kale_Seed, Kale, Radish_Seed, Radish,
Farm_Hat, Delivery_Hat, Attack_Hat 
}
enum Plot_State { Dry, Wet, Grow }

enum Plot_Growth_State { None, Seed, Partial_1, Partial_2, Full }
enum Grow_Type { None, Carrot, Onion, Turnip, Potato, Kale, Radish }

enum Slot_Pos {Left, Middle, Right}

enum Upgrade_Type { AddPlot, UnlockOnion, UnlockTurnip, UnlockPotato, UnlockKale, UnlockRadish, AddFarmerHelper,
AddFireAttack, AddElectricAttack,
AddPluckHelper, AddAttackHelper,
AddHat
 }

enum Dir { Left, Right, Up, Down}
enum Helper_State { Idle, Wander, Get_Item, Deliver_Item, Pluck_Crop, Attack }

enum Helper_Type { Farmer, Pluck, Attack }


enum Attack_Type { Regular, Fire, Electric }
