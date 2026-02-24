extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DialogueBox/Button.visible = false
	await get_tree().create_timer(2.5).timeout
	$background.texture = load("res://scenes/careers/doctor/ending_scene/Untitled23 (5).png")
	$DialogueBox/DialogueText.text = "....But the patient is much better now!"
	await get_tree().create_timer(2.5).timeout
	$background.texture = load("res://scenes/careers/doctor/ending_scene/Untitled23 (6).png")
	$DialogueBox/DialogueText.text = "This has been such a successful day! Good job, Doc!"
	$DialogueBox/Button.visible = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
