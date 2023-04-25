extends Spatial

#Cache references to player, pod, and player_camera nodes
onready var player = $"../Player"
onready var pod = $"boid/Pod"
onready var player_camera = $"../Player/Camera"

var initial_offset
var target_transform

#Variable to track if the player is inside the pod
var is_in_pod = false

#Signal that gets emitted when the player enters the pod
signal player_entered_pod

func _ready():
	#Calculate the initial offset between the creature and the player
	initial_offset = global_transform.origin - player.global_transform.origin
	# Connect to the player_entered_pod signal
	connect("player_entered_pod", self, "_on_player_entered_pod")

func _input(event):
	#If z is pressed stop following player
	#added Stop_follow to key bindings
	if event.is_action_pressed("stop_follow"):
		is_in_pod = false

func _on_Area_body_entered(body):
	#Check if the entered body is the player
	if body == player:
		#Set the target_transform to be the pod's current transform
		target_transform = pod.global_transform
		#Emit the player_entered_pod signal
		emit_signal("player_entered_pod")

func _on_player_entered_pod():
	#Perform each action once the previous action is completed
	yield(move_player_to_target(), "completed")
	yield(rotate_player_to_target(), "completed")
	yield(move_camera_to_target(), "completed")

	#Mark the player as being inside the pod
	is_in_pod = true

func move_player_to_target():
	var t = 0.0
	while t < 1.0:
		t += 0.01
		player.global_transform = player.global_transform.interpolate_with(target_transform, t)
		yield(get_tree().create_timer(0.016), "timeout")
	return "completed"

func rotate_player_to_target():
	var creature_angle = global_transform.basis.get_euler().y
	var player_angle = player.global_transform.basis.get_euler().y
	var angle_diff = creature_angle - player_angle

	while abs(angle_diff) > 0.001:
		var rotation_speed = 0.01 * sign(angle_diff)
		player.rotate_y(rotation_speed)
		player_angle += rotation_speed
		angle_diff = creature_angle - player_angle
		yield(get_tree().create_timer(0.016), "timeout")
	return "completed"

func move_camera_to_target():
	var target_camera_pos = player.global_transform.origin + Vector3(0, 2, -5)
	var t = 0.0
	while t < 1.0:
		t += 0.01
		player_camera.global_transform.origin = player_camera.global_transform.origin.linear_interpolate(target_camera_pos, t)
		yield(get_tree().create_timer(0.016), "timeout")
	return "completed"

func _physics_process(delta):
	#Instead of disabling the player movement and having new creature movement
	#Tryed to make the creature follow the player with a constant off set
	#I do regret this decision :-(
	if is_in_pod:
		var target_position = player.global_transform.origin + initial_offset
		global_transform.origin = global_transform.origin.linear_interpolate(target_position, 0.1)

		#Rotate creature to face the same direction as the player using slerp
		var target_rotation = player.global_transform.basis.orthonormalized()
		global_transform.basis = global_transform.basis.slerp(target_rotation, 0.1)

