extends Control
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var choice1 = $DialogueBox/HBoxContainer/Choice1
@onready var background = $Background


func _ready():
	# Connect the button signals
	$DialogueBox.visible = false
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled29 (2).png")
	choice1.pressed.connect(_on_choice1_pressed)
	await get_tree().create_timer(2.0).timeout
	background.texture = load("res://scenes/careers/doctor/docpics/Untitled25 (2).png")
	$DialogueBox.visible = true



func _on_choice1_pressed():
	print("Player chose: Get an EKG now")
	# For now, just go back to main menu
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_ekgordered.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
