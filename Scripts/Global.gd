extends Node
var console = null
var Tilemap = null 

var tanks = {
	'standart':{
		'sprite': "res://Images/tankBody_dark.png",
		'barrel_count': 1,
		'hp': 100,
		'speed': 1000,
		'max_barrel_type': 1,
		'barrel_pos': [
			Vector2(775, 430),
   ]
  },
 
 'big_tank': {
  'sprite': "res://Images/tankBody_darkLarge_outline.png",
  'barrel_count': 2,
  'hp': 150,
  'speed': 700,
  'max_barrel_type': 2,
  'barrel_pos': [
   Vector2(827, 415),
   Vector2(847, 415),
   ]
  },
 'the_biggest_tank': {
  'sprite': "res://Images/tankBody_huge_outline.png",
  'barrel_count': 4,
  'hp': 250,
  'speed': 450,
  'max_barrel_type': 3,
  'barrel_pos': [
   Vector2(-7, -9),
   Vector2(7, -9),
   Vector2(-7, 28),
   Vector2(7, 28),
   ]
  }
 }

var barrel = {
 'barrel_low':{
  'cost': 500,
  'sprite': "res://Images/tankDark_barrel2_outline.png",
  'barrel_type': 1,
  'damage': 50,
  'speed': 50,
  'cool_down': 1,
  },
 'barrel_middle':{
  'cost': 1000,
  'sprite': "res://Images/tankDark_barrel3_outline.png",
  'barrel_type': 2,
  'damage': 20,
  'speed': 40,
  'cool_down': 0.5,
  },
 'barrel_high':{
  'cost': 1500,
  'sprite': "res://Images/tankDark_barrel1_outline.png",
  'barrel_type': 3,
  'damage': 15,
  'speed': 25,
  'cool_down': 0.2,
  }
 }
var keys_tanks = tanks.keys()
var time = OS.get_time()
var time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)

func _ready():
	var texture_standart = "res://Images/tankBody_dark_outline.png"
	randomize()

func rand_rangei(start, stop):
	if start == stop:
		return start
	return randi() % int((stop - start)) + int(start)




		#поменять танка "res://Images/tankBody_dark_outline.png"
		
	
func get_back_command():
	var p = console.back_command
	console.back_command = null
	if console == null:
		print("error: Console dont't init.")
		return "error: Console dont't init." 
	return p
func print(info):
	if console == null:
		print("error: Console dont't init.")
		return "error: Console dont't init." 
	print(info)
	console.write(time_return + "-" + str(info))
func Get_Console(info):
	console = info
	console.write(time_return + "-" + "Console_conected")

