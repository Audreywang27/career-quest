extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_intro.tscn")
	pass # Replace with function body.
 #testing commetns

func _on_game_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
	pass # Replace with function body.


func _on_game_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/architect/architect_Intro.tscn")
	pass # Replace with function body.
