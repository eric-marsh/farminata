extends Node2D
class_name chicken

var target_pos: Vector2
var speed: float = 0.15
var is_dragging: bool = false

var love_meter: int = 0

var state: Enum.Animal_State = Enum.Animal_State.Idle

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
func _ready():
	set_state(Enum.Animal_State.Idle)
	target_pos = Util.random_visible_position()
	animated_sprite.flip_h = target_pos > global_position
	Util.quick_timer(self, 360.0, func():
		love_meter = 20	
	)

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + Vector2(0, 12)
		return
	match(state):
		Enum.Animal_State.Idle:
			pass
		Enum.Animal_State.Wander:
			animated_sprite.flip_h = target_pos > global_position
			global_position += (target_pos - global_position).normalized() * speed
			if global_position.distance_to(target_pos) < speed:
				set_state(Enum.Animal_State.Idle)
		_:
			pass
			

func set_state(animal_state: Enum.Animal_State) -> void:
	state = animal_state
	match(state):
		Enum.Animal_State.Idle:
			if love_meter < 10:
				animated_sprite.play("chick_idle")
			else:
				animated_sprite.play("chicken_idle")
			Util.quick_timer(self, 1.0, func():
				set_state(Enum.Animal_State.Wander)
				reset_target()
			)
		Enum.Animal_State.Wander:
			if love_meter < 10:
				animated_sprite.play("chick_walking")
			else:
				animated_sprite.play("chicken_walking")
	pass

func reset_target()->void:
	target_pos = Util.random_visible_position()
	animated_sprite.flip_h = target_pos > global_position


@onready var heart_sprite: Sprite2D = $HeartSprite

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !Globals.Main.is_dragging:
			set_state(Enum.Animal_State.Idle)
			is_dragging = true
			scale = Vector2.ONE * 2
			Globals.Main.is_dragging = true
			z_index = 25
			Globals.AudioNode.play_pickup_sound()
		elif is_dragging and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			global_position = get_global_mouse_position() + Vector2(0, 12)
			set_state(Enum.Animal_State.Idle)
			heart_sprite.visible = true
			love_meter += 1
			
			Util.quick_timer(self, 1.0, func():
				heart_sprite.visible = false
			)
			is_dragging = false
			scale = Vector2.ONE
			Globals.Main.is_dragging = false
			z_index = 0
			Globals.AudioNode.play_grass_sound()
