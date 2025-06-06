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
	$HealthBar/Label.text = str(int(State.piniata_hp)) + "/" + str(int(State.max_piniata_hp))
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

func create_drop()->void:
	if !Globals.PlotGrid:
		return
	 
	
	var drop_type = get_random_output() 
	if drop_type == Enum.Drop_Type.X:
		return
			
	$Output.trigger_output(drop_type, Vector2.ZERO)


func get_random_output() -> Enum.Drop_Type:
	var weighted_drops: Array[Enum.Drop_Type] = [
		Enum.Drop_Type.Water,
		Enum.Drop_Type.Water,
		Enum.Drop_Type.Water,
		Enum.Drop_Type.Sun,
		Enum.Drop_Type.Sun,
		Enum.Drop_Type.X  # placeholder for best seed
	]
	var result = weighted_drops[randi() % weighted_drops.size()]
	if result == Enum.Drop_Type.X:
		var seed = DropUtil.get_best_possible_seed()
		return null if seed == Enum.Drop_Type.X else seed
	return result

func unlock_drop_type(type: Enum.Drop_Type) -> void:
	if !possible_outputs.has(type):
		possible_outputs.push_back(type)
