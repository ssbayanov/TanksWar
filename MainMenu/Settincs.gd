extends WindowDialog
var settincs = {"voliume": 100, "fullscreen": true}
var voliume_set = settincs["voliume"]
var fullscreen = settincs["fullscreen"]


func _ready():
	var save_settincs = File.new()
	if save_settincs.file_exists("user://savegame.save"): 
		save_settincs.open("user://savegame.save", File.READ)
		settincs = parse_json(save_settincs.get_line())
	else:
		print("Settings not loading")
	print("Fullscreen:", bool(settincs.get("fullscreen", false)))
#	ProjectSettings.set_setting("display/window/size/fullscreen", bool(settincs.get("fullscreen", false)))
#	ProjectSettings.save()
	
	$CheckButton.pressed = settincs["fullscreen"]
	
	
func save_project():
	var save = File.new()
	save.open("user://savegame.save", File.WRITE)
	save.store_line(to_json(settincs))
	save.close()
	







func _on_save_pressed():
	ProjectSettings.set_setting("display/window/size/fullscreen", bool(fullscreen))
	ProjectSettings.save()
	$Label3.show()
	settincs["fullscreen"] = fullscreen
	settincs["voliume"] = voliume_set
	print(fullscreen)
	g.voliume == voliume_set

	save_project()
	
	


func _on_CheckButton_toggled(button_pressed):
	print(fullscreen)
	fullscreen = bool(button_pressed)
