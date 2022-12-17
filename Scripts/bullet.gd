extends KinematicBody2D

export var shoot_delay = 0.7#через какой промежуток времени можно стрелять сново
var player = null
var speed =  1000#скорость пули
var dammage = 10 # урон пули
var startpos = 0
var fly_time = 4
var type = 1
var c_speed = Vector2(0, -speed)
export var is_object = false




func _ready():
	if is_object:
		$collider.disabled = false 

func _process(delta):
	if is_object:
		return
	else:
		$collider.disabled = false
	var collision = move_and_collide(c_speed.rotated(rotation)*delta, false)
	var p
	if player != null:
		p = player.global_position.rotated(PI)
		lerp_angle(global_rotation, p.angle(), delta * 20)
	
	
	
	fly_time -= delta
	
	if fly_time <= 0:
		get_parent().remove_child(self)
		return
		
	if collision:
		var body = collision.collider 
		if body.has_method("damage_hp"):
			body.damage_hp(dammage)
		get_parent().remove_child(self)
		
		return




func _on_sens_body_entered(body):
	if is_object:
		if body.has_method("add_bullet"):
			body.add_bullet(self)
			get_parent().remove_child(self)
