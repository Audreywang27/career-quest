extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if zookeeper_data.all_played():
		$DialogueBox/HBoxContainer/Button3.disabled = true
		$DialogueBox/HBoxContainer/Button3.modulate = Color(0.5,0.5,0.5)
	
	if zookeeper_data.activities_done["feed"]:
		$DialogueBox/HBoxContainer/Button.disabled = true
		$DialogueBox/HBoxContainer/Button.modulate = Color(0.5,0.5,0.5)
	
	if zookeeper_data.activities_done["health"]:
		$DialogueBox/HBoxContainer/Button2.disabled = true
		$DialogueBox/HBoxContainer/Button2.modulate = Color(0.5,0.5,0.5)
		
	if zookeeper_data.all_logged():
		$DialogueBox/HBoxContainer/Button4.disabled = true
		$DialogueBox/HBoxContainer/Button4.modulate = Color(0.5,0.5,0.5)
	if zookeeper_data.all_tasks_done():
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/careers/zookeeper/final_scene.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/feed.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/health.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment.tscn")


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/log.tscn")


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
