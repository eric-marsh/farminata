extends Node2D

var target_pos: Vector2
var speed: float = 0.05
var is_dragging: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: AnimatedSprite2D = $AnimatedSprite2D/Shadow



func _ready():
	animated_sprite_2d.play()
	shadow.play()
	target_pos = Util.random_visible_position()
	animated_sprite_2d.flip_h = target_pos < global_position
	shadow.flip_h = animated_sprite_2d.flip_h
	
func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() 
		return
		
	if self.animated_sprite_2d.frame != 0:
		return
	animated_sprite_2d.flip_h = target_pos < global_position
	shadow.flip_h = animated_sprite_2d.flip_h
	
	global_position += (target_pos - global_position).normalized() * speed
	if global_position.distance_to(target_pos) < speed:
		reset_target()

func reset_target()->void:
	target_pos = Util.random_visible_position()
	animated_sprite_2d.flip_h = target_pos < global_position
	shadow.flip_h = animated_sprite_2d.flip_h

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !Globals.Main.is_dragging:
			is_dragging = true
			scale = Vector2.ONE * 2
			Globals.Main.is_dragging = true
			z_index = 25
			Globals.AudioNode.play_pickup_sound()
			shadow.visible = false
		elif is_dragging and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			is_dragging = false
			scale = Vector2.ONE
			Globals.Main.is_dragging = false
			z_index = 0
			Globals.AudioNode.play_grass_sound()
			shadow.visible = true
