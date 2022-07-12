extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var arvr_interface = ARVRServer.find_interface("Native mobile")
	if arvr_interface and arvr_interface.initialize():
		get_viewport().arvr = true

func _input(event):
	if event.is_action_pressed("restart") and event.get_action_strength("restart") == 1:
		get_tree().change_scene("res://assets/FirstPersonVRPlayerExample/scenes/VR.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
