extends ColorRect

var is_fade_forwards: bool = false

var amount_of_white_screen_time: float = 3.0
func _ready() -> void:
		if Debug.FAST_CREDITS:
			get_node("AnimationPlayer").speed_scale = 5.0
			amount_of_white_screen_time = 0.1
		pass

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
		
		Util.quick_timer(self, amount_of_white_screen_time, func(): 
			is_fade_forwards = false
			trigger_fade_back_in()
		)
	else:
		# back to normal
		$"../CanvasLayer".visible = true
			
