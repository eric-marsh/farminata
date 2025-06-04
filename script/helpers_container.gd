extends Node2D
class_name helpers_container

const HELPER = preload("res://scene/helper/helper.tscn")
const ATTACK_HELPER = preload("res://scene/helper/attack_helper.tscn")

func _ready() -> void:
	for i in range(State.num_seed_helpers):
		add_helper(Enum.Helper_Type.Seed)
	for i in range(State.num_sun_helpers):
		add_helper(Enum.Helper_Type.Sun)
	for i in range(State.num_water_helpers):
		add_helper(Enum.Helper_Type.Water)
	for i in range(State.num_pluck_helpers):
		add_helper(Enum.Helper_Type.Pluck)
	for i in range(State.num_attack_helpers):
		add_helper(Enum.Helper_Type.Attack)

func _physics_process(delta: float) -> void:
	pass
	
func add_helper(helper_type: Enum.Helper_Type) -> void:
	var h
	if helper_type == Enum.Helper_Type.Attack:
		h = ATTACK_HELPER.instantiate() as attack_helper
	else:
		h = HELPER.instantiate() as helper
	h.helper_type = helper_type
	h.global_position = Util.random_visible_position()
	h.id = Util.get_total_helpers()
	h.id_of_type = Util.get_total_helpers_of_type(helper_type)
	add_child(h)
	match(helper_type):
		Enum.Helper_Type.Seed:
			State.num_seed_helpers += 1
		Enum.Helper_Type.Sun:
			State.num_sun_helpers += 1
		Enum.Helper_Type.Water:
			State.num_water_helpers += 1
		Enum.Helper_Type.Pluck:
			State.num_pluck_helpers += 1
		Enum.Helper_Type.Attack:
			State.num_attack_helpers += 1

func get_inactive_helper() -> helper:
	for c in get_children():
		if c.state == Enum.Helper_State.Idle or c.state == Enum.Helper_State.Wander:
			return c
	return null
