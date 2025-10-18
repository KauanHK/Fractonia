extends Node2D

var fases = {
	1: preload("res://scenes/fases/Fase1.tscn"),
	2: preload("res://scenes/fases/fase_2.tscn"),
	3: preload("res://scenes/fases/fase_3.tscn"),
	4: preload("res://scenes/fases/fase_4.tscn"),
	5: preload("res://scenes/fases/fase_5.tscn")
}

# Variáveis para saber qual mapa e player estão na tela
var node_fase_atual = null

func _on_menu_iniciar_fase(id_fase: int) -> void:
	print('_on_menu_iniciar_fase')
	limpar_fase_anterior()

	# Carrega a cena do mapa do disco e a cria no jogo
	get_tree().paused = false
	node_fase_atual = fases[id_fase].instantiate()
	add_child(node_fase_atual)
	node_fase_atual.finalizar_fase.connect(_on_open_menu)
	node_fase_atual.reiniciar_fase.connect(_on_reiniciar_fase.bind(id_fase))


func _on_open_menu() -> void:
	limpar_fase_anterior()
	$Menu.show()


func _on_reiniciar_fase(id_fase) -> void:
	_on_menu_iniciar_fase(id_fase)


func limpar_fase_anterior() -> void:
	if is_instance_valid(node_fase_atual):
		node_fase_atual.queue_free()
		node_fase_atual = null
