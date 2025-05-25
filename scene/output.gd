extends Node2D

const DROPPABLE = preload("res://scene/droppable.tscn")

@export var slot_pos: Enum.Slot_Pos = Enum.Slot_Pos.Left
var output_force = 300
var output_impulse=Vector2(0,-output_force)

var min_range = 32
var max_range = 128

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func spawn_droppable(target_position: Vector2) -> void:
	var rand_impulse_dir
	match slot_pos:
		Enum.Slot_Pos.Left:
			rand_impulse_dir = Util.rng.randf_range(-1 * min_range, -1 * max_range)
		Enum.Slot_Pos.Middle:
			rand_impulse_dir = Util.rnd_sign() * Util.rng.randf_range(-max_range/2, max_range/2)
		Enum.Slot_Pos.Right:
			rand_impulse_dir = Util.rng.randf_range(min_range,max_range)
	
	#var impulse = output_impulse + impulse_based_on_slot + Vector2(rand_impulse_dir, intensity_y)
	var intensity_y = -55.9
	var impulse = output_impulse + Vector2(rand_impulse_dir, intensity_y)
	
	var d = DROPPABLE.instantiate() as droppable
	d.target_position = target_position
	d.apply_central_impulse(impulse)
	add_child(d)
