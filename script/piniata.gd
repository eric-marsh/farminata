extends Node2D
class_name piniata

@onready var droppable_output = $Output
@onready var animation_player:AnimationPlayer = $AnimationPlayerPulse

@onready var health_bar = $HealthBar

var id: int = 0

var piniata_center: Vector2 = Vector2.ZERO

var possible_outputs: Array[Enum.Drop_Type] = [
	Enum.Drop_Type.Sun, 
	Enum.Drop_Type.Water, 
	Enum.Drop_Type.Carrot_Seed
	]

func _ready() -> void:
	piniata_center = global_position
	health_bar.max_value = State.max_piniata_hp
	health_bar.min_value = 0
	
	await get_tree().create_timer(0.0001).timeout
	if Debug.PINIATA_HP > 0:
		State.array_piniata_hp[id] = Debug.PINIATA_HP
	update_health_bar()
	
	if State.array_piniata_hp[id] == 0:
		show_corpse()

var path_velocity: float = 0.0
var path_default_progress: float = 0.0
var damping: float = 1.0       # slows it down
var spring_force: float = 5.0  # pulls back to center

var play_kill_animation: bool = false
func _process(delta: float) -> void:
	if !visible or is_dead:
		return
	
	
	if play_kill_animation:
		var pos: Vector2 = piniata_center + Util.random_offset(32)
		DropUtil.create_apply_droppable_animation(get_random_death_output(), pos - Vector2(0, 16), Util.random_visible_position())
		if Globals.Main.global_timer % 5 == 0:
			piniata_particle(pos)
			if Globals.AudioNode:
				Globals.AudioNode.play_hit_piniata_sound()
	
	
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
	health_bar.value = State.array_piniata_hp[id]
	$HealthBar/Label.text = str(int(State.array_piniata_hp[id])) + "/" + str(int(State.max_piniata_hp))
	if damage_amount == 0:
		return
	var pos = health_bar.global_position + Vector2(health_bar.size.x * (float(State.array_piniata_hp[id]) / float(State.max_piniata_hp)), 6) * scale.x
	Util.create_explosion_particle(pos, Color.RED, damage_amount)

var chance_of_output: float = 0.2

func hit_piniata(strength: int = 1, pos: Vector2 = Vector2.ZERO):
	if play_kill_animation:
		return
	strength *= 1
	
	animation_player.stop(true)
	animation_player.play("pulse")
	State.array_piniata_hp[id] = max(1, State.array_piniata_hp[id] - abs(strength))
	update_health_bar(abs(strength))
	
	animate_hit(strength, pos)

	if Util.random_chance(chance_of_output * abs(strength)):
		create_drop()

func animate_hit(strength: float, pos: Vector2 = Vector2.ZERO) -> void:
	path_velocity += strength
	path_velocity = clamp(strength/10, -n, n)
	piniata_particle(pos)

func piniata_particle(pos: Vector2):
	var c = particle_colors[particle_color_index]
	particle_color_index = (particle_color_index + 1) % particle_colors.size()
	Util.create_explosion_particle(pos, c.lightened(0.5), 6, 1.9)


var num_failed_drops_in_a_row = 0
@onready var plot_message: Sprite2D = $Node2D/Sprite2D/PlotMessage

func create_drop()->void:
	var drop_type = get_random_output() 
	if drop_type == Enum.Drop_Type.X:
		num_failed_drops_in_a_row += 1
		if num_failed_drops_in_a_row > 5 and !plot_message.visible:
			plot_message.visible = true
			Util.quick_timer(self, 3.0, func():
				plot_message.visible = false
			)
			
		return
	num_failed_drops_in_a_row = 0
	plot_message.visible = false
			
	$Node2D/Output.trigger_output(drop_type, Vector2.ZERO)


var death_outputs: Array[Enum.Drop_Type] = [Enum.Drop_Type.Water, Enum.Drop_Type.Sun, Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Carrot, Enum.Drop_Type.Onion, Enum.Drop_Type.Turnip, Enum.Drop_Type.Potato, Enum.Drop_Type.Kale, Enum.Drop_Type.Radish]
func get_random_death_output() -> Enum.Drop_Type:
	return death_outputs.pick_random()


var outputed_sun_last:bool = false
func get_random_output() -> Enum.Drop_Type:
	# Use integer weights; 100 = base scale
	var drop_weights = {
		Enum.Drop_Type.Water: 300,
		Enum.Drop_Type.Sun: 300,
		Enum.Drop_Type.X: 250,
		Enum.Drop_Type.Carrot: 5,  
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
				Enum.Drop_Type.Water, Enum.Drop_Type.Sun:
					if outputed_sun_last:
						outputed_sun_last = false
						return Enum.Drop_Type.Water
					else:
						outputed_sun_last = true
						return Enum.Drop_Type.Sun
				_:
					return drop_type

	return Enum.Drop_Type.X  # fallback


func unlock_drop_type(type: Enum.Drop_Type) -> void:
	if !possible_outputs.has(type):
		possible_outputs.push_back(type)

func _on_left_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			player_hit_piniata(State.hit_strength * -1)

func _on_right_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			player_hit_piniata(State.hit_strength)


var last_attack_type = Enum.Attack_Type.Regular
var attack_types = [Enum.Attack_Type.Regular]

func player_hit_piniata(strength: float)->void:
	State.total_piniata_clicks += 1
	check_for_death(strength)
	
	if State.electric_attack_unlocked and attack_types.size() != 3:
		attack_types = [Enum.Attack_Type.Regular, Enum.Attack_Type.Fire, Enum.Attack_Type.Electric]
	if (State.fire_attack_unlocked and !State.electric_attack_unlocked) and attack_types.size() != 2:
		attack_types = [Enum.Attack_Type.Regular, Enum.Attack_Type.Fire]
	var attack_type: Enum.Attack_Type = attack_types.pop_front()
	attack_types.push_back(attack_type)
	
	var hit_position: Vector2 = get_global_mouse_position()
	var attack_strength = Util.get_attack_strength(attack_type)
	hit_piniata(attack_strength * Util.get_sign(strength), hit_position)
	Util.create_slash_animation(hit_position, strength > 0, attack_type)
	DamageNumber.display_number(str(attack_strength), hit_position, Util.get_attack_color(attack_type))
	
	if Globals.AudioNode:
		if attack_type == Enum.Attack_Type.Fire:
			Globals.AudioNode.play_pinitata_flame()
			return
		if attack_type == Enum.Attack_Type.Electric:
			Globals.AudioNode.play_pinitata_electricity()
			return
		
		Globals.AudioNode.play_hit_piniata_sound()


var death_animation_time = 5.0
func check_for_death(strength: float):
	if !play_kill_animation and State.array_piniata_hp[id] - abs(strength) <= 0:
		if Debug.FAST_CREDITS:
			death_animation_time = 0.1
		
		State.array_piniata_hp[id] = 0
		play_kill_animation = true
		animation_player.stop(true)
		animation_player.play("kill_piniata")
		Util.quick_timer(self, death_animation_time, func(): 
			if Util.is_game_over():
				Globals.Main.get_node("FadeAwayRect").trigger_fade_to_white()
				Util.quick_timer(self, death_animation_time / 2, func(): show_corpse()) 
			else:
				show_corpse()
				
		)
		update_health_bar(abs(strength))

var is_dead: bool = false
@onready var node_2d: Node2D = $Node2D
const DEAD_PINIATA = preload("res://scene/dead_piniata.tscn")
func show_corpse() -> void:
	is_dead = true
	health_bar.visible = false
	node_2d.visible = false
	var d = DEAD_PINIATA.instantiate()
	d.global_position = global_position + Vector2(-11, 118)
	Globals.Main.get_node("DeadPiniatas").add_child(d)
