extends CanvasLayer
class_name credits

@onready var margin_container = $MarginContainer
@onready var new_game_plus_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NewGamePlusButton


var show_credits: bool = false

var speed: float = 0.4
func _ready():
	margin_container.global_position = Vector2(0, 400)
	self.visible = false
	new_game_plus_button.text = "New Game+"
	for i in range(State.num_games_won):
		new_game_plus_button.text += "+"
	if State.num_games_won >= State.max_games:
		new_game_plus_button.visible = false
		$MarginContainer/VBoxContainer/NEWGAMEPLUSOVER.visible = true
		$MarginContainer/Graveyard.visible = true
	
	if Debug.FAST_CREDITS:
		speed = 5.0
	
func _process(delta):
	if !show_credits:
		return
	self.visible = true
	Globals.CanvasLayerNode.visible = false
	
	if margin_container.global_position.y > 0:
		margin_container.global_position.y = max(0, margin_container.global_position.y - speed)
	

@onready var stats = $MarginContainer/VBoxContainer/STATS
func start_credits() -> void:
	show_credits = true
	
	var hours = str(int(floor(State.total_game_time / 3600.0))).pad_zeros(2)
	var minutes = str(int((floor(State.total_game_time) as int % 3600) / 60)).pad_zeros(2)
	var seconds = str(int(floor(State.total_game_time) as int % 60)).pad_zeros(2)
	
	var stats_text: String = (
		"Total Time: " + str(hours,":",minutes,":",seconds) + "\n" +
		"Money Made: $" + str(State.total_profit) + "\n" +
		"Seeds Planted: " + str(State.total_seeds_planted) + "\n" +
		"Farmiñata Clicks: " + str(State.total_piniata_clicks) + "\n" +
		"Favorite Crop: " + str(get_favorite_crop())
	)
	stats.text = stats_text




func get_favorite_crop() -> String:
	var max_count := 0
	var max_drop_type = Enum.Drop_Type.Carrot
	for crop in State.total_sold_crop_types:
		if State.total_sold_crop_types[crop] > max_count:
			max_count = State.total_sold_crop_types[crop]
			max_drop_type = crop
	
	print(max_drop_type)
	return DropUtil.get_drop_type_string(max_drop_type as Enum.Drop_Type)


func _on_new_game_plus_button_pressed() -> void:
	if Globals.SceneSwitcherNode:
		Globals.SceneSwitcherNode.start_new_game_plus()


func _on_continue_playing_pressed() -> void:
	show_credits = false
	visible = false

	if Globals.Main and Globals.CanvasLayerNode:
		Globals.Main.start_raining = true
		Globals.CanvasLayerNode.visible = true
		if !State.has_given_bonus:
			State.has_given_bonus = true
			Globals.Main.change_money(500)
			var pos = get_viewport().get_visible_rect().size / 2 - Vector2(64, 120)
			DamageNumber.display_money_get(str(500), pos, Color.GREEN)
