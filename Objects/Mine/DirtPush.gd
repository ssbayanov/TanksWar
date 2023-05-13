extends Sprite
var active = -9000000000

func _process(delta):
	if $Area2D.get_overlapping_bodies() == []: return
	if active < -5000: return 
	if active != 0:
		active -= delta
		if active <= 0: active == 0
		else: return
	for obj in $Area2D.get_overlapping_bodies():
		if not is_instance_valid(obj): continue
		if not obj is KinematicBody2D: continue
		if not obj.has_method("damage_hp"): continue
		obj.damage_hp(5 * delta)

func _ready():
	pass


func _on_Mine_classic():
	active = 0.5
