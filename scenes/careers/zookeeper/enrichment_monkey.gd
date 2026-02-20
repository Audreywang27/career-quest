extends Node2D
#make three button choices - lion monkey and penguin for the user to play with

var playing = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = 5.0
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing: 
		var mouse = get_global_mouse_position()
		$Sprite2D.position = $Sprite2D.position.lerp(mouse, delta*3)
		
func _on_timer_timeout():
	playing = false
	$AcceptDialog.dialog_text = "The animal is tired and happy! Great work!"
	$AcceptDialog.popup_centered()


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
