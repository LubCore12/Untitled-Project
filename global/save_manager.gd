extends Node

const SAVE_PATH := "user://saved_game.json"
var game_stats := {}
var is_new_game := false

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json := JSON.stringify(game_stats)
		file.store_line(json)
		file.close()
		print("game is saved")
	else:
		printerr("saving error")

func load_game():
	if not (SAVE_PATH):
		return {}
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json := file.get_line()
		var result = JSON.parse_string(json)
		if typeof(result) == TYPE_DICTIONARY:
			print("game is loaded")
			return result
		else:
			printerr("reading file error")
	else:
		printerr("loading error")
	return 0
	
