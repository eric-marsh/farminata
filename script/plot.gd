extends Node2D
class_name plot

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Type = Enum.Grow_Type.None

var size: Vector2 = Vector2(32, 32)

#var grass_scale_speed: float = 0.2
var grass_scale_speed: float = 1.1

@onready var grass = $Grass
@onready var dirt = $Dirt
@onready var plant: Sprite2D = $Plant
@onready var shadow: Sprite2D = $Plant/Shadow


var target_helper: helper = null

func _ready() -> void:
	size = Vector2(dirt.texture.get_width(), dirt.texture.get_height())
	update_image()
	animation_player.play("popup_crop")
	
	grass.flip_h = Util.random_chance(0.5)
	dirt.flip_h = Util.random_chance(0.5)
	plant.flip_h = Util.random_chance(0.5)
	shadow.flip_h = plant.flip_h
	
	if Debug.SWAY_RAND_DIR:
		skew_dir = Util.rnd_sign() * skew_dir
	if Debug.SWAY_RAND_START:
		current_skew = Util.rng.randf_range(-0.15, 0.15)

func _process(delta: float) -> void:
	if !is_growing:
		animate_breeze()
	
	if grass.visible and grass.scale < State.target_grass_scale:
		grass.scale = grass.scale.lerp(State.target_grass_scale, delta * grass_scale_speed)
		# Snap to target if close enough
		if grass.scale.distance_to(State.target_grass_scale) < 0.01:
			grass.scale = State.target_grass_scale
		grass.offset = Vector2(0, -8) + (grass.scale * Vector2(0, 1))


var current_skew: float = 0.0
var skew_dir: float = 0.001

func update_breeze():
	if abs(current_skew) > 0.15:
		skew_dir *= -1
	current_skew += skew_dir

func animate_breeze():
	update_breeze()
	plant.skew = current_skew
	plant.offset.x = tan(plant.skew) * 8
	shadow.offset.x = plant.offset.x



func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("droppable"):
		return
	apply_droppable(body)

var is_droppable_being_applied: bool = false
func apply_droppable(d: droppable) -> void:
	if is_droppable_being_applied or is_growing or plot_growth_state == Enum.Plot_Growth_State.Full:
		return
	is_droppable_being_applied = true
	
	# i think i can get rid of this
	Util.quick_timer(self, 0.5, func():
		is_droppable_being_applied = false
		)
	
	if 	DropUtil.is_seed(d.drop_type):
		if plot_growth_state == Enum.Plot_Growth_State.None:
			State.total_seeds_planted += 1
			grow_type = PlantUtil.drop_type_to_grow_type(d.drop_type)
			var prev_plot_state = plot_state
			set_next_growth_state()
			target_helper = null
			plot_state = prev_plot_state # TODO: do this the right way
			cleanup_droppable(d)
			update_image()
			
			if Globals.AudioNode:
				Globals.AudioNode.play_apply_droppable_sound()
			
			dirt.scale = Vector2.ONE
			grass.visible = true
		return
	
	if d.drop_type == Enum.Drop_Type.Water:
		if plot_state == Enum.Plot_State.Dry:
			plot_state = Enum.Plot_State.Wet
			if Globals.AudioNode:
				Globals.AudioNode.play_apply_droppable_sound()
			
			target_helper = null
			cleanup_droppable(d)
			update_image()
		return
	
	if d.drop_type == Enum.Drop_Type.Sun:
		if plot_state == Enum.Plot_State.Wet and plot_growth_state != Enum.Plot_Growth_State.None:
			#plot_state = Enum.Plot_State.Dry
			if Globals.AudioNode:
				Globals.AudioNode.play_grass_sound()
			set_next_growth_state()
			target_helper = null
			cleanup_droppable(d)
			update_image()
		return



func cleanup_droppable(d: droppable) -> void:
	DropUtil.create_apply_droppable_animation(d.drop_type, d.global_position, global_position - Vector2(0, 8))
	d.delete()

func reset_growth_state():
	plot_growth_state = Enum.Plot_Growth_State.None
	growth_stage_index = 0


var is_growing:bool = false
var growth_stage_index: int = 0
func set_next_growth_state():
	if !is_full_grown():
		if growth_stage_index == 0:
			done_growing()
			return
		else:
			is_growing = true
			plot_state = Enum.Plot_State.Grow
			play_grow_animation(PlantUtil.get_grow_type_grow_time(grow_type))
			if Globals.AudioNode:
				Globals.AudioNode.play_start_grow_sound()

func play_grow_animation(duration: float):
	var original_duration := 10.0  # The length your animation was authored for
	var speed := original_duration / duration
	animation_player.speed_scale  = speed
	animation_player.play("grow_crop")

func done_growing()->void:
	var stage = PlantUtil.PLANT_IMAGES[grow_type][growth_stage_index]
	plot_growth_state = stage.state
	growth_stage_index += 1
	is_growing = false
	plot_state = Enum.Plot_State.Dry
	update_image()
	animation_player.play("pulse_crop")
	
	if Globals.AudioNode:
		Globals.AudioNode.play_done_grow_sound()

func is_full_grown() -> bool:
	return PlantUtil.PLANT_IMAGES[grow_type].size() == growth_stage_index

const PLOT_WET = preload("res://img/plot/plot_wet.png")
const PLOT_DRY = preload("res://img/plot/plot_dry.png")
const PLOT_GROW = preload("res://img/plot/plot_grow.png")
const SEED = preload("res://img/plants/seed.png")




func update_image():
		match plot_state:
			Enum.Plot_State.Dry:
				dirt.texture = PLOT_DRY
			Enum.Plot_State.Wet:
				dirt.texture = PLOT_WET
			Enum.Plot_State.Grow:
				dirt.texture = PLOT_GROW
		if !is_growing:
			plant.texture = PlantUtil.get_plant_img(plot_growth_state, grow_type)
			shadow.texture = plant.texture
			plant.offset = Vector2(0, -4)
			if plot_growth_state == Enum.Plot_Growth_State.Full:
				plant.offset = Vector2(0, -13)
			shadow.offset = plant.offset




var is_plucking: bool = false
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if plot_growth_state != Enum.Plot_Growth_State.Full:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !Globals.Main.is_dragging:
		if event.pressed:
			animation_player.play("pluck_crop")
			is_plucking = true
			get_viewport().set_input_as_handled()
		else:
			animation_player.stop()
			is_plucking = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	plant.scale = Vector2.ONE
	animation_player.speed_scale = 1
	if anim_name == "pluck_crop":
		if is_plucking:
			pluck_crop(true)
	if anim_name == "grow_crop":
		is_growing = false
		plot_state = Enum.Plot_State.Dry
		plant.rotation = 0
		done_growing()
	if anim_name == "popup_crop":
		Util.create_explosion_particle(global_position - Vector2(0,8), Color(Color.html("#806359"), 0.7), 6, 1.0)
		grass.visible = true
		if State.num_plots == 1:
			animation_player.play("pulse_tutorial")
	if anim_name == "pulse_tutorial":
		animation_player.play("pulse_tutorial")
		return
	if anim_name == "pulse_crop":
		return

func pluck_crop(clicked:bool=false):
	reset_growth_state()
	update_image()
	spawn_produce(clicked)
	if Globals.AudioNode:
		Globals.AudioNode.play_pluck_sound()

static var flip_horiz = false
func spawn_produce(clicked:bool=false):
	var d: droppable
	
	match grow_type:
		Enum.Grow_Type.None:
			return
		Enum.Grow_Type.Carrot:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Carrot, global_position, Vector2.ZERO, Vector2.ZERO)
		Enum.Grow_Type.Onion:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Onion, global_position, Vector2.ZERO, Vector2.ZERO)
		Enum.Grow_Type.Turnip:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Turnip, global_position, Vector2.ZERO, Vector2.ZERO)
		Enum.Grow_Type.Potato:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Potato, global_position, Vector2.ZERO, Vector2.ZERO)
		Enum.Grow_Type.Kale:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Kale, global_position, Vector2.ZERO, Vector2.ZERO)
		Enum.Grow_Type.Radish:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Radish, global_position, Vector2.ZERO, Vector2.ZERO)
	d.get_node("Sprite2D").flip_h = flip_horiz
	d.get_node("Sprite2D/Shadow").flip_h = flip_horiz
	flip_horiz = !flip_horiz
	
	if !clicked:
		# TODO: have a little hop animation
		d.start_static = true
		return
	
	if Globals.Main and !Globals.Main.is_dragging:
		d.start_dragging()
		d.start_static=true
		Globals.Main.is_dragging = true
