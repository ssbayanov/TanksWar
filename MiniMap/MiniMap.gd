extends VBoxContainer

export var zoom = 1 
var player
var marker_list = []

onready var enemy_list = get_tree().get_nodes_in_group("enemy")
onready var viewport = $Control/ViewportContainer/Viewport
onready var marker = $Control/ViewportContainer/Viewport/Sprite
onready var camera = $Control/ViewportContainer/Viewport/Sprite/Camera2D
func _ready(): for e in enemy_list: add_marker(e)

# функции подгрусски данных
func set_map(m):
	viewport.add_child(m.get_node("Ground").duplicate());
	viewport.add_child(m.get_node("Roads").duplicate());
	
	var new_tree = load("res://Objects/Tree/treegreen.tscn")
	g.print(get_parent().get_parent().tree_positions)
#	for i in get_parent().get_parent().tree_positions:
#		var tree = new_tree.instance()
#		tree.global_position = Vector2((i.x * 64) + 32, (i.y * 64) + 32)
#		add_child(tree)
		
func set_player(p): player = p;


func add_marker(obj): # добовляем новый маркер
	var new_marker = load("res://MiniMap/marker.tscn").instance()
	new_marker.obj = obj
	viewport.add_child(new_marker)
	
func _process(delta):
	if player == null: return; # Проверка на подгруску персонажа.
	marker.position = player.position # Задаю позицию камеры в Viewport.
	camera.zoom = Vector2(zoom * 3, zoom * 3) #Задаю размер камеры
	marker.rotation_degrees = player.rotation_degrees # Поворачиваю с соотвецтвием с игроком.
	$zoom_see.text = "ZOOM -" + str(zoom) # Показываю размер зумма.

func _input(event): # Функция для изменения покозтиля размер карты от пользователя.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP: zoom -= 0.1;
		if event.button_index == BUTTON_WHEEL_DOWN: zoom += 0.1;
		if zoom > 6: zoom = 6
		if zoom < 0.5: zoom = 0.5
