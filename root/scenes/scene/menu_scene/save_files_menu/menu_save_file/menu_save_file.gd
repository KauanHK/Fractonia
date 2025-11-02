class_name MenuSaveFile
extends MarginContainer
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal save_file_pressed(index: int)
signal save_file_button_pressed(button_type: ButtonType)

enum ButtonType { PLAY, EXPORT, IMPORT, DELETE, RENAME }

const NAME_TITLE: String = "MENU_NAME"
const TIME_TITLE: String = "GAME_OBJECTIVE_TIME"

var index: int = -1

@onready var playtime_datetime_label: Label = %NomeFase
@onready var save_file_button: Button = %SaveFileButton


func _ready() -> void:
	_connect_signals()


func toggle_name_edit(enabled: bool) -> void:
	pass


func set_index(new_index: int) -> void:
	index = new_index


func set_text(text: String) -> void:
	playtime_datetime_label.text = text


func _refresh_title_label() -> void:
	toggle_name_edit(false)


func _connect_signals() -> void:
	save_file_button.pressed.connect(_on_save_file_pressed)
	save_file_button.toggled.connect(_on_save_file_button_toggled)


func _on_save_file_pressed() -> void:
	print('ButtonType.PLAY')
	save_file_button_pressed.emit(ButtonType.PLAY)


func _on_save_file_button_toggled(toggled_on: bool) -> void:
	toggle_name_edit(false)


func _on_language_changed(_locale: String) -> void:
	pass


func _on_button_confirmed(button_type: ButtonType) -> void:
	save_file_button_pressed.emit(button_type)
