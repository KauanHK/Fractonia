@tool
extends Control

@export_group("Next Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.MENU_SCENE
@export var scene_manager_options_id: String = "fade_boot"

const FASE_SCENE = preload("res://root/scenes/scene/game_scene/game_content/fases/fase.tscn")

var scene_fase_atual: Fase = null
var scene_pause = null
var _boot_splash_color: Color = ProjectSettings.get("application/boot_splash/bg_color")
var _boot_splash_image_path: String = ProjectSettings.get("application/boot_splash/image")
var _boot_splash_texture: Texture = load(_boot_splash_image_path)

@onready var boot_splash_color_rect: ColorRect = %BootSplashColorRect
@onready var boot_splash_texture_rect: TextureRect = %BootSplashTextureRect
@onready var menu_scene: MenuScene = $MenuScene


func _ready() -> void:
	_set_boot_splash()

	if Engine.is_editor_hint():
		return

	menu_scene.save_files_menu.iniciar_fase.connect(_on_inicar_fase)


func _set_boot_splash() -> void:
	boot_splash_color_rect.color = _boot_splash_color
	boot_splash_texture_rect.texture = _boot_splash_texture


func _on_inicar_fase(id_fase: int) -> void:
	menu_scene.visible = false
	
	scene_fase_atual = FASE_SCENE.instantiate()
	add_child(scene_fase_atual)
	
	scene_fase_atual.finalizar_fase.connect(_on_finalizar_fase)
	scene_fase_atual.set_fase(id_fase)
	scene_fase_atual.init()


func _on_finalizar_fase() -> void:
	get_tree().paused = false
	scene_fase_atual.queue_free()
	menu_scene.visible = true
	menu_scene.save_files_menu.process_mode = Node.PROCESS_MODE_INHERIT
