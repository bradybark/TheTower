extends Sprite

const BattleUnits = preload("res://BattleUnits.tres")

func show_effects():
	var playerStats = BattleUnits.PlayerStats
	var executable = BattleUnits.Enemy.is_executable()
	if(executable == true && playerStats.lvl >= 11):
		show()
