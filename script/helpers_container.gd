extends Node2D
class_name helpers_container

const HELPER = preload("res://scene/helper.tscn")

func _ready() -> void:
	for i in range(State.num_helpers):
		add_helper()

var timer: float = 0.0
var assign_jobs_interval: float = 2.0
func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= assign_jobs_interval:
		timer = 0
		assign_inactive_helpers_jobs()
	
	
func add_helper() -> void:
	var h = HELPER.instantiate() as helper
	h.global_position = Util.random_visible_position()
	add_child(h)

func assign_inactive_helpers_jobs():
	print("assign_inactive_helpers_jobs")
	for c in get_children():
		if c.state == Enum.Helper_State.Idle or c.state == Enum.Helper_State.Wander:
			var p = $"../PlotContainer/PlotGrid".get_plot_for_helper()
			if p == null:
				return # all plots are active. so return
			var success = p.assign_job_to_helper(c)
			if !success:
				print("plot didnt have any needs. returning. need to fix get_plot_for_helper() ")
				return
			c.set_state(Enum.Helper_State.Get_Item)
			return c

#func get_inactive_helper() -> helper:
	#for c in get_children():
		#if c.state == Enum.Helper_State.Idle or c.state == Enum.Helper_State.Wander:
			#return c
	#return null
