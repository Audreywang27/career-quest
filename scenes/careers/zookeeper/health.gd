extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
var spots_remaining = 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spot_1_0_pressed() -> void:
	$Spot1_0.hide()
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
		if not $AcceptDialog.confirmed.is_connected(_on_accept_dialog_confirmed):
				$AcceptDialog.confirmed.connect(_on_accept_dialog_confirmed)
		$AcceptDialog.position = Vector2(445,445)
		$AcceptDialog.popup()	
		$TextureRect.texture = load("res://scenes/careers/zookeeper/health_pics/Untitled35__1_-removebg-preview.png")

func _on_accept_dialog_confirmed() -> void:
	zookeeper_data.activities_done["health"] = true
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
