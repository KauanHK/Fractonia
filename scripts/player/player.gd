extends CharacterBody2D

const VELOCIDADE = 200.0

func _process(delta: float) -> void:
	
	var direcao := Vector2.ZERO
	direcao.x = Input.get_axis("move_left", "move_right")
	direcao.y = Input.get_axis("move_up", "move_down")
	direcao = direcao.normalized()
	
	velocity = direcao * VELOCIDADE
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
	global_position.x = clamp(global_position.x, 0, 1580)
	global_position.y = clamp(global_position.y, 0, 847)
	
	move_and_slide()
