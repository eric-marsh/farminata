class_name attack_helper
extends helper

@export var attack_interval: float = 1.0
@export var attack_strength: int = 2

var has_reached_attack_pos: bool = false

var is_target_pos_reached: bool = false

var always_wander: bool = false

@onready var attack_timer: Timer = $AttackTimer
@onready var throwable: Sprite2D = $Throwable

func _ready() -> void:
	await get_tree().create_timer(0.00001).timeout
	target_pos = get_attack_pos(id_of_type)
	set_state(Enum.Helper_State.Attack)
	update_animation()
	
	
	
	attack_timer.wait_time = attack_interval
	attack_timer.connect("timeout", on_attack_timer_timeout)
	
	#$AnimatedSprite2D.modulate = Util.get_color_from_helper_type(helper_type).lightened(0.4)
	configure_hat()
	if Debug.Helper_Speed > 0:
		update_speed(Debug.Helper_Speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()
	
func _physics_process(_delta: float) -> void:
	update_hat_animation()
	if apply_upgrade:
		attack_interval = max(0.5, attack_interval - (num_hats * 0.1))
		attack_timer.wait_time = attack_interval
		attack_strength += 1
		apply_upgrade = false
	
	
	if state == Enum.Helper_State.Attack and always_wander:
		set_state(Enum.Helper_State.Wander)
		print("set WANDER state")
		return
	
	
	if state == Enum.Helper_State.Get_Item:
		if is_attacking():
			attack_timer.stop()
			throwable.visible = false
			held_item.visible = false
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
	
	if state == Enum.Helper_State.Wander:
		var has_reached_target:bool = move_to_target()
		if has_reached_target:
			set_state(Enum.Helper_State.Wander)
	
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = str(Util.get_helper_state_string(state), "\n", Util.get_helper_type_string(helper_type))





func start_attacking() -> void:
	if !target_piniata:
		return
	
	start_position = global_position
	throwable.visible = true
	attack_timer.start()
	
	# change direction to face piniata
	var direction = (target_piniata.piniata_center - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
		# TODO: Use idle animation

func is_attacking() -> bool:
	return !attack_timer.is_stopped()

func stop_attacking() -> void:
	attack_timer.stop()
	set_state(Enum.Helper_State.Idle)
	target_pos = global_position
	always_wander = true
	throwable.visible = false
	held_item.visible = false
	

var start_position: Vector2
func on_attack_timer_timeout() -> void:
	if !target_piniata:
		return
	if dir == Enum.Dir.Left:
		target_piniata.hit_piniata(attack_strength, throwable.global_position)
	else:
		target_piniata.hit_piniata(attack_strength * -1, throwable.global_position)
	DamageNumber.display_number(attack_strength, throwable.global_position, Color.WHITE)
	
func update_thowable() -> void:
	if !target_piniata:
		return
	var target_position: Vector2
	if dir == Enum.Dir.Left:
		target_position = target_piniata.piniata_center + Vector2(42, 0)
	else:
		target_position = target_piniata.piniata_center + Vector2(-42, 0)
	
	
	var total_time = attack_timer.wait_time
	var elapsed_time = total_time - attack_timer.time_left
	var t = clamp(elapsed_time / total_time, 0, 1) # Normalize from 0 to 1

	# Interpolate from start to target
	throwable.global_position = start_position.lerp(target_position, t)
	throwable.z_index = 15


var num_attack_helpers = 100
var target_piniata: piniata = null
static var target_piniata_index: int = 0
func get_attack_pos(index: int) -> Vector2:
	if !Globals.PiniataContainer or Globals.PiniataContainer.get_children().size() == 0:
		return Vector2.ZERO
	
	var attack_pos_radius: int = 250
	var y_offset: int = 120
	
	target_piniata = Globals.PiniataContainer.get_children()[target_piniata_index]
	target_piniata_index = (target_piniata_index + 1) % Globals.PiniataContainer.get_children().size()
	
	var angle_step = PI / (num_attack_helpers + 1)
	var angle = PI + angle_step * (index + 1)  
	var offset
	offset = Vector2(cos(angle), -sin(angle)) * attack_pos_radius
	if id_of_type % 2 == 0:
		offset = Vector2(cos(angle), -sin(angle)) * attack_pos_radius
	else:
		offset = Vector2(-cos(angle), -sin(angle)) * attack_pos_radius
	
	var main_piniata_center = Vector2(337, -5)
	return main_piniata_center + offset + Vector2(0, y_offset)
