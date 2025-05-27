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

func get_drop_type_string(symbol: Enum.Drop_Type) -> String:
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

func random_visible_position() -> Vector2:
	if !Globals.CameraNode:
		print("No CameraNode in random_visible_position()")
		return Vector2.ZERO
		
	var camera_center = Globals.CameraNode.global_position
	var half_screen_size = (get_viewport().get_visible_rect().size / Globals.CameraNode.zoom) / 2
	var x = camera_center.x + randf_range(-half_screen_size.x, half_screen_size.x)
	var y = camera_center.y + randf_range(-half_screen_size.y, half_screen_size.y)
	return Vector2(x, y)


#enum Helper_State { Idle, Wander, Get_Item, Deliver_Item }
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

const APPLY_DROPPABLE_ANIMATION = preload("res://scene/apply_droppable_animation.tscn")
func create_shrink_animation(texture: Texture, pos: Vector2):
	if !Globals.AnimationsContainer:
		return
	var a = APPLY_DROPPABLE_ANIMATION.instantiate()
	a.get_node("Sprite2D").texture = texture
	a.global_position = pos
	Globals.AnimationsContainer.add_child(a)
	
	
