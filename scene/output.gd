extends Node2D
class_name output


@export var slot_pos: Enum.Slot_Pos = Enum.Slot_Pos.Left

var output_force:int = 300
var output_impulse: Vector2 = Vector2(0, -output_force)
var min_range: int = 32
var max_range:int = 128

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func trigger_output(drop_type: Enum.Drop_Type, target_position: Vector2) -> void:
	var rand_impulse_dir: float
	
	match slot_pos:
		Enum.Slot_Pos.Left:
			rand_impulse_dir = -Util.rng.randf_range(min_range, max_range)
		Enum.Slot_Pos.Middle:
			rand_impulse_dir = Util.rnd_sign() * Util.rng.randf_range(min_range, max_range) / 2
		Enum.Slot_Pos.Right:
			rand_impulse_dir = Util.rng.randf_range(min_range, max_range)
	
	var impulse = output_impulse + Vector2(rand_impulse_dir, -55.9)
	Util.spawn_droppable(drop_type, global_position, target_position, impulse)
	
	
