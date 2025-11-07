extends Node2D

# Sinais para comunicar com a cena da fase.
signal deve_fazer_pergunta_boss(boss: Node)
signal death_boss

@onready var perguntas_container: Node = $Perguntas
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

var indice_pergunta_atual: int = 0
var perguntas: Array = []

func _ready() -> void:
	perguntas = perguntas_container.get_children()
	# Esconde todas as perguntas no início.
	for p in perguntas:
		p.hide()


func proxima_pergunta() -> void:
	# Esconde a pergunta anterior (se houver).
	if indice_pergunta_atual < perguntas.size():
		perguntas[indice_pergunta_atual].hide()

	indice_pergunta_atual += 1

	# Verifica se ainda há perguntas a serem feitas.
	if indice_pergunta_atual < perguntas.size():
		# Inicia a próxima pergunta.
		perguntas[indice_pergunta_atual].ask()
	else:
		# Se não houver mais perguntas, o boss foi derrotado.
		_derrotar_boss()


func morte_jogador() -> void:
	# Esconde a UI de pergunta que estiver ativa.
	if indice_pergunta_atual < perguntas.size():
		perguntas[indice_pergunta_atual].hide()

	# Reseta o estado da batalha para a próxima tentativa.
	indice_pergunta_atual = 0
	get_tree().paused = false # Garante que o jogo está despausado.


func iniciar_batalha() -> void:
	indice_pergunta_atual = 0
	if perguntas.size() > 0:
		perguntas[indice_pergunta_atual].ask()


func _derrotar_boss() -> void:
	# Toca uma animação de morte.
	# animation_player.play("morte")
	# await animation_player.animation_finished

	# Avisa a cena da fase que a batalha terminou.
	emit_signal("death_boss")

	# Remove o boss da cena.
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	emit_signal("deve_fazer_pergunta_boss", self)
	$CollisionShape2D.set_deferred("disabled", true)
	iniciar_batalha()
