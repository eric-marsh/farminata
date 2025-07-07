extends CanvasLayer
class_name credits

@onready var margin_container = $MarginContainer

var show_credits: bool = false

var speed: float = 0.4
func _ready():
	margin_container.global_position = Vector2(0, 400)
	self.visible = false
	
func _process(delta):
	if !show_credits:
		return
	self.visible = true
	
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
