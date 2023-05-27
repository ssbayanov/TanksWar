extends Control

onready var end_money = $end_menu/CanvasLayer
onready var customise = $start_menu/Customise
onready var your_money = $start_menu/your_money
onready var main_menu = $start_menu/MainMenu/Layout
onready var cost_tank = $start_menu/cost_tank


func _ready():
	
	var save_money = File.new()
	if not save_money.file_exists("user://savemoney.save"):
		return

	save_money.open("user://savemoney.save", File.READ)
#    while save_money.get_position() < save_money.get_len():
	var node_data = parse_json(save_money.get_line())
	if typeof(node_data) == TYPE_DICTIONARY:
		g.dictionary_save = node_data
		
#	print('xsdcfvgbhnjmk,', g.money)
	save_money.close()
	g.money = g.dictionary_save['money']
	g.bought_bar = g.dictionary_save['bought_bar']
	g.bought_tank = g.dictionary_save['bought_tank']


func _process(delta):
	
	g.cost_tank = g.tanks[customise.tank_params['body']]['cost'] + g.barrels[customise.tank_params['barrel']]['cost']
	var text_money = your_money
	var text_cost = cost_tank
	var text_m = 'your_money: ' + str(g.money)
	var text_c = 'cost: ' + str(g.cost_tank)
	text_money.text = text_m 
	text_cost.text = text_c
#	your_money.(g.money)
#	cost_tank.(g.cost_tank)
#	print(g.money, 'money')
#	print(g.barrels[customise.tank_params['barrel']]['cost'], 'cost')

func _on_start_pressed():
#	print(customise.tank_params)
#	print(g.dictionary_save,'dsfsdfsdfsdf')
#	print(g.bought_tank, 'tank', g.bought_bar, 'asdfsdgfsfdg')

#	print(customise.tank_params)
#	print(g.tanks[customise.tank_params['body']]['cost'])
#	g.cost_tank = g.tanks[customise.tank_params['body']]['cost'] + g.barrels[customise.tank_params['barrel']]['cost']

	
	if g.bought == true:
		g.point += 100
		var game = g.stage.instance()
		game.connect("stage_completed", $end_menu, "checker")
	
		get_tree().get_root().add_child(game)
		g.tank_parametrs = customise.tank_params
		game.set_tank_params(customise.tank_params)
		game.connect("stage_complete", self, "stage_complete")
		hide()
		g.game = game
		g.save_money()



func _on_options_pressed():
	pass 


func _on_exet_pressed():
	$ExitWindow.show()


func _on_yes_pressed():
	get_tree().quit()


func _on_no_pressed():
	$ExitWindow.hide()
	






func _on_buy_pressed():
	if customise.tank_params['barrel'] in g.bought_bar:
#			print(g.cost_tank - g.barrels[customise.tank_params['barrel']]['cost'], 'psdffsdgsfgd')
#			print(g.cost_tank, 'cost_tank')
#			print(g.barrels[customise.tank_params['barrel']]['cost'], 'barrel_cost')
#
		g.cost_tank -= g.barrels[customise.tank_params['barrel']]['cost']

			
	elif customise.tank_params['body'] in g.bought_tank:
#		print(g.cost_tank - g.tanks[customise.tank_params['body']]['cost'], 'psdffsdgsfgd')
#		print(g.cost_tank, 'cost_tank')
#		print(g.tanks[customise.tank_params['body']]['cost'], 'body_cost')
		
		g.cost_tank -= g.tanks[customise.tank_params['body']]['cost']
		
#		print('sdffdfsssssssssssssssssssssssssss')
		
#			print(g.tanks[customise.tank_params['barrel']]['cost'])
		
	if g.money >= g.cost_tank:
		if customise.tank_params['barrel'] in g.bought_bar:
			g.bought_tank.append(customise.tank_params['body'])
#				g.cost_tank -= g.tanks[customise.tank_params['barrel']]['cost']
		elif customise.tank_params['body'] in g.bought_tank:
			g.bought_bar.append(customise.tank_params['barrel'])
#				g.cost_tank -= g.tanks[customise.tank_params['body']]['cost']
		else:
			g.bought_bar.append(customise.tank_params['barrel'])
			g.bought_tank.append(customise.tank_params['body'])
		g.money -= g.cost_tank
		$start_menu/Customise/Panel/buy.hide()
#		$Customise/Panel/buy.hide()
		g.bought = true



	


func _on_end_menu_show_all():
	print('show_all')
	show()
	$start_menu/Customise/Panel/buy.hide()
	$end_menu.hide()
	$end_menu/CanvasLayer.hide()
	$end_menu/CanvasLayer.get_child(2).hide()
	$start_menu/Customise/Panel/buy.show()
#	$start_menu.show()
	
	
	
	
	
func stage_complete():
	print('stage_complete')
	
	$end_menu.show()
	$end_menu/CanvasLayer.show()
	$end_menu/CanvasLayer.get_child(1).show()
#	$start_menu.hide()
