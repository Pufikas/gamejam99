extends Control

signal next_dialogue

@onready var speaker : Label = $Speaker
@onready var dialogue : Label = $Dialogue
@onready var continue_btn : Button = $Continue

func _ready() -> void:
	continue_btn.pressed.connect(_on_continue_pressed)
	hide()

func show_line(speaker_name: String, dialogue_text: String):
	speaker.text = speaker_name
	dialogue.text = dialogue_text
	show()

func _on_continue_pressed():
	next_dialogue.emit()

func close_dialogue():
	hide()
