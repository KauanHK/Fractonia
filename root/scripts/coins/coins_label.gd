class_name CoinsLabel
extends Control

@onready var coins_label: Label = %CoinsLabel


func _ready() -> void:
	update()


func update() -> void:
	var num_moedas_atual: int = SaveManager.dados_do_jogo["moedas"]
	coins_label.text = str(num_moedas_atual)
