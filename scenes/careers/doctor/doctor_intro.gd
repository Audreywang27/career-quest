extends Control
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var choice1 = $DialogueBox/HBoxContainer/Choice1
@onready var choice2 = $DialogueBox/HBoxContainer/Choice2
@onready var background = $Background

func _ready():
	# Connect the button signals
	choice1.pressed.connect(_on_choice1_pressed)
	choice2.pressed.connect(_on_choice2_pressed)
	
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled23 (1) (1).png")
	
	# Wait 1 second then switch to second background
	await get_tree().create_timer(3.0).timeout
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled23 (3) (1).png")

func _on_choice1_pressed():
	print("Player chose: Check vital signs immediately")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_vitals.tscn")

func _on_choice2_pressed():
	print("Player chose: Ask about medical history first")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_history.tscn")


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
