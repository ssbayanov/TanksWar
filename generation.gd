extends Node2D
var box = 1
var canister = 2 
var wfegr44huah = 3
var barecata = 4
var random_number



func _ready():
	random_number = rand_range(1, 4)
	
	if random_number == box:
		pass load $box ;
	elif random_number == canister:
		pass load $Canistor;
	elif random_number == wfegr44huah:
		pass load $wfegr44huah ;
	else: random_number == barecata:
		pass load $barecata ;
