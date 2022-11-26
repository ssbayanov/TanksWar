extends Node
var console = null
var Tilemap = null 


var time = OS.get_time()
var time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)

func _ready():
	randomize()

func rand_rangei(start, stop):
	if start == stop:
		return start
	return randi() % int((stop - start)) + int(start)



func print(info):
	if console == null:
		print("error: Console dont't init.")
		return "error: Console dont't init." 
	print(info)
	console.write(time_return + "-" + str(info))
func Get_Console(info):
	console = info
	console.write(time_return + "-" + "Console_conected")

