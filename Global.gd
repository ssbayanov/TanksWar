extends Node
var console = null
var Tilemap = null
var cost_tank = 0
var money = 0
# Console
var god_mode:bool = false
var speed_coff:int = 1
var tank_parametrs
var game

var map_size = Vector2()

var bullets = load("res://Bullet/Bullet2.tscn")

var stage = load("res://Stage/Stage.tscn")
var barrel = load("res://MainMenu/barrel.tscn")
var track = load("res://Objects/Track/track.tscn")



var tanks = {
	'standart':{
		'cost': 0,
		'sprite': "res://Images/tankBody_dark_outline.png",
		'barrel_count': 1,
		'hp': 100,
		'speed': 1000,
		'acc':100,
		'dec': 1000,
		'max_barrel_type': 1,
		'barrel_pos': [
			Vector2(0, 0),
		]
		
	},
 
	'big_tank': {
		'cost': 500,
		'sprite': "res://Images/tankBody_darkLarge_outline.png",
		'barrel_count': 2,
		'hp': 150,
		'speed': 700,
		'acc':60,
		'dec': 1300,
		'max_barrel_type': 2,
		'barrel_pos': [
			Vector2(-6, 0),
			Vector2(5,  0),
			]
		},
	'the_biggest_tank': {
		'cost': 1000,
		'sprite': "res://Images/tankBody_huge_outline.png",
		'barrel_count': 4,
		'hp': 250,
		'speed': 450,
		'acc':50,
		'dec': 1500,
		'max_barrel_type': 3,
		'barrel_pos': [
			Vector2(-8, -21),
			Vector2(8, -21),
			Vector2(-8, 15),
			Vector2(8, 15),
			]
		}
	}

var barrels = {
	'barrel_low':{
		'cost': 0,
		'sprite': "res://Images/tankDark_barrel2_outline.png",
		'barrel_type': 1,
		'dmg_hp': 0,
		'speed': 50,
		'cool_down': 1,
	},
	'barrel_middle': {
		'cost': 1000,
		'sprite': "res://Images/tankDark_barrel3_outline.png",
		'barrel_type': 2,
		'dmg_hp': 10,
		'speed': 40,
		'cool_down': 0.5,
	},
	'barrel_high': {
		'cost': 3000,
		'sprite': "res://Images/tankDark_barrel1_outline.png",
		'barrel_type': 3,
		'dmg_hp': 25,
		'speed': 25,
		'cool_down': 0.2,
	}
}



var keys_tanks = tanks.keys()
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
		print(info)
		return
		
	console.write(time_return + "-" + str(info))
	
	
func Get_Console(info):
	console = info
	console.write(time_return + "-" + "Console_conected")




