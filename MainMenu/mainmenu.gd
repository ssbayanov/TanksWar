extends Control


func _ready():
	
	var save_money = File.new()
	if not save_money.file_exists("user://savemoney.save"):
		return

	save_money.open("user://savemoney.save", File.READ)
#    while save_money.get_position() < save_money.get_len():
	var node_data = parse_json(save_money.get_line())

	g.money = node_data
#	print('xsdcfvgbhnjmk,', g.money)
	save_money.close()
	



func _process(delta):
	g.cost_tank = g.tanks[$Customise.tank_params['body']]['cost'] + g.barrels[$Customise.tank_params['barrel']]['cost']
	var text_money = $your_money
	var text_cost = $cost_tank
	var text_m = 'your_money: ' + str(g.money)
	var text_c = 'cost: ' + str(g.cost_tank)
	text_money.text = text_m 
	text_cost.text = text_c
#	$your_money.(g.money)
#	$cost_tank.(g.cost_tank)



func _on_start_pressed():
#	print($Customise.tank_params)
#	print(g.tanks[$Customise.tank_params['body']]['cost'])
#	g.cost_tank = g.tanks[$Customise.tank_params['body']]['cost'] + g.barrels[$Customise.tank_params['barrel']]['cost']
	
	if g.money >= g.cost_tank:
		g.money -= g.cost_tank
		g.money += 100
		var game = g.stage.instance()
		get_tree().get_root().add_child(game)
		g.tank_parametrs = $Customise.tank_params
		game.set_tank_params($Customise.tank_params)
		hide()
		g.game = game
		save_money()
	else:
		
		print('not_enough money!')


func _on_options_pressed():
	pass 


func _on_exet_pressed():
	$ExitWindow.show()


func _on_yes_pressed():
	get_tree().quit()


func _on_no_pressed():
	$ExitWindow.hide()
	
func save_money():
#	print('dcfvgbhnjmk,l.sdasdasdasdasdasdasdasd')
	var save_money = File.new()
	save_money.open("user://savemoney.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	save_money.store_line(to_json(g.money))
	save_money.close()
	print(g.money)



