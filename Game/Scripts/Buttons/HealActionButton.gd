extends "res://ActionButton.gd"

const Heal = preload("res://Heal.tscn")

#function thats called when the Heal Action Button is pressed
func _on_pressed():
	var playerStats = BattleUnits.PlayerStats
	var cost = set_cost()
	if playerStats != null:
		if playerStats.mp >= cost:
			create_heal()
			do_heal()
			playerStats.ap -= 1

#creates the heal animation
func create_heal():
	var heal = Heal.instance()
	var main = get_tree().current_scene
	main.add_child(heal)

#determines the heal amount
func determine_heal():
	var playerStats = BattleUnits.PlayerStats
	var levels = int(playerStats.lvl)
	var size = levels/4
	var bonus = playerStats.level_bonus_calc(size)
	var heal = 4 + bonus
	if global.aspect_of_sentinel == true:
		heal *= 1.5
		heal = int(heal)
	return heal
	
#function that actually does the healing
func do_heal():
	var cost = set_cost()
	var heal = determine_heal()
	var temp = false
	if global.aspect_of_sentinel == true:
		temp = true
	BattleUnits.PlayerStats.hp += heal
	BattleUnits.PlayerStats.mp -= cost
	BattleUnits.Enemy.show_floaty_text(heal,"HP",temp)

#function that sets the cost of the spell
func set_cost():
	var cost
	if global.aspect_of_sentinel == true:
		cost = 4
	else:
		cost = 8
	return cost
