extends CharacterBody2D


@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0

signal healthChanged
signal game_over


func _ready() -> void:
	$Health.update()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.stop()


func _on_fase_1_causar_dano(dano: int) -> void:
	$Health.causar_dano(dano)


func _on_health_death() -> void:
	$AnimatedSprite2D.play("death")
	game_over.emit()
