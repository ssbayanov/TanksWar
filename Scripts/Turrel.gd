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
var time_cold = 0
var blindness = 0


func _ready():
	bullet = load("res://Scence/bullet1.tscn").instance()
	change_hp(0)
	
	
func _physics_process(delta):
	if time_cold > 0:
		time_cold -= delta
		$tank_npc.material.set_shader_param("coldscale", true)
		return
	else:
		$tank_npc.material.set_shader_param("coldscale", false)
		
	if not player_tank:
		return
		
	var distance = (player_tank.global_position - global_position).rotated(PI * 0.5)
	
	if blindness <= 0:
		
		global_rotation = lerp_angle(global_rotation, distance.angle(), delta * 2)
		

		
		if abs(rad2deg(global_rotation - distance.angle())) < 0.05:
			global_rotation = distance.angle()
			
		$Node2D.set_global_rotation(0)
		if can_shoot > 0:
			_shoot() 
		shoot_delayer += delta
	else:
		blindness -= delta
	
	
func damage_hp(amount):
	change_hp(-amount)
	
	
func boom():
	hp = 0
	$boom_player.show()
	$boom_player.play()
	$CollisionShape2D.disabled = true
	player_tank = null
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
	
	
func _shoot():
	print("нет возможности стрелять")
	if shoot_delayer >= bullet.shoot_delay:
		
		var newbullet = bullet.duplicate()
		get_parent().add_child(newbullet)
		newbullet.shoot_delay = 0.2
		#newbullet.player = player_tank
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


func colding(long):
	print(long / 10)
	time_cold = long / 10

func flashing(time):
	blindness = time
