extends KinematicBody2D

var minimap_icon = "Mob"
var mindistance = 100
var maxdistance = 500
var player_tank = null
var max_speed = 500 #максимальная скорость танка
var acc = 100 #замедление танка (accsiliration)
var dec = 300 #ускорение танка
var bullet
var c_speed = Vector2()  # текущий вектор
var rot_speed = 70 #скорость поворота
var shoot_delayer = 1
var hp = 100
var can_shoot = 0
var len_track = 0
var track_step = 10

var barrel = true

var time_in_map = 0 # нужно
var ride_accuracy = 100 # нужно
var max_destance_error = 1000

var timer = 0
onready var trackRes = g.track# нужно

onready var reload_progress = $NoRotateble/reloadprogress
onready var hpbar = $NoRotateble/hpbar

func _ready():
	g.targets += 1
	bullet = g.bullets.instance()
	change_hp(0)


func _process(delta):
	if not player_tank:
		return
	time_in_map += delta
	
	#_shoot_delayer_process(delta)


var data_for_forward = [0, 0]

func _physics_process(delta):
	if not player_tank:
		return
	var distance = (player_tank.position - position).rotated(PI/2)
	
	if distance.length() < maxdistance and distance.length() > mindistance: 
		if abs(c_speed.y) < max_speed: #меняем скорость на ускорение * время смены кадров
			c_speed.y -= acc * delta 
	else:
		if abs(c_speed.y) >= 0:
			if abs(c_speed.y) < 10:
				c_speed.y = 0
		else:
			c_speed.y -= (dec*delta) * c_speed.y / abs(c_speed.y)
	global_rotation = lerp_angle(global_rotation,distance.angle(),delta)
	$NoRotateble.global_rotation = 0
	c_speed = move_and_slide(c_speed.rotated(rotation)).rotated(-rotation)
	c_speed.x = 0

	len_track += c_speed.length() * delta
	if len_track >= track_step:
		len_track = 0
		var t = trackRes.instance()
		get_tree().root.add_child(t)
		t.global_position = global_position 
		t.global_rotation = global_rotation
#	#c_speed.x = 0
#
#	timer += delta
#	len_track += c_speed.length() * delta
#	if len_track >= track_step:
#		len_track = 0
#		var t = trackRes.instance()
#		get_tree().root.add_child(t)
#		t.global_position = global_position 
#		t.global_rotation = global_rotation
	
	
func damage_hp(amount):
#	var damage = amount + g.barrels[g.tank_parametrs['barrel']]['dmg_hp']
#	g.money += 50
	change_hp(-amount)
	
	
func boom():
	hp = 0

	$boom_player.show()
	$boom_player.play()
	$CollisionShape2D.disabled = true
	player_tank = null
	reload_progress.hide()
	$tank_npc.material.set_shader_param("grayscale", true)
	g.point += 100
	g.targets -= 1
	get_parent().kill_enemy()
	
func change_hp(amount):
	hp +=amount
	if hp <=0:
		hp = 0
		#signal("remove_turrel")

		remove_from_group("minimap_objects")
		boom()
	if hp > 100:
		hp = 100
	hpbar.set_value(hp)
	
	 
func _shoot_delayer_process(delta):
	if shoot_delayer < 1:
		shoot_delayer += delta 
		reload_progress.set_value(shoot_delayer*100)
		reload_progress.show()
	else:
		shoot_delayer = 1
		reload_progress.hide()
	
	$Node2D.set_global_rotation(0)
	if can_shoot > 0:
		_shoot() 
	
	
func _shoot():
	if shoot_delayer >= bullet.shoot_delay:
		var newbullet = bullet.duplicate()
		get_parent().add_child(newbullet)
		newbullet.shoot_delay = 0.2
		if barrel:
			$shooot.show()
			$shooot.play("default")
			newbullet.global_position = $Position2D.global_position
		else:
			$shooot2.show()
			$shooot2.play("default")
			newbullet.global_position = $Position2D2.global_position
		barrel = not barrel 
		newbullet.global_rotation = global_rotation
		newbullet.is_object=false
		shoot_delayer = 0
	

func _on_Area2D_body_entered(body):
	can_shoot += 1


func _on_Area2D_body_exited(body):
	can_shoot = 1


func _on_boom_player_animation_finished():
	$boom_player.hide()


func _on_shooot_animation_finished():
	$shooot.set_frame(0)
	$shooot.hide()

func _on_shooot2_animation_finished():
	$shooot2.set_frame(0)
	$shooot2.hide()

func set_player(player):
	player_tank = player


func inaction():
	var pos = global_position
	var where_pos = player_tank.position
	var distance = where_pos - pos
	var evclidion_distance = pow(pow(distance.x, 2) + pow(distance.y ,2), 0.5)
	var angel = pos.angle_to(where_pos)
	
	var rot_error = g.rand_rangei((ride_accuracy - 100), (100 - ride_accuracy)) / 100.0 * PI 
	var distance_error = g.rand_rangei((ride_accuracy - 100), (100 - ride_accuracy)) / 100.0 * max_destance_error# / 100 

#	print("Угол -", rad2deg(angel))
#	racy)) / 100.0 * PI 


#	print("Угол -", rad2deg(angel))
#	print(rad2deg(rot_error))
#	print(distance_error)

	return [(rot_error + angel), distance_error]
	
