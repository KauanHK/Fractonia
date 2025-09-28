extends Button

@export var texto: String = "Botão Padrão"

@onready var label = $Label
@onready var hover_sound = $HoverSound
@onready var press_sound = $PressSound
@onready var animation_player = $AnimationPlayer


func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.pressed.connect(_on_pressed)
	
	label.text = texto


func _on_mouse_entered():
	pass
	# hover_sound.play()
	# animation_player.play("hover_effect")


func _on_pressed():
	pass
	# press_sound.play()
	# animation_player.play("press_effect")
