extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
var spots_remaining = 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spot_1_pressed() -> void:
	$Spot1.hide()
	spots_remaining -= 1
	check_complete()
	$Spot1.hide()
	spots_remaining -= 1
	check_complete()

func _on_spot_2_pressed() -> void:
	$Spot2.hide()
	spots_remaining -= 1
	check_complete()

func _on_spot_3_pressed() -> void:
	$Spot3.hide()
	spots_remaining -= 1
	check_complete()
	
func _on_spot_4_pressed() -> void:
	$Spot4.hide()
	spots_remaining -= 1
	check_complete()
	
func check_complete():
	if spots_remaining == 0:
		$AcceptDialog.dialog_text = "Animal is healthy! Great work!"
		$AcceptDialog.popup_centered()	
		$TextureRect.texture = load("res://scenes/careers/zookeeper/button_pics/Untitled32.png")


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
