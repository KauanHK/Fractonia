extends CanvasLayer

signal iniciar_fase


func emitir_sinal_iniciar_fase(id_fase) -> void:
	hide()
	emit_signal('iniciar_fase', id_fase)


func _ready() -> void:
	
	var botoes = [
		$Fase1,
		$Fase2,
		$Fase3,
		$Fase4,
		$Fase5,
	]
	
	var fase_atual = SaveManager.dados_do_jogo["fase_atual"]
	for i in range(1, fase_atual+1):
		botoes[i].disabled = true


func _on_fase_1_pressed() -> void:
	emitir_sinal_iniciar_fase(1)


func _on_fase_2_pressed() -> void:
	emitir_sinal_iniciar_fase(2)


func _on_fase_3_pressed() -> void:
	emitir_sinal_iniciar_fase(3)


func _on_fase_4_pressed() -> void:
	emitir_sinal_iniciar_fase(4)


func _on_fase_5_pressed() -> void:
	emitir_sinal_iniciar_fase(5)
