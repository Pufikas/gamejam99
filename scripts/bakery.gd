extends Node2D

@export var customer_scene : PackedScene
@export var customer_list : Array[CustomerData]
@onready var customer_container : Node2D = $CustomerContainer
@onready var get_hint_btn : Button = $UI/GetHintBtn

@onready var dialogue_manager = %DialogueManager
@onready var cake : Node2D = $Plate/Cake
@onready var cake_combination_area : PanelContainer = $CakeCombinationArea

@onready var cake_clear_btn : Button = $UI/CakeButtons/Clear
@onready var cake_serve_btn : Button = $UI/CakeButtons/Serve

@onready var ingredient_info : Control = $UI/IngredientInfo
@onready var ingredients_panel : Node2D = $IngredientsPanel

var customer : Node2D
var curr_customer_index = 0

func _ready() -> void:
	cake_combination_area.ingredients_changed.connect(_on_ingredients_changed)
	cake_combination_area.ingredient_applied.connect(cake.toggle_sprite) # player drags an ingredient to the combination area
	cake_combination_area.clear_cake_sprites.connect(cake.clear_cake)
	cake_combination_area.cake_served.connect(_on_cake_served)
	
	# connect all ingredients from the ingredient panel where the node class name is IngredientPanel
	for ingredient in ingredients_panel.find_children("*", "IngredientPanel", true, false):
		ingredient.ingredient_hover.connect(_on_ingredient_hovered)
	
	AudioManager.play_music(0)
	_on_ingredients_changed(0)
	spawn_customer()

func spawn_customer():
	if curr_customer_index >= customer_list.size():
		print("No more customers!")
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
		return
	
	var new_customer = customer_scene.instantiate()
	
	customer_container.add_child(new_customer)
	new_customer.customer_clicked.connect(_on_customer_clicked)
	new_customer.customer_left.connect(_on_customer_left)
	
	new_customer.setup(
		customer_list[curr_customer_index],
		curr_customer_index,
		dialogue_manager # pass the reference where is the dialogue manager
	)
	
	customer = new_customer
	curr_customer_index += 1
	
	customer.enter_bakery()

func _on_customer_left():
	if customer:
		customer.queue_free()
	
	customer = null
	await get_tree().create_timer(4.0).timeout
	spawn_customer()

func _on_ingredient_hovered(ing_name: String, description: String) -> void:
	%IngredientLabel.text = ing_name
	%IngredientDescription.text = description
	#print("[DEBUG] hover ingredient: ", ing_name)
	if ing_name == "" || description == "":
		ingredient_info.visible = false
	else:
		ingredient_info.visible = true

func _on_ingredients_changed(count: int) -> void:
	#print("[DEBUG] (bakery) _on_ingredients_changed ", count)
	cake_clear_btn.visible = count > 0
	cake_serve_btn.visible = count == 2

func _on_cake_served(recipe: Dictionary) -> void:
	print("[DEBUG] (bakery) Cake created: ", recipe)
	print("[DEBUG] Customer reference: ", customer)
	if customer == null:
		return
	customer.receive_cake(recipe)

func _on_customer_clicked() -> void:
	if dialogue_manager.is_playing:
		return
	
	dialogue_manager.start_dialogue(customer.get_dialogue_path(), "start")

# calls functions inside the cake_combination_area script
func _on_serve_pressed() -> void:
	cake_combination_area.serve_cake()

func _on_clear_pressed() -> void:
	cake_combination_area.clear_combinations()

func _on_get_hint_btn_pressed() -> void:
	if dialogue_manager.is_playing:
		dialogue_manager.end_dialogue()
	
	if !customer:
		return
	
	dialogue_manager.start_dialogue(customer.get_dialogue_path(), "hint")
