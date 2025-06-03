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
		Enum.Helper_State.Pluck_Crop:
			return "Pluck_Crop"
		_:
			return "idk that helper state"
			
func get_helper_type_string(type: Enum.Helper_Type) -> String:
	match(type):
		Enum.Helper_Type.Seed:
			return "Seed"
		Enum.Helper_Type.Water:
			return "Water"
		Enum.Helper_Type.Sun:
			return "Sun"
		Enum.Helper_Type.Pluck:
			return "Pluck"
		_:
			return "idk that helper state"


func random_offset(f) -> Vector2:
	return Vector2(Util.rng.randf_range(-f, f), Util.rng.randf_range(-f, f))

func random_chance(fraction: float) -> bool:
	return randf() < clamp(fraction, 0.0, 1.0)

const EXPLOSION_PARTICLE = preload("res://scene/explosion_particle.tscn")
func create_explosion_particle(pos: Vector2, color: Color) -> void:
	var p = EXPLOSION_PARTICLE.instantiate() as CPUParticles2D
	p.global_position =pos
	p.color = color.lightened(0.5)
	p.connect("finished", func(): p.queue_free())
	p.emitting = true
	Globals.AnimationsContainer.add_child(p)
	
