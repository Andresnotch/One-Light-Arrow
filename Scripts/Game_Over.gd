extends Node2D


func _process(delta):
	if $Yes.pressed:
		GlobalVars.playerLife = 100
		get_tree().change_scene(GlobalVars.current_scene)
	if $No.pressed:
		get_tree().quit()
	pass
