extends Node2D

@export var customer_name = "Customer"

@onready var click_area : Area2D = $Area2D

signal customer_arrived
signal customer_clicked

func _ready() -> void:
	customer_name = name

func enter_bakery(): # should not start a dialogue immediately, only to show that there is a new customer arrived
	show()
	customer_arrived.emit() 

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			customer_clicked.emit()
			print("DEBUG, customer area clicked")
