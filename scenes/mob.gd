extends Area2D

signal responder_pergunta

func _on_body_entered(body: Node2D) -> void:
	responder_pergunta.emit()
