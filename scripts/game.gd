extends Node2D

var fases = {
	1: "res://scenes/map.tscn",
	2: "res://scenes/map2.tscn"
}
var caminho_player = "res://scenes/player.tscn"

# Variáveis para saber qual mapa e player estão na tela
var node_mapa_atual = null
var node_player_atual = null

func _on_menu_iniciar_fase(id_fase: int) -> void:
	# Garante que não há um jogo antigo rodando
	limpar_fase_anterior()

	# Carrega a cena do mapa do disco e a cria no jogo
	var cena_mapa = load(fases[id_fase])
	node_mapa_atual = cena_mapa.instantiate()
	add_child(node_mapa_atual)
	
	# Carrega a cena do player e a cria no jogo
	var cena_player = load(caminho_player)
	node_player_atual = cena_player.instantiate()
	
	# Coloca o jogador na posição inicial definida no mapa
	var ponto_inicial = node_mapa_atual.get_node_or_null("PlayerStart")
	if ponto_inicial:
		node_player_atual.global_position = ponto_inicial.global_position
	
	add_child(node_player_atual)
	
	node_mapa_atual.open_menu.connect(_on_open_menu)
	$Menu.hide()


func _on_open_menu() -> void:
	limpar_fase_anterior()
	$Menu.show()


func limpar_fase_anterior() -> void:
	if is_instance_valid(node_mapa_atual):
		node_mapa_atual.queue_free()
		node_mapa_atual = null
		
	if is_instance_valid(node_player_atual):
		node_player_atual.queue_free()
		node_player_atual = null
