extends Node2D
class_name helpers_container

const HELPER = preload("res://scene/helper/helper.tscn")
const ATTACK_HELPER = preload("res://scene/helper/attack_helper.tscn")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func add_helper(helper_type: Enum.Helper_Type, update_count: bool = true) -> void:
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
	if update_count:
		match(helper_type):
			Enum.Helper_Type.Farmer:
				State.num_farmer_helpers += 1
			Enum.Helper_Type.Pluck:
				State.num_pluck_helpers += 1
			Enum.Helper_Type.Attack:
				State.num_attack_helpers += 1

func get_inactive_helper() -> helper:
	for c in get_children():
		if c.state == Enum.Helper_State.Idle or c.state == Enum.Helper_State.Wander:
			return c
	return null

func get_helper_that_needs_hat(hat: Enum.Drop_Type, pos: Vector2) -> helper:
	var closest_helper: helper = null
	var closest_dist: float = 999999
	var fewest_hats: int = 999999
	
	for c in get_children():
		if !(c is helper):
			continue
		
		match hat:
			Enum.Drop_Type.Farm_Hat:
				if c.helper_type != Enum.Helper_Type.Farmer:
					continue
			Enum.Drop_Type.Delivery_Hat:
				if c.helper_type != Enum.Helper_Type.Pluck:
					continue
			Enum.Drop_Type.Attack_Hat:
				if c.helper_type != Enum.Helper_Type.Attack:
					continue
			_:
				continue
		
		var dist = c.global_position.distance_to(pos)
		
		# Choose the helper with fewest hats. If equal, choose the closer one.
		if c.num_hats < fewest_hats or (c.num_hats == fewest_hats and dist < closest_dist):
			closest_dist = dist
			fewest_hats = c.num_hats
			closest_helper = c
	
	return closest_helper

func on_game_over():
	for c in get_children():
		if c.helper_type == Enum.Helper_Type.Attack:
			c.stop_attacking()
			print(c)
