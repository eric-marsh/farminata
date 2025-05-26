extends Node2D
class_name plot

@onready var search_area = $SearchArea

@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Types = Enum.Grow_Types.None

var size: Vector2 = Vector2(32, 32)

func _ready() -> void:
	size = Vector2($Dirt.texture.get_width(), $Dirt.texture.get_height())
	update_image()
	
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("droppable"):
		return
	apply_droppable(body)

#{ Blurry, X, Water, Sun, Carrot_Seed }
func apply_droppable(d: droppable):
	if plot_growth_state == Enum.Plot_Growth_State.Full:
		return
	match d.drop_type:
		Enum.Drop_Type.Water:
			if plot_state == Enum.Plot_State.Dry:
				plot_state = Enum.Plot_State.Wet
				d.delete()
		Enum.Drop_Type.Sun:
			if plot_state == Enum.Plot_State.Wet and plot_growth_state != Enum.Plot_Growth_State.None:
				plot_state = Enum.Plot_State.Dry
				set_next_growth_state()
				d.delete()
		Enum.Drop_Type.Carrot_Seed:
			if plot_growth_state == Enum.Plot_Growth_State.None:
				grow_type = Enum.Grow_Types.Carrot
				set_next_growth_state()
				d.delete()
		_:
			return
	update_image()
	
	

func reset_growth_state():
	plot_growth_state = Enum.Plot_Growth_State.None

func set_next_growth_state():
	print("Next Growth State")
	match plot_growth_state:
		Enum.Plot_Growth_State.None:
			plot_growth_state = Enum.Plot_Growth_State.Seed
		Enum.Plot_Growth_State.Seed:
			plot_growth_state = Enum.Plot_Growth_State.Partial_1
		Enum.Plot_Growth_State.Partial_1:
			plot_growth_state = Enum.Plot_Growth_State.Partial_2
		Enum.Plot_Growth_State.Partial_2:
			plot_growth_state = Enum.Plot_Growth_State.Full
	
	assigned_helper_seed = null
	assigned_helper_water = null
	assigned_helper_sun = null

const PLOT_WET = preload("res://img/plot/plot_wet.png")
const PLOT_DRY = preload("res://img/plot/plot_dry.png")
const SEED = preload("res://img/plants/seed.png")
const CARROT = preload("res://img/plants/carrot/carrot.png")
const SAPLING_1 = preload("res://img/plants/carrot/sapling_1.png")
const SAPLING_2 = preload("res://img/plants/carrot/sapling_2.png")
const SAPLING_FINAL = preload("res://img/plants/carrot/sapling_final.png")

#enum Plot_Growth_State { None, Seed, Partial_1, Partial_2, Full }
func update_image():
		match plot_state:
			Enum.Plot_State.Dry:
				$Dirt.texture = PLOT_DRY
			Enum.Plot_State.Wet:
				$Dirt.texture = PLOT_WET
		
		match plot_growth_state:
			Enum.Plot_Growth_State.None:
				$Plant.texture = null
				$Plant.offset = Vector2.ZERO
			Enum.Plot_Growth_State.Seed:
				$Plant.texture = SEED
				$Plant.offset = Vector2.ZERO
			Enum.Plot_Growth_State.Partial_1:
				$Plant.texture = SAPLING_1
				$Plant.offset = Vector2.ZERO
			Enum.Plot_Growth_State.Partial_2:
				$Plant.texture = SAPLING_2
				$Plant.offset = Vector2.ZERO
			Enum.Plot_Growth_State.Full:
				$Plant.texture = SAPLING_FINAL
				$Plant.offset = Vector2(0, -8)
				

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if plot_growth_state != Enum.Plot_Growth_State.Full:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			reset_growth_state()
			update_image()
			spawn_produce()
			
			
func spawn_produce():
	var d
	print(grow_type)
	match grow_type:
		Enum.Grow_Types.None:
			return
		Enum.Grow_Types.Carrot:
			print("Carrot")
			d = Util.spawn_droppable(Enum.Drop_Type.Carrot, global_position, Vector2.ZERO, Vector2.ZERO)
			d.is_produce = true
			
	if Globals.Main and !Globals.Main.is_dragging:
		d.is_dragging = true
		Globals.Main.is_dragging = true


var assigned_helper_seed = null
var assigned_helper_water = null
var assigned_helper_sun = null
func assign_job_to_helper(h: helper) -> bool:
	var d: droppable
	if plot_growth_state == Enum.Plot_Growth_State.Full:
		return false
	if plot_growth_state == Enum.Plot_Growth_State.None:
		d = search_for_drop(Enum.Drop_Type.Carrot_Seed) 
		assigned_helper_seed = null if d == null else h
	if plot_state == Enum.Plot_State.Dry:
		print("Dry")
		d = search_for_drop(Enum.Drop_Type.Water) 
		assigned_helper_water = null if d == null else h
	if plot_state == Enum.Plot_State.Wet:
		d = search_for_drop(Enum.Drop_Type.Sun) 
		assigned_helper_sun = null if d == null else h
	if d == null:
		print("d is null")
		return false
	
	d.is_being_targeted = true
	h.target_droppable = d
	h.target_plot = self
	return true


func search_for_drop(drop_type: Enum.Drop_Type) -> droppable:
	for a in search_area.get_overlapping_bodies():
		if !a is droppable or a.is_dragging or a.is_being_targeted:
			continue
		if a.drop_type != drop_type:
			print(Util.get_drop_type_string(a.drop_type))
			continue
		
		return a
	return null
