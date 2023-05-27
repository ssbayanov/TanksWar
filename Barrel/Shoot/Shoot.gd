extends Sprite


var shoots = ["Large", "Orange", "Red", "Thin"]
enum shootTypes {LARGE, ORANGE, RED, THIN}

var type = shootTypes.THIN

var time = 0
var time_leave = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_texture(g.shoots_resources.get("shoot%s" % shoots[type]))


func _process(delta):
	if time > time_leave and visible:
		hide()
	else:
		time += delta


func shoot():
	show()
	time = 0
