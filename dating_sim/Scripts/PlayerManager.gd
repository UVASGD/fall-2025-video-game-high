extends Node
class_name PlayerManager

var romance_points: int

signal romance_points_incremented()
signal romance_points_decremented()

func _ready():
	romance_points = 0
	connect("romance_points_incremented", increment_romance())
	connect("romance_points_decremented", decrement_romance())
	
func get_romance_points():
	return romance_points

func increment_romance():
	romance_points += 1
	
func decrement_romance():
	romance_points -= 1
