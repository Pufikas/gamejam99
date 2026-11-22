extends Control

@onready var play = $VBoxContainer/Start
@onready var exit = $VBoxContainer/Exit   # Ajusta la ruta si es diferente

func _ready():
	play.grab_focus()
	play.pressed.connect(_on_Start_pressed)
	exit.pressed.connect(_on_Exit_pressed)


func _on_Start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bakery.tscn")


func _on_Exit_pressed() -> void:
	get_tree().quit()
