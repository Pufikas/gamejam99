extends Node2D

@onready var customer = $Customer
@onready var dialogue_manager = %DialogueManager
@onready var cake : Node2D = $Plate/Cake
@onready var cake_combination_area : PanelContainer = $CakeCombinationArea

@onready var cake_clear_btn : Button = $UI/CakeButtons/Clear
@onready var cake_serve_btn : Button = $UI/CakeButtons/Serve

@onready var ingredient_info : Control = $UI/IngredientInfo
@onready var ingredients_panel : Node2D = $IngredientsPanel

func _ready() -> void:
	customer.customer_clicked.connect(_on_customer_clicked)
	
	cake_combination_area.ingredients_changed.connect(_on_ingredients_changed)
	cake_combination_area.ingredient_applied.connect(cake.toggle_sprite) # player drags an ingredient to the combination area
	cake_combination_area.clear_cake_sprites.connect(cake.clear_cake)
	cake_combination_area.cake_served.connect(_on_cake_served)
	
	# connect all ingredients from the ingredient panel where the node class name is IngredientPanel
	for ingredient in ingredients_panel.find_children("*", "IngredientPanel", true, false):
		ingredient.ingredient_hover.connect(_on_ingredient_hovered)
	
	_on_ingredients_changed(0)
	customer.enter_bakery()

func _on_ingredient_hovered(ing_name: String, description: String) -> void:
	%IngredientLabel.text = ing_name
	%IngredientDescription.text = description
	
	#print("[DEBUG] hover ingredient: ", ing_name)
	ingredient_info.show()

func _on_ingredients_changed(count: int) -> void:
	#print("[DEBUG] (bakery) _on_ingredients_changed ", count)
	cake_clear_btn.visible = count > 0
	cake_serve_btn.visible = count == 2

func _on_cake_served(recipe: Dictionary) -> void:
	print("[DEBUG] (bakery) Cake created: ", recipe)
	print("[DEBUG] Customer reference: ", customer)
	customer.receive_cake(recipe)

func _on_customer_clicked() -> void:
	if dialogue_manager.is_playing:
		return
	
	dialogue_manager.start_dialogue(customer.dialogue_file)

# calls functions inside the cake_combination_area script
func _on_serve_pressed() -> void:
	cake_combination_area.serve_cake()

func _on_clear_pressed() -> void:
	cake_combination_area.clear_combinations()
