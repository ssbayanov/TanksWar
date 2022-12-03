extends Node2D

var obj = null

func _process(delta):
	if !obj:
		return
	
	if 'hp' in obj:
		if obj.hp <= 0:
			queue_free()
			return
	else:
		queue_free()
		return
		
	position = obj.position
