extends Area2D

class_name Boss2

signal responder_pergunta_boss(boss: Node)
signal death_boss

@onready var nodes_perguntas: Array = $Perguntas.get_children()

var pergunta_atual: Node = null
var index_pergunta_atual: int = 0

func _on_body_entered(body: Node2D) -> void:
	responder_pergunta()


func proxima_pergunta() -> void:
	index_pergunta_atual += 1
	if index_pergunta_atual >= nodes_perguntas.size():
		emit_signal("death_boss")
		queue_free()
		return

	responder_pergunta()


func responder_pergunta() -> void:
	if pergunta_atual != null:
		pergunta_atual.hide()
	else:
		index_pergunta_atual = 0

	pergunta_atual = nodes_perguntas[index_pergunta_atual]
	if pergunta_atual != null:
		pergunta_atual.show()
		emit_signal("responder_pergunta_boss", self)


func morte_jogador() -> void:
	if pergunta_atual != null:
		pergunta_atual.hide()
