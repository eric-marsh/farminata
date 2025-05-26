extends Node

var rng = RandomNumberGenerator.new()

func rnd_sign():
	if randf() < 0.5:
		return 1
	else:
		return -1

func quick_timer(obj: Node, wait_time: float, on_timeout: Callable):
	var t: Timer = Timer.new()
	obj.add_child(t)
	t.one_shot = true
	t.autostart = false
	t.wait_time = wait_time
	t.timeout.connect(func(): on_timeout.call())
	t.start()


func get_random_enum_value(enum_type: Dictionary) -> int:
	var values = enum_type.values()
	return values[randi() % values.size()]

#enum Output_Type {X, Water, Sun, Carrot_Seed }
const BLURRY = preload("res://img/slots/symbols/blurry.png")
const CARROT_SEED = preload("res://img/slots/symbols/carrot_seed.png")
const SUN = preload("res://img/slots/symbols/sun.png")
const WATER = preload("res://img/slots/symbols/water.png")
const X = preload("res://img/slots/symbols/x.png")
func get_output_type_img(symbol: Enum.Output_Type) -> Texture2D:
	match(symbol):
		Enum.Output_Type.Blurry:
			return BLURRY
		Enum.Output_Type.X:
			return X
		Enum.Output_Type.Water:
			return WATER
		Enum.Output_Type.Sun:
			return SUN
		Enum.Output_Type.Carrot_Seed:
			return CARROT_SEED
		_:
			return null

func is_valid_droppable_type(symbol: Enum.Output_Type) -> bool:
	return symbol != Enum.Output_Type.X and symbol != Enum.Output_Type.Blurry

func get_slot_output_string(symbol: Enum.Output_Type) -> String:
	match(symbol):
		Enum.Output_Type.Blurry:
			return "BLURRY"
		Enum.Output_Type.X:
			return "X"
		Enum.Output_Type.Water:
			return "WATER"
		Enum.Output_Type.Sun:
			return "SUN"
		Enum.Output_Type.Carrot_Seed:
			return "CARROT_SEED"
		_:
			print("DONT KNOW WHAT THAT WAS", symbol)
			return ""
