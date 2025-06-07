extends Node

enum Drop_Type { Blurry, X, Water, Sun, Carrot_Seed, Carrot, Onion_Seed, Onion, Farm_Hat, Delivery_Hat, Attack_Hat }
enum Plot_State { Dry, Wet }

enum Plot_Growth_State { None, Seed, Partial_1, Partial_2, Full }
enum Grow_Type { None, Carrot, Onion }

enum Slot_Pos {Left, Middle, Right}

enum Upgrade_Type { AddPlot, UnlockOnion, AddSeedHelper, AddSunHelper, AddWaterHelper, AddPluckHelper, AddAttackHelper }

enum Dir { Left, Right, Up, Down}
enum Helper_State { Idle, Wander, Get_Item, Deliver_Item, Pluck_Crop, Attack }

enum Helper_Type { Seed, Water, Sun, Pluck, Attack }
