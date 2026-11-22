extends Node

signal dialogue_finished

@onready var dialogue_panel : Control = %DialoguePanel

var dialogue_lines : Array = []
var current_line : int = 0
var is_playing : bool = false

func _ready():
	dialogue_panel.next_dialogue.connect(advance_dialogue)

func start_dialogue(file_path: String, sequence: String = "start"):
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		push_error("Could not open dialogue file: " + file_path)
		return
		
	var data = JSON.parse_string(file.get_as_text())
	
	if not data is Dictionary:
		push_error("Invalid dialogue JSON.")
		return
	
	if not data.has(sequence) or not data[sequence] is Array:
		push_error("Dialogue sequence not found: " + sequence)
		return
	
	dialogue_lines = data[sequence]
	current_line = 0
	is_playing = true
	
	show_current_line()

# shows the whole dialogue text immediatelly, should show text bit by bit (not render all in one go)
func show_current_line():
	if current_line >= dialogue_lines.size():
		end_dialogue()
		return
	
	var line = dialogue_lines[current_line]
	
	dialogue_panel.show_line(
		line.get("speaker", " "),
		line.get("text", "")
	)

func advance_dialogue():
	if not is_playing:
		return
	
	current_line += 1
	show_current_line()

func end_dialogue():
	is_playing = false
	dialogue_panel.close_dialogue()
	dialogue_finished.emit()
