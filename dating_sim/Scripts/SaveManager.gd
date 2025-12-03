extends Node
class_name SaveManager

var save_path := "user://savegame.json"
var save_data: Dictionary = {"dialogue_position": 0, "document_number": 0, "romance_points": 0}
var current_document_index: int = 0
var current_document_line: int = 0
var romance_points: int = 0

signal game_loaded(data: Dictionary)

func save() -> void:
	# TODO: Access player and dialogue info
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	save_data["dialogue_position"] = current_document_line
	save_data["document_number"] = current_document_index
	save_data["romance_points"] = romance_points
	var json: String = JSON.stringify(save_data, "\t")  # formatted JSON
	file.store_string(json)
	print("Game saved!")

func load() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return {}

	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	var text: String = file.get_as_text()
	var result = JSON.parse_string(text)

	if result == null:
		print("Save file corrupted.")
		return {}

	print("Game loaded!")
	
	game_loaded.emit(result)
	return result
