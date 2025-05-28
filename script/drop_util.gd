extends Node

const BLURRY = preload("res://img/slots/symbols/blurry.png")
const SUN = preload("res://img/slots/symbols/sun.png")
const WATER = preload("res://img/slots/symbols/water.png")
const X = preload("res://img/slots/symbols/x.png")
const CARROT_SEED = preload("res://img/slots/symbols/carrot_seed.png")
const CARROT = preload("res://img/plants/carrot/carrot.png")
const ONION_SEED = preload("res://img/slots/symbols/onion_seed.png")
const ONION = preload("res://img/plants/onion/onion.png")

var drop_type_images = {
	Enum.Drop_Type.Blurry: BLURRY,
	Enum.Drop_Type.X: X,
	Enum.Drop_Type.Water: WATER,
	Enum.Drop_Type.Sun: SUN,
	Enum.Drop_Type.Carrot_Seed: CARROT_SEED,
	Enum.Drop_Type.Carrot: CARROT,
	Enum.Drop_Type.Onion_Seed: ONION_SEED,
	Enum.Drop_Type.Onion: ONION
}

var drop_type_strings = {
	Enum.Drop_Type.Blurry: "BLURRY",
	Enum.Drop_Type.X: "X",
	Enum.Drop_Type.Water: "WATER",
	Enum.Drop_Type.Sun: "SUN",
	Enum.Drop_Type.Carrot_Seed: "CARROT_SEED",
	Enum.Drop_Type.Onion_Seed: "ONION_SEED",
	Enum.Drop_Type.Carrot: "CARROT",
	Enum.Drop_Type.Onion: "ONION"
}

var drop_type_colors = {
	Enum.Drop_Type.Water: Color.BLUE,
	Enum.Drop_Type.Sun: Color.YELLOW,
	Enum.Drop_Type.Carrot_Seed: Color.BROWN,
	Enum.Drop_Type.Onion_Seed: Color.BROWN
}

func is_produce(symbol: Enum.Drop_Type) -> bool:
	return symbol in [Enum.Drop_Type.Carrot, Enum.Drop_Type.Onion]

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

const DROPPABLE = preload("res://scene/droppable.tscn")
func spawn_droppable(drop_type: Enum.Drop_Type, position: Vector2, target_position: Vector2, impulse: Vector2 = Vector2.ZERO):
	var d = DROPPABLE.instantiate() as droppable
	d.drop_type = drop_type
	d.global_position = position
	d.target_position = target_position
	if impulse != Vector2.ZERO:
		d.apply_central_impulse(impulse)
	if Globals.DropsNode:
		Globals.DropsNode.add_child(d)
	return d



const APPLY_DROPPABLE_ANIMATION = preload("res://scene/apply_droppable_animation.tscn")
func create_shrink_animation(drop_type: Enum.Drop_Type, pos: Vector2):
	if !Globals.AnimationsContainer:
		return
	var a = APPLY_DROPPABLE_ANIMATION.instantiate() 
	a.drop_type = drop_type
	a.global_position = pos
	Globals.AnimationsContainer.add_child(a)
	
