extends Node2D
enum all {CLASSIC, FLASH}
export(all) var type_of_explosion
const scale_shape = 195
var object = null
var time = 0
var what
func _ready():
	$Mina.modulate.a = 0
func _process(delta):
	if object == null:
		return
	var leng = abs((global_position - object.global_position).length())
	$Mina.modulate.a = 15 / leng
	if leng >= 200:
		return
	time += delta
	if time > 1:
		if type_of_explosion == 0:
			object.damage_hp(abs(150 - (leng / 2)))
			queue_free()
		if type_of_explosion == 1:
			$AnimationPlayer.play("flash")
			

func _on_Area2D_body_entered(body):
	if object == null and body.has_method("damage_hp"):
		object = body
func _on_Area2D_body_exited(body):
	object = null


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
