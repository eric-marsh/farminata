extends Node2D
class_name MainNode

var global_timer: int = 0
var total_seconds: float = 0.0
var is_game_over: bool = false
var is_paused: bool = false

var max_blocks: int = 900
var is_dragging: bool = false

var money_count: int = 0

func _ready() -> void:
	global_timer = 0
	total_seconds = 0.0
	is_game_over = false
	is_paused = false
	
func _process(delta: float) -> void:
	if Globals.Main and Globals.Main.is_paused:
		return
	global_timer += 1
	if is_game_over:
		is_paused = false
		return
	total_seconds += delta
	
	
func _input(event):
	if Debug.DEBUG_ENABLE_DEBUGGING_KEYS and event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("ui_select") and !is_game_over:
		is_paused = !is_paused
		if is_paused and Globals.Audio:
			Globals.Audio.ship_hover_stop()

var can_restart_game = false
func check_game_over():
	if Globals.Player and Globals.Player.is_out_of_blocks():
		is_game_over = true
		if Globals.CanvasLayerNode:
			Globals.CanvasLayerNode.show_game_over()
		Util.quick_timer(self, 1.0, func(): can_restart_game = true)
		if Globals.Audio:
			Globals.Audio.ship_hover_stop()
	pass
	
func change_money(money_dif: int):
	money_count += money_dif
	Globals.CanvasLayerNode.update_money_counter()

#
#var ParticleBrickHit = preload("res://scene/particle_brick_hit.tscn")
#func spawn_particle(color, pos):
	#var p = ParticleBrickHit.instantiate() as CPUParticles2D
	#p.position = pos
	#p.emitting = true
	#p.one_shot = true
	#p.color_overide = color
	#Globals.ParticleContainer.add_child(p)
