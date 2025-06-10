extends Node


const SEED = preload("res://img/plants/seed.png") #all seeds look the same

const CARROT_SAPLING_1 = preload("res://img/plants/carrot/carrot_sapling1.png")
const CARROT_SAPLING_2 = preload("res://img/plants/carrot/carrot_sapling2.png")
const CARROT_SAPLING_3 = preload("res://img/plants/carrot/carrot_sapling3.png")
const ONION_SAPLING_1 = preload("res://img/plants/onion/onion_sapling1.png")
const ONION_SAPLING_2 = preload("res://img/plants/onion/onion_sapling2.png")
const ONION_SAPLING_3 = preload("res://img/plants/onion/onion_sapling3.png")
const TURNIP_SAPLING_1 = preload("res://img/plants/turnip/turnip_sapling1.png")
const TURNIP_SAPLING_2 = preload("res://img/plants/turnip/turnip_sapling2.png")
const TURNIP_SAPLING_3 = preload("res://img/plants/turnip/turnip_sapling3.png")
const POTATO_SAPLING_1 = preload("res://img/plants/potato/potato_sapling1.png")
const POTATO_SAPLING_2 = preload("res://img/plants/potato/potato_sapling2.png")
const POTATO_SAPLING_3 = preload("res://img/plants/potato/potato_sapling3.png")
const KALE_SAPLING_1 = preload("res://img/plants/kale/kale_sapling1.png")
const KALE_SAPLING_2 = preload("res://img/plants/kale/kale_sapling2.png")
const KALE_SAPLING_3 = preload("res://img/plants/kale/kale_sapling3.png")
const RADISH_SAPLING_1 = preload("res://img/plants/radish/radish_sapling1.png")
const RADISH_SAPLING_2 = preload("res://img/plants/radish/radish_sapling2.png")
const RADISH_SAPLING_3 = preload("res://img/plants/radish/radish_sapling3.png")


const PLANT_IMAGES = {
	Enum.Grow_Type.Carrot: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: CARROT_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: CARROT_SAPLING_2,
		Enum.Plot_Growth_State.Full: CARROT_SAPLING_3,
	},
	Enum.Grow_Type.Onion: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: ONION_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: ONION_SAPLING_2,
		Enum.Plot_Growth_State.Full: ONION_SAPLING_3,
	},
	Enum.Grow_Type.Turnip: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: TURNIP_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: TURNIP_SAPLING_2,
		Enum.Plot_Growth_State.Full: TURNIP_SAPLING_3,
	},
	Enum.Grow_Type.Potato: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: POTATO_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: POTATO_SAPLING_2,
		Enum.Plot_Growth_State.Full: POTATO_SAPLING_3,
	},
	Enum.Grow_Type.Kale: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: KALE_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: KALE_SAPLING_2,
		Enum.Plot_Growth_State.Full: KALE_SAPLING_3,
	},
	Enum.Grow_Type.Radish: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: RADISH_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: RADISH_SAPLING_2,
		Enum.Plot_Growth_State.Full: RADISH_SAPLING_3,
	},
}

func get_grow_type_string(type: Enum.Grow_Type) -> String:
	match(type):
		Enum.Grow_Type.Carrot:
			return ("Carrot")
		Enum.Grow_Type.Onion:
			return ("Onion")
		Enum.Grow_Type.Turnip:
			return ("Turnip")
		Enum.Grow_Type.Potato:
			return ("Potato")
		Enum.Grow_Type.Kale:
			return ("Kale")
		Enum.Grow_Type.Radish:
			return ("Radish")
		_:
			return "unknown grow type"

func get_growth_state_string(type: Enum.Plot_Growth_State) -> String:
	match type:
		Enum.Plot_Growth_State.Seed:
			return("Seed")
		Enum.Plot_Growth_State.Partial_1:
			return("Partial_1")
		Enum.Plot_Growth_State.Partial_2:
			return("Partial_2")
		Enum.Plot_Growth_State.Full:
			return ("Full")
		_:
			return "unknown growth stage"

func get_plant_img(growth_state: int, grow_type: int):
	var img = PLANT_IMAGES.get(grow_type, {}).get(growth_state, null)
	return img

func drop_type_to_grow_type(drop_type: Enum.Drop_Type) -> Enum.Grow_Type:
	match drop_type:
		Enum.Drop_Type.Carrot_Seed:
			return Enum.Grow_Type.Carrot
		Enum.Drop_Type.Onion_Seed:
			return Enum.Grow_Type.Onion
		Enum.Drop_Type.Turnip_Seed:
			return Enum.Grow_Type.Turnip
		Enum.Drop_Type.Potato_Seed:
			return Enum.Grow_Type.Potato
		Enum.Drop_Type.Kale_Seed:
			return Enum.Grow_Type.Kale
		Enum.Drop_Type.Radish_Seed:
			return Enum.Grow_Type.Radish
		_:
			print("Invalid drop_type in drop_type_to_grow_type()")
			return Enum.Grow_Type.Carrot
