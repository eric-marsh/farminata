extends Node


const SEED = preload("res://img/plants/seed.png") #all seeds look the same
const CARROT_SAPLING_1 = preload("res://img/plants/carrot/carrot_sapling_1.png")
const CARROT_SAPLING_2 = preload("res://img/plants/carrot/carrot_sapling_2.png")
const CARROT_SAPLING_FINAL = preload("res://img/plants/carrot/carrot_sapling_final.png")
const ONION_SAPLING_1 = preload("res://img/plants/onion/onion_sapling_1.png")
const ONION_SAPLING_2 = preload("res://img/plants/onion/onion_sapling_2.png")
const ONION_SAPLING_FINAL = preload("res://img/plants/onion/onion_sapling_final.png")

const PLANT_IMAGES = {
	Enum.Grow_Type.Carrot: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: CARROT_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: CARROT_SAPLING_2,
		Enum.Plot_Growth_State.Full: CARROT_SAPLING_FINAL,
	},
	Enum.Grow_Type.Onion: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: ONION_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: ONION_SAPLING_2,
		Enum.Plot_Growth_State.Full: ONION_SAPLING_FINAL,
	},
}

func get_grow_type_string(type: Enum.Grow_Type) -> String:
	match(type):
		Enum.Grow_Type.Carrot:
			return ("Carrot")
		Enum.Grow_Type.Onion:
			return ("Onion")
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
		_:
			print("Invalid drop_type in drop_type_to_grow_type()")
			return Enum.Grow_Type.Carrot
