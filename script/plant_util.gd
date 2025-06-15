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
	Enum.Grow_Type.Carrot: [
		{ state = Enum.Plot_Growth_State.Partial_1, image = CARROT_SAPLING_1 },
		{ state = Enum.Plot_Growth_State.Partial_2, image = CARROT_SAPLING_2 },
		{ state = Enum.Plot_Growth_State.Full, image = CARROT_SAPLING_3 },
	],
	Enum.Grow_Type.Onion: [
		{ state = Enum.Plot_Growth_State.Seed, image = SEED },
		{ state = Enum.Plot_Growth_State.Partial_1, image = ONION_SAPLING_1 },
		{ state = Enum.Plot_Growth_State.Partial_2, image = ONION_SAPLING_2 },
		{ state = Enum.Plot_Growth_State.Full, image = ONION_SAPLING_3 },
	],
	Enum.Grow_Type.Turnip: [
		{ state = Enum.Plot_Growth_State.Seed, image = SEED },
		{ state = Enum.Plot_Growth_State.Partial_1, image = TURNIP_SAPLING_1 },
		{ state = Enum.Plot_Growth_State.Partial_2, image = TURNIP_SAPLING_2 },
		{ state = Enum.Plot_Growth_State.Full, image = TURNIP_SAPLING_3 },
	],
	Enum.Grow_Type.Potato: [
		{ state = Enum.Plot_Growth_State.Seed, image = SEED },
		{ state = Enum.Plot_Growth_State.Partial_1, image = POTATO_SAPLING_1 },
		{ state = Enum.Plot_Growth_State.Partial_2, image = POTATO_SAPLING_2 },
		{ state = Enum.Plot_Growth_State.Full, image = POTATO_SAPLING_3 },
	],
	Enum.Grow_Type.Kale: [
		{ state = Enum.Plot_Growth_State.Seed, image = SEED },
		{ state = Enum.Plot_Growth_State.Partial_1, image = KALE_SAPLING_1 },
		{ state = Enum.Plot_Growth_State.Partial_2, image = KALE_SAPLING_2 },
		{ state = Enum.Plot_Growth_State.Full, image = KALE_SAPLING_3 },
	],
	Enum.Grow_Type.Radish: [
		{ state = Enum.Plot_Growth_State.Seed, image = SEED },
		{ state = Enum.Plot_Growth_State.Partial_1, image = RADISH_SAPLING_1 },
		{ state = Enum.Plot_Growth_State.Partial_2, image = RADISH_SAPLING_2 },
		{ state = Enum.Plot_Growth_State.Full, image = RADISH_SAPLING_3 },
	],
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
	var stages = PLANT_IMAGES.get(grow_type, [])
	for stage in stages:
		if stage.state == growth_state:
			return stage.image
	return null

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

const plant_grow_scales = {
	Enum.Grow_Type.Carrot: 1.0,
	Enum.Grow_Type.Onion: 0.9,
	Enum.Grow_Type.Turnip: 0.8,
	Enum.Grow_Type.Potato: 0.7,
	Enum.Grow_Type.Kale: 0.6,
	Enum.Grow_Type.Radish: 0.5,
}

func get_grow_speed_scale(grow_type: Enum.Grow_Type) -> float:
	return plant_grow_scales.get(grow_type, 0.5)
