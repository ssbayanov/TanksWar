extends StaticBody2D

var hp = 50

export var is_small = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if is_small:
		$CollisionLarge.disabled = true
		$treeGreen_large.hide()
		$treeGreen_small.show()
		hp = 20
	else:
		$treeGreen_large.show()
		$treeGreen_small.hide()

func damage_hp(amount):
	hp -= amount
	if hp <= 0:
		$treeGreen_large.hide()
		$treeGreen_small.hide()
		$CollisionLarge.disabled = true
		$CollisionSmall.disabled = true
		$twings.show()
		$TreeGreenLeaf.show()
		$TreeGreenLeaf2.show()
		$TreeGreenLeaf3.show()
		$TreeGreenLeaf4.show()
		$TreeGreenLeaf5.show()
		$TreeGreenLeaf6.show()
		if is_small:
			$twings/twigs2.hide()
			
		yield(get_tree().create_timer(5.0), "timeout")
		queue_free()
