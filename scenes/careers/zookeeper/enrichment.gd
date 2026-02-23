extends Node2D

func _ready() -> void:
	if zookeeper_data.played_with["monkey"]:
		$HBoxContainer/monkey.disabled =  true
		$HBoxContainer/monkey.modulate = Color(0.5,0.5,0.5)
		
	if zookeeper_data.played_with["lion"]:
		$HBoxContainer/lion.disabled =  true
		$HBoxContainer/lion.modulate = Color(0.5,0.5,0.5)
		
	if zookeeper_data.played_with["penguin"]:
		$HBoxContainer/penguin.disabled =  true
		$HBoxContainer/penguin.modulate = Color(0.5,0.5,0.5)
	
	
func _on_monkey_pressed():
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment_monkey.tscn")
	

func _on_lion_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment_lion.tscn")


func _on_penguin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment_penguin.tscn")


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
