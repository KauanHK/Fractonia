class_name PauseMenu
extends CanvasLayer
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var title_label: Label = %TitleLabel

@onready var continue_menu_button: MenuButtonClass = %ContinueMenuButton
@onready var options_menu_button: MenuButtonClass = %OptionsMenuButton
@onready var leave_menu_button: MenuButtonClass = %LeaveMenuButton
@onready var quit_menu_button: MenuButtonClass = %QuitMenuButton


func _ready() -> void:
	LogWrapper.debug(self, "Ready.")
