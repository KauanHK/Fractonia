@tool
extends Control
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export_group("Next Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.MENU_SCENE
@export var scene_manager_options_id: String = "fade_boot"

var scene_fase_atual = null
var _boot_splash_color: Color = ProjectSettings.get("application/boot_splash/bg_color")
var _boot_splash_image_path: String = ProjectSettings.get("application/boot_splash/image")
var _boot_splash_texture: Texture = load(_boot_splash_image_path)

@onready var boot_splash_color_rect: ColorRect = %BootSplashColorRect
@onready var boot_splash_texture_rect: TextureRect = %BootSplashTextureRect
@onready var menu_scene: MenuScene = $MenuScene

var fases: Dictionary = {
	1: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_1.tscn"),
	2: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_2.tscn"),
	3: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_3.tscn"),
	4: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_4.tscn"),
	5: preload("res://root/scenes/scene/game_scene/game_content/fases/fase_5.tscn")
}


func _ready() -> void:
	_set_boot_splash()

	if Engine.is_editor_hint():
		return

	menu_scene.save_files_menu.iniciar_fase.connect(_on_inicar_fase)


func _set_boot_splash() -> void:
	boot_splash_color_rect.color = _boot_splash_color
	boot_splash_texture_rect.texture = _boot_splash_texture


func _on_inicar_fase(id_fase: int) -> void:
	menu_scene.queue_free()
	print(id_fase)
	scene_fase_atual = fases[id_fase].instantiate()
	add_child(scene_fase_atual)
