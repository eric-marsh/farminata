extends CanvasLayer
class_name canvas_layer

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
	
	
func update_money_counter():
	if Globals.Main:
		$MarginContainer/VBoxContainer/HBoxContainer/MoneyLabel.text = str(Globals.Main.money_count)
