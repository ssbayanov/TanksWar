extends Node2D

enum MineType {CLASSIC, FLASH, COLD, BLACK_HOLE}
export(MineType) var type_of_explosion

var time = 0

export var detonation_time = 0.1
export var detonation_distance = 50
export var showing_distance = 250


var detonated = false


func _ready():
	$Mina.modulate.a = 0


func _physics_process(delta):
	if detonated:
		return
		
	if len($Area2D.get_overlapping_bodies()) == 0:
		return
	
	var in_detonation_distance = 0
	
	for obj in $Area2D.get_overlapping_bodies():
		if not is_instance_valid(obj):
			continue
			
		if not obj is KinematicBody2D:
			continue
			
		if not obj.has_method("damage_hp"):
			continue
			
		var leng = abs((global_position - obj.global_position).length())
		
		#if leng < 100 and leng < $ProgressBar2.value:
			# $ProgressBar2.value = leng
		
		if leng < showing_distance:
			$Mina.modulate.a = 1 - leng / showing_distance
			$ProgressBar2.value =  100 - leng / showing_distance * 100
		else:
			$Mina.modulate.a = 0
			
		if leng >= detonation_distance:
			continue
		
		
		in_detonation_distance += 1
			
		time += delta
		
		
		if time > detonation_time:
			detonate()
			if type_of_explosion == MineType.CLASSIC:
				obj.damage_hp(abs(150 - (leng / 2)))
				#queue_free()
			elif type_of_explosion == MineType.FLASH:
				if obj.has_method("flashing"):
					obj.flashing(0.5)
			elif type_of_explosion == MineType.COLD:
				if obj.has_method("colding"):
					obj.colding(abs(150 - (leng / 2)))
			elif type_of_explosion == MineType.BLACK_HOLE:
				if "c_speed" in obj:
					var dist = (obj.global_position - global_position)
					obj.global_position -= dist * (detonation_distance - dist.length()) / 100 * delta
					
	if in_detonation_distance == 0:
		time = 0
		
	$ProgressBar.value = time / detonation_time * 100

func detonate():
	detonated = true
	if type_of_explosion == MineType.CLASSIC:
		$AnimationPlayer.play("explosion")
	elif type_of_explosion == MineType.FLASH:
		$AnimationPlayer.play("flash")
	elif type_of_explosion == MineType.COLD:
		$AnimationPlayer.play("colding")
	elif type_of_explosion == MineType.BLACK_HOLE:
		$AnimationPlayer.play("black_hole")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != 'idle': 
		queue_free()
