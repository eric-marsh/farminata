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

#enum Slot_Output {X, Water, Sun, Carrot_Seed }
const BLURRY = preload("res://img/slots/symbols/blurry.png")
const CARROT_SEED = preload("res://img/slots/symbols/carrot_seed.png")
const SUN = preload("res://img/slots/symbols/sun.png")
const WATER = preload("res://img/slots/symbols/water.png")
const X = preload("res://img/slots/symbols/x.png")
func get_slot_output_img(symbol: Enum.Slot_Output) -> Texture2D:
	match(symbol):
		Enum.Slot_Output.Blurry:
			return BLURRY
		Enum.Slot_Output.X:
			return X
		Enum.Slot_Output.Water:
			return WATER
		Enum.Slot_Output.Sun:
			return SUN
		Enum.Slot_Output.Carrot_Seed:
			return CARROT_SEED
		_:
			return null

func get_slot_output_string(symbol: Enum.Slot_Output) -> String:
	match(symbol):
		Enum.Slot_Output.Blurry:
			return "BLURRY"
		Enum.Slot_Output.X:
			return "X"
		Enum.Slot_Output.Water:
			return "WATER"
		Enum.Slot_Output.Sun:
			return "SUN"
		Enum.Slot_Output.Carrot_Seed:
			return "CARROT_SEED"
		_:
			print("DONT KNOW WHAT THAT WAS", symbol)
			return ""
