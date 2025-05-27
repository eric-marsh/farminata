extends RigidBody2D
class_name droppable

@export var target_position: Vector2
@export var speed: float = 200.0
@export var drop_type: Enum.Drop_Type = Enum.Drop_Type.Water


var is_being_targeted: bool = false
var is_dragging: bool = false
var is_produce: bool = false


var upwards_speed: float = 100.0
var velocity: Vector2
var moving_to_target: bool = false
var time_passed: float = 0.0

var min_fall_amount = 50.0

var start_pos: Vector2
func _ready():
	await get_tree().create_timer(0.0001).timeout
	$Sprite2D.texture = DropUtil.get_drop_type_img(drop_type)
	start_pos = global_position
	
	if is_produce:
		Util.quick_timer(self,0.2, func():
			# Todo: Money animation
			Globals.Main.change_money(Prices.get_drop_price(drop_type))
			queue_free()
		)

func _physics_process(delta):
	if global_position.y > start_pos.y + min_fall_amount:
		gravity_scale = 0.0
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		moving_to_target = true
	
	if is_dragging:
		global_transform.origin = get_global_mouse_position()
		
	
	if Debug.DEBUG_DROPPABLE_MOVE_TO_TARGET and moving_to_target:
		var dir = (target_position - global_position).normalized()
		velocity = dir * speed
		position += velocity * delta

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !Globals.Main:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Globals.Main and Globals.Main.is_dragging:
				return
			is_dragging = true
			Globals.Main.is_dragging = true
			set_collision_layer_value(1, false)
		elif is_dragging and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			is_dragging = false
			Globals.Main.is_dragging = false
			set_collision_layer_value(1, true)


func delete():
	if is_dragging:
		is_dragging = false
		Globals.Main.is_dragging = false
	queue_free()
