## Original File MIT License Copyright (c) 2024 TinyTakinTeller
class_name SaveFilesMenu
extends Control

@export_group("Play Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.GAME_SCENE
@export var scene_manager_options_id: String = "fade_play"

@export var menu_save_file_pck: PackedScene

var _menu_save_files: Array[MenuSaveFile] = []

var _action_handler: ActionHandler = ActionHandler.new()

@onready var save_files_menu_scroll_container: ScrollContainer = %SaveFilesMenuScrollContainer
@onready var save_files_v_box_container: VBoxContainer = %SaveFilesVBoxContainer
@onready var control_grab_focus: ControlGrabFocus = %ControlGrabFocus
@onready var menu_textbox_dialog: MenuTextboxDialog = %MenuTextboxDialog

@onready var back_menu_button: MenuButtonClass = %BackMenuButton

signal iniciar_fase(id_fase: int)


func _ready() -> void:
	if not menu_save_file_pck:
		LogWrapper.debug(self, "Save File UI packed scene not set.")
		return

	init_buttons()
	_connect_signals()


func init_buttons() -> void:

	var fase_atual: int = SaveManager.dados_do_jogo["fase_atual"]

	var id_fase: int = 1
	for phase_button in save_files_v_box_container.get_children():
		if phase_button is not MenuButtonClass:
			continue
		phase_button.button_down.connect(_on_phase_button_pressed.bind(id_fase))
		phase_button.text = 'Fase ' + str(id_fase)
		
		phase_button.disabled = id_fase > fase_atual
		id_fase += 1

	control_grab_focus.ready()


func _connect_signals() -> void:
	SaveManager.jogo_salvo.connect(_on_jogo_salvo)


func _on_jogo_salvo() -> void:

	var fase_atual: int = SaveManager.dados_do_jogo["fase_atual"]
	var id_fase: int = 1
	for phase_button in save_files_v_box_container.get_children():
		if phase_button is not MenuButtonClass:
			continue
		if id_fase > fase_atual:
			phase_button.disabled = true


func _on_phase_button_pressed(id_fase: int) -> void:
	iniciar_fase.emit(id_fase)
