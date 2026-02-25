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
var play_area_width : float  # Match your ColorRect width
var play_area_center_x : float # Half of screen width (adjust if needed)
var play_area_left :float
var play_area_right :float
var scale_factor:float

var lives = 3
var game_won = false
var invincible = false

func _ready():
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	scale_factor = screen_width / 1150.0
	
	play_area_width = screen_width * 0.45
	play_area_center_x = screen_width / 2
	play_area_left = play_area_center_x - (play_area_width / 2)
	play_area_right = play_area_center_x + (play_area_width / 2)
	$ColorRect.size.x = play_area_width
	$ColorRect.size.y = screen_height
	$ColorRect.position.x = play_area_left
	$ColorRect2.position.x = play_area_center_x - ($ColorRect2.size.x / 2)
	#$ColorRect3.position.x = 0
	#$ColorRect3.size.x = play_area_left
	#$ColorRect3.size.y = screen_height
	$ColorRect3.position = Vector2.ZERO
	$ColorRect3.size = Vector2(screen_width, screen_height)

	# Right border  
	#$ColorRect4.position.x = play_area_right
	#$ColorRect4.size.x = play_area_left  # same width as left border
	#$ColorRect4.size.y = screen_height
	
	$LivesLabel.text = "❤️❤️❤️"
	$LivesLabel.scale = Vector2(scale_factor, scale_factor)
	
	$Player.position = Vector2(play_area_center_x,get_viewport_rect().size.y - 100)
	$Player.scale = Vector2(scale_factor, scale_factor) 
	$Player.area_entered.connect(_on_player_hit)
	$Player.scale_factor = scale_factor
	
	$Timer.timeout.connect(_spawn_obstacle)
	$GameTimer.timeout.connect(_on_game_won)
	
	$ColorRect2.z_index = 99
	#$Label.scale = Vector2(scale_factor, scale_factor)
	$ColorRect2.z_as_relative = false
	$Label.z_index = 100
	$Label.z_as_relative = false
	_update_score()

func _spawn_obstacle():
	var time_elapsed = Time.get_ticks_msec() / 1000.0
	_spawn_single_obstacle()
	if time_elapsed > 20.0:  # after 20 seconds spawn 2 at once
		await get_tree().create_timer(0.3).timeout
		_spawn_single_obstacle()
		
func _spawn_single_obstacle():
	
	var random_scene = obstacle_scenes[randi() % obstacle_scenes.size()]	
	var obstacle = random_scene.instantiate()
	obstacle.visible = false
	add_child(obstacle)
	# Random X position within play area
	obstacle.scale = Vector2(scale_factor, scale_factor)
	obstacle.speed = 100 * scale_factor
# Random X position within play area
	await get_tree().process_frame
	
	var poly = obstacle.get_node("CollisionPolygon2D")
	var points = poly.polygon
	var min_x = points[0].x
	var max_x = points[0].x
	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
	var obstacle_width = (max_x - min_x) / 2 * scale_factor
	
	var spawn_x = randf_range(play_area_left + obstacle_width, play_area_right - obstacle_width)
	obstacle.position = Vector2(spawn_x, -50)
	obstacle.visible = true

	
func _update_score():
	$Label.text = "Score: " + str(score)

func _process(delta):
	var time_elapsed = Time.get_ticks_msec()/1000.0
	$Timer.wait_time = max(0.5, 1.5 - (time_elapsed * 0.02))
	
func _on_player_hit(area):
	if game_won:
		return
	
	lives -= 1
	
	if lives == 2:
		$LivesLabel.text = "❤️❤️"
	elif lives == 1:
		$LivesLabel.text = "❤️"
	elif lives == 0 || game_won:
		get_tree().paused = true 
		var losePopup = AcceptDialog.new()
		losePopup.dialog_text = "Game Over! Score: " + str(score)
		losePopup.title = "Game Over"
		losePopup.process_mode = Node.PROCESS_MODE_ALWAYS
		
		add_child(losePopup)
		losePopup.popup_centered()
		
		losePopup.close_requested.connect(func(): 
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/careers/dodge_game/lost_game.tscn")
		)
		# OK/Exit button goes back to doctor game (or quits)
		losePopup.confirmed.connect(func(): 
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/careers/dodge_game/lost_game.tscn")  # Change to your doctor scene path
			# OR use: get_tree().quit() to close the game entirel
		)
	invincible = true
	for i in range(5):
		$Player.modulate.a = 0.3
		await get_tree().create_timer(0.15).timeout
		$Player.modulate.a = 1.0
		await get_tree().create_timer(0.15).timeout
	invincible = false
	
func _on_game_won():
	# Stop spawning obstacles
	game_won = true
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
	
