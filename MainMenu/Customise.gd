extends Control

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
	$Panel/buy.hide()
	update_tank()

# warning-ignore:unused_argument



func update_tank():
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	var barrel_type = keys_barrels[c_key2]
	
	tank_params['body'] = tank_type
	tank_params['barrel'] = barrel_type
	
	$castom/Tank.set_texture(load(tank['sprite']))
	update_barrel()

		
		
func _on_Right_pressed():
	var tank_type = keys_tanks[c_key]
	c_key += 1
	if c_key >= len(keys_tanks):
		c_key = 0
	check_barrel()
	update_tank()
	
	if tank_params['barrel'] in g.bought_bar and tank_params['body'] in g.bought_tank:
		g.bought = true
		$Panel/buy.hide()
	else:
		g.bought = false
		$Panel/buy.show()

		
func _on_Left_pressed():
	var tank_type = keys_tanks[c_key]
	c_key -= 1
	if c_key < 0:
		c_key = len(keys_tanks) - 1
	
	check_barrel()
	update_tank()
	if tank_params['barrel'] in g.bought_bar and tank_params['body'] in g.bought_tank:
		g.bought = true
		$Panel/buy.hide()
	else:
		g.bought = false
		$Panel/buy.show()
	
		

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
	
	var barrel_res = g.barrel
	if choose == false:
#		print('aaaaaaaaaaaaaaaaa', tank['max_barrel_type'])
		c_key2 = tank['max_barrel_type'] -1
#		print('aa', c_key2)
	if c_key2 < 0:
		c_key2 = 0
	for i in range(len(arr_b)):
		var n = arr_b.pop_front()
#		print(n,'n')
		n.queue_free()

	
#	print(arr_b, 'aaaaaaaaaaaaaa')
	if barrel['barrel_type'] > tank['max_barrel_type']: 
		choose = false
	else:
		choose = true

	
	for i in range(tank['barrel_count']):
#		print(i)
		
		var new_barrel = barrel_res.instance()
		new_barrel.set_type(keys_barrels[c_key2])
		new_barrel.set_position(tank['barrel_pos'][i] * $castom/Tank.scale.x + $castom/barrel.global_position)
		new_barrel.scale = $castom/Tank.scale
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
#	print(choose, c_key2)
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	c_key2 -= 1
	if c_key2 < 0:
		c_key2 = len(keys_barrels) - 1
	check_barrel()
	if choose == false:
#		print('aaaaaaaaaaaaaaaaa', tank['max_barrel_type'])
		c_key2 = tank['max_barrel_type'] -1
#		print('aa', c_key2)
	update_barrel()
	if tank_params['barrel'] in g.bought_bar and tank_params['body'] in g.bought_tank:
		g.bought = true
		$Panel/buy.hide()
	else:
		g.bought = false
		$Panel/buy.show()

	

func _on_Right_b_pressed():
#	print(choose, c_key2)
	var tank_type = keys_tanks[c_key]
	var tank = g.tanks[tank_type]
	c_key2 += 1

	if c_key2 >= len(keys_barrels):
		c_key2 = 0
	check_barrel()
	if choose == false:
		c_key2 = 0
	update_barrel()
	
	if tank_params['barrel'] in g.bought_bar and tank_params['body'] in g.bought_tank:
		g.bought = true
		$Panel/buy.hide()
	else:
		g.bought = false
		$Panel/buy.show()
