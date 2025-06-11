extends Node


const ROCK = preload("res://img/droppables/rock.png")
const SUN = preload("res://img/droppables/sun.png")
const WATER = preload("res://img/droppables/water.png")
const X = preload("res://img/droppables/x.png")
const BLURRY = preload("res://img/slots/symbols/blurry.png")

const DELIVERY_HAT = preload("res://img/helper/delivery_hat.png")
const FARMER_HAT = preload("res://img/helper/farmer_hat.png")
const ATTACK_HAT = preload("res://img/helper/attack_hat.png")

const CARROT = preload("res://img/plants/carrot/carrot.png")
const CARROT_SEED = preload("res://img/plants/carrot/carrot_seed.png")
const ONION = preload("res://img/plants/onion/onion.png")
const ONION_SEED = preload("res://img/plants/onion/onion_seed.png")
const TURNIP = preload("res://img/plants/turnip/turnip.png")
const TURNIP_SEED = preload("res://img/plants/turnip/turnip_seed.png")
const POTATO = preload("res://img/plants/potato/potato.png")
const POTATO_SEED = preload("res://img/plants/potato/potato_seed.png")
const KALE = preload("res://img/plants/kale/kale.png")
const KALE_SEED = preload("res://img/plants/kale/kale_seed.png")
const RADISH = preload("res://img/plants/radish/radish.png")
const RADISH_SEED = preload("res://img/plants/radish/radish_seed.png")


var drop_type_images = {
	Enum.Drop_Type.Blurry: BLURRY,
	Enum.Drop_Type.X: X,
	Enum.Drop_Type.Water: WATER,
	Enum.Drop_Type.Sun: SUN,
	
	Enum.Drop_Type.Carrot_Seed: CARROT_SEED,
	Enum.Drop_Type.Carrot: CARROT,
	Enum.Drop_Type.Onion_Seed: ONION_SEED,
	Enum.Drop_Type.Onion: ONION,
	Enum.Drop_Type.Turnip_Seed: TURNIP_SEED,
	Enum.Drop_Type.Turnip: TURNIP,
	Enum.Drop_Type.Potato_Seed: POTATO_SEED,
	Enum.Drop_Type.Potato: POTATO,
	Enum.Drop_Type.Kale_Seed: KALE_SEED,
	Enum.Drop_Type.Kale: KALE,
	Enum.Drop_Type.Radish_Seed: RADISH_SEED,
	Enum.Drop_Type.Radish: RADISH,
	
	Enum.Drop_Type.Delivery_Hat: DELIVERY_HAT,
	Enum.Drop_Type.Farm_Hat: FARMER_HAT,
	Enum.Drop_Type.Attack_Hat: ATTACK_HAT,
}


var drop_type_strings = {
	Enum.Drop_Type.Blurry: "BLURRY",
	Enum.Drop_Type.X: "X",
	Enum.Drop_Type.Water: "WATER",
	Enum.Drop_Type.Sun: "SUN",
	Enum.Drop_Type.Carrot_Seed: "CARROT_SEED",
	Enum.Drop_Type.Onion_Seed: "ONION_SEED",
	Enum.Drop_Type.Carrot: "CARROT",
	Enum.Drop_Type.Onion: "ONION",
	Enum.Drop_Type.Turnip_Seed: "TURNIP_SEED",
	Enum.Drop_Type.Turnip: "TURNIP",
	Enum.Drop_Type.Potato_Seed: "Potato_Seed",
	Enum.Drop_Type.Potato: "Potato",
	Enum.Drop_Type.Kale_Seed: "Kale_Seed",
	Enum.Drop_Type.Kale: "KALE",
	Enum.Drop_Type.Radish_Seed: "RADISH_SEED",
	Enum.Drop_Type.Radish: "RADISH",
	
	Enum.Drop_Type.Delivery_Hat: "DELIVERY_HAT",
	Enum.Drop_Type.Farm_Hat: "FARMER_HAT",
	Enum.Drop_Type.Attack_Hat: "ATTACK_HAT",
}

var drop_type_colors = {
	Enum.Drop_Type.Water: Color.BLUE,
	Enum.Drop_Type.Sun: Color.YELLOW,
	Enum.Drop_Type.Carrot_Seed: Color.BROWN,
	Enum.Drop_Type.Onion_Seed: Color.BROWN,
	Enum.Drop_Type.Turnip_Seed: Color.BROWN,
	Enum.Drop_Type.Potato_Seed: Color.BROWN,
	Enum.Drop_Type.Kale_Seed: Color.BROWN,
	Enum.Drop_Type.Radish_Seed: Color.BROWN,
	
}

func is_seed(symbol: Enum.Drop_Type) -> bool:
	return symbol in [Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed, Enum.Drop_Type.Turnip_Seed, Enum.Drop_Type.Potato_Seed, Enum.Drop_Type.Kale_Seed, Enum.Drop_Type.Radish_Seed]

func is_produce(symbol: Enum.Drop_Type) -> bool:
	return symbol in [Enum.Drop_Type.Carrot, Enum.Drop_Type.Onion, Enum.Drop_Type.Turnip, Enum.Drop_Type.Potato, Enum.Drop_Type.Kale, Enum.Drop_Type.Radish]

func is_hat(symbol: Enum.Drop_Type) -> bool:
	return symbol in [Enum.Drop_Type.Farm_Hat, Enum.Drop_Type.Delivery_Hat, Enum.Drop_Type.Attack_Hat]

func is_valid_droppable_type(symbol: Enum.Drop_Type) -> bool:
	return symbol != Enum.Drop_Type.X and symbol != Enum.Drop_Type.Blurry

func get_drop_type_img(symbol: Enum.Drop_Type) -> Texture2D:
	return drop_type_images.get(symbol, null)

func get_drop_type_string(symbol: Enum.Drop_Type) -> String:
	if symbol in drop_type_strings:
		return drop_type_strings[symbol]
	print("DONT KNOW WHAT THAT WAS", symbol)
	return ""

func get_drop_type_color(drop_type: Enum.Drop_Type) -> Color:
	return drop_type_colors.get(drop_type, Color.WHITE)

const APPLY_DROPPABLE_ANIMATION = preload("res://scene/apply_droppable_animation.tscn")
func create_apply_droppable_animation(drop_type: Enum.Drop_Type, start_pos: Vector2, target_pos: Vector2):
	if !Globals.AnimationsContainer:
		return
	var a = APPLY_DROPPABLE_ANIMATION.instantiate() 
	a.drop_type = drop_type
	a.global_position = start_pos
	a.start_pos = start_pos
	a.target_pos = target_pos
	Globals.AnimationsContainer.add_child(a)

const DROPPABLE = preload("res://scene/droppable.tscn")
func spawn_droppable(drop_type: Enum.Drop_Type, position: Vector2, target_position: Vector2, impulse: Vector2 = Vector2.ZERO):
	var d = DROPPABLE.instantiate() as droppable
	d.drop_type = drop_type
	d.global_position = position
	d.target_position = target_position
	update_droppable_count(drop_type, 1)
	
	if impulse != Vector2.ZERO:
		d.apply_central_impulse(impulse)
	if Globals.DropsNode:
		Globals.DropsNode.add_child(d)
	return d


var droppable_count = {}
func update_droppable_count(drop_type: Enum.Drop_Type, difference: int) -> void:
	if !droppable_count.has(drop_type):
		droppable_count.set(drop_type, 0)
	droppable_count.set(drop_type, droppable_count.get(drop_type) + difference)
	
func get_total_drops_of_type(drop_type: Enum.Drop_Type) -> int:
	if !droppable_count.has(drop_type):
		return 0
		
	return droppable_count.get(drop_type, 0)



var priority: Array = [
		{ "seed": Enum.Drop_Type.Radish_Seed, "produce": Enum.Drop_Type.Radish },
		{ "seed": Enum.Drop_Type.Kale_Seed, "produce": Enum.Drop_Type.Kale },
		{ "seed": Enum.Drop_Type.Potato_Seed, "produce": Enum.Drop_Type.Potato },
		{ "seed": Enum.Drop_Type.Turnip_Seed, "produce": Enum.Drop_Type.Turnip },
		{ "seed": Enum.Drop_Type.Onion_Seed, "produce": Enum.Drop_Type.Onion },
		{ "seed": Enum.Drop_Type.Carrot_Seed, "produce": Enum.Drop_Type.Carrot },
	]
	
func get_highest_produce() -> droppable:
	for pair in priority:
		if State.unlocked_slot_outputs.has(pair.seed) or pair.seed == Enum.Drop_Type.Carrot_Seed:
			var d = Globals.DropsNode.get_droppable_of_type(pair.produce)
			if d:
				return d
	return null  

func get_highest_seed() -> droppable:
	for pair in priority:
		if State.unlocked_slot_outputs.has(pair.seed) or pair.seed == Enum.Drop_Type.Carrot_Seed:
			var d = Globals.DropsNode.get_droppable_of_type(pair.seed)
			if d:
				return d
	return null  
	
var max_seed_offset: int = 4
func get_highest_seed_within_limit() -> Enum.Drop_Type:
	var max_seeds_allowed: int = PlotUtil.get_total_plots() + max_seed_offset
	for pair in priority:
		if State.unlocked_slot_outputs.has(pair.seed) or pair.seed == Enum.Drop_Type.Carrot_Seed:
			if DropUtil.get_total_drops_of_type(pair.seed) < max_seeds_allowed:
				return pair.seed
	return Enum.Drop_Type.X
	
func print_drop_counts()->void:
	if droppable_count.size() == 0:
		return
	
	var result = ""
	for k in droppable_count.keys():
		result += get_drop_type_string(k as Enum.Drop_Type) + ": " + str(get_total_drops_of_type(k as Enum.Drop_Type)) + " "
	
	if result != "":
		print(result)
	
