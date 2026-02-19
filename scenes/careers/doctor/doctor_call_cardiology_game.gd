extends Control
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var choice1 = $DialogueBox/HBoxContainer/Choice1


func _ready():
	# Connect the button signals
	choice1.pressed.connect(_on_choice1_pressed)

func _on_choice1_pressed():
	print("Player chose: Start!")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/dodge_game/main.tscn")
