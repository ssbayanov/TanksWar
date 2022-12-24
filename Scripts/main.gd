extends Node2D


func _ready():
	get_data_for_player()
	
	$CanvasLayer/MiniMap.set_map($map)
	$CanvasLayer/MiniMap.set_player($player)
	
func set_tank_params(params):
	$player.set_params(params)
	


func get_data_for_player():
	var enemy = get_tree().get_nodes_in_group("enemy")
	for i in enemy:
		print('it is print enemy', enemy)
		i.player_tank = $player

