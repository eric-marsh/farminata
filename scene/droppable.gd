extends RigidBody2D
class_name droppable

@export var target_position: Vector2
@export var speed: float = 200.0

var upwards_speed: float = 100.0
var velocity: Vector2
var moving_to_target: bool = false
var time_passed: float = 0.0

var min_fall_amount = 100

var start_pos: Vector2
func _ready():
	start_pos = global_position
	# Initial diagonal velocity: up + left/right randomly
	var horizontal = -1 if randf() < 0.5  else 1
	#velocity = Vector2(upwards_speed * horizontal, -upwards_speed)
	pass

func _process(delta):
	if global_position.y > start_pos.y + min_fall_amount:
		moving_to_target = true
	
	if moving_to_target:
		var dir = (target_position - global_position).normalized()
		velocity = dir * speed
		position += velocity * delta
	
	pass
	#time_passed += delta
#
	#if not moving_to_target:
		#position += velocity * delta
#
		#if time_passed >= 0.2:
			#moving_to_target = true
	#else:
		## Move toward the target
		#if target_position:
			#var dir = (target_position - global_position).normalized()
			#velocity = dir * speed
			#position += velocity * delta
