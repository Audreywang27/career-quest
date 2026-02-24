extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

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

var backgrounds = [
	preload("res://scenes/log_background_pics/Untitled48 (1).png"),
	preload("res://scenes/log_background_pics/Untitled48 (2).png"),
	preload("res://scenes/log_background_pics/Untitled48 (3).png"),
	preload("res://scenes/log_background_pics/Untitled48 (4).png"),
	preload("res://scenes/log_background_pics/Untitled48 (5).png"),
	preload("res://scenes/log_background_pics/Untitled48.png"),
]

var current_index = 0

func _on_timer_timeout():
	current_index = (current_index + 1) % backgrounds.size()
	$TextureRect.texture = backgrounds[current_index]
