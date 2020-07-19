extends Node2D


func _process(delta):
	if $Yes.pressed:
		get_tree().change_scene(GlobalVars.current_scene)
	if $No.pressed:
		get_tree().quit()
	pass
