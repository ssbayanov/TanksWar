extends Control
var eneble:bool = false




func _ready():
	var time = OS.get_time()
	var time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)
	write(time_return + "- Console started")
	g.Get_Console(get_child(0).get_parent())

func _process(delta): 
	
	var time = OS.get_time()
	var time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)
	
	if Input.is_action_just_pressed("show_console"): eneble = !eneble; get_tree().paused = eneble; if eneble == true: show(); else: hide() # Включение и отключение кнцоли.
	if Input.is_action_just_pressed("accept") and eneble == true and $LineEdit.text != "": 
		write(time_return + "-" + $LineEdit.text)
		$LineEdit.text = ""; 

	
			
			
func write(what):
	$TextEdit.text += what + "\n"
	$TextEdit.update()
	$TextEdit.cursor_set_line($TextEdit.get_line_count() - 1)
	$TextEdit.update()
	print(what)

