extends AnimatedSprite2D

var target_pos: Vector2
var speed: float = 0.005

func _ready():
	target_pos = Util.random_visible_position()
	flip_h = target_pos < global_position
	
func _process(_delta):
	global_position += (target_pos - global_position).normalized() * speed
	if global_position.distance_to(target_pos) < speed:
		target_pos = Util.random_visible_position()
		flip_h = target_pos < global_position
