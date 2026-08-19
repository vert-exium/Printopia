extends Node

const save_file_name: String = "user://save.json"
const default_dictionary: Dictionary = {"balance": 0.0, "print_time": 3.0, "earnings": 1.0, "earnLevel": 0, "speedLevel": 0, "autoPrint": false, "autoPrintCost": 100000.0}

func save_game(data: Dictionary) -> void:
	var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.WRITE)
	if save_file == null:
		push_error("Error opening file")
		return
	var string_data: String = JSON.stringify(data)
	save_file.store_line(string_data)
	save_file.close()

func load_game() -> Dictionary:
	if FileAccess.file_exists(save_file_name):
		var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.READ)
		if save_file == null:
			push_error("Error reading file")
			return default_dictionary
		var json = JSON.new()
		var string_data: String = save_file.get_line()
		if json.parse(string_data) == OK:
			var data: Dictionary = json.get_data()
			save_file.close()
			
			for key in default_dictionary.keys():
				if not data.has(key):
					data[key] = default_dictionary[key]
					
			return data
		push_error("Corrupted data")
	return default_dictionary

func reset_save() -> void:
	save_game(default_dictionary)
