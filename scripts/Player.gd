extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 50
const GRAVITY = 1250
const JUMP_HEIGHT = 350
const MIN_JUMP_HEIGHT = -125

const UP = Vector2(0, -1)

var velocity = Vector2.ZERO
var canMove = true
var isCrouched = false
var canJump = true
var wasJumpPressed = false
var isDead = false
var isLookingUp = false


onready var camera = $Camera2D
onready var respawnPoint = get_node("RespawnPoint").global_position

onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $Area2D/HurtBox
onready var audioStreamPlayer = $AudioStreamPlayer

const DeathEffect = preload("res://deathEffect.tscn")


func _physics_process(delta):
	
	respawnPoint = get_node("RespawnPoint").global_position
	
	velocity.y += GRAVITY * delta
	var friction = false
	
	
	if isDead == false:
		if is_on_floor():
			canJump = true
			if wasJumpPressed == true:
				jump()
		
		if Input.is_action_just_released("Jump") && velocity.y <= MIN_JUMP_HEIGHT:
			velocity.y = MIN_JUMP_HEIGHT
		
		
		if Input.is_action_just_pressed("attack"):
			$HitBox/CollisionShape2D.disabled = false
		
		
		if canMove == true:
			if velocity.x > 0:
				$Sprite.flip_h = false
				$HitBox.position.x = 10
			elif velocity.x < 0:
				$Sprite.flip_h = true
				$HitBox.position.x = -10
			if Input.is_action_pressed("ui_right"):
				velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
				animationPlayer.play("Run")
			elif Input.is_action_pressed("ui_left"):
				velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
				animationPlayer.play("Run")
			else:
				animationPlayer.play("Idle")
				friction = true
			if Input.is_action_just_pressed("Jump"):
				wasJumpPressed = true
				rememberJumpTime()
				if canJump == true:
					jump()
					audioStreamPlayer.play()
			if !is_on_floor():
				coyoteTime()
		
	velocity = move_and_slide(velocity, UP)
	
	if is_on_floor():
		if isLookingUp == false:
			if Input.is_action_just_pressed("ui_down"):
				animationPlayer.play("crouch")
				canMove = false
				velocity.x = 0
				isCrouched = true
			elif Input.is_action_just_released("ui_down"):
				canMove = true
				isCrouched = false
		
		if Input.is_action_just_pressed("Look_up"):
			animationPlayer.play("look_up")
			canMove = false
			isLookingUp = true
			velocity.x = 0
			camera.offset.y = -10
		elif Input.is_action_just_released("Look_up"):
			camera.offset.y = 0
			canMove = true
			isLookingUp = false
	
	if !is_on_floor():
		if Input.is_action_pressed("ui_down"):
			velocity.y += 3000 * delta
	
	if isCrouched == true:
		if Input.is_action_just_pressed("ui_right"):
			$Sprite.flip_h = false
		elif Input.is_action_just_pressed("ui_left"):
			$Sprite.flip_h = true
	
	if friction == true:
		velocity.x = lerp(velocity.x, 0, 0.3)
	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.05)
				

func jump():
	audioStreamPlayer.play()
	velocity.y = -JUMP_HEIGHT
	
func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJump = false
	
func rememberJumpTime():
	yield(get_tree().create_timer(.1), "timeout")
	wasJumpPressed = false
	
func dead():
	$Sprite.visible = false
	$deathTimer.start()

func _on_Timer_timeout():
	$Sprite.visible = true
	self.position = respawnPoint
	isDead = false

func create_death_effect():
	var deathEffct = DeathEffect.instance()
	get_parent().add_child(deathEffct)
	deathEffct.global_position = global_position

func _on_Area2D_area_entered(area):
	if area.is_in_group("HitBox"):
		dead()
		create_death_effect()
		isDead = true
		velocity.x = 0
	elif area.is_in_group("Door"):
		canMove = false
		animationPlayer.play("Idle")
		velocity.y = 0
		velocity.x = 0
		$transitionScreen.transition()

func _on_transitionScreen_transition():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Levels/level2.tscn")

func _on_checkpoint_checked():
	pass
