extends Node2D

@onready var customer = $Customer
@onready var dialogue_manager = %DialogueManager
@onready var cake : Node2D = $Plate/Cake
@onready var cake_combination_area : PanelContainer = $CakeCombinationArea

func _ready() -> void:
	customer.customer_clicked.connect(_on_customer_clicked)
	cake_combination_area.ingredient_applied.connect(cake.toggle_sprite) # player drags an ingredient to the combination area
	cake_combination_area.clear_cake_sprites.connect(cake.clear_cake)
	customer.enter_bakery()

func _on_customer_clicked() -> void:
	if dialogue_manager.is_playing:
		return
	
	# just temp hard coded load
	dialogue_manager.start_dialogue(
		"res://narratives/customer_01.json"
	)
