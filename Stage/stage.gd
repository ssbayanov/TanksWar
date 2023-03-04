extends Node2D

onready var map = $map

func _ready():
	rand_seed(map.map_seed)
	get_data_for_player()
	
	$CanvasLayer/MiniMap.set_map($map)
	$CanvasLayer/MiniMap.set_player($player)
	
func set_tank_params(params):
	$player.set_params(params)
	generate_objects()
	
func get_data_for_player():
	var enemy = get_tree().get_nodes_in_group("enemy")
	for i in enemy:
		print('it is print enemy', enemy)
		i.player_tank = $player


func rand_rangei(start, stop):
	if start == stop:
		return start
	return randi() % int((stop - start)) + int(start)
	
func generate_objects():
	generate_tree()
	generate_mines()
	generate_boxes()

func generate_tree(cofficente_abaut:int = -1, cofficente_to:int = -0.58):
	var noise = map.get_noise(map.size, 50)
	var tree = load("res://Objects/Tree/treegreen.tscn")
	var roads = map.find_node("Roads")
	
	for x in range(map.size.x):
		for y in range(map.size.y):
			var tile = noise.get_noise_2d(x, y)
			if tile < cofficente_abaut or tile > cofficente_to:
				continue
			if roads.get_cell(x, y) != TileMap.INVALID_CELL:
				continue
			var object = tree.instance()
			$objects/tree.add_child(object)
			object.global_position = Vector2((x * 64) + randi() % 32, (y * 64) + randi() % 32)


func generate_mines():
	var caunt = rand_rangei(5, 10)
	rand_seed(map.map_seed)
	var object = load("res://Objects/Mine/Mine.tscn")
	g.print(caunt)
	for i in range(caunt):
		var new_mine = object.instance()
		var x = rand_rangei(0, map.size.x)
		var y = rand_rangei(0, map.size.y)
		new_mine.type_of_explosion = rand_rangei(0, 3)
		$objects/Mines.add_child(new_mine)
		new_mine.global_position = Vector2((x * 64) + 32, (y * 64) + 32)



func generate_boxes():
	var objects = [load("res://Barrel/Barel.tscn"), load("res://Objects/Box/box.tscn"), 
	load("res://Objects/Hedhehog/barecata.tscn"), load("res://Objects/Hedhehog/Hedgehog.tscn")]
	
	
	for object in objects:
		var caunt = rand_rangei(5, 10)
		rand_seed(map.map_seed)
		
		g.print(caunt)
		for i in range(caunt):
			var new_mine = object.instance()
			var x = rand_rangei(0, map.size.x)
			var y = rand_rangei(0, map.size.y)
			$objects/Mines.add_child(new_mine)
			new_mine.global_position = Vector2((x * 64) + 32, (y * 64) + 32)
