extends Control

var cursors = {
	"pencil": preload("res://Assets/kenney_cursor-pack/PNG/Outline/Default/drawing_pencil.png"),
	"stamp": preload("res://assets/kenney_cursor-pack/PNG/Outline/Default/drawing_brush.png"),
}

func _ready() -> void:
	var screen_size = get_viewport_rect().size
	$ColorRect.size = screen_size
	$ColorRect.position = Vector2.ZERO
	
	$ColorRect/Header/Title.size = screen_size
	$ColorRect/TextureRect.position = Vector2.ZERO
	call_deferred("_set_cursor")
	

func _set_cursor() -> void:
	Input.set_custom_mouse_cursor(cursors["pencil"])

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(cursors["stamp"])
		else:
			Input.set_custom_mouse_cursor(cursors["pencil"])

func _on_ModelBuilding_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/architect/ModelBuilding.tscn")

func _on_puzzle_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/careers/architect/RoomByRoom.tscn")
