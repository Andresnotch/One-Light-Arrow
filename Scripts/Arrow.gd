extends RigidBody2D


# Declare member variables here. Examples:
var flytime : int
export var MAX_FLYTIME = 50
export var onground = false


# Called when the node enters the scene tree for the first time.
func _ready():
	flytime = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if flytime < MAX_FLYTIME:
		flytime += 1
	else:
		linear_damp = -1
		angular_damp = -1
		$PickupArea.monitorable = true
		onground = true
	if linear_velocity.length() > 1:
		$Sprite.look_at(position + linear_velocity)
	pass

