extends Node2D
class_name helpers_container

const HELPER = preload("res://scene/helper.tscn")

func _ready() -> void:
	for i in range(State.num_helpers):
		add_helper()

func _physics_process(delta: float) -> void:
	pass
	
func add_helper() -> void:
	var h = HELPER.instantiate() as helper
	h.global_position = Util.random_visible_position()
	add_child(h)

func get_inactive_helper() -> helper:
	for c in get_children():
		if c.state == Enum.Helper_State.Idle or c.state == Enum.Helper_State.Wander:
			return c
	return null
