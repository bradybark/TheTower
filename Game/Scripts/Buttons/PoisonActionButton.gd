extends "res://ActionButton.gd"

#function thats called when the Poison Action Button is pressed
func _on_pressed():
	if BattleUnits.Enemy != null and BattleUnits.PlayerStats != null and BattleUnits.PlayerStats.poisoned_slash == false:
		BattleUnits.PlayerStats.poisoned_slash = true
		BattleUnits.PlayerStats.ap -= 1

