class_name Game
extends Node2D

var fases: Dictionary = {
	1: preload("res://root/scenes/scene/game_scene/game_content/fases/Fase1.tscn"),
	2: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_2.tscn"),
	3: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_3.tscn"),
	4: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_4.tscn"),
	5: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_5.tscn")
}

# Variáveis para saber qual mapa e player estão na tela
var node_fase_atual: Node = null


func _ready() -> void:
	_on_menu_iniciar_fase(1)


func _on_menu_iniciar_fase(id_fase: int) -> void:
	limpar_fase_anterior()

	# Carrega a cena do mapa do disco e a cria no jogo
	get_tree().paused = false
	var scene = fases.get(id_fase, null)
	if scene == null:
		push_error("Game._on_menu_iniciar_fase: fase %d não encontrada" % id_fase)
		return

	node_fase_atual = scene.instantiate()
	add_child(node_fase_atual)
	if node_fase_atual.has_signal("finalizar_fase"):
		node_fase_atual.finalizar_fase.connect(_on_open_menu)
	if node_fase_atual.has_signal("reiniciar_fase"):
		node_fase_atual.reiniciar_fase.connect(_on_reiniciar_fase.bind(id_fase))


func _on_open_menu() -> void:
	limpar_fase_anterior()
	$Menu.show()


func _on_reiniciar_fase(id_fase: int) -> void:
	_on_menu_iniciar_fase(id_fase)


func limpar_fase_anterior() -> void:
	if is_instance_valid(node_fase_atual):
		node_fase_atual.queue_free()
		node_fase_atual = null
