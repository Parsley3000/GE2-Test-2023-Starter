extends Spatial


onready var player = $"../Player"
onready var pod = $Pod

var player_in_pod = false

func _on_Area_body_entered(body):
	if body == player:
		player.global_transform.origin = pod.global_transform.origin + Vector3(0, 1, 0)
		
		player_in_pod = true

func _process(delta):
	if player_in_pod:
		var target_transform = player.global_transform
		global_transform = target_transform

		rotation = player.rotation
