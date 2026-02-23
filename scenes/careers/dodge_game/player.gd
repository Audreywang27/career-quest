extends Area2D

var dragging = false
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if click is on the player
				var distance = position.distance_to(event.position)
				if distance < 100:  # Adjust based on your sprite size
					dragging = true
			else:
				dragging = false
	
	if event is InputEventMouseMotion and dragging:
		var play_area_width = 450
		var play_area_center = screen_size.x / 2
		var left_bound = play_area_center - (play_area_width / 2)
		var right_bound = play_area_center + (play_area_width / 2)
		
		var player_half_width = 65 * scale.x  # Adjust 32 to match your sprite
		position.x = clamp(event.position.x, left_bound + player_half_width, right_bound-player_half_width)
