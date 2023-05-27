extends RigidBody2D

var friction_force = -5
var object = null
var hp = 1

const max_len = 70
var old_position = position

onready var oilRes = load("res://Scence/oil_stain.tscn")

func damage_hp(amount):
	change_hp(-amount)
func change_hp(amount):
	hp +=amount
	if hp <=0:
		$Area2D/Barrel5454.hide() 
		$Area2D/Barrel232.show()
		$CPUParticles2D.show()
func _physics_process(delta):
		linear_velocity = Vector2.ZERO
		if hp <= 0: oil_leakage()
func _process(delta):
	if object == null:
		return

func oil_leakage():
	if old_position.length() >= max_len:
		var object = oilRes.duplicate()
		object.instance()
		object.global_position = global_position








