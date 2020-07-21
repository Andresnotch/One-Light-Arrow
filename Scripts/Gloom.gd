extends KinematicBody2D

export var life = 100
export var movement_speed = 100
var istriggered = false

func _process(delta):
	var movement = Vector2()
	# Set ray to player relative position
	$LookDirection.cast_to = get_parent().get_parent().get_node("Player").global_position - global_position
	var col = $LookDirection.get_collider()
	if (col != null):
		# If both are Kinematic
		if (col.get_class() == get_parent().get_parent().get_node("Player").get_class()):
			# Set movement
			movement = (get_parent().get_parent().get_node("Player").global_position
			- global_position).normalized() * movement_speed
	# Move when triggered
	if(istriggered): move_and_slide(movement)
	pass

func _on_DamageArea_area_entered(_area):
	if life > 0:
		life -= 50
	else: queue_free()
	pass # Replace with function body.

func _on_VisionArea_body_entered(_body):
	# Entra el jugador al area de vision
	istriggered = true
	pass


func _on_VisionArea_body_exited(_body):
	# Sale el jugador del area de vision
	istriggered = false
	pass
