extends Spatial

var rotation_speed = 1

func _process(delta):
	#Rotate the pod around its Y-axis
	rotate_y(rotation_speed * delta)
