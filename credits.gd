extends CanvasLayer
class_name credits

@onready var margin_container = $MarginContainer
@onready var new_game_plus_button: Button = $MarginContainer/VBoxContainer/NewGamePlusButton

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
	
	var stats_text: String = (
		"💰 Total Money Made: $" + str(State.total_profit) + "\n" +
		"🌱 Seeds Planted: " + str(State.total_seeds_planted) + "\n" +
		"🗡️ Piñata Clicks: " + str(State.total_piniata_clicks) + "\n" +
		"🥇 Favorite Crop: " + str(get_favorite_crop())
	)
	stats.text = stats_text

func get_favorite_crop() -> String:
	var max_count := 0
	var max_drop_type = null
	for crop in State.total_sold_crop_types:
		if State.total_sold_crop_types[crop] > max_count:
			max_count = State.total_sold_crop_types[crop]
			max_drop_type = crop
	
	return DropUtil.get_drop_type_string(max_drop_type if max_drop_type else Enum.Drop_Type.Carrot)


func _on_new_game_plus_button_pressed() -> void:
	if Globals.SceneSwitcherNode:
		Globals.SceneSwitcherNode.start_new_game_plus()
