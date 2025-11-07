extends CanvasLayer

signal iniciar_fase(id_fase: int)

@onready var botoes: Array = [ $Fase1, $Fase2, $Fase3, $Fase4, $Fase5 ]

func _ready() -> void:
	update()

func emitir_sinal_iniciar_fase(id_fase: int) -> void:
	hide()
	emit_signal("iniciar_fase", id_fase)


func update() -> void:
	var fase_atual: int = SaveManager.dados_do_jogo.get("fase_atual", 1)
	for i in range(botoes.size()):
		var botao = botoes[i]
		botao.disabled = i >= fase_atual
		botao.pressed.connect(Callable(self, "emitir_sinal_iniciar_fase").bind(i+1))


func _on_visibility_changed() -> void:
	if visible:
		update()
