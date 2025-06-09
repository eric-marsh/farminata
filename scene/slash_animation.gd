extends AnimatedSprite2D

static var last_animation_index:int = 0

@onready var slash_animation: AnimatedSprite2D = $"."

const SLASH_ANIMATION = preload("res://img/particle/slash_animation.tres")

@export var flip_horiz = false

var animations = [
	"slash_1",
	"slash_2",
	"slash_3"
]

func _ready() -> void:
	init_animation()
	slash_animation.play(animations[last_animation_index])
	last_animation_index = (last_animation_index + 1) % animations.size()

func init_animation() -> void:
	flip_h = flip_horiz
	match(last_animation_index):
		0:
			slash_animation.offset = Vector2(-42, -12)
		1:
			slash_animation.offset = Vector2(-30, 12)
		2:
			slash_animation.offset = Vector2(-30, -2)
	
	if flip_horiz:
		slash_animation.offset *= -1
	


func _on_animation_finished() -> void:
	queue_free()
