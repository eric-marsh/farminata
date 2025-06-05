extends RigidBody2D
class_name droppable

@export var target_position: Vector2
@export var speed: float = 200.0
@export var drop_type: Enum.Drop_Type = Enum.Drop_Type.Water
var is_held: bool = false
var is_delivered: bool = false

var is_being_targeted: bool = false
var is_dragging: bool = false
var is_produce: bool = false

@export var start_static:bool = false

var upwards_speed: float = 100.0
var velocity: Vector2
var moving_to_target: bool = false
var time_passed: float = 0.0

var min_fall_amount = 50.0

var start_pos: Vector2

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	start_pos = global_position
	await get_tree().create_timer(0.0001).timeout
	collision_shape.disabled = true
	$Sprite2D.texture = DropUtil.get_drop_type_img(drop_type)
	$Sprite2D/Shadow.texture = DropUtil.get_drop_type_img(drop_type)
	
	is_produce = DropUtil.is_produce(drop_type) 
	if is_produce:
		var new_radius = $CollisionShape2D.shape.radius * 2
		$CollisionShape2D.shape = null
		var new_shape = CircleShape2D.new() as CircleShape2D
		new_shape.radius = new_radius
		$CollisionShape2D.shape = new_shape

func _physics_process(delta):
	update_shadow()
	if start_static or global_position.y > start_pos.y + min_fall_amount:
		collision_shape.disabled = false
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

func update_shadow():
	$Sprite2D/Shadow.global_position = $Sprite2D.global_position + Vector2(0, 1)

var dragging_scale:Vector2 = Vector2.ONE * 1.2
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if !Globals.Main:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_dragging()
		elif is_dragging and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			stop_dragging()

func start_dragging() -> void:
	if !Globals.Main or Globals.Main.is_dragging:
		return
	is_dragging = true
	$Sprite2D.scale = dragging_scale
	Globals.Main.is_dragging = true
	set_collision_layer_value(1, false)
	
func stop_dragging() -> void:
	if !Globals.Main:
		return
	is_dragging = false
	$Sprite2D.scale = Vector2.ONE
	Globals.Main.is_dragging = false
	set_collision_layer_value(1, true)

func delete():
	print("delete")
	if is_dragging:
		is_dragging = false
		Globals.Main.is_dragging = false
	queue_free()


func hide_droppable():
	$CollisionShape2D.disabled = true
	visible = false
