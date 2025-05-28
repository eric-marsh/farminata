extends Area2D

@onready var droppable_output = $Output

var hp: int = State.piniata_hp

var possible_outputs: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.Sun, 
	Enum.Drop_Type.Water, 
	Enum.Drop_Type.Carrot_Seed
	]

func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			hit_piniata()

func hit_piniata(strength: float = 1):
	var drop_type: Enum.Drop_Type = get_random_output()
	$Output.trigger_output(drop_type, Vector2.ZERO)
	hp -= strength
	
func get_random_output() -> Enum.Drop_Type:
	return possible_outputs[randi() % possible_outputs.size()]
