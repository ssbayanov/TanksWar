extends KinematicBody2D

var dir = Vector2()
var minimap_icon = "Player"
var max_speed = 1000 #максимальная скорость танка
var acc = 100 #ускорение танка (acceleration)
var dec = 1000 #замедление танка
var c_speed = Vector2()  # текущий вектор
var rot_speed = 100 #скорость поворота

var hp = 100
var upgrades = {}

onready var barrels = $Barrels


var len_track = 0
var track_step = 10
var time_cold = 0

# Console

onready var trackRes = g.track
onready var bullet_res = g.bullets

func _ready():
	$icon.rotation_degrees = 0
	var bullet = bullet_res.instance()
	bullet.is_object = true
	
	add_child(bullet)
#	bullet.hide()
#	add_bullet(bullet)
	change_hp(0)
	$Camera2D.limit_left = -64
	$Camera2D.limit_top = -64
	$Camera2D.limit_bottom = (g.map_size.y + 1) * 64
	$Camera2D.limit_right = (g.map_size.x + 1) * 64


func set_params(params: Dictionary):
	""" Load tank and barrels params on start level
	params - Dictionary: keys:
		'body' - body key name in g.tanks
		'barrel' - barrel key name in g.barrels 
	"""
	# get body params
	var body = g.tanks[params['body']]
	# load texture
	$icon.set_texture(load(body['sprite']))
	
	# load tank params
	max_speed = body['speed']
#	acc = params['body']['acc']
#	dec = params['body']['dec']
	rot_speed = max_speed / 10
	hp = body['hp']
	
	barrels.set_params(params)

#	$Barrels.set_texture(load(barrel['sprite']))
	print(params)
	
	
func _process(delta):
#	g.print(global_position)
	if time_cold > 0:
		return

	if Input.is_action_pressed("ui_accept"):
		barrels.shoot()
		$AudioStreamPlayer2D2.play()
	$hpbar.set_global_rotation(0)


func get_input():
	if Input.is_action_pressed("ui_down"):
		dir.y = -1
	elif Input.is_action_pressed("ui_up"):
		dir.y = 1
	else:
		dir.y = 0
		
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		dir.x = -1
	else:
		dir.x = 0
	


func move(delta):
	if abs(c_speed.y) < max_speed * g.speed_coff: #меняем скорость на ускорение * время смены кадров
		c_speed.y += acc * delta * g.speed_coff * dir.y
	if dir.y == 0 and abs(c_speed.y) > 0:
		c_speed.y -= (dec * delta) * c_speed.y / abs(c_speed.y)
			
	rotation_degrees += rot_speed * delta * dir.x
	
	c_speed = move_and_slide(c_speed.rotated(rotation)).rotated(-rotation)
	c_speed.x = 0
	
	
func update_progressbar():
	$hpbar.set_global_rotation(0)
	

func is_freeze(delta):
	if time_cold > 0:
		time_cold -= delta
		#$Barrel.time_cold = time_cold
		$icon.material.set_shader_param("coldscale", true)
		return true

	$icon.material.set_shader_param("coldscale", false)
	return false


func put_track(delta):
	len_track += c_speed.length() * delta
	if len_track >= track_step:
		len_track = 0
		var t = trackRes.instance()
		get_tree().root.add_child(t)
		t.global_position = global_position 
		t.global_rotation = global_rotation
		
func _physics_process(delta):
	# if tank is freezed than cancel control
	if is_freeze(delta):
		return
	
	# get keyboard input
	get_input()
	
	# put track
	put_track(delta)
	
	# move player
	move(delta)


func damage_hp(amount):
	$AudioStreamPlayer2D3.play()
	# if god mode is enabled - no damage
	if g.god_mode: 
		return
	var damage = amount + g.barrels[g.tank_parametrs['barrel']]['dmg_hp']
	change_hp(-damage)


func change_hp(amount):
	hp +=amount
	
	if hp <=0:
		hp = 0
		$AudioStreamPlayer24D.play()
	if hp > 100:
		hp = 100
		
	$hpbar/hpbar.set_value(hp)
	 
	
func add_bullet(new_bullet):
	barrels.add_bullet(new_bullet)
	
	
func colding(long):
#	print(long / 10)
	time_cold = long / 10
	
	
func slowing(body):
	var side = int(rand_range(1, 3))
	var tick = int(rand_range(10, 100))
	if side == 1:
		$AnimationPlayer.play("rotating")
		while tick:
#			side = rand_range(1, 10)
			body.global_rotation -= 1
			tick -= 1
#			if side == 3:
#			if side == 3:
#				break
	else:
		$AnimationPlayer.play("rotating_left")
		while tick:
#			side = rand_range(1, 10)
			body.global_rotation += 1
			tick -= 1
#			if side == 3:
#				break
