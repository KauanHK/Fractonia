extends Node2D

var fases = {
	1: "res://scenes/fases/Fase1.tscn",
	2: "res://scenes/map2.tscn"
}
var caminho_player = "res://scenes/player.tscn"

# Variáveis para saber qual mapa e player estão na tela
var node_fase_atual = null

func _on_menu_iniciar_fase(id_fase: int) -> void:
	
	limpar_fase_anterior()

	# Carrega a cena do mapa do disco e a cria no jogo
	var cena_fase = load(fases[id_fase])
	node_fase_atual = cena_fase.instantiate()
	add_child(node_fase_atual)


func _on_open_menu() -> void:
	limpar_fase_anterior()
	$Menu.show()


func limpar_fase_anterior() -> void:
	if is_instance_valid(node_fase_atual):
		node_fase_atual.queue_free()
		node_fase_atual = null
