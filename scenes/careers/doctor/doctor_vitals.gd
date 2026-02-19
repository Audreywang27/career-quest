extends Control
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var choice1 = $DialogueBox/HBoxContainer/Choice1
@onready var choice2 = $DialogueBox/HBoxContainer/Choice2
@onready var background = $Background

func _ready():
	# Connect the button signals
	choice1.pressed.connect(_on_choice1_pressed)
	choice2.pressed.connect(_on_choice2_pressed)
	
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled27 (1).png")
	
	# Wait 1 second then switch to second background
	await get_tree().create_timer(3.0).timeout
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled27 (2).png")


func _on_choice1_pressed():
	print("Player chose: Order EKG now")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_ekgordered.tscn")

func _on_choice2_pressed():
	print("Player chose: Give pain meds")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_continueQuestions.tscn")
