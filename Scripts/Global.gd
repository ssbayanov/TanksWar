extends Node

var texture_standart = "res://Images/tankBody_dark_outline.png"
var tanks = {
	'standart': {
		'cost': 3,
		'sprite': "res://Images/tankBody_dark_outline.png",
		'barrel_count': 1,
		'hp': 100,
		'acc': 100,
		'dec': 1000,
		'speed': 1000,
		'max_barrel_type':2,
		'barrel_pos': [
			Vector2(775, 430),
			],
		},
		
	'big_tank': {
		'cost': 50,
		'sprite': "res://Images/tankBody_darkLarge_outline.png",
		'barrel_count': 2,
		'hp': 150,
		'acc': 70,
		'dec': 1000,
		'speed': 700,
		'max_barrel_type':2,
		'barrel_pos': [
			Vector2(827,415),
			Vector2(847,415),
			],

		},
	'the_biggest_tank': {
		'cost': 100,
		'sprite': "res://Images/tankBody_huge_outline.png",
		'barrel_count': 4,
		'hp': 250,
		'acc': 50,
		'dec': 1000,
		'speed': 450,
		'max_barrel_type':3,
		'barrel_pos': [
			Vector2(754,417),
			Vector2(771,417),
			Vector2(754,385),
			Vector2(771,385),
			],
		}
	}


func _ready():
	var texture_standart = "res://Images/tankBody_dark_outline.png"
	randomize()

func rand_rangei(start, stop):
	if start == stop:
		return start
	return randi() % int((stop - start)) + int(start)




		#поменять танка "res://Images/tankBody_dark_outline.png"
		
	

