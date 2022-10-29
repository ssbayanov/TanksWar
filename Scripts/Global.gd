extends Node

var tank_bodies = {
	'standart': {
		'hp' : 100,
		'places' : 1,
		'speed' : 700,
		'texture' : "res://Images/tankBody_red_outline.png",
		'max_type_barrel' : 2,
	},
	'better_tank': {
		'hp' : 200,
		'places' : 1,
		'speed' : 650,
		'texture' :"res://Images/tankBody_darkLarge_outline.png",
		'max_type_barrel' : 4 ,
		},
	'big_tank' : {
		'hp' : 300,
		'places' : 2,
		'speed' : 500,
		'texture' :"res://Images/tankBody_bigRed_outline.png",
		'max_type_barrel' : 6 ,
		},
	'best_tank' : {
		'hp' : 500,
		'places' : 2,
		'speed' : 400,
		'texture' :"res://Images/tankBody_huge_outline.png",
		'max_type_barrel' : 10 ,
		},
}

func _ready():
	randomize()

func rand_rangei(start, stop):
	if start == stop:
		return start
	return randi() % int((stop - start)) + int(start)

