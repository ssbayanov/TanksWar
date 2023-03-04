extends Control
var money = 1 
var etr = [0,123,500,1000]

var track = null

func _ready():
	pass 
	
func Load_scene(car_name):
	track = load("TrackScene.tscn").instance()
	get_tree().root.add_child(track)
	
	var car = load(car_name).instance()
	track.add_child(car)
	car.translation = track.get_node("spabn").translation
	car.get_node("Camera").set_current(true)
	hide()
	
func _on_Button2_pressed():
	Load_scene("VehicleBody.tscn")


func _on_Button_pressed():
	Load_scene("VehicleBody2.tscn")


func _on_back_pressed():
	if track != null:
		track.queue_free()
		show()
	else:
		get_tree().quit()
if press 123
