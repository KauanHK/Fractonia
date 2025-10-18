extends Area2D

var is_player_in: bool = false

signal responder_pergunta


func _process(delta: float) -> void:
	if is_player_in and Input.is_action_just_pressed("interact"):
		responder_pergunta.emit(self)

func _on_body_entered(body: Node2D) -> void:
	is_player_in = true


func _on_body_exited(body: Node2D) -> void:
	is_player_in = false
