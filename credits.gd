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
	

func start_credits() -> void:
	show_credits = true
