extends KinematicBody2D

export var player_speed = 200 # Pixels/second
export var strenght = 1000

var arrow = preload("res://Scenes/Player/Arrow.tscn")
var arrow_point = preload("res://Scenes/Player/ArrowPoint.tscn")

func _process(_delta):
	#Fire only if it has no arrows in tree
	if Input.is_action_pressed("Fire") and !get_tree().root.has_node("Arrow"):
		var arrow_instance = arrow.instance()
		arrow_instance.position = position
		arrow_instance.apply_impulse(Vector2(), get_local_mouse_position().normalized()*strenght)
		arrow_instance.name = "Arrow"
		get_tree().root.add_child(arrow_instance)
		#Turn off self light, shadow on and small light on
		$ArrowLight.visible = false
		$Shadow.visible = true
		$SmallLight.visible = true
	if get_tree().root.has_node("Arrow") and !get_tree().root.has_node("ArrowPoint"):
		var arrow_point_instance = arrow_point.instance()
		arrow_point_instance.position = position
		arrow_point_instance.name = "ArrowPoint"
		get_tree().root.add_child(arrow_point_instance)
	if get_tree().root.has_node("ArrowPoint"):
		var ap = get_tree().root.get_node("ArrowPoint")
		ap.position = position
		ap.look_at(get_tree().root.get_node("Arrow").position)
	pass

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
	
	motion = motion.normalized() * player_speed

	move_and_slide(motion)



func _on_Area2D_area_entered(_area):
	$SmallLight.visible = false
	$ArrowLight.visible = true
	$Shadow.visible = false
	if get_tree().root.has_node("ArrowPoint"):
		get_tree().root.get_node("ArrowPoint").queue_free()
		get_tree().root.get_node("Arrow").queue_free()
		
	pass
