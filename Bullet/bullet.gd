extends KinematicBody2D

#export var shoot_delay = 0.7#через какой промежуток времени можно стрелять сново
#var speed =  2000#скорость пули
#var c_speed = Vector2()
#var dammage = 10 # урон пули
#var startpos = 0
#var fly_time = 4
enum type {LIGHT, BOLD}
export(type) var type_bullet
export var is_object = true


var bullets = {
	type.LIGHT:{
		"shoot_delay": 0.7,
		"speed": 2000,
		"c_speed": Vector2(),
		"dammage": 10, # урон пули
		"startpos": 0,
		"fly_time": 4,
		"Sprite": "res://Bullet/Images/bulletBlue3_outline.png",
	},
	
	type.BOLD:{
		"shoot_delay": 3,
		"speed": 1000,
		"c_speed": Vector2(),
		"dammage": 50, # урон пули
		"startpos": 0,
		"fly_time": 2,
		"Sprite": "res://Bullet/Images/bulletBlue2_outline.png"
	}
}

onready var shoot_delay = bullets[type_bullet]["shoot_delay"]#через какой промежуток времени можно стрелять сново
onready var speed = bullets[type_bullet]["speed"] #скорость пули
onready var c_speed = bullets[type_bullet]["c_speed"]
onready var dammage = bullets[type_bullet]["dammage"] # урон пули
onready var startpos = bullets[type_bullet]["startpos"]
onready var fly_time = bullets[type_bullet]["fly_time"]
onready var sprite = bullets[type_bullet]["Sprite"]



func _ready():
	if is_object:
		$collider.disabled = false
	else:
		$Vistrel.play()
#		$bulletBlue2_outline.set_texture(sprite)
#		print("set_textured")
#
#
func _process(delta):
	if is_object:
		return
	else:
		$collider.disabled = false
	
	$bulletBlue2_outline.set_texture(load(sprite))
#	print("set_textured")

		
	var collision = move_and_collide(c_speed * delta + (Vector2(0,-speed)).rotated(rotation)*delta, false)
		
	fly_time -= delta
	
	if fly_time <= 0:
		get_parent().remove_child(self)
		return
		
	if collision:
		var body = collision.collider 
		if body.has_method("damage_hp"):
			body.damage_hp(dammage)
			
		if not body.has_method("_on_sens_body_entered"):
			get_parent().remove_child(self)
		
		return




func _on_sens_body_entered(body):
	if is_object:
		if body.has_method("add_bullet"):
			body.add_bullet(self)
			get_parent().remove_child(self)
			
