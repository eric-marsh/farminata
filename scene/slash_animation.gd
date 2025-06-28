extends AnimatedSprite2D

static var last_animation_index:int = 0

@onready var slash_animation: AnimatedSprite2D = $"."

const SLASH_ANIMATION = preload("res://img/particle/slash_animation.tres")

@export var flip_horiz = false

var regular_animations = [
	"slash_1",
	"slash_2",
	"slash_1",
	"slash_3",
]

var fire_animations = [
	"fire_1",
	"fire_2",
	"fire_1",
	"fire_3",
]

var electric_animations = [
	"electric_1",
	"electric_2",
	"electric_1",
	"electric_3",
]

func _ready() -> void:
	init_animation()
	slash_animation.play(regular_animations[last_animation_index])
	last_animation_index = (last_animation_index + 1) % regular_animations.size()
	
	#slash_animation.play(fire_animations[last_animation_index])
	#last_animation_index = (last_animation_index + 1) % fire_animations.size()
	#
	#slash_animation.play(electric_animations[last_animation_index])
	#last_animation_index = (last_animation_index + 1) % electric_animations.size()

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
