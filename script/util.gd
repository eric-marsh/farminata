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

#enum Drop_Type {X, Water, Sun, Carrot_Seed }
const BLURRY = preload("res://img/slots/symbols/blurry.png")
const CARROT_SEED = preload("res://img/slots/symbols/carrot_seed.png")
const SUN = preload("res://img/slots/symbols/sun.png")
const WATER = preload("res://img/slots/symbols/water.png")
const X = preload("res://img/slots/symbols/x.png")
const CARROT = preload("res://img/plants/carrot/carrot.png")

func get_drop_type_img(symbol: Enum.Drop_Type) -> Texture2D:
	match(symbol):
		Enum.Drop_Type.Blurry:
			return BLURRY
		Enum.Drop_Type.X:
			return X
		Enum.Drop_Type.Water:
			return WATER
		Enum.Drop_Type.Sun:
			return SUN
		Enum.Drop_Type.Carrot_Seed:
			return CARROT_SEED
		Enum.Drop_Type.Carrot:
			return CARROT
		_:
			return null

func is_valid_droppable_type(symbol: Enum.Drop_Type) -> bool:
	return symbol != Enum.Drop_Type.X and symbol != Enum.Drop_Type.Blurry

func get_slot_output_string(symbol: Enum.Drop_Type) -> String:
	match(symbol):
		Enum.Drop_Type.Blurry:
			return "BLURRY"
		Enum.Drop_Type.X:
			return "X"
		Enum.Drop_Type.Water:
			return "WATER"
		Enum.Drop_Type.Sun:
			return "SUN"
		Enum.Drop_Type.Carrot_Seed:
			return "CARROT_SEED"
		_:
			print("DONT KNOW WHAT THAT WAS", symbol)
			return ""


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

func get_enum_direction(dir: Vector2) -> Enum.Dir:
	if abs(dir.x) > abs(dir.y):
		return Enum.Dir.Right if dir.x > 0 else Enum.Dir.Left
	else:
		return Enum.Dir.Down if dir.y > 0 else Enum.Dir.Up
