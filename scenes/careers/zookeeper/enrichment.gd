extends Node2D

func _ready() -> void:
	pass
	
func _on_monkey_pressed():
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment_monkey.tscn")
	

func _on_lion_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment_lion.tscn")


func _on_penguin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment_penguin.tscn")


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
