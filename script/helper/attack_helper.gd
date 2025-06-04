class_name attack_helper
extends helper


var has_reached_attack_pos: bool = false
var attack_pos_radius: int = 250
var is_target_pos_reached: bool = false

func _ready() -> void:
	target_pos = get_attack_pos(id_of_type)
	set_state(Enum.Helper_State.Attack)
	update_animation()
	
	$AnimatedSprite2D.modulate = Util.get_color_from_helper_type(helper_type).lightened(0.4)
	if Debug.Helper_Speed > 0:
		speed = Debug.Helper_Speed
		min_velocity = Vector2(-speed, -speed)
		max_velocity = Vector2(speed, speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()
	
func _physics_process(_delta: float) -> void:
	# Go to attack spot
	if !is_target_pos_reached:
		var has_reached_target:bool = move_to_target()
		if has_reached_target:
			is_target_pos_reached = true
		return
	
	# attack
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = str(Util.get_helper_state_string(state), "\n", Util.get_helper_type_string(helper_type), " 1" if held_droppable != null else " 0")


var num_attack_helpers = 100
func get_attack_pos(index: int) -> Vector2:
	if !Globals.PiniataNode:
		return Vector2.ZERO

	var center = Globals.PiniataNode.global_position
	var angle_step = PI / (num_attack_helpers + 1)
	var angle = PI + angle_step * (index + 1)  
	var offset = Vector2(cos(angle), sin(angle)) * attack_pos_radius
	return center + offset
