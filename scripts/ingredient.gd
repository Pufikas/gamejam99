class_name IngredientPanel
extends PanelContainer

@export var ing_name : String = "Temp"
@export var description : String = "A long description"
@export var sprite : Texture2D
@export var custom_cursor : Texture2D

@onready var texture_rect : TextureRect = $TextureRect
@onready var label_text : Label = %Label
@onready var label_description : Label = %Description

signal ingredient_hover(ing_name : String, description : String)

func _ready() -> void:
	texture_rect.texture = sprite
	label_text.text = ing_name
	label_description.text = description

func _on_mouse_entered() -> void:
	ingredient_hover.emit(ing_name, description)

func _on_mouse_exited() -> void:
	ingredient_hover.emit("", "")

# this shows the system cursor again
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _get_drag_data(_at_position: Vector2) -> Variant:
	var p = TextureRect.new() # preview when dragging
	p.texture = custom_cursor
	p.custom_minimum_size = Vector2(64, 64)
	p.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	p.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	set_drag_preview(p)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	return {
		"id": ing_name.to_snake_case(),
		"name": ing_name,
		"texture": sprite
	}
