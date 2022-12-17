extends RigidBody2D

var friction_force = -5
var object = null
var hp = 20



func damage_hp(amount):
	change_hp(-amount)
func change_hp(amount):
	hp +=amount
	if hp <=0:
		$SandBag.hide() 
			
func _physics_process(delta):
	
		linear_velocity = Vector2.ZERO
func _process(delta):
	if object == null:
		return








func _on_CollisionShape2D88_body_entered(body):
	$KinematicBody2D
	var max_speed = 1000
	max_speed = 0
