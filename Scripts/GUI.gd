extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerLife.value = GlobalVars.playerLife
	$PlayerForce.value = GlobalVars.playerShootingTime
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $PlayerLife.value != GlobalVars.playerLife:
		$PlayerLife.value = GlobalVars.playerLife
	if $PlayerForce.value != GlobalVars.playerShootingTime:
		$PlayerForce.value = GlobalVars.playerShootingTime
	pass
