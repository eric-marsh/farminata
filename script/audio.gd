extends Node2D
class_name audio

@onready var music: AudioStreamPlayer2D = $Music
@onready var grass: AudioStreamPlayer2D = $Grass

func _ready() -> void:
	music.connect("finished", Callable(self,"_on_loop_music").bind($Music))
	music.play()
	
	pass

func _process(_delta: float) -> void:
	pass

func _on_loop_music(player):
	$Music.play()


const grass_sounds = [
	preload("res://audio/grass/footstep_grass_000.ogg"),
	preload("res://audio/grass/footstep_grass_001.ogg"),
	preload("res://audio/grass/footstep_grass_002.ogg"),
	preload("res://audio/grass/footstep_grass_003.ogg"),
	preload("res://audio/grass/footstep_grass_004.ogg")
]

func play_grass_sound():
	grass.stream = grass_sounds.pick_random()
	grass.play()



var slot_spin_assigned_id:int = -1
func play_slot_spin(id):
	slot_spin_assigned_id = id
	$SlotSpin.play(0.0)
	
func unplay_slot_spin(id):
	if id == slot_spin_assigned_id:
		$SlotSpin.stop()
