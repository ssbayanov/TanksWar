extends Node2D

const min_width = 50
const min_height = 50
const max_width = 100
const max_height = 100

var is_horisontal = false
var is_sand_on_top_or_left = false

var size = Vector2()

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

func _ready():
	size.x = g.rand_rangei(min_width, max_width)
	size.y = g.rand_rangei(min_height, max_height)

	is_horisontal = bool(g.rand_rangei(0,2))
	is_sand_on_top_or_left = bool(g.rand_rangei(0,2))
	
	generate_ground()
	generate_roads()

	
func generate_roads():
	for i in range(100):
		put_road_line()
	
func put_road_line():
	var start_pos = Vector2()
	start_pos.x = g.rand_rangei(0, max_width)
	start_pos.y = g.rand_rangei(0, max_height)
	
	
	var is_h = bool(g.rand_rangei(0,2))
	
	var length
	var delta = Vector2()
	
	if is_h:
		length = g.rand_rangei(5, max_width - start_pos.x - 10)
		delta.x = 1
	else:
		length = g.rand_rangei(5, max_height - start_pos.y - 10)
		delta.y = 1
		
	for i in range(length):
		put_road(start_pos, is_h)
		start_pos += delta
	
	
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
	
	for x in range(width_zones):
		for y in range(height_zones):
			set_cell($ground, Vector2(x, y) + delta_green, 0, Vector2(0, g.rand_rangei(0, 2)))
			set_cell($ground, Vector2(x, y) + delta_sand, 0, Vector2(0, g.rand_rangei(2, 4)))
			
func set_cell(tile_map, pos, tile, pos_tile):
	tile_map.set_cell(pos.x, pos.y, tile, false, false, false, pos_tile)


func put_road(pos, is_h):
	var ground_type = $ground.get_cellv(pos)
	var ground_autotile = $ground.get_cell_autotile_coord(pos.x, pos.y)
	
	var tile_type
	var road_tile
	var road_autotile_coord = Vector2()
	
	if ground_type == TILE.PLAIN:
		if ground_autotile.y > 1:
			tile_type = TILE.ROAD_SAND
		else:
			tile_type = TILE.ROAD_GREEN
			
		if is_h:
			road_tile = ROAD.HORISONTAL
		else:
			road_tile = ROAD.VERTICAL
			
		road_autotile_coord.x = road_tile % 6
		road_autotile_coord.y = road_tile / 6
		
	if tile_type:
		set_cell($roads, pos, tile_type, road_autotile_coord)
		
	
