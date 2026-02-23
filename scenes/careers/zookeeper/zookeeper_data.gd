extends Node

var played_with = {
	"monkey": false,
	"lion": false,
	"penguin": false
}

var log_done = {
	"monkey": false,
	"lion": false,
	"penguin": false
}

var activities_done = {
	"feed": false,
	"health": false,
	"log": false
}
func all_played() -> bool:
	return played_with["monkey"] and played_with["lion"] and played_with["penguin"]

func all_logged() -> bool:
	return log_done["monkey"] and log_done["lion"] and log_done["penguin"]
	
func all_done() -> bool:
	return activities_done["feed"] and activities_done["health"] and activities_done["log"]

func all_tasks_done() -> bool:
	return all_played() and all_logged() and activities_done["feed"] and activities_done["health"]
