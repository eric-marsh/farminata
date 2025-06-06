extends Area2D

@onready var droppable_output = $Output
@onready var animation_player_pulse:AnimationPlayer = $AnimationPlayerPulse

@onready var health_bar = $HealthBar

var possible_outputs: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.Sun, 
	Enum.Drop_Type.Water, 
	Enum.Drop_Type.Carrot_Seed
	]

func _ready() -> void:
	health_bar.max_value = State.max_piniata_hp
	health_bar.min_value = 0
	update_health_bar()
	
func update_health_bar(damage_amount: int = 0) -> void:
	health_bar.value = State.piniata_hp
	$HealthBar/Label.text = str(State.piniata_hp) + "/" + str(State.max_piniata_hp)
	if damage_amount == 0:
		return
	var pos = health_bar.global_position + Vector2((health_bar.size.x * (State.piniata_hp / State.max_piniata_hp)), 6)
	Util.create_explosion_particle(pos, Color.RED, damage_amount)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			hit_piniata()


#var chance_of_output: float = 0.2
var chance_of_output: float = 0.6

func hit_piniata(strength: int = 1):
	animation_player_pulse.stop(true)
	animation_player_pulse.play("pulse")
	State.piniata_hp -= strength
	update_health_bar(strength)
	
	if Util.random_chance(chance_of_output):
		create_drop()
	
	
	

var max_seed_offset: int = 4
func create_drop()->void:
	if !Globals.PlotGrid:
		return
	
	print(Globals.PlotGrid.get_total_plots() + max_seed_offset)
	
	var drop_type: Enum.Drop_Type
	for i in range(100):
		drop_type = get_random_output()
		if !DropUtil.is_seed(drop_type) or DropUtil.get_total_drops_of_type(drop_type) < Globals.PlotGrid.get_total_plots() + max_seed_offset:
			break
			
	$Output.trigger_output(drop_type, Vector2.ZERO)


func get_random_output() -> Enum.Drop_Type:
	return possible_outputs[randi() % possible_outputs.size()]

func unlock_drop_type(type: Enum.Drop_Type) -> void:
	if !possible_outputs.has(type):
		possible_outputs.push_back(type)
