extends CharacterBody2D
class_name helper

@export var id: int = 0
@export var id_of_type: int = 0
@export var helper_type: Enum.Helper_Type = Enum.Helper_Type.Seed
@onready var anim = $AnimatedSprite2D 

var target_droppable: droppable = null
var target_plot: plot = null

var held_droppable: droppable = null

var state: Enum.Helper_State = Enum.Helper_State.Idle
var dir: Enum.Dir = Enum.Dir.Down
var target_pos: Vector2 = Vector2.ZERO
var speed:int = 40

var min_velocity: Vector2 = Vector2(-speed, -speed)
var max_velocity: Vector2 = Vector2(speed, speed)
var state_timer_set: bool = false

func _ready() -> void:
	await get_tree().create_timer(0.001).timeout
	
	#set_state(Enum.Helper_State.Get_Item)
	set_state(Enum.Helper_State.Idle)
	update_animation()
	
	$AnimatedSprite2D.modulate = Util.get_color_from_helper_type(helper_type).lightened(0.4)
	
	if Debug.Helper_Speed > 0:
		speed = Debug.Helper_Speed
		min_velocity = Vector2(-speed, -speed)
		max_velocity = Vector2(speed, speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()
	
func _physics_process(_delta: float) -> void:
	var has_reached_target:bool = move_to_target()
	if has_reached_target:
		on_reaching_target_pos()
	
	if state == Enum.Helper_State.Get_Item and !is_instance_valid(target_droppable):
		set_state(Enum.Helper_State.Idle)
		return
	
	if state == Enum.Helper_State.Wander and Globals.Main and Globals.Main.global_timer % 20 == 0:
		check_for_tasks_to_do()
	
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = str(Util.get_helper_state_string(state), "\n", Util.get_helper_type_string(helper_type), " 1" if held_droppable != null else " 0")


func on_idle() -> void:
	if held_droppable:
		var p = find_plot_for_droppable(held_droppable)
		if p:
			target_plot = p
			target_pos = target_plot.global_position + target_plot.size / 2
			set_state(Enum.Helper_State.Deliver_Item)
			return
	else:
		var d = find_droppable_based_on_helper_type()
		if d:
			target_droppable = d
			set_state(Enum.Helper_State.Get_Item)
			return
		
	set_state(Enum.Helper_State.Wander)

func on_plucker_idle() -> void:
	if !held_droppable:
		# first, check for any produce on the ground
		var d = find_droppable_based_on_helper_type()
		if d:
			target_droppable = d
			set_state(Enum.Helper_State.Get_Item)
			return
		# otherwise, check for pluckable plot
		var p:plot = Globals.PlotGrid.get_plot_that_needs_plucking()
		if p:
			target_plot = p
			target_pos = target_plot.global_position + target_plot.size / 2
			set_state(Enum.Helper_State.Pluck_Crop)
			return
	set_state(Enum.Helper_State.Wander)

func check_for_tasks_to_do() -> void:
	if helper_type == Enum.Helper_Type.Pluck:
		on_plucker_idle()
	else:
		on_idle()

func set_state(s: Enum.Helper_State) -> void:
	state = s
	match(state):
		Enum.Helper_State.Idle:
			check_for_tasks_to_do()
		Enum.Helper_State.Wander:
			target_pos = Util.random_visible_position()
		Enum.Helper_State.Get_Item:
			pass
		Enum.Helper_State.Deliver_Item:
			if helper_type == Enum.Helper_Type.Pluck and Globals.SellChestNode:
				target_pos = Globals.SellChestNode.global_position + Vector2(32,-32)
				return
				#if is_held_item_produce and Globals.SellChestNode:
			if Globals.PlotGrid:
				var p = find_plot_for_droppable(held_droppable)
				if p:
					target_plot = p
					target_pos = target_plot.global_position + target_plot.size / 2
					return
			# finding plot failed. Wander until a new one comes up
			set_state(Enum.Helper_State.Wander)
		Enum.Helper_State.Pluck_Crop:
			$HeldItem.visible = false
			target_pos = target_plot.global_position + target_plot.size / 2
		_:
			pass


func on_reaching_target_pos() -> void:
	match(state):
		Enum.Helper_State.Idle:
			print("This should happen: Reached target as Idle")
			return
		Enum.Helper_State.Wander:
			set_state(Enum.Helper_State.Idle) # helper checks for items when idle
		Enum.Helper_State.Get_Item:
			pick_up_droppable(target_droppable)
			set_state(Enum.Helper_State.Deliver_Item)
			return
		Enum.Helper_State.Deliver_Item:
			if !is_instance_valid(held_droppable):
				target_plot = null
				held_droppable = null
				$HeldItem.visible = false
				set_state(Enum.Helper_State.Idle)
				return
			$HeldItem.visible = false
			var d = DropUtil.spawn_droppable(held_droppable.drop_type, target_pos, Vector2.ZERO)
			d.start_static = true
			d.is_delivered = true
			target_plot = null
			held_droppable.delete()
			held_droppable = null
			set_state(Enum.Helper_State.Idle)
			pass	
		Enum.Helper_State.Pluck_Crop:
			target_plot.pluck_crop()
			target_plot = null
			set_state(Enum.Helper_State.Idle)
		_:
			pass

func find_droppable_based_on_helper_type() -> droppable:
	if !Globals.DropsNode:
		return null
	var d: droppable = null
	match(helper_type):
		Enum.Helper_Type.Seed:
			d = Globals.DropsNode.get_droppable_of_type(Enum.Drop_Type.Carrot_Seed) #TODO: onion Seed
		Enum.Helper_Type.Water:
			d = Globals.DropsNode.get_droppable_of_type(Enum.Drop_Type.Water)
		Enum.Helper_Type.Sun:
			d = Globals.DropsNode.get_droppable_of_type(Enum.Drop_Type.Sun)
		Enum.Helper_Type.Pluck:
			d = Globals.DropsNode.get_droppable_of_type(Enum.Drop_Type.Carrot) #TODO: Onion
	return d

func pick_up_droppable(d: droppable) -> void:
	held_droppable = d
	d.is_held = true
	$HeldItem.visible = true
	$HeldItem.texture = d.get_node("Sprite2D").texture
	#d.delete()
	d.hide_droppable()
	target_droppable = null

func find_plot_for_droppable(d: droppable):
	var p:plot = null
	match(d.drop_type):
		Enum.Drop_Type.Carrot_Seed, Enum.Drop_Type.Onion_Seed:
			p = Globals.PlotGrid.get_plot_that_needs_seed()
		Enum.Drop_Type.Water:
			p = Globals.PlotGrid.get_plot_that_needs_water()
		Enum.Drop_Type.Sun:
			p = Globals.PlotGrid.get_plot_that_needs_sun()
		_:
			pass
	return p

func move_to_target() -> bool:
	if state == Enum.Helper_State.Idle:
		return false
	if target_droppable:
		target_pos = target_droppable.global_position
	
	var direction = (target_pos - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
	velocity = direction * speed
	velocity = velocity.clamp(min_velocity, max_velocity)
	move_and_slide()
	
	return global_position.distance_to(target_pos) <= 2
	

func update_animation() -> void:
	match dir:
		Enum.Dir.Left:
			anim.play("walk_right")
			anim.flip_h = true
		Enum.Dir.Right:
			anim.play("walk_right")
			anim.flip_h = false
		Enum.Dir.Up:
			anim.play("walk_up")
			anim.flip_h = false
		Enum.Dir.Down:
			anim.play("walk_down")
			anim.flip_h = false
		_:
			print("Dont know that direction")
