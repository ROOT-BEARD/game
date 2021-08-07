extends CanvasLayer

signal transition

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("fadetonormal")

func transition():
	animationPlayer.play("fadeToBlack")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeToBlack":
		emit_signal("transition")
		animationPlayer.play("fadetonormal")
