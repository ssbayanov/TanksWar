extends Control
var mode = false 

func _ready():
	hide()
	mode = false


func _on_interfeise_open_settings():
	if mode == false:
		show()
		mode == true
	else:
		hide()
		mode == false
