extends Node2D

@onready var player = $Player


func _ready() -> void:
	
	# Coloca o jogador na posição inicial definida no mapa
	var ponto_inicial = get_node_or_null("PlayerStart")
	if ponto_inicial:
		player.global_position = ponto_inicial.global_position
	
	open_menu.connect(_on_open_menu)
	$Menu.hide()
