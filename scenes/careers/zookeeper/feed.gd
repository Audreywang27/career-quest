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
		$AcceptDialog.dialog_text = "Correct!"
		$AcceptDialog.popup_centered()
	else:
		$AcceptDialog.dialog_text = "Wrong! Try again!"
		$AcceptDialog.popup_centered()
	selected_food = ""

func _on_accept_dialog_confirmed():
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
