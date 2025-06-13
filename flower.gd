extends Node2D

@onready var flower_sprite: Sprite2D = $FlowerSprite



func _process(_delta: float) -> void:
	animate_breeze()
	pass

func animate_breeze():
	flower_sprite.skew = Util.get_breeze_skew()
	#flower_sprite.offset.x = tan(flower_sprite.skew) 
