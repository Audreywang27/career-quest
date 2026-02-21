extends Node2D

var selected_food = ""
var correct_answers = {
	"Lion" : "Meat",
	"Penguin" : "Fish",
	"Monkey" : "Fruit"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	selected_food = "Meat"


func _on_button_2_pressed() -> void:
	selected_food = "Fish"

func _on_button_3_pressed() -> void:
	selected_food = "Fruit"

func _on_lion_pressed() -> void:
	check_answer("Lion")

func _on_penguin_pressed() -> void:
	check_answer("Penguin")

func _on_monkey_pressed() -> void:
	check_answer("Monkey")


func check_answer(animal):
	if selected_food == "":
		return
	if correct_answers[animal] == selected_food:
		show_correct_expression(animal)
		disable_food_button(selected_food)
	else:
		show_incorrect_expression(animal)
	selected_food = ""

func disable_food_button(food):
	if food == "Meat":
		$VBoxContainer/Button.disabled = true
		$VBoxContainer/Button.modulate = Color(0.5, 0.5, 0.5)
	elif food == "Fish":
		$VBoxContainer/Button2.disabled = true
		$VBoxContainer/Button2.modulate = Color(0.5, 0.5, 0.5)
	elif food == "Fruit":
		$VBoxContainer/Button3.disabled = true
		$VBoxContainer/Button3.modulate = Color(0.5, 0.5, 0.5)
func show_correct_expression(animal):
	var button = $HBoxContainer.get_node(animal)
	var original_texture = button.texture_normal
	button.texture_normal = load("res://scenes/careers/zookeeper/button_pics/Untitled34.png")
	await get_tree().create_timer(2.0).timeout
	button.texture_normal = original_texture
		

func show_incorrect_expression(animal):
	var button = $HBoxContainer.get_node(animal)
	var original_texture = button.texture_normal
	button.texture_normal = load("res://scenes/careers/zookeeper/button_pics/Untitled33.png")
	await get_tree().create_timer(2.0).timeout
	button.texture_normal = original_texture
		
func _on_accept_dialog_confirmed(): #this isn't working, so need to figure ts out
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
