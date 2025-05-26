extends CharacterBody2D
class_name helper

@onready var anim = $AnimatedSprite2D

var state: Enum.Helper_State = Enum.Helper_State.Idle

var dir: Enum.Dir = Enum.Dir.Down

var target_pos: Vector2 = Vector2.ZERO
var speed:int = 40

var min_velocity: Vector2 = Vector2(-speed, -speed)
var max_velocity: Vector2 = Vector2(speed, speed)

var state_timer_set: bool = false

func _ready() -> void:
	target_pos = global_position + Vector2(0, -100)
	set_state(Enum.Helper_State.Idle)
	update_animation()
	pass
	
func _physics_process(delta: float) -> void:
	match(state):
		Enum.Helper_State.Idle:
			pass
		Enum.Helper_State.Wander:
			move_to_target()

func set_state(s: Enum.Helper_State) -> void:
		state_timer_set = false
		match(s):
			Enum.Helper_State.Idle:
				if !state_timer_set:
					state_timer_set = true
					Util.quick_timer(self, 0.4, func(): set_state(Enum.Helper_State.Wander))
			Enum.Helper_State.Wander:
				target_pos = Util.random_visible_position()
		state = s
		#print(Util.get_helper_state_string(state), " timer: ", state_timer_set)
		

func move_to_target():
	# if target reached
	if global_position.distance_to(target_pos) <= speed:
		set_state(Enum.Helper_State.Idle)
	
	var direction = (target_pos - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
	velocity = direction * speed
	velocity = velocity.clamp(min_velocity, max_velocity)
	move_and_slide()

func update_animation() -> void:
	match dir:
		Enum.Dir.Left:
			anim.play("walk_right")
			anim.flip_h = true
		Enum.Dir.Right:
			anim.play("walk_right")
			anim.flip_h = false
		Enum.Dir.Up:
			anim.play("walk_up")
			anim.flip_h = false
		Enum.Dir.Down:
			anim.play("walk_down")
			anim.flip_h = false
		_:
			print("Dont know that direction")
