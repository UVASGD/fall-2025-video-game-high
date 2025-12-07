extends Node
class_name BackgroundManager

signal background_fade_completed

var character_data: CharacterData
var background_rect: TextureRect
var fade_background_rect: TextureRect
var fade_tween: Tween

var current_background_key: String = ""
var is_fading: bool = false
var background_library: Dictionary = {}

func initialize(data: CharacterData, bg_texture_rect: TextureRect):
	character_data = data
	background_rect = bg_texture_rect
	setup_fade_background()

func setup_fade_background():
	# Create a secondary TextureRect for crossfading
	fade_background_rect = TextureRect.new()
	fade_background_rect.name = "FadeBackground"
	fade_background_rect.expand_mode = background_rect.expand_mode
	fade_background_rect.stretch_mode = background_rect.stretch_mode
	fade_background_rect.size = background_rect.size
	fade_background_rect.position = background_rect.position
	fade_background_rect.anchor_left = background_rect.anchor_left
	fade_background_rect.anchor_right = background_rect.anchor_right
	fade_background_rect.anchor_top = background_rect.anchor_top
	fade_background_rect.anchor_bottom = background_rect.anchor_bottom
	fade_background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_background_rect.modulate.a = 0.0
	fade_background_rect.z_index = background_rect.z_index - 1

	background_rect.add_child(fade_background_rect)
	fade_background_rect.anchor_left = 0
	fade_background_rect.anchor_right = 1
	fade_background_rect.anchor_top = 0
	fade_background_rect.anchor_bottom = 1
	fade_background_rect.offset_left = 0
	fade_background_rect.offset_top = 0
	fade_background_rect.offset_right = 0
	fade_background_rect.offset_bottom = 0

func set_background_library(bg_dict: Dictionary):
	background_library = bg_dict

func change_background(bg_key: String, fade_duration: float = -1) -> void:
	if fade_duration == -1:
		fade_duration = character_data.get_float("BackgroundDefaultFadeDuration", 1.0)
	
	if bg_key == "":
		clear_background(fade_duration)
		return
	
	if bg_key == current_background_key:
		return
	
	if not background_library.has(bg_key):
		print("Warning: Background texture not found: ", bg_key)
		return
	
	var new_texture = background_library[bg_key]
	if not new_texture:
		print("Warning: Invalid background texture for: ", bg_key)
		return
	
	print("BackgroundManager: Changing to background: ", bg_key)
	current_background_key = bg_key
	
	if background_rect.texture != null and fade_duration > 0:
		await crossfade_to_background(new_texture, fade_duration)
	else:
		# Direct change without fade
		background_rect.texture = new_texture
		background_rect.modulate.a = 1.0

func crossfade_to_background(new_texture: Texture2D, fade_duration: float) -> void:
	is_fading = true
	fade_duration = 1.0
	fade_background_rect.texture = new_texture
	await get_tree().process_frame
	fade_background_rect.modulate.a = 0.0
	fade_background_rect.z_index = background_rect.z_index + 1

	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()

	# Fade in new background
	fade_tween.tween_property(fade_background_rect, "modulate:a", 1.0, fade_duration * 0.8)

	await fade_tween.finished

	background_rect.texture = fade_background_rect.texture
	background_rect.modulate.a = 1.0
	fade_background_rect.modulate.a = 0.0
	fade_background_rect.z_index = background_rect.z_index - 1

	is_fading = false
	background_fade_completed.emit()


func clear_background(fade_duration: float = -1):
	if fade_duration == -1:
		fade_duration = character_data.get_float("BackgroundDefaultFadeDuration", 1.0)
	
	current_background_key = ""
	
	if background_rect.texture == null:
		return
	
	if fade_duration > 0:
		is_fading = true
		if fade_tween:
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(background_rect, "modulate:a", 0.0, fade_duration)
		await fade_tween.finished
		background_rect.texture = null
		background_rect.modulate.a = 1.0
		is_fading = false
	else:
		background_rect.texture = null

func set_background_immediately(bg_key: String):
	if bg_key == "":
		background_rect.texture = null
		current_background_key = ""
		return
	
	if not background_library.has(bg_key):
		print("Warning: Background texture not found: ", bg_key)
		return
	
	var texture = background_library[bg_key]
	if texture:
		background_rect.texture = texture
		background_rect.modulate.a = 1.0
		current_background_key = bg_key

func get_current_background() -> String:
	return current_background_key

func is_background_fading() -> bool:
	return is_fading
