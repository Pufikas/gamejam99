extends Node2D

@onready var customer = $Customer
@onready var dialogue_manager = %DialogueManager
@onready var cake : Node2D = $Plate/Cake
@onready var cake_combination_area : PanelContainer = $CakeCombinationArea

@onready var cake_clear_btn : Button = $UI/CakeButtons/Clear
@onready var cake_serve_btn : Button = $UI/CakeButtons/Serve

func _ready() -> void:
	customer.customer_clicked.connect(_on_customer_clicked)
	
	cake_combination_area.ingredients_changed.connect(_on_ingredients_changed)
	cake_combination_area.ingredient_applied.connect(cake.toggle_sprite) # player drags an ingredient to the combination area
	cake_combination_area.clear_cake_sprites.connect(cake.clear_cake)
	cake_combination_area.cake_created.connect(_on_cake_created)
	
	_on_ingredients_changed(0)
	customer.enter_bakery()

func _on_ingredients_changed(count: int) -> void:
	print("[DEBUG] (bakery) _on_ingredients_changed ", count)
	cake_clear_btn.visible = count > 0
	cake_serve_btn.visible = count == 2

func _on_cake_created(recipe: Dictionary) -> void:
	print("[DEBUG] (bakery) Cake created: ", recipe)

func _on_customer_clicked() -> void:
	if dialogue_manager.is_playing:
		return
	
	# just temp hard coded load
	dialogue_manager.start_dialogue(
		"res://narratives/customer_01.json"
	)

# calls functions inside the cake_combination_area script
func _on_serve_pressed() -> void:
	cake_combination_area.create_cake()

func _on_clear_pressed() -> void:
	cake_combination_area.clear_combinations()
