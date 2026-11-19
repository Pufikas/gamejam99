extends PanelContainer

var selected_ingredients : Array[Dictionary] = []

signal cake_created(recipe : Dictionary)
signal ingredient_applied(ingredient : Dictionary)
signal ingredients_changed(count: int)
signal clear_cake_sprites()


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return selected_ingredients.size() < 2

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	selected_ingredients.append(data)

	print("[DEBUG] Added ingredient: ", data["name"])
	ingredient_applied.emit(data)
	ingredients_changed.emit(selected_ingredients.size())
	
func get_recipe() -> Dictionary:
	if selected_ingredients.size() != 2:
		return {}
		
	var id_one = String(selected_ingredients[0]["id"])
	var id_two = String(selected_ingredients[1]["id"])
	
	var ids = [id_one, id_two]
	ids.sort()
	
	var recipe_key = ids[0] + "|" + ids[1]
	print("[DEBUG] recipe_key: ", recipe_key)
	return RecipeBook.RECIPES.get(recipe_key, {})

func clear_combinations() -> void:
	selected_ingredients.clear()
	clear_cake_sprites.emit() # emit so cake can clear the sprites off
	ingredients_changed.emit(0)

func create_cake() -> void:
	if selected_ingredients.size() != 2:
		return
		
	var recipe = get_recipe()
	# couldnt find that combination, so just remove and (TODO) emit a dialogue for a fairy saying something
	if recipe.is_empty():
		print("[DEBUG] Invalid combination")
		clear_combinations()
		return
	
	print("[DEBUG] Combination: ", recipe)
	
	cake_created.emit(recipe)
	clear_combinations()
