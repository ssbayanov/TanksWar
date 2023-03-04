extends RigidBody2D

var friction_force = 10000
var count_rep = 100
var max_speed_before 
func _physics_process(delta):
	#add_central_force(linear_velocity.normalized() * friction_force )
	angular_velocity *= 0.007
	linear_velocity *= 0.007
	
	if linear_velocity.length() < 200:
		linear_velocity = Vector2.ZERO
		
#	if conscern $Player:
#		max_speed - 300
		


func _on_Area2D_body_entered(body):
	if 'max_speed' in body:
		count_rep = 100
		max_speed_before = body.max_speed
		while true:
			body.max_speed -= 100
			count_rep -= 1
			if count_rep <= 0:
				break


func _on_Area2D_body_exited(body):
	if 'max_speed' in body:
		body.max_speed = max_speed_before
