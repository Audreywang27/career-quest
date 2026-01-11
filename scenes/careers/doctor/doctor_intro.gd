extends Control
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var choice1 = $DialogueBox/HBoxContainer/Choice1
@onready var choice2 = $DialogueBox/HBoxContainer/Choice2

func _ready():
	# Connect the button signals
	choice1.pressed.connect(_on_choice1_pressed)
	choice2.pressed.connect(_on_choice2_pressed)

func _on_choice1_pressed():
	print("Player chose: Check vital signs")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_choice2_pressed():
	print("Player chose: Ask history")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
