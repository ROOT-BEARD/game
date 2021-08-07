extends "res://scripts/bunny.gd"

var isGunOut = false

func _ready():
	$Timer.wait_time = 5
	$Timer.start()

# warning-ignore:unused_argument
func _on_Area2D_area_entered(area):
	animationPlayer.play("pulling gun")
	isGunOut = true

# warning-ignore:unused_argument
func _on_Area2D_area_exited(area):
	animationPlayer.play("stash gun")
	isGunOut = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "stash gun":
		animationPlayer.play("Idle")
	if anim_name == "look around":
		animationPlayer.play("Idle")

func _on_Timer_timeout():
	if !isGunOut:
		animationPlayer.play("look around")
