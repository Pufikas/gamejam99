extends PanelContainer

var select_sfx = preload("res://assets/audio/sfx/Selecting_an_ingredient.ogg")

var selected_ingredients : Array[Dictionary] = []

signal cake_served(recipe : Dictionary)
signal ingredient_applied(ingredient : Dictionary)
signal ingredients_changed(count : int)
signal clear_cake_sprites()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return selected_ingredients.size() < 2

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	selected_ingredients.append(data)

	#print("[DEBUG] Added ingredient: ", data["name"])
	ingredient_applied.emit(data)
	AudioManager.play_sfx(select_sfx)
	ingredients_changed.emit(selected_ingredients.size())
	
func get_recipe() -> Dictionary:
	if selected_ingredients.size() != 2:
		return {}
		
	var id_one = String(selected_ingredients[0]["id"])
	var id_two = String(selected_ingredients[1]["id"])
	
	var ids = [id_one, id_two]
	ids.sort()
	
	var recipe_key = ids[0] + "|" + ids[1]

	print("[DEBUG] Generated recipe key: ", recipe_key)
	print("[DEBUG] Recipe exists: ", RecipeBook.RECIPES.has(recipe_key))
	return RecipeBook.RECIPES.get(recipe_key, {})

func clear_combinations() -> void:
	selected_ingredients.clear()
	clear_cake_sprites.emit() # emit so cake can clear the sprites off
	ingredients_changed.emit(0)

func serve_cake() -> void:
	if selected_ingredients.size() != 2:
		return
		
	var recipe = get_recipe()
	
	if recipe.is_empty():
		#print("[DEBUG] Invalid combination")
		cake_served.emit(recipe)
		clear_combinations()
		return
	
	cake_served.emit(recipe)
	clear_combinations()
