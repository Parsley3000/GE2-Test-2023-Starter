extends Spatial

# Variables for nodes
onready var player = $"../Player"
onready var pod = $Pod
onready var camera = $"../Player/Camera"

# Flag for whether the player has entered the pod
var player_enter_pod = false

#Flag for when the player is in position above pod
var player_in_pod = false

# Movement speed for smooth transition moving player over to pod
var move_speed = 5.0

# Camera offset to move out of first person, into third person
var camera_offset = Vector3(0, 2, -4)

# Signal from the pod
func _on_Area_body_entered(body):
	#if the body that entered is the player
	if body == player:
		#set position of player just a
		player.global_transform.origin = player.global_transform.origin.linear_interpolate(pod.global_transform.origin + Vector3(0, 1, 0))
		# Set the flag to start following the player
		player_enter_pod = true

func _process(delta):
	if player_enter_pod:
		#set position of player just a
		player.global_transform.origin = player.global_transform.origin.linear_interpolate(pod.global_transform.origin + Vector3(0, 1, 0))
		
	if (player.global_transform.origin) == (pod.global_transform.origin + Vector3(0, 1, 0)):
		var player_in_pod = true
		
		
	if player_in_pod:
		# Update the camera's position relative to the player
		camera.global_transform.origin = player.global_transform.origin + camera_offset

		# Update the creature's transform to match the player's transform
		var target_transform = player.global_transform
		global_transform = target_transform

		# Apply rotation as well
		rotation = player.rotation




