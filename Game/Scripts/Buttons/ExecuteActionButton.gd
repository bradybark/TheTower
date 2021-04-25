extends "res://ActionButton.gd"

const Siphon = preload("res://Execute.tscn")

#function thats called when the Siphon Action Button is pressed
func _on_pressed():
	var cost = set_cost()
	if BattleUnits.Enemy != null and BattleUnits.PlayerStats != null:
		if BattleUnits.PlayerStats.mp >= cost:
			BattleUnits.PlayerStats.mp -= cost
			BattleUnits.PlayerStats.ap -= 1
			create_execute(BattleUnits.Enemy.global_position)
			var can_execute = BattleUnits.Enemy.is_executable()
			if can_execute == true:
				BattleUnits.Enemy.take_damage(9001)
				BattleUnits.Enemy.show_floaty_text("EXECUTED!","Siphon",true)
				BattleUnits.PlayerStats.hp += BattleUnits.PlayerStats.max_hp/2
				BattleUnits.Enemy.show_floaty_text(BattleUnits.PlayerStats.max_hp/2,"HP",false)	
			else:
				BattleUnits.Enemy.show_floaty_text("NOT EFFECTIVE","Siphon",false)
				BattleUnits.Enemy.take_damage(4)
				BattleUnits.PlayerStats.hp += 4
				BattleUnits.Enemy.show_floaty_text(4,"HP",false)

#function that create the animation and effects
func create_execute(position):
	var siphon = Siphon.instance()
	var main = get_tree().current_scene
	main.add_child(siphon)
	siphon.global_position = position

#function that sets the cost of the spell
func set_cost():
	var cost
	if global.aspect_of_sentinel == true:
		cost = 4
	else:
		cost = 8
	return cost
		
