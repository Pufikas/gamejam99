extends PanelContainer

@onready var first_item : TextureRect = %FirstItem
@onready var second_item : TextureRect = %SecondItem
@onready var result_cake : TextureRect = $VBoxContainer/ResultCake
@onready var button : Button = $VBoxContainer/Button

var selected_ingredients : Array[Dictionary] = []

signal cake_created(recipe : Dictionary)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and selected_ingredients.size() < 2

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	selected_ingredients.append(data)
	
	if selected_ingredients.size() == 1:
		first_item.texture = data["texture"]
	
	elif selected_ingredients.size() == 2:
		second_item.texture = data["texture"]
		button.show()
		print("[DEBUG] Combine ready")
	
func get_recipe() -> Dictionary:
	var id_one = String(selected_ingredients[0]["id"])
	var id_two = String(selected_ingredients[1]["id"])
	
	var ids = [id_one, id_two]
	ids.sort()
	
	var recipe_key = ids[0] + "|" + ids[1]
	print("[DEBUG] recipe_key: ", recipe_key)
	return RecipeBook.RECIPES.get(recipe_key, {})

func _clear_combinations() -> void:
	first_item.texture = null
	second_item.texture = null
	
	button.hide()
	selected_ingredients.clear()

func _on_button_pressed() -> void:
	var recipe = get_recipe()
	
	# couldnt find that combination, so just remove and (TODO) emit a dialogue for a fairy saying something
	if recipe.is_empty():
		print("What kind of combination is that?")
		_clear_combinations()
		return
	
	print("[DEBUG] Combination: ", recipe)
	
	cake_created.emit(recipe)
	
	_clear_combinations()
