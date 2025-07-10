extends Node2D

@onready var flower_sprite: Sprite2D = $FlowerSprite
var is_flower: bool = false
var should_sway: bool = false

func _ready() -> void:
	$GroundSprite.visible = is_flower
	$AnimationPlayer.play("popup_flower")
	Util.quick_timer(self, 0.2, func(): Util.create_explosion_particle(global_position - Vector2(0,8), Color(Color.WHITE, 0.5), 6, 1.0))

func _process(_delta: float) -> void:
	if should_sway:
		animate_breeze()

func animate_breeze():
	flower_sprite.skew = Util.get_breeze_skew()
	#flower_sprite.offset.x = tan(flower_sprite.skew) 
