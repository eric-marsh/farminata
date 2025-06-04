extends Node2D
class_name helpers_container

const HELPER = preload("res://scene/helper.tscn")

func _ready() -> void:
	for i in range(State.num_seed_helpers):
		add_helper(Enum.Helper_Type.Seed)
	for i in range(State.num_sun_helpers):
		add_helper(Enum.Helper_Type.Sun)
	for i in range(State.num_water_helpers):
		add_helper(Enum.Helper_Type.Water)
	for i in range(State.num_pluck_helpers):
		add_helper(Enum.Helper_Type.Pluck)

func _physics_process(delta: float) -> void:
	pass
	
func add_helper(helper_type: Enum.Helper_Type) -> void:
	var h = HELPER.instantiate() as helper
	h.helper_type = helper_type
	h.global_position = Util.random_visible_position()
	add_child(h)

func get_inactive_helper() -> helper:
	for c in get_children():
		if c.state == Enum.Helper_State.Idle or c.state == Enum.Helper_State.Wander:
			return c
	return null
