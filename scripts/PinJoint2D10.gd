extends PinJoint2D

onready var player = get("res://Player.tscn")

func _on_Area2D_area_entered(area):
	Joint.node_b = player
