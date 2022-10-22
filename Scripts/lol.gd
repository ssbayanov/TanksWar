extends KinematicBody2D
var time_cold = 0

func _process(delta):
	if time_cold > 0:
		return
	var p = get_global_mouse_position()
	look_at(p)
