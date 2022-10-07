extends Node2D

var mindistance = 100
var maxdistance = 500
var player_tank 
var bullet
var c_speed = Vector2()  # текущий вектор
var rot_speed = 70 #скорость поворота
var shoot_delayer = 1
var hp = 100
var can_shoot = 0
var len_track = 0
var track_step = 10

var barrel = true
# var b = "text"

func _ready():
	bullet = load("res://Scence/bullet1.tscn").instance()
	change_hp(0)
	
# Called when the node enters the scene tree for the first time.
func damage_hp(amount):
	change_hp(-amount)
	
func boom():
	hp = 0
	$boom_player.show()
	$boom_player.play()
	$CollisionShape2D.disabled = true
	player_tank = null
	$Node2D/reloadprogress.hide()
	$tank_npc.material.set_shader_param("grayscale", true)
	
	
func change_hp(amount):
	hp +=amount
	if hp <=0:
		hp = 0
		boom()
	if hp > 100:
		hp = 100
	$Node2D/hpbar.set_value(hp)
	

func _process(delta):
	if not player_tank:
		return
	_shoot_delayer_process(delta)
	
	 
func _shoot_delayer_process(delta):
	if shoot_delayer < 1:
		shoot_delayer += delta 
		$Node2D/reloadprogress.set_value(shoot_delayer*100)
		$Node2D/reloadprogress.show()
	else:
		shoot_delayer = 1
		$Node2D/reloadprogress.hide()
	
	$Node2D.set_global_rotation(0)
	if can_shoot > 0:
		_shoot1() 
	
	
	
	
	
func _shoot1():
	if shoot_delayer >= bullet.shoot_delay:
		var newbullet = bullet.duplicate()
		get_parent().add_child(newbullet)
		newbullet.shoot_delay = 0.2
		if barrel:
			$shooot3.show()
			$shooot3.play("default")
			newbullet.global_position = $Position2D3.global_position
		else:
			$shooot4.show()
			$shooot4.play("default")
			newbullet.global_position = $Position2D4.global_position
		barrel = not barrel 
		newbullet.global_rotation = global_rotation
		newbullet.is_object=false
		shoot_delayer = 0
	if shoot_delayer >= bullet.shoot_delay:
		var newbullet = bullet.duplicate()
		newbullet.shoot_delay = 0.7
		get_parent().add_child(newbullet)
		newbullet.global_position = $barrel/BulletPosition2D3.global_position
		newbullet.global_rotation = $barrel/Sprite.global_rotation
		newbullet.is_object = false
		shoot_delayer = 0
		$barrel/shooot3.play("default")
		$barrel/shooot3.show()
		

func _on_shooot_animation_finished():
	$barrel/shooot3.set_frame(0)
	$barrel/shooot3.hide()

	




func _on_Area2D_body_entered(body):
	can_shoot += 1


func _on_Area2D_body_exited(body):
	can_shoot = 1


func _on_shooot3_animation_finished():
	$shooot.set_frame(0)
	$shooot.hide()
func _on_shooot4_animation_finished():
	$shooot2.set_frame(0)
	$shooot2.hide()


func _on_boom_player2_animation_finished():
	$boom_player2.hide()
