extends CharacterBody2D

const VELOCIDADE = 300.0

func _process(delta: float) -> void:
	
	var direcao := Vector2.ZERO
	direcao.x = Input.get_axis("move_left", "move_right")
	direcao.y = Input.get_axis("move_up", "move_down")
	direcao = direcao.normalized()
	
	velocity = direcao * VELOCIDADE
	
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x > 0
	
	move_and_slide()
