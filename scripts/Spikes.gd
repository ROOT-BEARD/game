extends KinematicBody2D

const TYPE = "Enemy"

const DeathEffect = preload("res://deathEffect.tscn")

func create_death_effect():
	var deathEffct = DeathEffect.instance()
	get_parent().add_child(deathEffct)
	deathEffct.global_position = global_position

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		create_death_effect()
		
