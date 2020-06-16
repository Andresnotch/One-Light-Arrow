extends KinematicBody2D

# Member variables
const MOTION_SPEED = 200 # Pixels/second


func _physics_process(_delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("w"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("s"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("a"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("d"):
		motion += Vector2(1, 0)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)



func _on_Area2D_area_entered(_area):
	print("player")
	$ArrowLight.visible = true
	$Shadow.visible = false
	pass
