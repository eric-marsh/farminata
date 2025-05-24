extends Node

var rng = RandomNumberGenerator.new()


func quick_timer(obj: Node, wait_time: float, on_timeout: Callable):
	var t: Timer = Timer.new()
	obj.add_child(t)
	t.one_shot = true
	t.autostart = false
	t.wait_time = wait_time
	t.timeout.connect(func(): on_timeout.call())
	t.start()


func get_random_enum_value(enum_type: Dictionary) -> int:
	var values = enum_type.values()
	return values[randi() % values.size()]
#
#func get_dir_string(c: Enum.Dir):
	#match(c):
		#Enum.Dir.Left:
			#return "Left"
		#Enum.Dir.Right:
			#return "Right"
		#Enum.Dir.Up:
			#return "Up"
		#Enum.Dir.Down:
			#return "Down"
#
#func get_color_from_enum(c: Enum.Color_Type):
	#match(c):
		#Enum.Color_Type.Red:
			#return Color.html("#fa5457")
		#Enum.Color_Type.Blue:
			#return Color.html("#01b4bc")
		#Enum.Color_Type.Green:
			#return Color.html("#f6d51f")
#
#func get_color_string(c: Enum.Color_Type):
	#match(c):
		#Enum.Color_Type.Red:
			#return "Red"
		#Enum.Color_Type.Blue:
			#return "Blue"
		#Enum.Color_Type.Green:
			#return "Green"
