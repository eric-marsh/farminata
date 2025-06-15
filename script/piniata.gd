extends Node2D

@onready var droppable_output = $Output
@onready var animation_player:AnimationPlayer = $AnimationPlayerPulse

@onready var health_bar = $HealthBar

var piniata_center: Vector2 = Vector2.ZERO

var possible_outputs: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.Sun, 
	Enum.Drop_Type.Water, 
	Enum.Drop_Type.Carrot_Seed
	]
	
func is_piniata_dead() -> bool:
	return !visible

func _ready() -> void:
	piniata_center = global_position
	health_bar.max_value = State.max_piniata_hp
	health_bar.min_value = 0
	
	if Debug.PINIATA_HP > 0:
		State.piniata_hp = Debug.PINIATA_HP
	update_health_bar()

var path_velocity: float = 0.0
var path_default_progress: float = 0.0
var damping: float = 1.0       # slows it down
var spring_force: float = 5.0  # pulls back to center

var play_kill_animation: bool = false
func _process(delta: float) -> void:
	if !visible:
		return
	
	
	
	if play_kill_animation and Globals.Main.global_timer % 5 == 0:
		var pos: Vector2 = piniata_center + Util.random_offset(32)
		piniata_particle(pos)
		DropUtil.create_apply_droppable_animation(get_random_output(), pos - Vector2(0, 16), Util.random_visible_position())
	
	
	piniata_center = $Node2D/Output.global_position
	var displacement = $Node2D.rotation - path_default_progress

	# spring + damping motion
	var acceleration = -displacement * spring_force - path_velocity * damping
	path_velocity += acceleration * delta
	$Node2D.rotation += path_velocity * delta
	
	# clamp to [0.0, 1.0] to stay on path
	$Node2D.rotation = clamp($Node2D.rotation, -360.0, 360.0)
	
var n = 1	
var particle_color_index=0
var particle_colors = [
	Color.html("#ff55ff"),
	Color.html("#ffff55"),
	Color.html("#55ffff"),
]


	
func update_health_bar(damage_amount: int = 0) -> void:
	health_bar.value = State.piniata_hp
	$HealthBar/Label.text = str(int(State.piniata_hp)) + "/" + str(int(State.max_piniata_hp))
	if damage_amount == 0:
		return
	var pos = health_bar.global_position + Vector2((health_bar.size.x * (State.piniata_hp / State.max_piniata_hp)), 6)
	Util.create_explosion_particle(pos, Color.RED, damage_amount)

var chance_of_output: float = 0.2
#var chance_of_output: float = 0.6

func hit_piniata(strength: int = 1, pos: Vector2 = Vector2.ZERO):
	if play_kill_animation:
		return
	strength *= 1
	
	animation_player.stop(true)
	animation_player.play("pulse")
	State.piniata_hp = max(1, State.piniata_hp - abs(strength))
	update_health_bar(abs(strength))
	
	animate_hit(strength, pos)
	
	if Util.random_chance(chance_of_output):
		create_drop()

func animate_hit(strength: float, pos: Vector2 = Vector2.ZERO) -> void:
	path_velocity += strength
	path_velocity = clamp(strength/10, -n, n)
	piniata_particle(pos)

func piniata_particle(pos: Vector2):
	var c = particle_colors[particle_color_index]
	particle_color_index = (particle_color_index + 1) % particle_colors.size()
	Util.create_explosion_particle(pos, c.lightened(0.5), 6, 1.9)

func create_drop()->void:
	var drop_type = get_random_output() 
	if drop_type == Enum.Drop_Type.X:
		return
			
	$Node2D/Output.trigger_output(drop_type, Vector2.ZERO)

func get_random_output() -> Enum.Drop_Type:
	# Use integer weights; 100 = base scale
	var drop_weights = {
		Enum.Drop_Type.Water: 300,
		Enum.Drop_Type.Sun: 300,
		Enum.Drop_Type.X: 250,
		Enum.Drop_Type.Carrot: 20,  
	}

	var filtered_weights := {}

	for drop_type in drop_weights.keys():
		if drop_type in [Enum.Drop_Type.Water, Enum.Drop_Type.Sun]:
			var too_much = DropUtil.get_total_drops_of_type(drop_type) >= State.num_plots * 3
			if not too_much:
				filtered_weights[drop_type] = drop_weights[drop_type]
		else:
			filtered_weights[drop_type] = drop_weights[drop_type]

	if filtered_weights.is_empty():
		return Enum.Drop_Type.X

	var total_weight = 0
	for weight in filtered_weights.values():
		total_weight += weight

	var choice = randi() % total_weight
	var cumulative = 0
	for drop_type in filtered_weights.keys():
		cumulative += filtered_weights[drop_type]
		if choice < cumulative:
			match drop_type:
				Enum.Drop_Type.X:
					var s = DropUtil.get_highest_seed_within_limit()
					return s if s != null else Enum.Drop_Type.X
				Enum.Drop_Type.Carrot:
					var rand_seed = State.unlocked_slot_outputs.pick_random()
					return DropUtil.get_produce_from_seed(rand_seed if rand_seed else Enum.Drop_Type.Carrot_Seed)
				_:
					return drop_type

	return Enum.Drop_Type.X  # fallback


func unlock_drop_type(type: Enum.Drop_Type) -> void:
	if !possible_outputs.has(type):
		possible_outputs.push_back(type)

func _on_left_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			check_for_gameover(State.hit_strength)
			hit_piniata(State.hit_strength * -1, get_global_mouse_position())
			Util.create_slash_animation(get_global_mouse_position(), false)

func _on_right_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			check_for_gameover(State.hit_strength)
			hit_piniata(State.hit_strength, get_global_mouse_position())
			Util.create_slash_animation(get_global_mouse_position(), true)
			

func check_for_gameover(strength: float):
	if !play_kill_animation and State.piniata_hp - abs(strength) <= 0:
		State.piniata_hp = 0
		play_kill_animation = true
		animation_player.stop(true)
		animation_player.play("kill_piniata")
		Util.quick_timer(self, 5.0, func(): $"../FadeAwayRect".trigger_fade_to_white())
		update_health_bar(abs(strength))
		
