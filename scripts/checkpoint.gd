extends StaticBody2D

var isChecked = false

onready var respawnPoint = get_node("RespawnPoint")
onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("idle(unchecked)")

# warning-ignore:unused_argument
func _physics_process(delta):
	if isChecked == true:
		pass

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		respawnPoint.global_position = self.position
		if isChecked == false:
			animationPlayer.play("checked")
		isChecked = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "checked":
		animationPlayer.play("idle(checked)")
