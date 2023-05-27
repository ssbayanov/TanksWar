extends CanvasLayer

signal show_all

onready var text_money = $CanvasLayer/money
onready var text_point = $CanvasLayer/points

func _ready():
	pass
#	if g.targets == 0 and g.staje == true:
#		g.targets = null
#		get_tree().paused = true
#game.connect("stage_complete", self, "checker")

	
func checker():
	$Timer.start()
	#		print('stage_started')
	
			
func _process(delta):
	pass

		

func _on_exit_pressed():
	if g.point == 0:
		
#		get_tree().paused = false
		g.money += g.money_earn
		g.save_money()
		g.money_earn = 0
		emit_signal("show_all")


func _on_Timer_timeout():
	if g.targets == 0 and g.point > 0:
#				print('staje_complete')
			text_point.text = 'points: ' + str(g.point)
			text_money.text = 'money: ' + str(g.money_earn)
			g.point -= 1
			g.money_earn += g.tanks[g.tank_parametrs['body']]['coof']
			if g.point == 0:
				text_point.text = ''
				text_money.text = ''
				
			
			$Timer.start()
	elif g.point == 0:
		var text_new = 'points: 0'
		var text_end =  'money: ' + str(g.money_earn)
		text_point.text = text_new
		text_money.text = text_end
#		print("money: " + str(g.money_earn))
		$CanvasLayer/exit.show()
		g.staje = false
	
