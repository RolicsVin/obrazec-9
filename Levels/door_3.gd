extends StaticBody3D


func on():
	$AnimationPlayer.play("on", 0.5)


func off():
	$AnimationPlayer.play("off", 0.5)
