extends Node2D
class_name apply_droppable_animation

var drop_type: Enum.Drop_Type

var start_pos: Vector2 = Vector2.ZERO
var target_pos: Vector2 = Vector2.ZERO

@onready var sprite_2d = $Path2D/PathFollow2D/Sprite2D
@onready var path_2d: Path2D = $Path2D
@onready var animation_player = $AnimationPlayer

var arc_up_amount: int = 80

func _ready():
	global_position = start_pos
	var diff: Vector2 = target_pos - start_pos
	var curve := Curve2D.new()
	curve.add_point(Vector2.ZERO)
	curve.add_point(diff)

	# Control points for the curve shape
	curve.set_point_in(1, Vector2(-diff.x / 2, -arc_up_amount))
	curve.set_point_out(0, Vector2(diff.x / 2, arc_up_amount))
	path_2d.curve = curve
	sprite_2d.modulate.a = 0.8
	sprite_2d.texture = DropUtil.get_drop_type_img(drop_type)

func _on_animation_player_animation_finished(anim_name):
	var c = DropUtil.get_drop_type_color(drop_type)
	Util.create_explosion_particle(target_pos, c.lightened(0.5))
	queue_free()
