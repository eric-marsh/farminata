extends Camera2D
class_name Camera

const zoom_step = 0.05
const zoom_max = Vector2(1.0, 1.0)
const zoom_min = Vector2(0.1, 0.1)
const zoom_speed = 1
var zoom_in = false
var zoom_out = false
var default_zoom = Vector2(1.0, 1.0)

func _ready() -> void:
	zoom = default_zoom
	pass
	
func _process(_delta: float) -> void:
	if Input.is_action_just_released("SCROLL_UP") and zoom < zoom_max:
		await zoom_camera(Vector2(zoom_step, zoom_step))
	elif Input.is_action_just_released("SCROLL_DOWN") and zoom > zoom_min:
		await zoom_camera(Vector2(zoom_step, zoom_step) * -1)

func zoom_camera(zoom_offset: Vector2) -> void:
	zoom = lerp(zoom, zoom + zoom_offset, zoom_speed)
	await get_tree().create_timer(0.1).timeout
