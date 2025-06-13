class_name attack_helper
extends helper

@export var attack_interval: float = 1.0
@export var attack_strength: int = 1

var has_reached_attack_pos: bool = false
var attack_pos_radius: int = 250
var is_target_pos_reached: bool = false

# Path2D seems like overkill. Just use the timer and calculate the position based on the attack interval


func _ready() -> void:
	target_pos = get_attack_pos(id_of_type)
	set_state(Enum.Helper_State.Attack)
	update_animation()
	
	$AttackTimer.wait_time = attack_interval
	$AttackTimer.connect("timeout", attack)
	
	#$AnimatedSprite2D.modulate = Util.get_color_from_helper_type(helper_type).lightened(0.4)
	configure_hat()
	if Debug.Helper_Speed > 0:
		update_speed(Debug.Helper_Speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()
	
func _physics_process(delta: float) -> void:
	update_hat_animation()
	if apply_upgrade:
		attack_interval = max(0.1, attack_interval / 2)
		attack_strength += 1
		apply_upgrade = false
	
	if state == Enum.Helper_State.Get_Item:
		if !target_droppable:
			set_state(Enum.Helper_State.Idle)
			return
		if target_droppable.is_hat:
			var has_reached_target:bool = move_to_target()
			if has_reached_target:
				equip_hat(target_droppable)
				target_droppable.hide_droppable()
				target_droppable.delete()
				target_droppable = null
				is_target_pos_reached = false
				target_pos = get_attack_pos(id_of_type)
				set_state(Enum.Helper_State.Attack)
				return
	
	# Go to attack spot
	if state == Enum.Helper_State.Attack and !is_target_pos_reached:
		var has_reached_target:bool = move_to_target()
		if has_reached_target:
			is_target_pos_reached = true
			start_attacking()
		return
	if is_attacking():
		update_thowable()
	
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = str(Util.get_helper_state_string(state), "\n", Util.get_helper_type_string(helper_type))

func start_attacking() -> void:
	if !Globals.PiniataNode:
		return
	
	start_position = global_position
	$Throwable.visible = true
	$AttackTimer.start()
	
	# change direction to face piniata
	var direction = (Globals.PiniataNode.piniata_center - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
		# TODO: Use idle animation

func is_attacking() -> bool:
	return !$AttackTimer.is_stopped()

var start_position: Vector2
func attack() -> void:
	if !Globals.PiniataNode:
		return
	if dir == Enum.Dir.Left:
		Globals.PiniataNode.hit_piniata(attack_strength, $Throwable.global_position)
	else:
		Globals.PiniataNode.hit_piniata(attack_strength * -1, $Throwable.global_position)
	

func update_thowable() -> void:
	if !Globals.PiniataNode:
		return
	var target_position: Vector2
	if dir == Enum.Dir.Left:
		target_position = Globals.PiniataNode.piniata_center + Vector2(42, 0)
	else:
		target_position = Globals.PiniataNode.piniata_center + Vector2(-42, 0)
	
	
	var total_time = $AttackTimer.wait_time
	var elapsed_time = total_time - $AttackTimer.time_left
	var t = clamp(elapsed_time / total_time, 0, 1) # Normalize from 0 to 1

	# Interpolate from start to target
	$Throwable.global_position = start_position.lerp(target_position, t)
	$Throwable.z_index = 15

var num_attack_helpers = 50
func get_attack_pos(index: int) -> Vector2:
	if !Globals.PiniataNode:
		return Vector2.ZERO

	var center = Globals.PiniataNode.piniata_center
	var angle_step = PI / (num_attack_helpers + 1)
	var angle = PI + angle_step * (index + 1)  
	var offset = Vector2(cos(angle), -sin(angle)) * attack_pos_radius
	return center + offset
