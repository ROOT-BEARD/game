extends StaticBody2D

func _on_HurtBox_area_entered(area):
	if area.is_in_group("HitBox"):
		queue_free()
