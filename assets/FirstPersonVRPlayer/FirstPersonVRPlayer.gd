extends KinematicBody

###################-VARIABLES-####################

# Move
var direction := Vector3()
# Walk
# Called when the node enters the scene tree
func _ready() -> void:
	randomize()
	var arvr_interface = ARVRServer.find_interface("Native mobile")
	if arvr_interface and arvr_interface.initialize():
		get_viewport().arvr = true
	direction = Vector3.BACK.rotated(Vector3.UP, $Head.global_transform.basis.get_euler().y)
	# Sometimes in the level design you might need to rotate the Player object itself
	# So changing the direction at the beginning
	set_physics_process(true)
	#$AnimationTree.set(wdd"parameters/walk_scale/scale", walk_speed)
	#switch_weapon(0)
	#$splatters.set_as_toplevel(true)


func _physics_process(delta) -> void:
	 
	var h_rot = self.global_transform.basis.get_euler().y
	if Input.is_action_pressed("hoist") || Input.is_action_pressed("sink"):
		direction = Vector3(
			0,
			Input.get_action_strength("hoist") - Input.get_action_strength("sink"),
			0
		)
		var v = move_and_slide(direction * 10)

	if Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		print(Input.get_action_strength("forward") * 100 )
		direction = Vector3(
			Input.get_action_strength("left") - Input.get_action_strength("right"),
			0,
			(Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		)

		var v = move_and_slide(direction * 10 * -1)
