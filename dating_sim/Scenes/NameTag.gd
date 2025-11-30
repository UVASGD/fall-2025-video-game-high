extends Control
class_name NameTag

@export var character_data: CharacterData
@export var padding: Vector2
@export var min_width: float
@export var font_size: int

var name_panel: Panel
var name_label: Label
var nametag_set_flag: bool = false

func _ready():
	setup_name_tag()

func setup_name_tag():
	name_panel = find_child("Panel") as Panel
	name_label = find_child("Label") as Label
	set_font_size(font_size)
	
	if not name_panel or not name_label:
		return
	
	# a lot of these sett_names are useless but they aren't affecting anything yet
	call_deferred("sett_name", " ")

func set_character(new_character_data: CharacterData):
	character_data = new_character_data
	call_deferred("sett_name", " ")

func update_name_tag():
	if not character_data or not name_label or not name_panel:
		return
	var character_name = character_data.character_name
	if character_name.is_empty():
		character_name = "Unknown"
	name_label.text = character_name
	calculate_and_resize()

func sett_name(new_name: String):
	if not name_label or not name_panel:
		return
	
	#print("NameTag: Setting custom name to '", new_name, "'")
	name_label.text = new_name
	calculate_and_resize()
	#EventBus.trigger_nameTagSet() # this is here so that the the talking animations wait for the name tag to be set before seeing which character image to use

func calculate_and_resize():
	if not name_label or not name_panel:
		return
	
	var font = name_label.get_theme_font("font")
	if not font:
		font = ThemeDB.fallback_font
		if not font:
			return
	
	var text_size = font.get_string_size(
		name_label.text, 
		HORIZONTAL_ALIGNMENT_LEFT, 
		-1, 
		font_size
	)
	
	var required_width = max(text_size.x + padding.x * 2, min_width)
	var required_height = text_size.y + padding.y
	name_panel.set_deferred("size", Vector2(required_width, required_height))
	name_label.set_deferred("size", Vector2(required_width, required_height))
	name_panel.set_deferred("position", Vector2.ZERO)

func set_font_size(new_font_size: int):
	font_size = new_font_size
	if name_label:
		name_label.add_theme_font_size_override("font_size", font_size)
		call_deferred("calculate_and_resize")

func set_padding(new_padding: Vector2):
	padding = new_padding
	call_deferred("calculate_and_resize")

func set_min_width(new_min_width: float):
	min_width = new_min_width
	call_deferred("calculate_and_resize")

func refresh():
	call_deferred("update_name_tag")
