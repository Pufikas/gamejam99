extends Node2D

signal ingredient_applied(ingredient : Variant)

func toggle_sprite(ingredient: Dictionary) -> void:
	update_cake_sprite(ingredient["id"])

func update_cake_sprite(ingredient_name: String) -> void:
	var node_name = ingredient_name.to_pascal_case()
	print("[DEBUG] update_cake_sprite name: ", node_name)
	
	var sprite = get_node_or_null(node_name)
	
	if sprite:
		sprite.show()
	else:
		push_warning("Ingredient sprite not found: " + node_name)
		

func clear_cake() -> void:
	for sprite in get_children():
		if sprite is Sprite2D:
			sprite.hide()
	$CakeBase.visible = true
