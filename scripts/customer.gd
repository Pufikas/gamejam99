extends Node2D

@export var data : CustomerData

@onready var sprite : Sprite2D = $Sprite2D
@onready var click_area : Area2D = $Area2D

var footstep_sfx = preload("res://assets/audio/sfx/Footsteps_on_concrete.wav")
var doorbell_sfx = preload("res://assets/audio/sfx/Doorbell.wav")
var correct_sfx = preload("res://assets/audio/sfx/Correct.mp3")
#var wrong_sfx = preload("res://assets/audio/sfx/Buzzer.wav")

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
	modulate.a = 0.0
	AudioManager.play_sfx(doorbell_sfx)
	AudioManager.play_sfx(footstep_sfx)
	
	# fade in (4s since the sfx is 4s)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 4)
	await tween.finished
	
	customer_arrived.emit()

func leave_bakery():
	AudioManager.play_sfx(footstep_sfx)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 4)
	
	await tween.finished
	
	hide()
	customer_left.emit()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			customer_clicked.emit()
			print("DEBUG, customer area clicked")

func receive_cake(recipe: Dictionary):
	var correct = recipe.get("correct_customer_id") == customer_id
	var sequence = "bad_result"

	if correct:
		sequence = "good_result"
		AudioManager.play_sfx(correct_sfx)
	#else:
	#	AudioManager.play_sfx(wrong_sfx)
	
	# wait for dialogue to finish, then the customer should leave
	dialogue_manager.start_dialogue(get_dialogue_path(), sequence)
	await dialogue_manager.dialogue_finished
	
	if correct:
		leave_bakery()
