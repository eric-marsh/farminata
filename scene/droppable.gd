extends RigidBody2D
class_name droppable

@export var target_position: Vector2
@export var speed: float = 200.0
@export var output_type: Enum.Output_Type = Enum.Output_Type.Water

var upwards_speed: float = 100.0
var velocity: Vector2
var moving_to_target: bool = false
var time_passed: float = 0.0

var min_fall_amount = 10

var start_pos: Vector2
func _ready():
	$Sprite2D.texture = Util.get_output_type_img(output_type)
	start_pos = global_position

func _process(delta):
	if global_position.y > start_pos.y + min_fall_amount:
		moving_to_target = true
	
	if moving_to_target:
		var dir = (target_position - global_position).normalized()
		velocity = dir * speed
		position += velocity * delta
	
