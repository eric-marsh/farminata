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
	return Enum.Dir.Right if dir.x > 0 else Enum.Dir.Left
	#if abs(dir.x) > abs(dir.y):
		#return Enum.Dir.Right if dir.x > 0 else Enum.Dir.Left
	#else:
		#return Enum.Dir.Down if dir.y > 0 else Enum.Dir.Up

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
		Enum.Helper_State.Attack:
			return "Attack"
		_:
			return "idk that helper state"
			
func get_helper_type_string(type: Enum.Helper_Type) -> String:
	match(type):
		Enum.Helper_Type.Farmer:
			return "Farmer" 
		Enum.Helper_Type.Pluck:
			return "Pluck"
		Enum.Helper_Type.Attack:
			return "Attack"
		_:
			return "idk that helper state"


func random_offset(f) -> Vector2:
	return Vector2(Util.rng.randf_range(-f, f), Util.rng.randf_range(-f, f))

func random_chance(fraction: float) -> bool:
	return randf() < clamp(fraction, 0.0, 1.0)

const EXPLOSION_PARTICLE = preload("res://scene/explosion_particle.tscn")
func create_explosion_particle(pos: Vector2, color: Color, num_squares: int = 12, speed_scale: float = 0.6) -> void:
	var p = EXPLOSION_PARTICLE.instantiate() as CPUParticles2D
	p.global_position =pos
	p.color = color
	p.amount = num_squares
	p.speed_scale = speed_scale
	p.connect("finished", func(): p.queue_free())
	p.emitting = true
	Globals.AnimationsContainer.add_child(p)
	

# https://coolors.co/palette/ff595e-ffca3a-8ac926-1982c4-6a4c93
func get_color_from_helper_type(type: Enum.Helper_Type) -> Color:
	match(type):
		Enum.Helper_Type.Farmer:
			return Color.html("#f15bb5")
		Enum.Helper_Type.Pluck:
			return Color.html("#9b5de5")
		Enum.Helper_Type.Attack:
			return Color.RED
		_:
			return Color.WHITE
	pass


func get_total_helpers_of_type(helper_type: Enum.Helper_Type) -> int:
	match(helper_type):
		Enum.Helper_Type.Farmer:
			return State.num_farmer_helpers 
		Enum.Helper_Type.Pluck:
			return State.num_pluck_helpers
		Enum.Helper_Type.Attack:
			return State.num_attack_helpers
		_:
			return 0

func get_total_helpers() -> int:
	return State.num_farmer_helpers + State.num_pluck_helpers + State.num_attack_helpers
	
	
const SLASH_ANIMATION = preload("res://scene/slash_animation.tscn")
func create_slash_animation(pos: Vector2, flip_h: bool = false):
	if !Globals.AnimationsContainer:
		return
	var a = SLASH_ANIMATION.instantiate() 
	a.global_position = pos
	a.flip_horiz = flip_h
	Globals.AnimationsContainer.add_child(a)




var current_skew: float = 0.0
var skew_dir: float = 0.0001

func update_breeze():
	if abs(current_skew) > 0.15:
		skew_dir *= -1
	current_skew += skew_dir

func get_breeze_skew():
	return current_skew
