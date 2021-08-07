extends StaticBody2D

onready var animationPlayer = $AnimationPlayer

# warning-ignore:unused_argument
func _physics_process(delta):
	var playerPos = get_node("../../Player").global_position
	
	if playerPos.x > self.global_position.x:
		$Sprite.flip_h = false
	elif playerPos.x < self.global_position.x:
		$Sprite.flip_h = true
