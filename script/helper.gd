extends CharacterBody2D
class_name helper

@export var helper_type: Enum.Helper_Type = Enum.Helper_Type.Seed
@onready var anim = $AnimatedSprite2D
@onready var held_item_sprite = $HeldItem

var target_droppable: droppable = null
var target_plot: plot = null

var state: Enum.Helper_State = Enum.Helper_State.Idle
var dir: Enum.Dir = Enum.Dir.Down
var held_item_type: Enum.Drop_Type
var target_pos: Vector2 = Vector2.ZERO
var speed:int = 40

var min_velocity: Vector2 = Vector2(-speed, -speed)
var max_velocity: Vector2 = Vector2(speed, speed)
var state_timer_set: bool = false

func _ready() -> void:
	await get_tree().create_timer(0.000001).timeout
	
	set_state(Enum.Helper_State.Get_Item)
	update_animation()
	
	if Debug.Helper_Speed > 0:
		speed = Debug.Helper_Speed
		min_velocity = Vector2(-speed, -speed)
		max_velocity = Vector2(speed, speed)
	
	if !Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.queue_free()
	
func _physics_process(_delta: float) -> void:
	var has_reached_target:bool = move_to_target()
	if has_reached_target:
		on_reaching_target()
		return

func on_reaching_target():
	match(state):
		Enum.Helper_State.Idle:
			pass
		Enum.Helper_State.Wander:
			set_state(Enum.Helper_State.Idle)
		Enum.Helper_State.Get_Item:
			set_state(Enum.Helper_State.Deliver_Item)
			pick_up_droppable(target_droppable)
			target_droppable = null
		Enum.Helper_State.Deliver_Item:
			var d = DropUtil.spawn_droppable(held_item_type, target_pos, Vector2.ZERO)
			d.start_static = true
			d.is_delivered = true
			remove_job()
		Enum.Helper_State.Pluck_Crop:
			target_plot.pluck_crop()
			set_state(Enum.Helper_State.Idle)


func pick_up_droppable(d: droppable) -> void:
	target_droppable.is_held = true
	held_item_sprite.visible = true
	held_item_type = d.drop_type
	held_item_sprite.texture = d.get_node("Sprite2D").texture
	d.delete()
	target_droppable = null
	

func set_state(s: Enum.Helper_State) -> void:
	held_item_sprite.visible = false
	state_timer_set = false
	match(s):
		Enum.Helper_State.Idle:
			clear_job_data()
			if !state_timer_set:
				state_timer_set = true
				Util.quick_timer(self, 0.4, func(): 
					if state == Enum.Helper_State.Idle:
						set_state(Enum.Helper_State.Wander)
				)
		Enum.Helper_State.Wander:
			clear_job_data()
			target_pos = Util.random_visible_position()
		Enum.Helper_State.Get_Item:
			if target_droppable == null:
				set_state(Enum.Helper_State.Idle)
				return
			target_pos = target_droppable.global_position
		Enum.Helper_State.Deliver_Item:
			if target_droppable.is_produce:
				if Globals.SellChestNode:
					target_pos = Globals.SellChestNode.global_position + Vector2(32,-32)
			else:
				target_pos = target_plot.global_position + target_plot.size / 2
		Enum.Helper_State.Pluck_Crop:
			held_item_sprite.visible = false
			target_pos = target_plot.global_position + target_plot.size / 2
	state = s
	if Debug.DEBUG_SHOW_HELPER_STATE:
		$StateLabel.text = str(Util.get_helper_state_string(state), "\n", Util.get_helper_type_string(helper_type))
	#print(Util.get_helper_state_string(state), " timer: ", state_timer_set)

func move_to_target() -> bool:
	if state == Enum.Helper_State.Idle:
		return false
	var direction = (target_pos - global_position).normalized()
	var new_dir = Util.get_enum_direction(direction)
	if new_dir != dir:
		dir = new_dir
		update_animation()
	velocity = direction * speed
	velocity = velocity.clamp(min_velocity, max_velocity)
	move_and_slide()
	
	return global_position.distance_to(target_pos) <= 2
		



func remove_job():
	clear_job_data()
	set_state(Enum.Helper_State.Idle)

func clear_job_data():
	if is_instance_valid(target_droppable):
		target_droppable.is_being_targeted = false
	target_droppable = null
	target_plot = null
	$HeldItem.visible = false

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
