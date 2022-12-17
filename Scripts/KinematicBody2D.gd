extends KinematicBody2D


var max_speed = 1000 #максимальная скорость танка
var acc = 100 #замедление танка (accsiliration)
var dec = 1000 #ускорение танка
var bullet
var c_speed = Vector2()  # текущий вектор
var rot_speed = 100 #скорость поворота
var shoot_delayer = 1
var hp = 100

var len_track = 0
var track_step = 10

var gravity = false
onready var trackRes = load("res://Scence/track.tscn")

func _ready():
	bullet = load("res://Scence/bullet1.tscn").instance()
	change_hp(0)


func _process(delta):
	_shoot_delayer_process(delta)
	if Input.is_action_just_pressed("ui_accept"):
		_shoot()
	$hpbar.set_global_rotation(0)

#p
func _physics_process(delta):
	if Input.is_action_pressed("ui_down"):#если происходит нажатие кномки вниз
		if abs(c_speed.y) < max_speed: #меняем скорость на ускорение * время смены кадров
			c_speed.y +=acc * delta #изменяем скорость на текущую скорость - ускорение * на смену кадров
	elif Input.is_action_pressed("ui_up"):#если происходит нажатие кномки в верх
		if abs(c_speed.y) < max_speed: #меняем скорость на ускорение * время смены кадров
			c_speed.y -=acc * delta #изменяем скорость на текущую скорость - ускорение * на смену кадров
	else:
		if abs(c_speed.y) > 0:
			c_speed.y -= (dec*delta) * c_speed.y / abs(c_speed.y)
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
	change_hp(-amount)
	
func change_hp(amount):
	hp +=amount
	if hp <=0:
		hp = 0
	if hp > 100:
		hp = 100
	$hpbar/hpbar.set_value(hp)
	 
func _shoot_delayer_process(delta):
	if bullet:
		if shoot_delayer < bullet.shoot_delay:
			shoot_delayer += delta 
			$hpbar/reloadprogress.set_value(shoot_delayer/bullet.shoot_delay)
			$hpbar/reloadprogress.show()
		else:
			$hpbar/reloadprogress.hide()
	
	
func _shoot():
	if shoot_delayer >= bullet.shoot_delay:
		var newbullet = bullet.duplicate()
		newbullet.shoot_delay = 0.7
		get_parent().add_child(newbullet)
		newbullet.global_position = $barrel/BulletPosition2D.global_position
		newbullet.global_rotation = $barrel/Sprite.global_rotation
		newbullet.is_object = false
		shoot_delayer = 0
		$barrel/shooot.play("default")
		$barrel/shooot.show()
		

func _on_shooot_animation_finished():
	$barrel/shooot.set_frame(0)
	$barrel/shooot.hide()


func add_bullet(new_bullet):
	if new_bullet.type > bullet.type:
		bullet = new_bullet



func black_holding(pos_mine, gr):
	gravity = gr
	while gravity:
		c_speed = Vector2.ZERO
