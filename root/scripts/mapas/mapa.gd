class_name Mapa
extends Node2D

@onready var player_start: Marker2D = $PlayerStart
@onready var node_mobs: Node2D = %Mobs
@onready var boss: Boss = $Boss
@onready var mobs: Array[Mob] = _carregar_mobs()


func posicionar_jogador(player: Player) -> void:
	player.global_position = player_start.global_position


func configurar_mobs(texto_perguntas: Array) -> void:
	for i in range(mobs.size()):
		var mob: Mob = mobs[i]
		mob.pergunta.configurar(texto_perguntas[i])


func configurar_boss(texto_perguntas_boss: Array) -> void:
	for i in range(boss.perguntas.size()):
		boss.perguntas[i].configurar(texto_perguntas_boss[i])


func _carregar_mobs() -> Array[Mob]:
	mobs = []
	for mob: Mob in $Mobs.get_children():
		mobs.append(mob)
	return mobs
