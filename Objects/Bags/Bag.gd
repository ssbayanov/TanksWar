extends RigidBody2D

var hp = 10
var friction_force = -5

func _physics_process2(delta):
	#add_central_force(linear_velocity.normalized() * friction_force )

	angular_velocity *= 0.001
	linear_velocity *= 0.001


	if linear_velocity.length() < 10:
		linear_velocity = Vector2.ZERO
func change_hp(amount):
	if hp <=0:
		$Sprite.hide()
