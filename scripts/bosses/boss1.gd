# Boss.gd
extends Node2D

# Sinais para comunicar com a cena da fase.
signal deve_fazer_pergunta_boss(boss)
signal death_boss

@onready var perguntas_container = $Perguntas
@onready var animation_player = $AnimationPlayer

var indice_pergunta_atual: int = 0
var perguntas: Array

func _ready():
	perguntas = perguntas_container.get_children()
	# Esconde todas as perguntas no início.
	for p in perguntas:
		p.hide()

# Chamado pela cena da fase quando o jogador acerta uma pergunta.
func proxima_pergunta():
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

# Chamado pela cena da fase se o jogador morrer durante a batalha.
func morte_jogador():
	# Esconde a UI de pergunta que estiver ativa.
	if indice_pergunta_atual < perguntas.size():
		perguntas[indice_pergunta_atual].hide()
	
	# Reseta o estado da batalha para a próxima tentativa.
	indice_pergunta_atual = 0
	get_tree().paused = false # Garante que o jogo está despausado.

# Inicia a batalha. Pode ser acionado por colisão, como no mob.
func iniciar_batalha():
	indice_pergunta_atual = 0
	perguntas[indice_pergunta_atual].ask()

func _derrotar_boss():
	# Toca uma animação de morte.
	animation_player.play("morte")
	await animation_player.animation_finished
	
	# Avisa a cena da fase que a batalha terminou.
	death_boss.emit()
	
	# Remove o boss da cena.
	queue_free()
