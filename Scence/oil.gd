extends StaticBody2D


func spreading():
	$AnimationPlayer.play("spreading")
	
func _ready():
	pass






func _on_Area2D_body_entered(body):
	pass
func _on_Area2D_body_exited(body):
	if body.has_method('slowing'): 
		body.slowing(body)

