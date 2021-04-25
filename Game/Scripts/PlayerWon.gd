extends Control

onready var panel = $Panel
onready var textbox = $Panel/Textbox

var button_counter = 0

func _ready():
	panel.hide()

#function thats called when the Continue Action Button is pressed
func _on_Button_pressed():
	panel.show()
	button_counter += 1
	if button_counter == 1:
			if global.aspect_of_rogue:
				if global.aspect_of_mage == true:
					textbox.text = "Incredible. You wield the power of the shadows just as well as the power of the arcane arts!"
				if global.aspect_of_knight == true:
					textbox.text = "Impressive. You understand shadows just as well as you understand your sword. "
			if global.aspect_of_sentinel:
				if global.aspect_of_mage == true:
					textbox.text = "Wow! Your mastery of the arcane is quite impressive. You are one powerful mage!"
				if global.aspect_of_knight == true:
					textbox.text = "Amazing. You embody the spirit of a true warrior!"
	if button_counter == 2:
		textbox.text = "You begin to hear whispers calling at you from miles away. They clamor away, incessant."
	if button_counter == 3:
		textbox.text = "Even through the mad rumblings... They seem familiar, like they're your own thoughts."
	if button_counter == 4:
		textbox.text = "But the loudest voice is that of the Tower. It calls to you. You can feel its power."
	if button_counter == 5:
		textbox.text = "The Tower feels like home. I think you'll be here awhile..."
	if button_counter == 6:
		var change = get_tree().change_scene("res://StartMenu.tscn")
		if change != 0:
			print("Error Code: ", change)
