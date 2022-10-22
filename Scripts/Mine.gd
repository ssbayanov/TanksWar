extends Node2D
enum all {CLASSIC, FLASH, COLD}
export(all) var type_of_explosion
const scale_shape = 195
var object = []
var time = 0
var what
func _ready():
	$Mina.modulate.a = 0
func _process(delta):
	if object == []:
		return
	for i in object:
		var leng = abs((global_position - i.global_position).length())
		$Mina.modulate.a = 15 / leng
		if leng >= 200:
			return
		time += delta
		if time > 1:
			if type_of_explosion == 0:
				i.damage_hp(abs(150 - (leng / 2)))
				queue_free()
			if type_of_explosion == 1:
				$AnimationPlayer.play("flash")
				if i.has_method("flashing"):
					i.flashing(0.5)
			if type_of_explosion == 2:
				if i.has_method("colding"):
					i.colding(abs(150 - (leng / 2)))
					queue_free()

func _on_Area2D_body_entered(body):
	if  body.has_method("damage_hp"):
		object.append(body)
func _on_Area2D_body_exited(body):
	for i in range(len(object) - 1):
		if object[i] == body:
			object.remove(i)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
