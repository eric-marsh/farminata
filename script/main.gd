extends Node2D
class_name MainNode

var global_timer: int = 0
var is_game_over: bool = false
var is_paused: bool = false

var max_blocks: int = 900
var is_dragging: bool = false
var dragged_droppable: droppable = null

func _ready() -> void:
	if !Debug.DONT_LOAD:
		State.load_game()
	if Debug.DELETE_SAVE:
		State.delete_save()
	
	global_timer = 0
	is_game_over = false
	is_paused = false
	
	if Debug.STARTING_MONEY > 0:
		change_money(Debug.STARTING_MONEY)
		
	if Debug.SPAWN_HATS:
		DropUtil.spawn_droppable(Enum.Drop_Type.Farm_Hat, Util.random_visible_position(), Vector2.ZERO)
		DropUtil.spawn_droppable(Enum.Drop_Type.Delivery_Hat, Util.random_visible_position(), Vector2.ZERO)
		DropUtil.spawn_droppable(Enum.Drop_Type.Attack_Hat, Util.random_visible_position(), Vector2.ZERO)


var save_timer: float = 0.0
func _process(delta: float) -> void:
	if is_paused:
		return
	global_timer += 1
	State.total_game_time += delta
	save_timer += delta
	if save_timer >= 5.0:
		State.save_game()
		save_timer = 0.0
		DropUtil.update_all_droppable_counts_and_delete()
	
	Util.update_breeze()
	
	if is_game_over:
		is_paused = false
		return

	
func _input(event):
	if Debug.DEBUG_ENABLE_DEBUGGING_KEYS and event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("ui_select") and !is_game_over:
		is_paused = !is_paused
		if is_paused and Globals.Audio:
			Globals.Audio.ship_hover_stop()
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		call_deferred("stop_dragging_droppable") 

func stop_dragging_droppable() -> void:
	if dragged_droppable:
		dragged_droppable.stop_dragging()


var can_restart_game = false
func check_game_over():
	if Globals.Player and Globals.Player.is_out_of_blocks():
		is_game_over = true
		if Globals.CanvasLayerNode:
			Globals.CanvasLayerNode.show_game_over()
		Util.quick_timer(self, 1.0, func(): can_restart_game = true)
		if Globals.Audio:
			Globals.Audio.ship_hover_stop()
	pass
	
func change_money(money_dif: int):
	if Globals.CanvasLayerNode:
		State.money += money_dif
		Globals.CanvasLayerNode.update_money_counter()
	
	# this is a really easy way to just play a noise when you buy an upgrade
	if money_dif < 0:
		if Globals.AudioNode:
			Globals.AudioNode.play_buy_upgrade_sound()
	
