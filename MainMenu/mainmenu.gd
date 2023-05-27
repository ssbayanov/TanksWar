extends Control


func _ready():
	pass



func _process(delta):
	pass



func _on_start_pressed():
<<<<<<< Updated upstream
	var game = g.stage.instance()
	get_tree().get_root().add_child(game)
	game.set_tank_params($Customise.tank_params)
	hide()
	g.game = game
=======
#	print($Customise.tank_params)
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
>>>>>>> Stashed changes


func _on_options_pressed():
	$Settincs.popup()


func _on_exet_pressed():
	$ExitWindow.show()


func _on_yes_pressed():
	ProjectSettings.save()
	get_tree().quit()


func _on_no_pressed():
	$ExitWindow.hide()
