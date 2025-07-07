extends Node2D

const MAIN = preload("res://scene/main.tscn")
@onready var main_menu: CanvasLayer = $MainMenu

@onready var continue_game_button: Button = $MainMenu/MarginContainer/VBoxContainer/ContinueGameButton


func _ready() -> void:
	if State.has_save_data():
		continue_game_button.visible = true
	if Debug.SKIP_MAIN_MENU:
		start_game()


func _on_continue_game_button_pressed() -> void:
	start_game()

func _on_new_game_button_pressed() -> void:
	State.delete_save()
	await get_tree().create_timer(0.1).timeout
	start_game()


func start_game() -> void:
	for c in get_children():
		c.queue_free()
	var m = MAIN.instantiate() as MainNode
	add_child(m)
	

func start_new_game_plus():
	State.reset_new_game_plus_state()
	State.save_game()
	get_tree().reload_current_scene()
	#start_game()
	
	
