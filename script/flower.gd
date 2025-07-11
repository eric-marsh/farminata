extends Node2D

@onready var flower_sprite: Sprite2D = $FlowerSprite
var is_flower: bool = false
var should_sway: bool = false
@onready var shadow: Sprite2D = $FlowerSprite/Shadow

func _ready() -> void:
	
	if Debug.SWAY_RAND_DIR:
		skew_dir = Util.rnd_sign() * skew_dir
	if Debug.SWAY_RAND_START:
		current_skew = Util.rng.randf_range(-0.15, 0.15)
	
	$GroundSprite.visible = is_flower
	$AnimationPlayer.play("popup_flower")
	Util.quick_timer(self, 0.2, func(): Util.create_explosion_particle(global_position - Vector2(0,8), Color(Color.WHITE, 0.5), 6, 1.0))

func _process(_delta: float) -> void:
	if should_sway:
		animate_breeze()

func animate_breeze():
	update_breeze()
	flower_sprite.skew = current_skew
	#flower_sprite.offset.x = tan(flower_sprite.skew) 


var current_skew: float = 0.0
var skew_dir: float = 0.001

func update_breeze():
	if abs(current_skew) > 0.15:
		skew_dir *= -1
	current_skew += skew_dir
