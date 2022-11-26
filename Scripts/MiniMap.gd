extends VBoxContainer

export var zoom = 1 setget set_zoom


onready var grid = self
onready var player_marker = $PlayerMarker



var markers = []
var grid_scale
var map_objects
var player = player_marker
var map = null

func _ready():
	map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for object in map_objects:
		if object.name == "player": 
			player = object # нашли игрока и запомнили
			
func set_map(m):
	map = m
	$ViewportContainer/Viewport.add_child(map.get_node("ground").duplicate())
	$ViewportContainer/Viewport.add_child(map.get_node("roads").duplicate())

	
func _process(delta):
	$ViewportContainer/Viewport/Camera2D.position = player.position
	
	map_objects = get_tree().get_nodes_in_group("minimap_objects") # получаем массив обьектов кторые должны быть на карте
	player_marker.position = self.rect_size / 2 # Ставим игрока в центре
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom) # задаём маштаб
	$zoom_see.text = "ZOOM -" + str(zoom)
	
	
	
	
	
	
	
	
	
	while len(map_objects) != len(markers):
		if len(map_objects)> len(markers):
			get_marker()
		elif len(map_objects) < len(markers):
			markers[len(markers) - 1].queue_free()
			markers.pop_back()
			
	for indecs in range(len(map_objects)):
		var object = map_objects[indecs]
		var marker = markers[indecs-1]
		if object.name == "player": marker.hide(); player_marker.rotation_degrees = object.rotation_degrees + 180; continue
		
		object.show()
		marker.position = set_pos_marker(pos(object.position, player.position), marker)

		
		"""
		Сделать ограничение по минимальному
		Сделать показ фона с tilemap (карты)
		"""
		
		
		
		
		
	
	
	

func get_marker():
	var marker = Sprite.new()
	marker.texture = load("res://Images/barrelBlack_top.png")
	add_child(marker)
	markers.append(marker)
	

func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom -= 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom += 0.1

func pos(object_pos, player_pos): return ((object_pos - player_pos) * grid_scale + self.rect_size/2) - Vector2(20, 20)


func set_pos_marker(pos, marker):	
	#marker.scale = Vector2(((marker.position / $MarginContainer.rect_size).x + (marker.position / $MarginContainer.rect_size).y) / 2 + 0.4, ((marker.position / $MarginContainer.rect_size).x + (marker.position / $MarginContainer.rect_size).y) / 2 + 0.4)
	if pos.x > (self.rect_size).x / 1.2:
		pos.x = (self.rect_size).x / 1.2
	if pos.x < 0:
		pos.x = 0
	if pos.y > (self.rect_size).y / 1.2:
		pos.y = (self.rect_size).y / 1.2
	if pos.y < 0:
		pos.y = 0
		
#	if pos.x > (self.rect_size).x * 2:
#		marker.hide()
#	if pos.x < -(self.rect_size).y * 2:
#		marker.hide()
#	if pos.y > (self.rect_size).y * 2:
#		marker.hide()
#	if pos.y < -(self.rect_size).y * 2:
#		marker.hide()
		
	return pos

