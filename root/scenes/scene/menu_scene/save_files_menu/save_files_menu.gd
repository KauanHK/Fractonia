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

var fases: Dictionary = {
	1: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_1.tscn"),
	2: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_2.tscn"),
	3: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_3.tscn"),
	4: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_4.tscn"),
	5: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_5.tscn")
}

signal iniciar_fase(id_fase: int)


func _ready() -> void:
	if not menu_save_file_pck:
		LogWrapper.debug(self, "Save File UI packed scene not set.")
		return

	_init_menu_save_files()
	_connect_signals()
	_init_action_handler()


func get_toggled_save_file() -> MenuSaveFile:
	for menu_save_file: MenuSaveFile in _menu_save_files:
		if menu_save_file.save_file_button.button_pressed:
			return menu_save_file
	return null


# the [ActionHandler] can be a cleaner way to handle some signals
# (connect 1 signal with X possible enum values instead of connecting X similar signals)
func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuSaveFile.ButtonType")
	_action_handler.register_actions(
		{
			MenuSaveFile.ButtonType.PLAY: _action_play_save_file_menu_button,
			MenuSaveFile.ButtonType.EXPORT: _action_export_save_file_menu_button,
			MenuSaveFile.ButtonType.IMPORT: _action_import_save_file_menu_button,
			MenuSaveFile.ButtonType.DELETE: _action_delete_save_file_menu_button,
			MenuSaveFile.ButtonType.RENAME: _action_rename_save_file_menu_button
		}
	)


func _action_play_save_file_menu_button(id_fase: int) -> void:
	var menu_save_file: MenuSaveFile = get_toggled_save_file()
	if menu_save_file == null:
		return
	process_mode = PROCESS_MODE_DISABLED
	Data.select_save_file(menu_save_file.index)
	
	iniciar_fase.emit(id_fase)


func _action_export_save_file_menu_button() -> void:
	var menu_save_file: MenuSaveFile = get_toggled_save_file()
	if menu_save_file == null:
		return
	var index: int = menu_save_file.index
	var export: String = Data.export_save_file_index(index)
	var center_target: Control = save_files_menu_scroll_container
	menu_textbox_dialog.custom_popup(export, center_target, false, index)


func _export_confirmed(text: String, _index: int) -> void:
	DisplayServer.clipboard_set(text)


func _action_import_save_file_menu_button(retry_flag: bool = false) -> void:
	var menu_save_file: MenuSaveFile = get_toggled_save_file()
	if menu_save_file == null:
		return
	var index: int = menu_save_file.index
	var center_target: Control = save_files_menu_scroll_container
	var clipboard: String = ""  # DisplayServer.clipboard_get()
	menu_textbox_dialog.custom_popup(clipboard, center_target, true, index, retry_flag)


func _import_confirmed(text: String, index: int) -> void:
	var success: bool = Data.import_save_file_index(index, text)
	if not success:
		_action_import_save_file_menu_button(true)
	else:
		var menu_save_file: MenuSaveFile = _menu_save_files[index]
		menu_save_file = _reload_menu_save_file(menu_save_file)
		_menu_save_files[index] = menu_save_file


func _action_delete_save_file_menu_button() -> void:
	var menu_save_file: MenuSaveFile = get_toggled_save_file()
	if menu_save_file == null:
		return
	var index: int = menu_save_file.index
	Data.delete_save_file_index(index)

	menu_save_file = _reload_menu_save_file(menu_save_file)
	_menu_save_files[index] = menu_save_file


func _action_rename_save_file_menu_button() -> void:
	var menu_save_file: MenuSaveFile = get_toggled_save_file()
	if menu_save_file == null:
		return
	menu_save_file.toggle_name_edit(true)


func _init_menu_save_files() -> void:

	var id_fase: int = 1
	for menu_save_file in save_files_v_box_container.get_children():
		if menu_save_file is not MenuSaveFile:
			continue
		menu_save_file.set_index(id_fase)
		menu_save_file.save_file_pressed.connect(_on_save_file_pressed)
		menu_save_file.save_file_button_pressed.connect(_on_save_file_button_pressed)
		_menu_save_files.append(menu_save_file)
		menu_save_file.set_text('Fase ' + str(id_fase))
		id_fase += 1

	control_grab_focus.ready()


func _reload_menu_save_file(menu_save_file: MenuSaveFile) -> MenuSaveFile:
	var save_files_metadatas: Array[Dictionary] = Data.get_save_files_metadatas()
	var save_file_metadatas: Dictionary = save_files_metadatas[menu_save_file.index]

	return menu_save_file


func _on_save_file_pressed(index: int) -> void:
	for menu_save_file: MenuSaveFile in _menu_save_files:
		if menu_save_file.index != index:
			menu_save_file.save_file_button.button_pressed = false


func _on_save_file_button_pressed(button_type: MenuSaveFile.ButtonType, id_fase: int) -> void:
	print('Mudando para a fase' + str(id_fase))
	_action_handler.handle_action("MenuSaveFile.ButtonType", button_type, self, id_fase)


func _connect_signals() -> void:
	self.visibility_changed.connect(_on_visibility_changed)
	menu_textbox_dialog.confirmed_action.connect(_on_menu_textbox_dialog_confirmed_action)


func _on_visibility_changed() -> void:
	if not is_visible_in_tree():
		for menu_save_file: MenuSaveFile in _menu_save_files:
			menu_save_file.save_file_button.button_pressed = false


func _on_menu_textbox_dialog_confirmed_action(
	textbox_mode: MenuTextboxDialog.TextboxMode, text: String, index: int
) -> void:
	if textbox_mode == MenuTextboxDialog.TextboxMode.IMPORT:
		_import_confirmed(text, index)
	elif textbox_mode == MenuTextboxDialog.TextboxMode.EXPORT:
		_export_confirmed(text, index)
