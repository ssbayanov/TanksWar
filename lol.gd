extends KinematicBody2D


func _process(delta):
	var p = get_global_mouse_position()
	look_at(p)
