extends KinematicBody2D

var mindistance = 100
var maxdistance = 500
var player_tank 
var minimap_icon = "Mob"

var bullet
var rot_speed = 70 #скорость поворота
var shoot_delayer = 1
var hp = 100
var can_shoot = 0


var barrel = true

func _ready():
<<<<<<< Updated upstream
	bullet = g.bullets[1].instance()
=======
	bullet = g.bullets.instance()
	bullet.is_object = true
	add_child(bullet)
	bullet.hide()
>>>>>>> Stashed changes
	change_hp(0)
	
	
func _physics_process(delta):
	if not player_tank:
		return
	var distance = (player_tank.position - position).rotated(PI/2)
	global_rotation = lerp_angle(rotation,distance.angle(),delta * 3)
	_shoot_delayer_process(delta)
	

	
func damage_hp(amount):
	change_hp(-amount)
	$enj.play()
	
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
#		emit_signal("removed", self)
		remove_from_group("minimap_objects")
		boom()
	if hp > 100:
		hp = 100
	$Node2D/hpbar.set_value(hp)
	if hp <= 0:
		$AudioStreamPlayer2D.play()
		

	


	
	
	 
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
	can_shoot -= 1


func _on_boom_player_animation_finished():
	$boom_player.hide()


func _on_shooot_animation_finished():
	$shooot.set_frame(0)
	$shooot.hide()

func _on_shooot2_animation_finished():
	$shooot2.set_frame(0)
	$shooot2.hide()

