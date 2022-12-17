extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var h_space

var step = 6
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
var erase_fraction = 0.2

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
	
#	 generate_roads()
	randomize()
	if !map_seed:
		map_seed = randi()
	seed(map_seed)
	print("Seed: ", map_seed)
	tile_size = Map.cell_size

#	make_maze()
#	erase_walls()
	
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
			if dir.x != 0:
				for i in range(step - 1):
					var pos = current + dir/step
					#pos.x += i
					put_road(pos, 5)
			else:
				for i in range(step - 2):
					var pos = current + dir/step
					#pos.y += i
					put_road(pos, 10)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		#yield(get_tree(), 'idle_frame')

func erase_walls():
	# randomly remove a number of the map's walls
	for i in range(int(size.x * size.y * erase_fraction)):
		var x = int(rand_range(step, size.x/step - step)) * step
		var y = int(rand_range(step, size.y/step - step)) * step
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
			if neighbor.x != 0:
				put_road(cell+neighbor/step, 5)
			else:
				put_road(cell+neighbor/step, 10)
		#yield(get_tree(), 'idle_frame')



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

func get_noise(size, period: float = 100):
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



	

#func update_neighbor(roads, pos):	
#	for x in range(pos.x - 1, pos.x + 2):
#		if x < 0 or x >= len(roads):
#			continue
#		for y in range(pos.y - 1, pos.y + 2):
#			if y < 0 or y >= len(roads[0]):
#				continue
#
#			if x == pos.x and y == pos.y:
#				continue
#
#			if roads[pos.x][pos.y] == 0:
#				continue
#
#			if roads[x][y] != 0:
#				roads[x][y] = 0
#
#func update_neighbor2(roads, pos):
#	# array of lines
#	var l = []
#
#	# 
#	for x in range(pos.x, pos.x + 5):
#		if x >= len(roads):
#			continue
#
#		for y in range(pos.y, pos.y + 5):
#			if y >= len(roads[0]):
#				continue
#
#			if roads[x][y] != 0:
#				l.append(Vector2(x, y))
#				roads[x][y] = 1
#
#	print(len(l))
##	return
#	if len(l) >= 2:
#		var prev = null
#		for t in l:
#			if prev:
#				var last_x = 0
#				var last_y = 0
#				var le = (prev - t).length()
#				for d in range(le):
#					var moved = t.move_toward(prev, d)
#					var ceil_x = int(round(moved.x))
#					var ceil_y = int(round(moved.y))
#					print(le, " ", d, " ", prev, " ", t, " ", moved)
#
#					roads[ceil_x][ceil_y] = 1
#					print("put ", ceil_x, ":", ceil_y)
#
#					if ceil_x != last_x:
#						roads[floor(moved.x)][ceil_y] = 1
#						print("put ", floor(moved.x), ":", ceil_y)
#					if ceil_y != last_y:
#						roads[ceil_x][floor(moved.y)] = 1
#						print("put ", ceil_x, ":", floor(moved.y))
#
#					last_x = ceil_x
#					last_y = ceil_y
#			prev = t
#	elif len(l) == 1:
#		roads[l[0].x][l[0].y] = 1
#
#
#
##func update_neighbor(roads, pos):
##	for x in range(pos.x - 1, pos.x + 2):
##		if x < 0 or x >= len(roads):
##			continue
##		var y = pos.y
##
##		if y < 0 or y >= len(roads[0]):
##			continue
##
##		if x == pos.x and y == pos.y:
##			continue
##
##		if roads[pos.x][pos.y] == 0:
##			continue
##
##		if roads[x][y] != 0:
##			roads[x][y] = 0
##
##	var l = []
##	for x in range(pos.x - 1, pos.x + 2):
##		if x < 0 or x >= len(roads):
##			continue
##		for y in range(pos.y - 1, pos.y + 2):
##			if y < 0 or y >= len(roads[0]):
##				continue
##
##			if x == pos.x and y == pos.y:
##				continue
##
##			if roads[x][y] != 0:
##				roads[x][y] = 0
#
#
#
#func create_map(w, h):
#	var map = []
#
#	for x in range(w):
#		var col = []
#		col.resize(h)
#		map.append(col)
#
#	return map
#
#func minimize_roads(roads: Array):
#
#	for x in range(size.x):
#		for y in range(size.y):
#			update_neighbor(roads, Vector2(x,y))
#
#func restore_minimized(roads: Array):
#	for x in range(size.x / 3):
#		for y in range(size.y / 3):
##			print(x, " ", y)
#			update_neighbor2(roads, Vector2(x * 3, y * 3))
#	"""
#736
#0 2
#415
#┌┬─┐
#││ │
#├┼─┤
#└┴─┘
#	"""
#	"neightbor, d  array"
#var null_cell = [
#	['─', '┐', '─', '┘', '┐', '┐', '┘', '┘'],
#	['┐', '│', '┌', '│', '┐', '┌', '┌', '┐'],
#	['─', '┌', '─', '└', '─', '┌', '└', '─'],
#	['┘', '│', '└', '│', '┘', '└', '└', '┘'],
#]
#var filled_cell = {
#	' ' : ['─', '│', '─', '│'],
#	'│' : ['┤', '│', '├', '│'],
#	'─' : ['─', '┬', '─', '┴', '─'],
#	'┌' : ['┌', '┌', '├', '┌'],
#	'┐' : ['┐', '┐', '┬', '┤', '┐'],
#	'┘' : ['┘', '┤', '┴', '┘'],
#	'└' : ['└', '├', '└', '└'],
#	'┬' : ['┬', '┬', '┬', '┼', '┬'],
#	'┤' : ['┤', '┤', '┼', '┤'],
#	'┴' : ['┴', '┼', '┴'],
#	'├' : ['┼', '├'],
#	'┼' : ['┼']
#}
#
#var dots = [
#		Vector2(-1, 0),	# 0
#		Vector2(0, 1),	# 1
#		Vector2(1, 0),	# 2
#		Vector2(0, -1),	# 3
#		Vector2(-1, 1),	# 4
#		Vector2(1, 1),	# 5
#		Vector2(1, -1), # 6
#		Vector2(-1, -1),# 7
#	]
#
#func track(roads: Array, vect_roads: Array, pos: Vector2):
#	var r_cell = roads[pos.x][pos.y]
#
#	if vect_roads[pos.x][pos.y] == null:
#		vect_roads[pos.x][pos.y] = ' '
#
#
#	if not r_cell:
#		return
#
#	var neightbor = -1
#	if pos.y == 0:
#		neightbor = 3
#	if pos.x == 0:
#		neightbor = 0
#
#	for d in range(len(dots)):
#		var cell = vect_roads[pos.x][pos.y]
#		var n_pos = pos + dots[d] # Neightbor position
#
#		if n_pos.x >= len(roads) or n_pos.y >= len(roads[0]) or \
#				n_pos.x < 0 or n_pos.y < 0:
#			continue
#
#		if roads[n_pos.x][n_pos.y]:
#			if neightbor == -1:
#				neightbor = d
#				continue
#
#			if cell == ' ':
#				if d < 4:
#					vect_roads[pos.x][pos.y] = null_cell[neightbor][d]
##				else:
##					if d == 5 or d == 4:
##						vect_roads[pos.x][pos.y] = null_cell[3][1]
###						roads[pos.x][pos.y + 1] = 1
###						track(roads, vect_roads, Vector2(pos.x, pos.y + 1))
##
##					else:
##						vect_roads[pos.x][pos.y] = null_cell[1][d]
##						roads[pos.x][pos.y - 1] = 1
##						track(roads, vect_roads, Vector2(pos.x, pos.y - 1))
#
#			else:
#				vect_roads[pos.x][pos.y] = filled_cell[cell][min(d, len(filled_cell[cell]) - 1)]
#
#
#func save(filename, content):
#	var file = File.new()
#	file.open("user://" + filename + ".txt", File.WRITE)
#	file.store_string(str(content))
#	file.close()
#
#
#func generate_roads():
##	for i in range(100):
##		put_road_line()
#	#var noise = get_noise(size, 40.0)
#	var noise2 = get_noise(size, 80.0)
#	var roads = []
#
#	for x in range(size.x):
#		roads.append([])
#		for y in range(size.y):
#			roads[x].append(0)
#			if noise.get_noise_2d(x, y) < 0.3 and \
#			noise.get_noise_2d(x, y) >= 0.2:
#				roads[x][y] = 1
#
#			if noise2.get_noise_2d(x, y) < 0.3 and \
#			noise2.get_noise_2d(x, y) >= 0.2:
#				roads[x][y] = 1
#
#	minimize_roads(roads)
#	var minimized = roads.duplicate(true)
#	save('minimized', str(roads).replace('0', ' ') \
#	.replace('1', '■').replace(',', '').replace('[', '').replace(']', '\n'))
#	restore_minimized(roads)
#	save('restored', str(roads).replace('0', ' ') \
#	.replace('1', '■').replace(',', '').replace('[', '').replace(']', '\n'))
#
#	for x in range(size.x):
#		for y in range(size.y):
#			if minimized[x][y] == 1:
#				set_cell($Roads3, Vector2(x, y), TILE.ROAD_SAND, Vector2.ZERO)
#
#	var vect_roads = create_map(len(roads), len(roads[0]))
#	for x in range(size.x):
#		for y in range(size.y):
#			track(roads, vect_roads, Vector2(x, y))
#
#	var road_autotile = {
#		'│' : Vector2(0, 0),
#		'─' : Vector2(1, 0),
#		'┌' : Vector2(2, 1),
#		'┐' : Vector2(3, 1),
#		'┘' : Vector2(5, 1),
#		'└' : Vector2(4, 1),
#		'┬' : Vector2(5, 0),
#		'┤' : Vector2(3, 0),
#		'┴' : Vector2(4, 0),
#		'├' : Vector2(2, 0),
#		'┼' : Vector2(1, 1),
#	}
#
##	print(vect_roads)
#	for x in range(size.x):
#		for y in range(size.y):
#			if vect_roads[x][y] in road_autotile:
#				set_cell($Roads2, Vector2(x, y), TILE.ROAD_SAND, road_autotile[vect_roads[x][y]])
#			if roads[x][y] > 0:
#				put_road(Vector2(x, y), 1)
#
#
#
#func put_road_line():
#	var start_pos = Vector2()
#	start_pos.x = g.rand_rangei(0, max_width)
#	start_pos.y = g.rand_rangei(0, max_height)
#
#
#	var is_h = bool(g.rand_rangei(0,2))
#
#	var length
#	var delta = Vector2()
#
#	if is_h:
#		length = g.rand_rangei(5, max_width - start_pos.x - 10)
#		delta.x = 1
#	else:
#		length = g.rand_rangei(5, max_height - start_pos.y - 10)
#		delta.y = 1
#
#	for i in range(length):
#		put_road(start_pos, is_h)
#		start_pos += delta
#
#
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

#	for x in range(width_zones):
#		for y in range(height_zones):
#			set_cell($Ground, Vector2(x, y) + delta_green, 0, Vector2(0, g.rand_rangei(0, 2)))
#			set_cell($Ground, Vector2(x, y) + delta_sand, 0, Vector2(0, g.rand_rangei(2, 4)))

	#print(noise_image.get_pixel(0,1))

	for x in range(size.x):
		for y in range(size.y):
			#print(noise.get_noise_2d(x, y))
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
#
#
#func _on_Button_toggled(button_pressed):
#	$Roads.visible = !button_pressed
#
#
#func _on_Button2_toggled(button_pressed):
#	$Roads2.visible = !button_pressed
#
#
#func _on_Button3_toggled(button_pressed):
#	$Roads3.visible = !button_pressed
#
