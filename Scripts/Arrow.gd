extends RigidBody2D


var flytime : int
var MAX_ENEMY_HITS = 3
var MAX_WALL_HITS = 2
var enemyhits : int
var wallhits : int
export var MAX_FLYTIME = 10
export var onground = false


func _ready():
	flytime = 0
	enemyhits = 0
	wallhits = 0
	pass

func _physics_process(delta):
	if flytime < MAX_FLYTIME:
		flytime += 1
	if enemyhits == MAX_ENEMY_HITS or wallhits == MAX_WALL_HITS:
		$PickupArea.monitorable = true
		$HurtArea.monitorable = false
		$ArrowShape.disabled = true
		onground = true
		mode = RigidBody2D.MODE_STATIC
	elif linear_velocity.length() > 3 or flytime < MAX_FLYTIME:
		rotation = linear_velocity.angle()
	pass

func _on_Arrow_body_entered(body):
	if body.is_in_group('Enemies') and enemyhits != MAX_ENEMY_HITS:
		enemyhits += 1
	elif wallhits != MAX_WALL_HITS:
		wallhits += 1
	pass
