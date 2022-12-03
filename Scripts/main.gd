extends Node2D


func _ready():
	get_data_for_player()
	
	var data = {
		'body' : g.tanks['the_biggest_tank']
	}
	$player.set_params(data)



func get_data_for_player():
	var enemy = get_tree().get_nodes_in_group("enemy")
	for i in enemy:
		print(enemy)
		i.player_tank = $player
