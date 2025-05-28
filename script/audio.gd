extends Node2D
class_name audio


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

var slot_spin_assigned_id:int = -1
func play_slot_spin(id):
	slot_spin_assigned_id = id
	$SlotSpin.play(0.0)
	
func unplay_slot_spin(id):
	if id == slot_spin_assigned_id:
		$SlotSpin.stop()

## Ball Hit Sounds
#const BallHit1 = preload("res://sounds/ui/impactMetal_heavy_001.ogg")
#const BallHit2 = preload("res://sounds/ui/impactMetal_heavy_002.ogg")
#const BallHit3 = preload("res://sounds/ui/impactMetal_heavy_003.ogg")
#const BallHit4 = preload("res://sounds/ui/impactMetal_heavy_004.ogg")
#var all_ball_hits = [BallHit1, BallHit2, BallHit3, BallHit4]
#var random_ball_hits = []
#
#func _ready() -> void:
	#$Music.connect("finished", Callable(self,"_on_loop_music").bind($Music))
	#$Music.play()
	#random_ball_hits = all_ball_hits.duplicate()
	#random_ball_hits.shuffle()
	#
	#if Debug.DEBUG_ALWAYS_MUTE:
		#var bus_idx = AudioServer.get_bus_index("Master")
		#AudioServer.set_bus_mute(bus_idx, true) # or false
#
#func _process(_delta: float) -> void:
	#if Globals.Player:
		#global_position = Globals.Player.global_position
	#pass
#
#
#
#func _on_loop_music(player):
	#$Music.play()
#
#
#
#func ball_hit():
	#$BallHit.stream = random_ball_hits.pop_front()
	#if random_ball_hits.size() == 0:
		#random_ball_hits = all_ball_hits.duplicate()
		#random_ball_hits.shuffle()
	#$BallHit.play()
#
#
#
#const CLICK_1 = preload("res://sounds/snipsnap/click1.ogg")
#const CLICK_3 = preload("res://sounds/snipsnap/click3.ogg")
#const CLICK_4 = preload("res://sounds/snipsnap/click4.ogg")
#const CLICK_5 = preload("res://sounds/snipsnap/click5.ogg")
#
#func snip(): 
	#$Snip.stream = CLICK_3
	#$Snip.play()
#
#func snap(): 
	#$Snip.stream = CLICK_4
	#$Snip.play()
	#
#const MOUSECLICK_1 = preload("res://sounds/mouse/mouseclick1.ogg")
#const MOUSERELEASE_1 = preload("res://sounds/mouse/mouserelease1.ogg")
#const ROLLOVER_2 = preload("res://sounds/mouse/rollover2.ogg")
#
#
#func mouse_press(): 
	#$Mouse.stream = MOUSECLICK_1
	#$Mouse.play()
	#
#func mouse_release(): 
	#$Mouse.stream = MOUSERELEASE_1
	#$Mouse.play()
#
#func block_rotate():
	#$Mouse.stream = ROLLOVER_2
	#$Mouse.play()
#
#const LASER_SMALL_000 = preload("res://sounds/ship/laserSmall_000.ogg")
#
#func lazer_shoot():
	#$Lazer.stream = LASER_SMALL_000
	#$Lazer.play()
	#
#const SPACE_ENGINE_001 = preload("res://sounds/ship/spaceEngine_001.ogg")
#const SPACE_ENGINE_LOW_002 = preload("res://sounds/ship/spaceEngineLow_002.ogg")
#
#func ship_hover():
	#if $ShipHover.playing:
		#return
	#$ShipHover.stream = SPACE_ENGINE_LOW_002
	#$ShipHover.play()
#
#func ship_hover_stop():
	#$ShipHover.stop()
#
#
#
#
## Enemy Hit sounds
#const PAINS = preload("res://sounds/enemy/pains.wav")
#const DEATHR = preload("res://sounds/enemy/deathr.wav")
#
#func enemy_hit():
	#$EnemyHit.stream = PAINS
	#$EnemyHit.play()
#
#func enemy_die():
	#$EnemyDie.stream = DEATHR
	#$EnemyDie.play()
