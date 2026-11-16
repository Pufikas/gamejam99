extends Node2D

@onready var customer = $Customer
@onready var dialogue_manager = %DialogueManager

func _ready() -> void:
	customer.customer_clicked.connect(_on_customer_clicked)
	customer.enter_bakery()

func _on_customer_clicked() -> void:
	if dialogue_manager.is_playing:
		return
	
	# just temp hard coded load
	dialogue_manager.start_dialogue(
		"res://narratives/customer_01.json"
	)
