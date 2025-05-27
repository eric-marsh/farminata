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

func get_enum_direction(dir: Vector2) -> Enum.Dir:
	if abs(dir.x) > abs(dir.y):
		return Enum.Dir.Right if dir.x > 0 else Enum.Dir.Left
	else:
		return Enum.Dir.Down if dir.y > 0 else Enum.Dir.Up

func random_visible_position() -> Vector2:
	if !Globals.CameraNode:
		print("No CameraNode in random_visible_position()")
		return Vector2.ZERO
		
	var camera_center = Globals.CameraNode.global_position
	var half_screen_size = (get_viewport().get_visible_rect().size / Globals.CameraNode.zoom) / 2
	var x = camera_center.x + randf_range(-half_screen_size.x, half_screen_size.x)
	var y = camera_center.y + randf_range(-half_screen_size.y, half_screen_size.y)
	return Vector2(x, y)


func get_helper_state_string(type: Enum.Helper_State) -> String:
	match(type):
		Enum.Helper_State.Idle:
			return "Idle"
		Enum.Helper_State.Wander:
			return "Wander"
		Enum.Helper_State.Get_Item:
			return "Get_Item"
		Enum.Helper_State.Deliver_Item:
			return "Deliver_Item"
		_:
			return "idk that helper state"

func random_offset(f) -> Vector2:
	return Vector2(Util.rng.randf_range(-f, f), Util.rng.randf_range(-f, f))



const SEED = preload("res://img/plants/seed.png") #all seeds look the same
const CARROT_SAPLING_1 = preload("res://img/plants/carrot/carrot_sapling_1.png")
const CARROT_SAPLING_2 = preload("res://img/plants/carrot/carrot_sapling_2.png")
const CARROT_SAPLING_FINAL = preload("res://img/plants/carrot/carrot_sapling_final.png")
const ONION_SAPLING_1 = preload("res://img/plants/onion/onion_sapling_1.png")
const ONION_SAPLING_2 = preload("res://img/plants/onion/onion_sapling_2.png")
const ONION_SAPLING_FINAL = preload("res://img/plants/onion/onion_sapling_final.png")

const PLANT_IMAGES = {
	Enum.Grow_Types.Carrot: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: CARROT_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: CARROT_SAPLING_2,
		Enum.Plot_Growth_State.Full: CARROT_SAPLING_FINAL,
	},
	Enum.Grow_Types.Onion: {
		Enum.Plot_Growth_State.Seed: SEED,
		Enum.Plot_Growth_State.Partial_1: ONION_SAPLING_1,
		Enum.Plot_Growth_State.Partial_2: ONION_SAPLING_2,
		Enum.Plot_Growth_State.Full: ONION_SAPLING_FINAL,
	},
}

func get_grow_type_string(type: Enum.Grow_Types) -> String:
	match(type):
		Enum.Grow_Types.Carrot:
			return ("Carrot")
		Enum.Grow_Types.Onion:
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
	pass

func get_plant_img(growth_state: int, grow_type: int):
	#print(get_growth_state_string(growth_state), " - ", get_grow_type_string(grow_type))
	var img = PLANT_IMAGES.get(grow_type, {}).get(growth_state, null)
	return img
#
