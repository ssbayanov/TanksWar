extends Node2D


func shoot():
	for i in get_children():
		i.shoot()
		
		
func add_bullet(new_bullet):
	for i in get_children():
		i.add_bullet(new_bullet)

func set_params(params):
	for i in get_children():
		i.queue_free()
		
	var body = g.tanks[params['body']]
	var barrel = g.barrels[params['barrel']]
	var barrel_res = load("res://Scence/barrel.tscn")
	
	for i in range(body['barrel_count']):
		var new_barrel = barrel_res.instance()
		new_barrel.set_position(body['barrel_pos'][i])
		add_child(new_barrel)
