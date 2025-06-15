extends Node2D
class_name audio

@onready var music: AudioStreamPlayer2D = $Music

func _ready() -> void:
	music.connect("finished", Callable(self,"_on_loop_music").bind($Music))
	music.play()
	
	pass

func _process(_delta: float) -> void:
	pass

func _on_loop_music(player):
	$Music.play()








var slot_spin_assigned_id:int = -1
func play_slot_spin(id):
	slot_spin_assigned_id = id
	$SlotSpin.play(0.0)
	
func unplay_slot_spin(id):
	if id == slot_spin_assigned_id:
		$SlotSpin.stop()
