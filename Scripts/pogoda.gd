extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_pressed():
	var game = preload("res://Scence/main.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()


func _on_options_pressed():
	pass 


func _on_exet_pressed():
	$if.show()


func _on_yes_pressed():
	get_tree().quit()


func _on_no_pressed():
	$if.hide()
