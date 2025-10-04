extends CharacterBody2D


@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0
@export var currentHealth: int = 100
@export var maxHealth: int = 100

signal healthChanged


func _ready() -> void:
	$HealthBar.update(self)


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


func _on_fase_1_causar_dano(dano: int) -> void:
	currentHealth -= dano
	$HealthBar.update(self)
