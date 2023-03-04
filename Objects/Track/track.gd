extends Node2D



var time = 15 

func _process(delta):
	time -= delta
	
	if time <= 0:
		queue_free()
