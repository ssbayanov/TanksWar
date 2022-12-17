extends Node2D
enum all {CLASSIC, FLASH,COLD, BLACK_HOLE}
export(all) var type_of_explosion
var scale_shape = 200
var object = null
var time = 0
var what
var gravity = false

func _ready():
	$Mina.modulate.a = 0
	if type_of_explosion == 3:
		scale_shape = 500
		time = 0.100
		print("я запустилась")
func _process(delta):
	if object == null:
		return
	var leng = abs((global_position - object.global_position).length())
	$Mina.modulate.a = 15 / leng
	Black_Hole()
	if leng >= 200:
		return
	time += delta
	if time > 1:
		if type_of_explosion == 0:
			object.damage_hp(abs(150 - (leng / 2)))
			queue_free()
		if type_of_explosion == 1:
			$animation.play("flash")
		if type_of_explosion == 3:
			$animation.play("black_hole")
			print("BooM")
			gravity = true
	
	
	
func _on_Area2D_body_entered(body):
	if object == null and body.has_method("damage_hp"):
		object = body
func _on_Area2D_body_exited(body):
	object = null


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func Black_Hole():
	if gravity:
		if $animation.is_playing():
			object.c_speed = Vector2.ZERO
 

