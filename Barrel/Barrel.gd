extends Node2D

var time_cold = 0
var bullet = null

var shoot_delayer = 1

func _shoot_delayer_process(delta):
	if bullet:
		if shoot_delayer < bullet.shoot_delay:
			shoot_delayer += delta 
#			$hpbar/reloadprogress.set_value(shoot_delayer/bullet.shoot_delay)
#			$hpbar/reloadprogress.show()
#		else:
#			$hpbar/reloadprogress.hide()

func _process(delta):
	_shoot_delayer_process(delta)
	
	if time_cold > 0:
		return
		
	var p = get_global_mouse_position()
	
	global_rotation = lerp_angle(global_rotation,(global_position - p).angle(),delta * 3)


func shoot():
	if bullet == null:
		return
	if shoot_delayer >= bullet.shoot_delay:
		var newbullet = bullet.duplicate()
		newbullet.shoot_delay = 0.7
		get_parent().get_parent().get_parent().add_child(newbullet)
		newbullet.global_position = $BulletPosition2D.global_position
		newbullet.global_rotation = $Sprite.global_rotation + PI
		newbullet.is_object = false
		shoot_delayer = 0
		$shooot.play("default")
		$shooot.show()
		

func _on_shooot_animation_finished():
	$shooot.set_frame(0)
	$shooot.hide()
	
	
func add_bullet(new_bullet):
	if bullet == null:
		bullet = new_bullet
		return
		
	if new_bullet.type > bullet.type:
		bullet = new_bullet
	
	
func set_type(type: Dictionary):
	pass
