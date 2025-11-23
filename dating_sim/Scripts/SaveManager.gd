extends Node
class_name SaveManager

var save_path := "user://savegame.json"
var example_save_data: Dictionary = {
					 "player": {
						 "dialogue_position": 0
					 },
					 "external": {
						 "romance_points": 0,
					 }
				 }

func save(data: Dictionary) -> void:
	# TODO: Access player and dialogue info
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var json = JSON.stringify(data, "\t")  # formatted JSON
	file.store_string(json)
	print("Game saved!")

func load() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return {}

	var file = FileAccess.open(save_path, FileAccess.READ)
	var text = file.get_as_text()
	var result = JSON.parse_string(text)

	if result == null:
		print("Save file corrupted.")
		return {}

	print("Game loaded!")
	return result
