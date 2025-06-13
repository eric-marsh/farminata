extends Node2D
class_name plot

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Type = Enum.Grow_Type.None

var size: Vector2 = Vector2(32, 32)

func _ready() -> void:
	size = Vector2($Dirt.texture.get_width(), $Dirt.texture.get_height())
	update_image()
	animation_player.play("popup_crop")
	
	
func _process(_delta: float) -> void:
	animate_breeze()


func animate_breeze():
	$Plant.skew = Util.get_breeze_skew()
	$Plant.offset.x = tan($Plant.skew) * 8



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
			grow_type = PlantUtil.drop_type_to_grow_type(d.drop_type)
			set_next_growth_state()
			cleanup_droppable(d)
			update_image()
		return
	
	if d.drop_type == Enum.Drop_Type.Water:
		if plot_state == Enum.Plot_State.Dry:
			plot_state = Enum.Plot_State.Wet
			cleanup_droppable(d)
			update_image()
		return
	
	if d.drop_type == Enum.Drop_Type.Sun:
		if plot_state == Enum.Plot_State.Wet and plot_growth_state != Enum.Plot_Growth_State.None:
			plot_state = Enum.Plot_State.Dry
			set_next_growth_state()
			cleanup_droppable(d)
			update_image()
		return

func cleanup_droppable(d: droppable) -> void:
	DropUtil.create_apply_droppable_animation(d.drop_type, d.global_position, global_position)
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
			animation_player.play("grow_crop")
			animation_player.speed_scale = 0.5

func done_growing()->void:
	var stage = PlantUtil.PLANT_IMAGES[grow_type][growth_stage_index]
	plot_growth_state = stage.state
	growth_stage_index += 1
	is_growing = false
	update_image()
	animation_player.play("pulse_crop")

func is_full_grown() -> bool:
	return PlantUtil.PLANT_IMAGES[grow_type].size() == growth_stage_index

const PLOT_WET = preload("res://img/plot/plot_wet.png")
const PLOT_DRY = preload("res://img/plot/plot_dry.png")
const SEED = preload("res://img/plants/seed.png")

func update_image():
		match plot_state:
			Enum.Plot_State.Dry:
				$Dirt.texture = PLOT_DRY
			Enum.Plot_State.Wet:
				$Dirt.texture = PLOT_WET
		if !is_growing:
			$Plant.texture = PlantUtil.get_plant_img(plot_growth_state, grow_type)
			$Plant.offset = Vector2(0, -4)
			if plot_growth_state == Enum.Plot_Growth_State.Full:
				$Plant.offset = Vector2(0, -13)

var is_plucking: bool = false
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if plot_growth_state != Enum.Plot_Growth_State.Full:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			animation_player.play("pluck_crop")
			is_plucking = true
		else:
			animation_player.stop()
			is_plucking = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.speed_scale = 1.0
	$Plant.scale = Vector2.ONE
	if anim_name == "pluck_crop":
		if is_plucking:
			pluck_crop(true)
		return
	if anim_name == "grow_crop":
		is_growing = false
		done_growing()
		return
	if anim_name == "popup_crop":
		Util.create_explosion_particle(global_position - Vector2(0,8), Color.html("#806359"), 6, 1.1)
		return
	if anim_name == "pulse_crop":
		return

func pluck_crop(clicked:bool=false):
	reset_growth_state()
	update_image()
	spawn_produce(clicked)

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


var is_mouse_over: bool = false
func _on_area_2d_mouse_entered() -> void:
	is_mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	if is_plucking:
		is_mouse_over = false
		is_plucking = false
		animation_player.stop()
