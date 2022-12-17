extends RigidBody2D

var friction_force = -5
var object = null
var hp = 30



func damage_hp(amount):
	change_hp(-amount)
func change_hp(amount):
	hp +=amount
	if hp <=0:
		
			

	
		linear_velocity = Vector2.ZERO
func _process(delta):
	if object == null:
		return
	

func _on_Barricade_body_entered(body):
	pass # Replace with function body.
