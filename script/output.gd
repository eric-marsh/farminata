extends Node2D
class_name output

@export var enable_offset:bool = false

var offset_max = 20.0

var output_force:int = 300
var output_impulse: Vector2 = Vector2(0, -output_force)
var min_range: int = 140
var max_range:int = 180


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func trigger_output(drop_type: Enum.Drop_Type, target_position: Vector2) -> void:
	var rand_impulse_dir: float
	
	match [0, 1, 2].pick_random():
		0:
			rand_impulse_dir = -Util.rng.randf_range(min_range, max_range)
		1:
			rand_impulse_dir = Util.rnd_sign() * Util.rng.randf_range(min_range, max_range) / 2
		2:
			rand_impulse_dir = Util.rng.randf_range(min_range, max_range)
	
	var impulse = output_impulse + Vector2(rand_impulse_dir, Util.rng.randf_range(-60, -120))
	var pos = global_position + Util.random_offset(offset_max) if enable_offset else Vector2.ZERO
	 
	DropUtil.spawn_droppable(drop_type, pos, target_position, impulse)
	
	
	
