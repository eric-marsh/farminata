extends Node2D
class_name plot

@onready var search_area = $SearchArea

@export var plot_state: Enum.Plot_State = Enum.Plot_State.Dry
@export var plot_growth_state: Enum.Plot_Growth_State = Enum.Plot_Growth_State.None
@export var grow_type: Enum.Grow_Type = Enum.Grow_Type.None

var size: Vector2 = Vector2(32, 32)

var assigned_helper_seed = null
var assigned_helper_water = null
var assigned_helper_sun = null

var target_seed: droppable = null
var target_water: droppable = null
var target_sun: droppable = null

func _ready() -> void:
	size = Vector2($Dirt.texture.get_width(), $Dirt.texture.get_height())
	update_image()
	
	if !Debug.DEBUG_SHOW_PLOT_STATE:
		$DebugNodes.queue_free()
	
func _process(_delta: float) -> void:
	if Debug.DEBUG_SHOW_PLOT_STATE and Globals.Main and Globals.Main.global_timer % 24 == 0:
		update_debug_nodes()
	pass


func update_debug_nodes():
	var text = ""
	text += str("Se: ", "1" if assigned_helper_seed else "0", "\n")
	text += str("w: ", "1" if assigned_helper_water else "0", "\n")
	text += str("Su: ", "1" if assigned_helper_sun else "0", "\n")
	$DebugNodes/StateLabel.text = text
	
	
	var seed_pos: Vector2 = (target_seed.global_position - global_position) if target_seed != null else size/2 
	$DebugNodes/SeedLine.set_point_position(1, seed_pos)
	var water_pos: Vector2 = (target_water.global_position - global_position) if target_water != null else size/2 
	$DebugNodes/WaterLine.set_point_position(1, water_pos)
	var sun_pos: Vector2 = (target_sun.global_position - global_position) if target_sun != null else size/2 
	$DebugNodes/SunLine.set_point_position(1, sun_pos)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("droppable"):
		return
	apply_droppable(body)

func apply_droppable(d: droppable):
	if plot_growth_state == Enum.Plot_Growth_State.Full:
		return

	

	var drop_type = d.drop_type
	
	print("*****************")
	print(d)
	print(drop_type)
	print(target_seed)
	print(assigned_helper_seed)
	match drop_type:
		Enum.Drop_Type.Water:
			if plot_state == Enum.Plot_State.Dry:
				plot_state = Enum.Plot_State.Wet
				cleanup_drop(d, drop_type, assigned_helper_water)
				target_water = null
				assigned_helper_water = null

		Enum.Drop_Type.Sun:
			if plot_state == Enum.Plot_State.Wet and plot_growth_state != Enum.Plot_Growth_State.None:
				plot_state = Enum.Plot_State.Dry
				set_next_growth_state()
				cleanup_drop(d, drop_type, assigned_helper_sun)
				target_sun = null
				assigned_helper_sun = null

		Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed:
			if plot_growth_state == Enum.Plot_Growth_State.None:
				grow_type = PlantUtil.drop_type_to_grow_type(drop_type)
				set_next_growth_state()
				
				
				cleanup_drop(d, drop_type, assigned_helper_seed)
				target_seed = null
				assigned_helper_seed = null
		_:
			return

	update_image()


func cleanup_drop(d: droppable, drop_type: Enum.Drop_Type, h:helper) -> void:
	d.delete()
	if h:
		h.remove_job()
	DropUtil.create_shrink_animation(drop_type, global_position + size / 2)
	
	

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
		d.is_dragging = true
		Globals.Main.is_dragging = true
	

func is_plot_needing_help():
	if plot_growth_state == Enum.Plot_Growth_State.Full:
		return true
	
	if assigned_helper_seed == null and target_seed and plot_growth_state == Enum.Plot_Growth_State.None:
		return true
	
	if assigned_helper_water == null and target_water and plot_state == Enum.Plot_State.Dry:
		return true
	
	if assigned_helper_sun == null and target_sun and plot_state == Enum.Plot_State.Wet:
		return true
	
	return false



func find_wanted_drops() -> void:
	if plot_growth_state == Enum.Plot_Growth_State.Full:
		return
	if target_seed == null and plot_growth_state == Enum.Plot_Growth_State.None:
		var s = search_for_drop(Enum.Drop_Type.Carrot_Seed) 
		if is_instance_valid(s):
			target_seed = s
			s.is_being_targeted = true
			if Globals.HelpersContainerNode:
				var h = Globals.HelpersContainerNode.get_inactive_helper()
				if is_instance_valid(h):
					assign_job_to_helper(h)
			
	if target_water == null and plot_state == Enum.Plot_State.Dry:
		var water =search_for_drop(Enum.Drop_Type.Water) 
		if is_instance_valid(water):
			target_water = water
			water.is_being_targeted = true
			if Globals.HelpersContainerNode:
				var h = Globals.HelpersContainerNode.get_inactive_helper()
				if is_instance_valid(h):
					assign_job_to_helper(h)
	if target_sun == null and plot_state == Enum.Plot_State.Wet:
		var sun =search_for_drop(Enum.Drop_Type.Sun) 
		if is_instance_valid(sun):
			target_sun = sun
			sun.is_being_targeted = true
			if Globals.HelpersContainerNode:
				var h = Globals.HelpersContainerNode.get_inactive_helper()
				if is_instance_valid(h):
					assign_job_to_helper(h)
	return

var assigned_helper_plucker: helper = null
func assign_job_to_helper(h: helper) -> bool:
	if !is_plot_needing_help():
		return false
	var d: droppable
	
	if !assigned_helper_plucker and plot_growth_state == Enum.Plot_Growth_State.Full:
		assigned_helper_plucker = h
		h.target_plot = self
		h.set_state(Enum.Helper_State.Pluck_Crop)
		return true
	elif !assigned_helper_seed and target_seed and plot_growth_state == Enum.Plot_Growth_State.None:
		assigned_helper_seed = h
		d = target_seed
	elif !assigned_helper_water and target_water and plot_state == Enum.Plot_State.Dry:
		assigned_helper_water = h
		d = target_water
	elif !assigned_helper_sun and target_sun and plot_state == Enum.Plot_State.Wet:
		assigned_helper_sun = h
		d = target_sun
	else:
		print("all helpers are assigned")
		return false
	if d == null:
		return false
	
	if is_instance_valid(d):
		d.is_being_targeted = true
		h.target_droppable = d
	h.target_plot = self
	h.set_state(Enum.Helper_State.Get_Item)
	return true


func get_target_drop_for_helper(h: helper):
	if h == assigned_helper_seed:
		return target_seed
	if h == assigned_helper_water:
		return target_water
	if h == assigned_helper_sun:
		return target_sun
	print("not assigned helper")
	return null

func search_for_drop(drop_type: Enum.Drop_Type) -> droppable:
	for a in search_area.get_overlapping_bodies():
		if !a is droppable or a.is_dragging or a.is_being_targeted:
			continue
		if a.drop_type != drop_type:
			continue
		
		return a
	#print("failed to find drop_type: ", DropUtil.get_drop_type_string(drop_type))
	return null
