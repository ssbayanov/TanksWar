extends VBoxContainer

export var zoom = 1 
var player
var marker_list = []

onready var enemy_list = get_tree().get_nodes_in_group("enemy")
onready var viewport = $Control/ViewportContainer/Viewport
onready var camera = $Control/ViewportContainer/Viewport/PlayerMarker/Camera2D
func _ready(): 
	for e in enemy_list: 
		add_marker(e)
	var cam = camera
	
	#wait for create map
	yield(get_tree().create_timer(0.5), "timeout")
	cam.limit_left = -64
	cam.limit_top = -64
	cam.limit_bottom = (g.map_size.y + 1) * 64
	cam.limit_right = (g.map_size.x + 1) * 64
	
	print("Minimap camera limit: ", g.map_size)

# функции подгрусски данных
func set_map(m):
	viewport.add_child(m.get_node("Ground").duplicate())
	viewport.add_child(m.get_node("Roads").duplicate())
func set_player(p): 
	player = p


func add_marker(obj): # добовляем новый маркер
	var new_marker = load("res://MiniMap/marker.tscn").instance()
	new_marker.obj = obj
	viewport.add_child(new_marker)
	
func _process(delta):
	if player == null: return; # Проверка на подгруску персонажа.
	$Control/ViewportContainer/Viewport/PlayerMarker.position = player.position # Задаю позицию камеры в Viewport.
	camera.zoom = Vector2(zoom * 3, zoom * 3) #Задаю размер камеры
	camera.rotation_degrees = 0
	$Control/ViewportContainer/Viewport/PlayerMarker.rotation_degrees = player.rotation_degrees # Поворачиваю с соотвецтвием с игроком.
	$zoom_see.text = "ZOOM -" + str(zoom) # Показываю размер зумма.

func _input(event): # Функция для изменения покозтиля размер карты от пользователя.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP: zoom -= 0.1;
		if event.button_index == BUTTON_WHEEL_DOWN: zoom += 0.1;
		if zoom > 3: zoom = 3
		if zoom < 1: zoom = 1
