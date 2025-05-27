extends Node
class_name enum_node

enum Drop_Type { Blurry, X, Water, Sun, Carrot_Seed, Carrot, Onion_Seed, Onion }
enum Plot_State { Dry, Wet }

enum Plot_Growth_State { None, Seed, Partial_1, Partial_2, Full }
enum Grow_Types { None, Carrot, Onion }

enum Slot_Pos {Left, Middle, Right}

enum Upgrade_Type { AddPlot, AddHelper }

enum Dir { Left, Right, Up, Down}
enum Helper_State { Idle, Wander, Get_Item, Deliver_Item }
