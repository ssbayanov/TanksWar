extends RigidBody2D

var friction_force = -5

func _physics_process(delta):
	add_central_force(linear_velocity.normalized() * friction_force )

	if linear_velocity.length() < 10000:
		linear_velocity = Vector2.ZERO
