extends "res://ActionButton.gd"

#function thats called when the Block Action Button is pressed
func _on_pressed():
	if BattleUnits.Enemy != null and BattleUnits.PlayerStats != null and BattleUnits.PlayerStats.blocking == false:
		BattleUnits.PlayerStats.blocking = true
		BattleUnits.PlayerStats.ap -= 1
