extends CharacterBody2D


class_name Player

@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -300.0

signal game_over

@onready var health_node: Node = $Health
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	if is_instance_valid(health_node) and health_node.has_method("update"):
		health_node.update()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		sprite.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		sprite.flip_h = false

	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		sprite.play("walking")
	else:
		sprite.stop()


func _on_fase_1_causar_dano(dano: int) -> void:
	print('DANO')
	if is_instance_valid(health_node) and health_node.has_method("causar_dano"):
		health_node.causar_dano(dano)


func _on_health_death() -> void:
	sprite.play("death")
	emit_signal("game_over")
