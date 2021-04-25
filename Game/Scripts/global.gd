extends Node

onready var world_tier = 1

var aspect_of_knight = false
var aspect_of_mage = false
var aspect_of_rogue = false
var aspect_of_sentinel = false

func set_aspect_mage(value):
	aspect_of_mage = value
	
func set_aspect_knight(value):
	aspect_of_knight = value

func set_aspect_rogue(value):
	aspect_of_rogue = value
	
func set_aspect_sentinel(value):
	aspect_of_sentinel = value

func set_textbox_floor_complete():
	var main = get_tree().current_scene
	var textbox = main.find_node("Textbox")
	if world_tier == 2:
		if aspect_of_knight == true:
			textbox.text = "Welcome Knight! You have advanced to the Second Floor. Keep going!"
		if aspect_of_mage == true:
			textbox.text = "Welcome Mage! You have advanced to the Second Floor. Keep going!"
	if world_tier == 3:
		if aspect_of_rogue == true:
			if aspect_of_mage == true:
				textbox.text = "Welcome to the Third Floor, Rogue Mage. You're almost there!"
			if aspect_of_knight == true:
				textbox.text = "Welcome to the Third Floor, Rogue Knight. You're almost there!"
		if aspect_of_sentinel == true:
			if aspect_of_mage == true:
				textbox.text = "Welcome to the Third Floor, Sentinel Mage. You're almost there!"
			if aspect_of_knight == true:
				textbox.text = "Welcome to the Third Floor, Sentinel Knight. You're almost there!"
