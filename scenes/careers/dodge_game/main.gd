extends Node2D

var obstacle_scenes = [
	preload("res://scenes/careers/dodge_game/obstacles/obstacle1.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle2.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle3.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle4.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle5.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle6.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle7.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle8.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle9.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle10.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle11.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle12.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle13.tscn"),
	preload("res://scenes/careers/dodge_game/obstacles/obstacle14.tscn"),
]
var score = 0
var play_area_width = 450  # Match your ColorRect width
var play_area_center_x = 1150 / 2  # Half of screen width (adjust if needed)
var play_area_left = play_area_center_x - (play_area_width / 2)
var play_area_right = play_area_center_x + (play_area_width / 2)

func _ready():
	# Position player at bottom center of play area
	$Player.position = Vector2(play_area_center_x,get_viewport_rect().size.y - 100)
	
	$Player.area_entered.connect(_on_player_hit)
	$Timer.timeout.connect(_spawn_obstacle)
	$GameTimer.timeout.connect(_on_game_won)
	
	$ColorRect2.z_index = 99
	$ColorRect2.z_as_relative = false
	$Label.z_index = 100
	$Label.z_as_relative = false
	_update_score()

func _spawn_obstacle():
	var random_scene = obstacle_scenes[randi() % obstacle_scenes.size()]	
	var obstacle = random_scene.instantiate()
	# Random X position within play area
	var spawn_x = randf_range(play_area_left + 30, play_area_right - 30)
	obstacle.position = Vector2(spawn_x, -50)
	
	add_child(obstacle)
	
func _update_score():
	$Label.text = "Score: " + str(score)

func _on_player_hit(area):
	get_tree().paused = true 
	var losePopup = AcceptDialog.new()
	losePopup.dialog_text = "Game Over! Score: " + str(score)
	losePopup.title = "Game Over"
	losePopup.process_mode = Node.PROCESS_MODE_ALWAYS
	
	add_child(losePopup)
	losePopup.popup_centered()
	
	losePopup.close_requested.connect(func(): 
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	# OK/Exit button goes back to doctor game (or quits)
	losePopup.confirmed.connect(func(): 
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_results.tscn")  # Change to your doctor scene path
		# OR use: get_tree().quit() to close the game entirel
	)
	
func _on_game_won():
	# Stop spawning obstacles
	$Timer.stop()
	
	var label_tween = create_tween()
	label_tween.tween_property($Label, "modulate:a", 0.0, 0.5)  # Fade out over 0.5 seconds
	var colorrect_tween = create_tween()
	label_tween.tween_property($ColorRect2, "modulate:a", 0.0, 0.5)
	
	# Show and lower the door
	await get_tree().create_timer(0.5).timeout  # Wait for scoreboard to fade
	$Door.visible = true
	$Door.position = Vector2(play_area_center_x, -200)  # Start above screen
	var door_tween = create_tween()
	door_tween.tween_property($Door, "position:y", 200, 2.0)  # Lower door over 2 seconds
	
	#disable player dragging
	$Player.set_process_input(false)
	$Player.set_deferred("monitoring", false)
	$Player.set_deferred("monitorable", false)
	#move player to the top
	var player_tween = create_tween()
	player_tween.tween_property($Player, "position", Vector2($Player.position.x, 330),2.0) #2 seconds to reach the top
	
	await player_tween.finished

	# Show win popup
	get_tree().paused = true
	var popup = AcceptDialog.new()
	popup.dialog_text = "You Win! Final Score: " + str(score)
	popup.title = "Victory!"
	popup.ok_button_text = "Continue"
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(popup)
	popup.popup_centered()
		
	popup.close_requested.connect(func(): 
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_results.tscn")
	)
	popup.confirmed.connect(func(): 
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/careers/doctor/doctor_results.tscn")
	)
	
