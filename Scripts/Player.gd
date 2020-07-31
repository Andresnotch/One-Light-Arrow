extends KinematicBody2D

export var player_speed = 200 # Pixels/second
export var progress = 0
export var life = 0

var arrow = preload("res://Scenes/Player/Arrow.tscn")
var arrow_point = preload("res://Scenes/Player/ArrowPoint.tscn")

func _ready():
	life = GlobalVars.playerLife
	GlobalVars.playerShootingTime = 0

func _process(_delta):
	#Shoot force accumulates over time
	if Input.is_action_pressed("Fire") and !get_tree().root.has_node("Arrow"):
		if GlobalVars.playerShootingTime < 100: GlobalVars.playerShootingTime += 1
	elif Input.is_action_just_released("Fire"):
		pass
	else:
		if GlobalVars.playerShootingTime > 0:
			GlobalVars.playerShootingTime = 0
			
			
	# Fire only if it has no arrows in tree
	if Input.is_action_just_released("Fire") and !get_tree().root.has_node("Arrow") and (GlobalVars.playerShootingTime > 10):
		print(GlobalVars.playerShootingTime)
		#Turn off self light, shadow on and small light on
		$ArrowLight.visible = false
		$Shadow.visible = true
		$SmallLight.visible = true
		var arrow_instance = arrow.instance()
		arrow_instance.position = position
		arrow_instance.apply_impulse(Vector2(),
				get_local_mouse_position().normalized() *
				GlobalVars.playerStrenght / 100 * GlobalVars.playerShootingTime)
		arrow_instance.name = "Arrow"
		get_tree().root.add_child(arrow_instance)
	# When Arrow is on ground, instance the Arrowpoint
	if (get_tree().root.has_node("Arrow") and
			get_tree().root.get_node("Arrow").onground and
			!get_tree().root.has_node("ArrowPoint")):
		var arrow_point_instance = arrow_point.instance()
		arrow_point_instance.position = position
		arrow_point_instance.name = "ArrowPoint"
		get_tree().root.add_child(arrow_point_instance)
	# Arrowpoint looks at Arrow position
	if get_tree().root.has_node("ArrowPoint"):
		var ap = get_tree().root.get_node("ArrowPoint")
		ap.position = position
		ap.look_at(get_tree().root.get_node("Arrow").position)
		
	#Death	
	if (life <= 0):
		GlobalVars.current_scene = get_tree().current_scene.filename
		get_tree().change_scene("res://Scenes/Game_Over.tscn") 
		
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


func _on_ArrowArea_area_entered(_area):
	$SmallLight.visible = false
	$ArrowLight.visible = true
	$Shadow.visible = false
	if get_tree().root.has_node("ArrowPoint"):
		get_tree().root.get_node("ArrowPoint").queue_free()
		get_tree().root.get_node("Arrow").queue_free()
	pass


func _on_DamageArea_area_entered(_area):
	#Solo daña si no se está procesando un daño anterior
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Damage")
		GlobalVars.playerLife -= 25
		life = GlobalVars.playerLife
		print(life)
	pass # Replace with function body.
	
