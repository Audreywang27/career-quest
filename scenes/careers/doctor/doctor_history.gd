extends Control
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var choice1 = $DialogueBox/HBoxContainer/Choice1
@onready var choice2 = $DialogueBox/HBoxContainer/Choice2
@onready var background = $Background

func _ready():
	# Connect the button signals
	$DialogueBox.visible = false
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled28 (2) (1).png")
	choice1.pressed.connect(_on_choice1_pressed)
	choice2.pressed.connect(_on_choice2_pressed)
	await get_tree().create_timer(2.0).timeout
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled26 (2).png")
	$DialogueBox.visible = true
	
func _on_choice1_pressed():
	print("Player chose: Check Vitals Now")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_vitals.tscn")

func _on_choice2_pressed():
	print("Player chose: Continue Questions")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_continue_questions.tscn")
