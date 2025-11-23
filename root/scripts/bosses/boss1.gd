class_name Boss
extends Control

# Sinais para comunicar com a cena da fase.
signal iniciar_batalha
signal morte

@onready var area_2d: Area2D = $Area2D
@onready var perguntas: Array[PerguntaUI] = _carregar_perguntas()
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

var indice_pergunta_atual: int = 0
var pergunta_atual: PerguntaUI


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	area_2d.body_entered.connect(_on_body_entered)


func _carregar_perguntas() -> Array[PerguntaUI]:
	var perguntas: Array[PerguntaUI] = []
	for node_pergunta: PerguntaUI in $Perguntas.get_children():
		perguntas.append(node_pergunta)
	return perguntas


func proxima_pergunta() -> void:

	if pergunta_atual:
		await pergunta_atual.fade_out()
		pergunta_atual.queue_free()
		indice_pergunta_atual += 1
	else:
		indice_pergunta_atual = 0

	if indice_pergunta_atual < perguntas.size():
		pergunta_atual = perguntas[indice_pergunta_atual]
		pergunta_atual.visible = true
		pergunta_atual.ask()
		return
	_derrotar_boss()


func _derrotar_boss() -> void:
	# Toca uma animação de morte.
	# animation_player.play("morte")
	# await animation_player.animation_finished

	morte.emit()
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	iniciar_batalha.emit()
