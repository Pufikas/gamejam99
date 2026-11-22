extends Control

signal next_dialogue

@onready var speaker_name : Label = $TextureRect/Speaker
@onready var dialogue_text : RichTextLabel = $TextureRect/Dialogue
@onready var continue_btn : Button = $TextureRect/Continue

var is_revealing : bool = false
var reveal_speed : float = 0.03
var text_tween : Tween

func _ready() -> void:
	continue_btn.pressed.connect(_on_continue_pressed)
	hide()

func show_line(speaker: String, text: String) -> void:
	show() # show the dialogue panel
	speaker_name.text = speaker
	dialogue_text.text = text
	
	dialogue_text.visible_characters = 0
	is_revealing = true
	
	reveal_text()

func reveal_text() -> void:
	if text_tween:
		text_tween.kill()
	
	is_revealing = true
	var char_count = dialogue_text.get_total_character_count()
	var duration = char_count * reveal_speed
	
	text_tween = create_tween()
	text_tween.tween_property(dialogue_text, "visible_ratio", 1.0, duration)
	
	text_tween.finished.connect(reveal_finished)

func reveal_finished() -> void:
	is_revealing = false

func _on_continue_pressed():
	if is_revealing:
		text_tween.kill()
		dialogue_text.visible_ratio = 1.0
		is_revealing = false
	else:
		next_dialogue.emit()

func close_dialogue():
	hide()
