extends Node2D
class_name plot


@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Type = Enum.Grow_Type.None

var size: Vector2 = Vector2(32, 32)

func _ready() -> void:
	size = Vector2($Dirt.texture.get_width(), $Dirt.texture.get_height())
	update_image()
	
	
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("droppable"):
		return
	apply_droppable(body)

func apply_droppable(d: droppable):
	if plot_growth_state == Enum.Plot_Growth_State.Full:
		return
	var drop_type = d.drop_type
	match drop_type:
		Enum.Drop_Type.Water:
			if plot_state == Enum.Plot_State.Dry:
				plot_state = Enum.Plot_State.Wet
				cleanup_droppable(d)

		Enum.Drop_Type.Sun:
			if plot_state == Enum.Plot_State.Wet and plot_growth_state != Enum.Plot_Growth_State.None:
				plot_state = Enum.Plot_State.Dry
				set_next_growth_state()
				cleanup_droppable(d)

		Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed:
			if plot_growth_state == Enum.Plot_Growth_State.None:
				grow_type = PlantUtil.drop_type_to_grow_type(drop_type)
				set_next_growth_state()
				cleanup_droppable(d)

		_:
			return

	update_image()

func cleanup_droppable(d: droppable) -> void:
	DropUtil.create_apply_droppable_animation(d.drop_type, d.global_position, global_position + size / 2)
	d.delete()

func reset_growth_state():
	plot_growth_state = Enum.Plot_Growth_State.None

func set_next_growth_state():
	match plot_growth_state:
		Enum.Plot_Growth_State.None:
			plot_growth_state = Enum.Plot_Growth_State.Seed
		Enum.Plot_Growth_State.Seed:
			plot_growth_state = Enum.Plot_Growth_State.Partial_1
		Enum.Plot_Growth_State.Partial_1:
			plot_growth_state = Enum.Plot_Growth_State.Partial_2
		Enum.Plot_Growth_State.Partial_2:
			plot_growth_state = Enum.Plot_Growth_State.Full
		

const PLOT_WET = preload("res://img/plot/plot_wet.png")
const PLOT_DRY = preload("res://img/plot/plot_dry.png")
const SEED = preload("res://img/plants/seed.png")

func update_image():
		match plot_state:
			Enum.Plot_State.Dry:
				$Dirt.texture = PLOT_DRY
			Enum.Plot_State.Wet:
				$Dirt.texture = PLOT_WET
		$Plant.texture = PlantUtil.get_plant_img(plot_growth_state, grow_type)
		$Plant.offset = Vector2.ZERO
		if plot_growth_state == Enum.Plot_Growth_State.Full:
			$Plant.offset = Vector2(0, -8)
		

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if plot_growth_state != Enum.Plot_Growth_State.Full:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pluck_crop(true)


func pluck_crop(clicked:bool=false):
	reset_growth_state()
	update_image()
	spawn_produce(clicked)


func spawn_produce(clicked:bool=false):
	var d
	match grow_type:
		Enum.Grow_Type.None:
			return
		Enum.Grow_Type.Carrot:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Carrot, global_position, Vector2.ZERO, Vector2.ZERO)
		Enum.Grow_Type.Onion:
			d = DropUtil.spawn_droppable(Enum.Drop_Type.Onion, global_position, Vector2.ZERO, Vector2.ZERO)
	
	if !clicked:
		# TODO: have a little hop animation
		d.start_static = true
		return
	
	if Globals.Main and !Globals.Main.is_dragging:
		d.start_dragging()
		d.start_static=true
		Globals.Main.is_dragging = true
