extends KinematicBody2D

var texture_tank = "res://Images/tankBody_dark_outline.png"
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

onready var trackRes = load("res://Scence/track.tscn")

func _ready():
	$icon.rotation_degrees = 0
	add_bullet(load("res://Scence/bullet1.tscn").instance())
	change_hp(0)
	$icon.set_texture(load(texture_tank))
	
func set_params(params):
	var body = g.tanks[params['body']]
	$icon.set_texture(load(body['sprite']))
	max_speed = body['speed']
#	acc = params['body']['acc']
#	dec = params['body']['dec']
	rot_speed = max_speed / 10
	hp = body['hp']
	
	#for barrel in body['barrel_count']:
		
	
	
func _process(delta):
	g.print(global_position)
	if time_cold > 0:
		return

	if Input.is_action_pressed("ui_accept"):
		barrels.shoot()
	$hpbar.set_global_rotation(0)
	

	

#p
func _physics_process(delta):
	
	if time_cold > 0:
		time_cold -= delta
		$Barrel.time_cold = time_cold
		$icon.material.set_shader_param("coldscale", true)
		return
	else:
		$icon.material.set_shader_param("coldscale", false)
	if Input.is_action_pressed("ui_down"):#если происходит нажатие кномки вниз
		if abs(c_speed.y) < max_speed * g.speed_coff: #меняем скорость на ускорение * время смены кадров
			c_speed.y +=acc * delta * g.speed_coff #изменяем скорость на текущую скорость - ускорение * на смену кадров
	elif Input.is_action_pressed("ui_up"):#если происходит нажатие кномки в верх
		if abs(c_speed.y) < max_speed * g.speed_coff: #меняем скорость на ускорение * время смены кадров
			c_speed.y -=acc * delta * g.speed_coff #изменяем скорость на текущую скорость - ускорение * на смену кадров
	else:
		if abs(c_speed.y) > 0:
			c_speed.y -= (dec * delta) * c_speed.y / abs(c_speed.y)
	if Input.is_action_pressed(("ui_right")):
		set_rotation_degrees(rotation_degrees + rot_speed*delta)
	elif Input.is_action_pressed(("ui_left")):
		set_rotation_degrees(rotation_degrees - rot_speed*delta)
	$hpbar.set_global_rotation(0)
	
	len_track += c_speed.length() * delta
	if len_track >= track_step:
		len_track = 0
		var t = trackRes.instance()
		get_tree().root.add_child(t)
		t.global_position = global_position 
		t.global_rotation = global_rotation
		
	
	c_speed = move_and_slide(c_speed.rotated(rotation)).rotated(-rotation)
	c_speed.x = 0
	
func damage_hp(amount):
	if g.god_mode == false: change_hp(-amount)
	
func change_hp(amount):
	hp +=amount
	if hp <=0:
		hp = 0
	if hp > 100:
		hp = 100
	$hpbar/hpbar.set_value(hp)
	 

func add_bullet(new_bullet):
	barrels.add_bullet(new_bullet)
	

func colding(long):
	print(long / 10)
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
