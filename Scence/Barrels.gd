extends Node2D


func shoot():
	for i in get_children():
		i.shoot()
		
		
func add_bullet(new_bullet):
	for i in get_children():
		i.add_bullet(new_bullet)
