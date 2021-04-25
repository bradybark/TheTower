extends Control


func _on_StartGameButton_pressed():
	var change = get_tree().change_scene("res://Beginning.tscn")
	if change != 0:
		print("Error Code: ", change)

func _on_QuitGameButton_pressed():
	get_tree().quit()
