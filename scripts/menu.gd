extends CanvasLayer

signal iniciar_fase

func _ready() -> void:
	
	var botoes = [
		$Fase1,
		$Fase2,
		$Fase3,
		$Fase4,
		$Fase5,
	]
	
	var fase_atual = SaveManager.dados_do_jogo["fase_atual"]
	for i in range(botoes.size()):
		var botao = botoes[i]
		botao.disabled = i >= fase_atual
		botao.pressed.connect(emitir_sinal_iniciar_fase.bind(i+1))


func emitir_sinal_iniciar_fase(id_fase) -> void:
	print('ok')
	hide()
	iniciar_fase.emit(id_fase)
