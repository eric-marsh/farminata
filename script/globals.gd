extends Node
class_name globals

var Main = null

func _ready():
	reset_nodes()
	
func _process(delta: float) -> void:
	if !is_instance_valid(Main):
		reset_nodes()

func reset_nodes():
	Main = get_node("/root/SceneSwitcher/Main")
