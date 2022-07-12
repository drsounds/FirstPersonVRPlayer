extends KinematicBody

###################-VARIABLES-####################

var is_flying = false

var velocity := Vector3()
var hoist := Vector3()
var gravity = 3
var bounce := Vector3()
# Move
var direction := Vector3()
var camera
# Walk
# Called when the node enters the scene tree
func _ready() -> void:
	randomize()
	var arvr_interface = ARVRServer.find_interface("Native mobile")
	if arvr_interface and arvr_interface.initialize():
		get_viewport().arvr = true
	camera = $Head/ARVROrigin/ARVRCamera
	direction = Vector3.BACK.rotated(Vector3.UP, $Head.global_transform.basis.get_euler().y)
	# Sometimes in the level design you might need to rotate the Player object itself
	# So changing the direction at the beginning
	set_physics_process(true)
	#$AnimationTree.set(wdd"parameters/walk_scale/scale", walk_speed)
	#switch_weapon(0)
	#$splatters.set_as_toplevel(true)	

func _input(event):
	if event.is_action_pressed("stop_gravity"):
		gravity = 0
		velocity.y = 0
	if event.is_action_pressed("resume_gravity"):
		velocity.y = 0
		gravity = 50
	if event.is_action_pressed("toggle_gravity"):
		if event.get_action_strength("toggle_gravity") == 1:
			if not is_flying:
				bounce.y = 1
				is_flying = true
			else:
				bounce.y = 0.5
				is_flying = false

	if event.is_action_pressed("jump"):
		if event.get_action_strength("jump") == 1:
			velocity.y = 10

func _physics_process(delta) -> void:	
	print(self.transform.origin.y)
	if self.transform.origin.y < -8000:
		self.transform.origin.y = -self.transform.origin.y
	if velocity.y > -800:
		velocity.y -= gravity * delta 
	if is_flying and velocity.y < 0.5:
		velocity.y = -bounce.y * 0.10
		bounce.y *= 0.1

	if is_on_floor() and velocity.y < 0:
		velocity.y = 0
	
	var h_rot = self.global_transform.basis.get_euler().y
	if Input.is_action_pressed("decrease_gravity"):
		gravity = -10
		if gravity < 0:
			gravity = 0
		velocity.y = 0

	if Input.is_action_pressed("increase_gravity"):
		gravity = 10
		if gravity > 0:
			gravity = 10
	var forward = -camera.transform.basis.z.normalized()
	if Input.is_action_pressed("hoist") || Input.is_action_pressed("sink"):
		hoist = Vector3(
			0,
			Input.get_action_strength("hoist") - Input.get_action_strength("sink"),
			0
		)
		var v = move_and_slide(hoist * 1)
	
	if Input.is_action_pressed("forward"):
		move_and_slide(forward * 5) 
	if Input.is_action_pressed("backward"):
		var backward = -forward
		move_and_slide(backward * 5) 

	if Input.is_action_pressed("left"):
		move_and_slide(-forward.cross(Vector3.UP) * 5)
	if Input.is_action_pressed("right"):
		move_and_slide(forward.cross(Vector3.UP) * 5)
	
	move_and_slide(velocity * 10)
