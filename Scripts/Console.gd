extends Control
var eneble:bool = false
var back_command = null

func if_command(command, command_will):
	for i in range(len(command) + 1): 
		if command[i] != command_will[i]:
			return false
	return true


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
		if $LineEdit.text[0] == "/":
			back_command = $LineEdit.text
		$LineEdit.text = "";
		
		
		
	var command = back_command
	back_command = null
	
	if command == null: return;
	elif command == "/god": 
		g.god_mode = !g.god_mode;
		g.print("Бесмертие персонажа - " + str(g.god_mode))
	elif command == "/restart": 
		g.print("Игра пеезапускается")
		g.game.get_node("CanvasLayer").get_node("MiniMap").queue_free()
		g.game.queue_free()
		get_parent().get_parent()._on_start_pressed()
	elif command == "/speed":
		g.print("Скорость перса задана - " + str(g.god_mode))
	elif command == "/help": 
		g.print("/god - это команда для бесмертия персонажа.")
		g.print("/restart - рестарт игры.")
		g.print("/speed (значение) - задаёт коффицент увелечения скорости игрока.")
		g.print("/help - Меню помощи.")
	else:
		g.print("Неверно введённая команда")
			
			
func write(what):
	$TextEdit.text += what + "\n"
	$TextEdit.update()
	$TextEdit.cursor_set_line($TextEdit.get_line_count() - 1)
	$TextEdit.update()
	print(what)




	
