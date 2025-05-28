extends Node2D
class_name apply_droppable_animation

var drop_type: Enum.Drop_Type

@onready var sprite: Sprite2D = $Sprite2D 

func _ready():
	sprite.texture = DropUtil.get_drop_type_img(drop_type)
	var c = DropUtil.get_drop_type_color(drop_type)
	Util.quick_timer(self, 0.4, func():
		Util.create_explosion_particle(global_position, c)
		queue_free()
	)
