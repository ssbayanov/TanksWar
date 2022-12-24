extends Node2D

var count_press = 0
var max_count_press = 3
var c_key = 0
var c_key2 = 0
var arr_b = []
var start 

var keys_tanks = g.tanks.keys()
var keys_barrels = g.barrels.keys()

var tank_params = {}

func _ready():
	update_tank()

# warning-ignore:unused_argument

	
func update_tank():
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	tank_params['body'] = tank_type
	
	$castom/Tank.set_texture(load(tank['sprite']))
	update_barrel()

		
		
func _on_Right_pressed():
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	c_key += 1
	if c_key >= len(keys_tanks):
		c_key = 0
	check_barrel()
	update_tank()

		
func _on_Left_pressed():
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	c_key -= 1
	if c_key < 0:
		c_key = len(keys_tanks) - 1

	check_barrel()
	update_tank()

	
		

var choose = true
		
		
func check_barrel():
	var barrel_type = keys_barrels[c_key2]
	var barrel = g.barrels[barrel_type]
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	if barrel['barrel_type'] > tank['max_barrel_type']: 
		choose = false

func update_barrel():
	var barrel_type = keys_barrels[c_key2]
	var barrel = g.barrels[barrel_type]
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	tank_params['barrel'] = barrel_type
	
	var barrel_res = load("res://Scence/barrel.tscn")
	if choose == false:
#		print('aaaaaaaaaaaaaaaaa', tank['max_barrel_type'])
		c_key2 = tank['max_barrel_type'] -1
		print('aa', c_key2)
	if c_key2 < 0:
		c_key2 = 0
	for i in range(len(arr_b)):
		var n = arr_b.pop_front()
		print(n,'n')
		n.queue_free()

	
	print(arr_b, 'aaaaaaaaaaaaaa')
	if barrel['barrel_type'] > tank['max_barrel_type']: 
		choose = false
	else:
		choose = true
		arr_b

	
	for i in range(tank['barrel_count']):
		print(i)
		
		var new_barrel = barrel_res.instance()
		new_barrel.set_barrel(keys_barrels[c_key2])
		new_barrel.set_position(tank['barrel_pos'][i])
		add_child(new_barrel)
		arr_b.append(new_barrel)
	

#	if arr_b.size() == 0:
	
	


		#get_node("castom").add_child(new_barrel)
#		new_barrel.set_texture(barrel['sprite'])
		
	
#	if tank['max_barrel_type'] == 1:
#		$castom/barrel.position = Vector2(tank['barrel_pos'][0][0], tank['barrel_pos'][0][1])
#	elif tank['max_barrel_type'] == 2:
#		$castom/barrel.position = Vector2(tank['barrel_pos'][0][0], tank['barrel_pos'][0][1])
#		$castom/barrel.position = Vector2(tank['barrel_pos'][0][0], tank['barrel_pos'][0][1])
#
	

func _on_Left_b_pressed():
	print(choose, c_key2)
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	c_key2 -= 1
	if c_key2 < 0:
		c_key2 = len(keys_barrels) - 1
	check_barrel()
	if choose == false:
#		print('aaaaaaaaaaaaaaaaa', tank['max_barrel_type'])
		c_key2 = tank['max_barrel_type'] -1
		print('aa', c_key2)
	update_barrel()

	

func _on_Right_b_pressed():
	print(choose, c_key2)
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	c_key2 += 1

	if c_key2 >= len(keys_barrels):
		c_key2 = 0
	check_barrel()
	if choose == false:
		c_key2 = 0
	update_barrel()
