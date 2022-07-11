extends ARVROrigin


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventJoypadButton:
		if event.is_action_pressed("lying"):
			rotate_x(PI / 2)
		if event.is_action_pressed("standing"):
			rotate_x(PI * 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
