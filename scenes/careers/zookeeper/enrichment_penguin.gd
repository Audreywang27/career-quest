extends Node2D
#make three button choices - lion monkey and penguin for the user to play with

var playing = true
var idle_timer : Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = 8.0
	$Timer.start()
	idle_timer = Timer.new()
	idle_timer.wait_time = 1.0
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_mouse_idle)
	add_child(idle_timer)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing: 
		var mouse = get_global_mouse_position()
		mouse.x = clamp(mouse.x,0,get_viewport_rect().size.x)
		mouse.y = clamp(mouse.y, 0, get_viewport_rect().size.y)
		$Sprite2D.position = $Sprite2D.position.lerp(mouse, delta*3)
		$Cursor.position = mouse
		
		if mouse.x > $Sprite2D.position.x:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false 	
		

func _input(event):
	if event is InputEventMouseMotion:
		$Sprite2D.texture = load("res://scenes/careers/zookeeper/enrichment_animal_pics/Untitled33__1_-removebg-preview.png")
		idle_timer.start()

func _on_mouse_idle():
	if playing: 
		$Sprite2D.texture = load("res://scenes/careers/zookeeper/enrichment_animal_pics/Untitled33-removebg-preview.png")
		$Timer.stop()
		$Timer.start()
func _on_timer_timeout():
	playing = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#$AcceptDialog.add_cancel_button().hide()
	$Sprite2D.texture = load("res://scenes/careers/zookeeper/enrichment_animal_pics/Untitled33__2_-removebg-preview.png")
	$AcceptDialog.dialog_text = "The animal is tired and happy! Great work!"
	$AcceptDialog.popup_centered()
	
func _on_accept_dialog_confirmed() -> void:
	zookeeper_data.played_with["penguin"] = true
	if zookeeper_data.all_played():
		get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/careers/zookeeper/enrichment.tscn")


func _on_home_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
