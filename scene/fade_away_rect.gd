extends ColorRect

var is_fade_forwards: bool = false

func trigger_fade_to_white()->void:
	visible = true
	$"../CanvasLayer".visible = false
	is_fade_forwards = true
	$AnimationPlayer.play("fade_to_white")
	pass


func trigger_fade_back_in()->void:
	visible = true
	$"../CanvasLayer".visible = false
	$AnimationPlayer.play_backwards("fade_to_white")
	pass


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if !Globals.HelpersContainerNode:
		return
		
	if is_fade_forwards:
		Globals.Main.on_game_over()
		
		Util.quick_timer(self, 3.0, func(): 
			is_fade_forwards = false
			trigger_fade_back_in()
		)
	else:
		# back to normal
		$"../CanvasLayer".visible = true
			
