extends Control


func _on_Button_pressed():
	var change = get_tree().change_scene("res://Battle.tscn")
	if change != 0:
		print("Error Code: ", change)
