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
	pass

func zoom_camera(zoom_offset: Vector2) -> void:
	zoom = lerp(zoom, zoom + zoom_offset, zoom_speed)
	await get_tree().create_timer(0.1).timeout
