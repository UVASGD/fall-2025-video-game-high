extends Control

# Use @onready to get references to your buttons by their paths
@onready var continue_button: Button = $Container/VBoxContainer/ContinueButton
@onready var save_button: Button = $Container/VBoxContainer/SaveButton
@onready var exit_button: Button = $Container/VBoxContainer/QuitButton

# --- Initialization and Setup ---

func _ready() -> void:
	# Ensure the menu starts hidden
	hide_menu()

	# Connect signals from the buttons to the functions below
	continue_button.pressed.connect(_on_continue_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

# Check for the pause key (e.g., Escape or 'ui_cancel')
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Stop the input from propagating to the game world
		get_viewport().set_input_as_handled()

		if get_tree().paused:
			# If already paused, unpause (Continue)
			hide_menu()
		else:
			# If not paused, show the menu and pause
			show_menu()

# --- Pause/Unpause Logic ---

func show_menu() -> void:
	self.visible = true
	# Stops all nodes (except those with 'process_mode' set to 'Always')
	get_tree().paused = true
	# Show the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_menu() -> void:
	self.visible = false
	get_tree().paused = false
	# Hide the mouse cursor for gameplay (assuming MOUSE_MODE_CAPTURED)

# --- Button Handlers ---

func _on_continue_button_pressed() -> void:
	# This automatically resumes the game
	print("gjsflgds")
	hide_menu()

func _on_save_button_pressed() -> void:
	# -----------------------------------------------------------------
	# PLACEHOLDER FOR YOUR SAVE GAME CALLABLE
	# -----------------------------------------------------------------

	# Example: If your save function is in a global script:
	# GlobalGameManager.save_game() 

	# Or if you use a Callable:
	# var save_callable = load_save_function()
	# save_callable.call()

	print("--- Save function called. Game progress stored. ---")

func _on_exit_button_pressed() -> void:
	# Option 1: Quit the application immediately
	get_tree().quit()

	# Option 2 (Recommended): Return to the main menu scene
	# Ensure you replace "res://main_menu.tscn" with your actual scene path
	#get_tree().paused = false # Must unpause before changing scenes
	#get_tree().change_scene_to_file("res://MainMenu.tscn")
