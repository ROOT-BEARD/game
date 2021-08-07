extends "res://scripts/bunny.gd"

func _on_Timer_timeout():
	animationPlayer.play("blow bubble")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "blow bubble":
		animationPlayer.play("chewing")
