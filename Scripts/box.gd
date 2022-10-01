extends RigidBody2D

var friction_force = -50

func _physics_process(delta):
	add_central_force(linear_velocity.normalized() * friction_force )

	if linear_velocity.length() < 100:
		linear_velocity = Vector2.ZERO
