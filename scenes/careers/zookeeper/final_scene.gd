extends Node2D
#need to make it so that it keeps track of everything being click
#once all the tasks have been completed, this pops up...
#ooooh when everything is done, the main buttons turn gray or smth..

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	zookeeper_data.played_with = {"monkey": false, "lion": false, "penguin": false}
	zookeeper_data.log_done = {"monkey": false, "lion": false, "penguin": false}
	zookeeper_data.activities_done = {"feed": false, "health": false}
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
