extends KinematicBody2D

export var progress = 0
export var life = 0
var velocity = Vector2.ZERO
export (int) var gravity = 1000
export (int) var speed = 200
export (int) var jump_speed = -350
export (int, 0, 200) var push = 100
export (float, 0, 1.0) var friction = 0.2
export (float, 0, 1.0) var acceleration = 0.25

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

			
func get_input():
	var dir = 0
	if Input.is_action_pressed("d"):
		dir += 1
	if Input.is_action_pressed("a"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
func _physics_process(delta):
	get_input()
	if is_on_wall() and velocity.y > 0:
		velocity.y += gravity * delta/5
	else:
		velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = jump_speed
		if is_on_wall():
			velocity.y = jump_speed
			if $CheckWallRight.is_colliding():
				velocity.x = -400
			else: velocity.x = 400
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
#			var cpos = collision.collider.to_local(collision.position)
			collision.collider.apply_central_impulse(-collision.normal * push)

func _on_ArrowArea_area_entered(_area):
	$SmallLight.visible = false
	$ArrowLight.visible = true
	$Shadow.visible = false
	if get_tree().root.has_node("ArrowPoint"):
		get_tree().root.get_node("ArrowPoint").queue_free()
		get_tree().root.get_node("Arrow").queue_free()
	pass


func _on_DamageArea_area_entered(area):
	#Solo daña si no se está procesando un daño anterior
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Damage")
		GlobalVars.playerLife -= 1
		life = GlobalVars.playerLife
		var damagearea : Area2D = area
		velocity += (get_global_transform().get_origin() - damagearea.get_global_transform().get_origin()).normalized() * 500
		print(get_global_transform().get_origin())
	pass
	
