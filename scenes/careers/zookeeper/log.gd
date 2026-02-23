extends Node2D

func _ready() -> void:
	if zookeeper_data.log_done["monkey"]:
		$VBoxContainer/monkey.disabled =  true
		$VBoxContainer/monkey.modulate = Color(0.5,0.5,0.5)
	if zookeeper_data.log_done["lion"]:
		$VBoxContainer/lion.disabled =  true
		$VBoxContainer/lion.modulate = Color(0.5,0.5,0.5)
	if zookeeper_data.log_done["penguin"]:
		$VBoxContainer/penguin.disabled =  true
		$VBoxContainer/penguin.modulate = Color(0.5,0.5,0.5)
func _on_monkey_pressed():
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/log_monkey.tscn")
	

func _on_lion_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/log_lion.tscn")


func _on_penguin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/log_penguin.tscn")

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
