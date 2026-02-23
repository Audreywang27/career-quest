extends Node2D

var questions = [
	{"question" : "How was the lion's appetite?", "options": ["Good", "Poor", "Refused food"]},
	{"question": "Did you notice anything unusual?", "options": ["No issues", "Minor concern", "Needs vet"]},
	{"question": "How was the animal's energy level?", "options": ["Normal", "Lethargic", "Hyperactive"]},
]

var current_question = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_question()
	
func load_question():
	if current_question >= questions.size():
		$AcceptDialog.dialog_text = "Log submitted! Great work!"
		$AcceptDialog.popup_centered()
		return
	$QuestionLabel.text = "[center]" + questions[current_question]["question"] + "[/center]"
	var opts = questions[current_question]["options"]
	$VBoxContainer/Button.text = opts[0]
	$VBoxContainer/Button2.text = opts[1]
	$VBoxContainer/Button3.text = opts[2]

func _on_button_pressed():
	current_question += 1
	load_question()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_accept_dialog_confirmed() -> void:
	zookeeper_data.log_done["monkey"] = true
	if zookeeper_data.all_logged():
		get_tree().change_scene_to_file("res://scenes/careers/zookeeper/welcome.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/careers/zookeeper/log.tscn")
