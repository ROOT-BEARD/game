extends Particles2D

onready var audioStreamPlayer = $AudioStreamPlayer

func _ready():
	emitting = true
	audioStreamPlayer.play()
	
