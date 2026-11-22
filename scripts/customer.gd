extends Node2D

@export var data : CustomerData

@onready var sprite : Sprite2D = $Sprite2D
@onready var click_area : Area2D = $Area2D
var dialogue_manager : Node

var customer_id : int

signal customer_arrived
signal customer_clicked
signal customer_left

func _ready() -> void:
	pass

func setup(customer_data: CustomerData, id: int, manager: Node):
	data = customer_data
	customer_id = id
	dialogue_manager = manager # get manager ref
	sprite.texture = data.customer_sprite

func get_dialogue_path() -> String:
	return "res://narratives/customers/customer_%d.json" % customer_id

func enter_bakery(): # should not start a dialogue immediately, only to show that there is a new customer arrived
	show()
	customer_arrived.emit() 

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			customer_clicked.emit()
			print("DEBUG, customer area clicked")

func receive_cake(recipe: Dictionary):
	var sequence = "bad_result"
	
	if (recipe.get("correct_customer_id") == customer_id):
		sequence = "good_result"
		customer_left.emit()
		#await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	
	dialogue_manager.start_dialogue(get_dialogue_path(), sequence)
	print("[DEBUG] receive cake in customer: ", recipe.get("correct_customer_id"))
