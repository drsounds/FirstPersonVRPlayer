"""
Code from player
"""

extends Spatial

var camrot_h = 0
var camrot_v = 0
var cam_v_max = 65
var cam_v_min = -45
var h_sensitivity = 0.1
var h_sensitivity_aim = 0.04
var v_sensitivity = 0.1
var v_sensitivity_aim = 0.04
var h_acceleration = 10
var v_acceleration = 10

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/pivot/Camera.add_exception(get_parent())
	Input.connect("joy_connection_changed",self,"joy_con_changed")
	print("Connected joypads: " + str(Input.get_connected_joypads()))

func joy_connection_changed(deviceid, isConnected):
	if isConnected:
		print("Joystick " + str(deviceid) + " connected")
	if Input.is_joy_known(0):
		print("Recognized and compatible joystick")
		print(Input.get_joy_name(0) + " device connected")
	else:
		print("Joystick " + str(deviceid) + " disconnected")

func _input(event):
	if self.get_parent().is_motion_locked:
		return
	if event is InputEventMouseMotion:
		var aim_transition = get_node("../AnimationTree").get("parameters/aim_transition/current")
		camrot_h += -event.relative.x * (h_sensitivity * aim_transition + h_sensitivity_aim * (1-aim_transition))
		camrot_v += event.relative.y * (v_sensitivity * aim_transition + v_sensitivity_aim * (1-aim_transition))
	if event is InputEventJoypadMotion:		
		var aim_transition = get_node("../AnimationTree").get("parameters/aim_transition/current")
		if event.axis == 2:
			camrot_h += -event.axis_value * 100 * (h_sensitivity * aim_transition + h_sensitivity_aim * (1-aim_transition))
		elif event.axis == 3:
			camrot_v += event.axis_value * 100 * (v_sensitivity * aim_transition + v_sensitivity_aim * (1-aim_transition))

func _physics_process(delta):
	
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration)

func recoil_recovery():
	pass #camrot_v -= get_node("../WeaponStats").recoil()/2
