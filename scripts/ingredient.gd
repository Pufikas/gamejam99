extends PanelContainer

@export var ing_name : String = "Temp"
@export var description : String = "A long description"
@export var sprite : Texture2D

@onready var texture_rect : TextureRect = $TextureRect
@onready var label_text : Label = %Label
@onready var label_description : Label = %Description

func _ready() -> void:
	texture_rect.texture = sprite
	label_text.text = ing_name
	label_description.text = description


func _on_mouse_entered() -> void:
	label_description.show()


func _on_mouse_exited() -> void:
	label_description.hide()
