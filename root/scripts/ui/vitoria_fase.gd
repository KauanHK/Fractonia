class_name VitoriaFase
extends CanvasLayer

@onready var restart_button: MenuButtonClass = %RestartButton
@onready var menu_button: MenuButtonClass = %MenuButton

var _max_coins: int = -1


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("ui_left"):
		print(1)

	if not visible or (SaveManager.dados_do_jogo["moedas"] >= _max_coins and _max_coins != -1):
		if Input.is_action_just_pressed("ui_left"):
			print(2)
		return

	if _max_coins == -1:
		if Input.is_action_just_pressed("ui_left"):
			print(3)
		_max_coins = SaveManager.dados_do_jogo["moedas"] + 500

	if Input.is_action_just_pressed("ui_left"):
		print(SaveManager.dados_do_jogo["moedas"])
	
	SaveManager.dados_do_jogo["moedas"] += 5
	SaveManager.salvar_jogo()
