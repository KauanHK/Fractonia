class_name MainMenu
extends Control
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const VERSION_PREFIX: String = "v"

@onready var title_label: Label = %TitleLabel

@onready var play_menu_button: MenuButtonClass = %PlayMenuButton
@onready var options_menu_button: MenuButtonClass = %OptionsMenuButton
@onready var credits_menu_button: MenuButtonClass = %CreditsMenuButton
@onready var quit_menu_button: MenuButtonClass = %QuitMenuButton


func _ready() -> void:
	_connect_signals()
	_refresh_labels()

	if OS.has_feature("web"):
		quit_menu_button.visible = false

	LogWrapper.debug(self, "Scene ready.")


func _refresh_labels() -> void:
	title_label.text = TranslationServerWrapper.translate(Configuration.GAME_TITLE)


func _connect_signals() -> void:
	SignalBus.language_changed.connect(_on_language_changed)
	
	quit_menu_button.confirmed.connect(_on_quit_button)


func _on_language_changed(_locale: String) -> void:
	_refresh_labels()


func _on_quit_button() -> void:
	get_tree().quit()
