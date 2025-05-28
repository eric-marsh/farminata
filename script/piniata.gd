extends Area2D

@onready var droppable_output = $Output
@onready var animation_player_pulse:AnimationPlayer = $AnimationPlayerPulse

var hp: int = State.piniata_hp

var possible_outputs: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.Sun, 
	Enum.Drop_Type.Water, 
	Enum.Drop_Type.Carrot_Seed
	]

func _ready() -> void:
	pass
	
	
func _process(_delta: float) -> void:
	pass


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			hit_piniata()


var chance_of_output: float = 0.1

func hit_piniata(strength: int = 1):
	animation_player_pulse.stop(true)
	animation_player_pulse.play("pulse")
	hp -= strength
	
	if Util.random_chance(chance_of_output):
		var drop_type: Enum.Drop_Type = get_random_output()
		$Output.trigger_output(drop_type, Vector2.ZERO)
	
	
func get_random_output() -> Enum.Drop_Type:
	return possible_outputs[randi() % possible_outputs.size()]
