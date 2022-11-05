extends Node2D
enum all {CLASSIC, FLASH, COLD, BLACK_HOLE}
export(all) var type_of_explosion
const scale_shape = 195
var object = []
var time = 0
var what
export var detonation_distance = 200
func _ready():
	$Mina.modulate.a = 0
	
func _process(delta):
	if object == []:
		return
	for obj in object:
		var leng = abs((global_position - obj.global_position).length())
		$Mina.modulate.a = 15 / leng
		if leng >= detonation_distance:
			return
		time += delta
		if time > 1:
			if type_of_explosion == 0:
				$AnimationPlayer.play("explosion")
				obj.damage_hp(abs(150 - (leng / 2)))
				#queue_free()
			elif type_of_explosion == 1:
				$AnimationPlayer.play("flash")
				if obj.has_method("flashing"):
					obj.flashing(0.5)
			elif type_of_explosion == 2:
				if obj.has_method("colding"):
					obj.colding(abs(150 - (leng / 2)))
					queue_free()
			elif type_of_explosion == 3:
				$AnimationPlayer.play("black_hole")
				if "c_speed" in obj:
					var dist = (obj.global_position - global_position)
					obj.global_position -= dist * (detonation_distance - dist.length()) / 100 * delta
								
func _on_Area2D_body_entered(body):
	if  body.has_method("damage_hp"):
		object.append(body)
func _on_Area2D_body_exited(body):
	for i in range(len(object) - 1):
		if object[i] == body:
			object.remove(i)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != 'idle': 
		queue_free()
