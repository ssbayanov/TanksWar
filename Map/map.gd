extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var h_space

var step = 10
var cell_walls = {Vector2(0, -step): N, Vector2(step, 0): E, 
				  Vector2(0, step): S, Vector2(-step, 0): W}

var tile_size = 64  # tile size (in pixels)

signal test_signal

const min_width = 50
const min_height = 50
const max_width = 100
const max_height = 100

var is_horisontal = false
var is_sand_on_top_or_left = false

var size = Vector2()

var is_main_scene = false
var is_start_move = false

var noise = null

var zones = []

var map_seed = 675343778


# fraction of walls to remove
var erase_fraction = 0.1

# get a reference to the map for convenience
onready var Map = $Roads

func _ready():
	if get_parent() is Viewport:
		print("Starting as main scene")
		is_main_scene = true

	size.x = g.rand_rangei(min_width, max_width)
	size.y = g.rand_rangei(min_height, max_height)

	is_horisontal = bool(g.rand_rangei(0,2))
	is_sand_on_top_or_left = bool(g.rand_rangei(0,2))

	noise = get_noise(size, 60)

	generate_ground()
	map_seed = randi()
	
#	 generate_roads()
	randomize()
	if !map_seed:
		map_seed = randi()
	seed(map_seed)
	print("Seed: ", map_seed)
	tile_size = Map.cell_size
	make_maze()
	erase_walls()
	generate_edge()
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	Map.clear()
	for x in range(size.x):
		for y in range(size.y):
			put_road(Vector2(x, y), N|E|S|W)
	for x in range(0, size.x, step):
		for y in range(0, size.y, step):
			unvisited.append(Vector2(x, y))
	var current = Vector2(0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = get_tile(current) - cell_walls[dir]
			var next_walls = get_tile(next) - cell_walls[-dir]
			put_road(current, current_walls)
			put_road(next, next_walls)
			# insert intermediate cell
			var tile = 5 if dir.x != 0 else 10
			for i in range(step - 1):
				put_road(current + dir/step * (i + 1) , tile)

			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		#yield(get_tree(), 'idle_frame')

func erase_walls():
	# randomly remove a number of the map's walls
	for i in range(int(size.x * size.y * erase_fraction) / step):
		var x = int(rand_range(1, size.x/step - 1)) * step
		var y = int(rand_range(1, size.y/step - 1)) * step
		var cell = Vector2(x, y)
		# pick random neighbor
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		# if there's a wall between them, remove it
		if get_tile(cell) & cell_walls[neighbor]:
			var walls = get_tile(cell) - cell_walls[neighbor]
			var n_walls = get_tile(cell+neighbor) - cell_walls[-neighbor]
			put_road(cell, walls)
			put_road(cell+neighbor, n_walls)
			
			# insert intermediate cell
			var tile = 5 if neighbor.x != 0 else 10
			for j in range(step - 1):
				put_road(cell + neighbor/step * (j + 1) , tile)
		yield(get_tree(), 'idle_frame')



enum ROAD {
	VERTICAL,
	HORISONTAL,
	T_VERTICAL_RIGHT,
	T_VERTICAL_LEFT,
	T_HORISONTAL_TOP,
	T_HORISONTAL_BOTTOM,
	MERGE,
	CROSS,
	CORNER_LT,
	CORNER_RT,
	CORNER_LB,
	CORNER_RB
}

enum JOINTS {
	V_GS,
	V_SG,
	V_SG_ROAD_TRACKS,
	H_SG,
	H_GS,
	H_GS_ROAD_TRACKS,
	V_GS_ROAD,
	V_SG_ROAD,
	V_GS_ROAD_TRACKS,
	H_SG_ROAD,
	H_GS_ROAD,
	H_SG_ROAD_TRACKS
}

enum TILE {
	PLAIN,
	ROAD_GREEN,
	ROAD_SAND,
	JOINT
}

func set_zoom(zoom, pos):
	var transform = get_viewport().get_canvas_transform()

	var old_scale = transform.get_scale()
	transform = transform.scaled((Vector2.ONE * zoom))
	var new_scale = transform.get_scale()

	var offset =  pos - pos * zoom
	transform = transform.translated(offset)

	get_viewport().set_canvas_transform(transform)

#	print('Offset: ', offset)
#	print('Transform: ', transform.get_scale())



func _input(e):
	if not is_main_scene:
		return

	if e is InputEventMouse:
		if e is InputEventMouseMotion:
			if is_start_move:
				var vp = get_parent()
				if vp is Viewport:
					var transform = get_viewport().get_canvas_transform()
					transform = transform.translated(e.relative * (Vector2.ONE / transform.get_scale()))
					get_viewport().set_canvas_transform(transform)


		if e is InputEventMouseButton:
#			print(e.button_index)

			#left button click
			if e.button_index == 1:
				if e.is_pressed():
					is_start_move = true
				else:
					is_start_move = false
			# scroll up
			if e.button_index == 5:
				set_zoom(0.9, e.position)
			if e.button_index == 4:
				set_zoom(1.1, e.position)

func get_noise(size, period: float = 100) -> OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()

	# Configure
	noise.seed = randi()
	noise.octaves = 150
	noise.period = period
	noise.persistence = 10000

	# Sample
	#print(noise.get_noise_2d(10.0, 10.0))

	print(size)

	return noise



func generate_ground():
	var height_zones = size.y

	var delta_sand = Vector2()
	var delta_green = Vector2()

	if is_horisontal:
		height_zones /= 2
		if is_sand_on_top_or_left:
			delta_green.y += height_zones
		else:
			delta_sand.y += height_zones
	var width_zones = size.y
	if not is_horisontal:
		width_zones /= 2
		if is_sand_on_top_or_left:
			delta_green.y += width_zones
		else:
			delta_green.y += width_zones

	for x in range(size.x):
		for y in range(size.y):
			if x % 4:
				var noise = OpenSimplexNoise.new()
				print(noise.get_image(size.x, size.y).get_pixel(x, y))
			if noise.get_noise_2d(x, y) > 0:
				set_cell($Ground, Vector2(x, y), 0, Vector2(0, g.rand_rangei(0, 2)))
			else:
				set_cell($Ground, Vector2(x, y), 0, Vector2(0, g.rand_rangei(2, 4)))

func set_cell(tile_map, pos, tile, pos_tile):
	tile_map.set_cell(pos.x, pos.y, tile, false, false, false, pos_tile)

var road_autotile = {
		0 : Vector2(1, 1),
		1 : Vector2(5, 0),
		2 : Vector2(3, 0),
		3 : Vector2(3, 1),
		4 : Vector2(4, 0),
		5 : Vector2(1, 0),
		6 : Vector2(5, 1),
		7 : Vector2(6, 1),
		8 : Vector2(2, 0),
		9 : Vector2(2, 1),
		10 : Vector2(0, 0),
		11 : Vector2(7, 1),
		12 : Vector2(4, 1),
		13 : Vector2(6, 0),
		14 : Vector2(7, 0),
		15 : Vector2(-1, 0),

	}
	
func get_tile(pos) -> int:
	var a_tile = $Roads.get_cell_autotile_coord(pos.x, pos.y)
	for key in road_autotile:
		if road_autotile[key] == a_tile:
			return key
			
	return -1

func put_road(pos, tile = 10):
	var ground_type = $Ground.get_cellv(pos)
	var ground_autotile = $Ground.get_cell_autotile_coord(pos.x, pos.y)

	var tile_type
	
	if ground_type == TILE.PLAIN:
		if ground_autotile.y > 1:
			tile_type = TILE.ROAD_SAND
		else:
			tile_type = TILE.ROAD_GREEN

	if tile_type:
		set_cell($Roads, pos, tile_type, road_autotile.get(tile, Vector2(-1, 0)))

func tile_is_sand(x, y) -> bool:
	
	var ground_autotile = $Ground.get_cell_autotile_coord(x, y)
	return ground_autotile.y > 1

enum EDGE {
		LEFT_TOP,
		RIGHT_TOP,
		RIGHT_BOTTOM,
		LEFT_BOTTOM,
		TOP,
		RIGHT,
		BOTTOM,
		LEFT,
		CENTER
	}
	
var tiles = {
	EDGE.LEFT_TOP: Vector2(0, 0),
	EDGE.TOP: Vector2(1, 0),
	EDGE.RIGHT_TOP: Vector2(2, 0),
	EDGE.RIGHT: Vector2(2, 1),
	EDGE.RIGHT_BOTTOM: Vector2(2, 2),
	EDGE.BOTTOM: Vector2(1, 2),
	EDGE.LEFT_BOTTOM: Vector2(0, 2),
	EDGE.LEFT: Vector2(0, 1),
	EDGE.CENTER: Vector2(1, 1),
}
	
func put_edge(x, y, type):
	
	var is_sand = tile_is_sand(x, y)
	
	if (x == 0 or x == size.x - 1) and (y == 0 or y == size.y - 1):
		var tx = x
		var ty = y
		if x == 0:
			tx -= 1
		if y == 0:
			ty -= 1
		set_cell($Ground, Vector2(tx, ty), 5 if is_sand else 4, tiles[type])
		set_cell($Ground, Vector2(tx, ty), 5 if is_sand else 4, tiles[type])
		set_cell($Ground, Vector2(tx, ty), 5 if is_sand else 4, tiles[type])
		
	else:
		var tx = x
		var ty = y
		if x == 0:
			tx -= 1
		elif x == size.x - 1:
			tx += 1
		if y == 0:
			ty -= 1
		elif y == size.y - 1:
			ty += 1
			
		set_cell($Ground, Vector2(tx, ty), 5 if is_sand else 4, tiles[type])


func generate_edge():	
	for x in range(size.x):
		put_edge(x, 0, EDGE.TOP)
		put_edge(x, size.y - 1, EDGE.BOTTOM)
	for y in range(size.y):
		put_edge(0, y, EDGE.LEFT)
		put_edge(size.x - 1, y, EDGE.RIGHT)
		
