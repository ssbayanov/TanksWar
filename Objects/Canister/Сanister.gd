extends Node2D

var hp = 1
var not_damage = true
var oil = load("res://Scence/oil.tscn") 
var func_op = false

func _ready():
	$Sprite.rotation_degrees = 0
	$CollisionShape2D.rotation_degrees = 0
	
#	print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
	
func damage_hp(amount):
	hp -= amount
	if hp <= 0:
		if not_damage == true:
			$AnimationPlayer.play("fall")
			not_damage = false
			$Timer.start()
			

	#		queue_free()


func _on_AnimationPlayer_animation_finished(fall):
	var new_oil = oil.instance()
	new_oil.spreading()
	add_child(new_oil)


func _on_Timer_timeout():
	if func_op == false:
		print('функция')
		$CollisionShape2D.disabled = true
		$Sprite.queue_free()
		func_op = true

	
