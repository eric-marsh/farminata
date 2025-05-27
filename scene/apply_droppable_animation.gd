extends Node2D
class_name apply_droppable_animation

func _ready():
	pass
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
	pass # Replace with function body.
