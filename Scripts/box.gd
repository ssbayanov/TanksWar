extends RigidBody2D

var friction_force = -5

func _physics_process(delta):
	#add_central_force(linear_velocity.normalized() * friction_force )

	angular_velocity *= 0.001
	linear_velocity *= 0.001
	

	if linear_velocity.length() < 10:
		linear_velocity = Vector2.ZERO

