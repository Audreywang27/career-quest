extends Area2D

var speed = 100

func _process(delta):
	var time_elapsed = Time.get_ticks_msec()/1000.0
	var speed_multi = 1.0 + (time_elapsed * 0.1)
	speed_multi = min(speed_multi,3.0)

	position.y += speed * speed_multi * delta 
	
	# Remove when off screen
	if position.y > get_viewport_rect().size.y + 50:
		get_parent().score+=1
		get_parent()._update_score()
		queue_free()
