extends MarginContainer

export (NodePath) var KinematicBody2D
export var zoom = 1 setget set_zoom


onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerMarker
onready var NpcMarker = $MarginContainer/Grid/NpcMarker

onready var minimap_icon = {"Mob": NpcMarker} #"Player": player_marker

var grid_scale
var markers = {}

var map_objects
func _ready():
	map_objects = get_tree().get_nodes_in_group("minimap_objects")
	print('aaaa', map_objects)
#	player_marker.position = grid.rect_size / 2
#	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
#
#	print("aaaaaaaaaaaaa", map_objects)
#	for item in map_objects:
#		if not "minimap_icon" in item:
#			continue
#		var new_marker = minimap_icon[item.minimap_icon]
#		grid.add_child(new_marker)
#		new_marker.show()
#		markers[item] = new_marker
	for object in get_tree().get_nodes_in_group("minimap_objects"):
		object.connect("removed", self, "_on_object_removed")


		
func _process(delta):
	map_objects = get_tree().get_nodes_in_group("minimap_objects")
#	print('aaaa', map_objects)
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	
	for item in map_objects:
		if not "minimap_icon" in item:
			continue
#		print(minimap_icon[item.minimap_icon])
#		print(item)
		#print(map_objects, item)
		var new_marker = minimap_icon[item.minimap_icon]
		#print("Маркер -", new_marker, item.minimap_icon)
		#print("Вот -", minimap_icon[item.minimap_icon], item)
		grid.add_child(new_marker)
		new_marker.show()
#		print(new_marker)
		markers[item] = new_marker
#		print(markers[item])
		
		
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	if !KinematicBody2D:
		return
	player_marker.rotation = get_node(KinematicBody2D).rotation + PI
	for item in markers:
#		print('adasdasdasdadsasdasd', item)
#		print('marker', markers)
		var obj_pos = (item.position - get_node(KinematicBody2D).position) * grid_scale + grid.rect_size / 2
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(1.5, 1.5)
		else:
			markers[item].scale = Vector2(1, 1)
		markers[item].position = obj_pos
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
#	if map_objects == []:
#		mob_marker.hide()
func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)




func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom -= 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom += 0.1






func _on_object_removed(object):
	print('kkkk', object)
	if object in markers:
		print('111111111111111')
		markers[object].queue_free()
		markers.erase(object)

