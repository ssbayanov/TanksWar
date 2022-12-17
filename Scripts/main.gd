extends Node2D

onready var map = $map

func _ready():
	get_data_for_player()
	
	var data = {
		'body' : g.tanks['the_biggest_tank']
	}
	
	$player.set_params(data)
	$CanvasLayer/MiniMap.set_map($map)
	$CanvasLayer/MiniMap.set_player($player)


	generate_objects()
	
func get_data_for_player():
	var enemy = get_tree().get_nodes_in_group("enemy")
	for i in enemy:
		print('it is print enemy', enemy)
		i.player_tank = $player


	
func generate_objects():
	generate_tree()


func generate_tree(cofficente_abaut:int = -1, cofficente_to:int = -0.58):
	var noise = map.get_noise(map.size, 50)
	for x in range(map.size.x):
		for y in range(map.size.y):
			var tile = noise.get_noise_2d(x, y)
			if tile >= cofficente_abaut and tile <= cofficente_to: 
				print(tile)
				var object = load("res://Scence/treegreen.tscn").instance()
				$objects/tree.add_child(object)
				object.global_position = Vector2(x * 64 + 32, y * 64 + 32)
	
	
