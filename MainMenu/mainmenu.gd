extends Control


func _ready():
	pass



func _process(delta):
	pass



func _on_start_pressed():
	var game = g.stage.instance()
	get_tree().get_root().add_child(game)
	game.set_tank_params($Customise.tank_params)
	hide()
	g.game = game


func _on_options_pressed():
	pass 


func _on_exet_pressed():
	$ExitWindow.show()


func _on_yes_pressed():
	get_tree().quit()


func _on_no_pressed():
	$ExitWindow.hide()