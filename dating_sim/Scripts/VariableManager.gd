extends Node
class_name VariableManager

signal variable_check_completed(success: bool, jump_index: int)

var character_data: CharacterData
var nametag_manager: NameTag

func initialize(char_data: CharacterData, nametag_data: NameTag):
	character_data = char_data
	nametag_manager = nametag_data

func change_variable(v_key: String, change_amount: float):
	
	if not character_data.character_variables.has(v_key):
		print("Warning: Variable not found: ", v_key)
		return
	
	var current_value = character_data.character_variables[v_key]
	
	if current_value is bool:
		character_data.character_variables[v_key] = (change_amount >= 1)
	elif current_value is int or current_value is float:
		character_data.character_variables[v_key] += change_amount

func change_name(n_key: String):
	nametag_manager.sett_name(n_key)

func check_variable(v_key: String, requirement: float, success_jump: int) -> bool:
	if not character_data:
		print("Warning: No character data loaded")
		return false
	
	if not character_data.character_variables.has(v_key):
		print("Warning: Variable not found for check: ", v_key)
		return false
	
	var current_value = character_data.character_variables[v_key]
	var check_passed = false
	
	# Handle booleans (check if true)
	if current_value is bool:
		check_passed = current_value
		print("VariableManager: Checking boolean '", v_key, "' = ", current_value)
	# Handle numbers (check if less than requirement)
	elif current_value is int or current_value is float:
		check_passed = (current_value < requirement)
		print("VariableManager: Checking '", v_key, "' (", current_value, " < ", requirement, ") = ", check_passed)
	else:
		print("Warning: Variable type not supported for check: '", v_key, "'")
	
	variable_check_completed.emit(check_passed, success_jump)
	return check_passed

func get_variable(v_key: String):
	if character_data and character_data.character_variables.has(v_key):
		return character_data.character_variables[v_key]
	return null
