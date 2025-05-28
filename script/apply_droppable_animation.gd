extends Node2D
class_name apply_droppable_animation

var drop_type: Enum.Drop_Type

@onready var sprite: Sprite2D = $Sprite2D 
@onready var particle: CPUParticles2D = $ExplosionParticle 

func _ready():
	sprite.texture = DropUtil.get_drop_type_img(drop_type)
	var c = DropUtil.get_drop_type_color(drop_type)
	particle.color = c.lightened(0.5)
	particle.one_shot = true
	Util.quick_timer(self, 0.4, func():
		particle.emitting = true
	)
	

func _on_explosion_particle_finished() -> void:
	queue_free()
