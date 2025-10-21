extends Button

class_name BotaoFractonia

@export var texto: String = "Botão Padrão"

@onready var label: Label = $Label
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var press_sound: AudioStreamPlayer = $PressSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("pressed", Callable(self, "_on_pressed"))
	label.text = texto


func _on_mouse_entered() -> void:
	# hover_sound.play()
	# animation_player.play("hover_effect")
	pass


func _on_pressed() -> void:
	# press_sound.play()
	# animation_player.play("press_effect")
	pass
