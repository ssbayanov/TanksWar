extends Node2D
var spr

func _ready():
	pass
	
func set_barrel(barrel_name):
	var barrel = g.barrel.get(barrel_name, null)
	$Sprite.set_texture(load(barrel['sprite']))
	
