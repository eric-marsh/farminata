extends Node2D

@onready var flower_sprite: Sprite2D = $FlowerSprite

func _ready() -> void:
	
	$AnimationPlayer.play("popup_flower")
	Util.quick_timer(self, 0.2, func(): Util.create_explosion_particle(global_position - Vector2(0,8), Color(Color.WHITE, 0.5), 6, 1.0))

func _process(_delta: float) -> void:
	animate_breeze()
	pass

func animate_breeze():
	flower_sprite.skew = Util.get_breeze_skew()
	#flower_sprite.offset.x = tan(flower_sprite.skew) 
