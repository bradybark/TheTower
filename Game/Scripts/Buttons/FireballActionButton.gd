extends "res://ActionButton.gd"

const Spell = preload("res://Fireball.tscn")

#function thats called when the Fireball Action Button is pressed
func _on_pressed():
	var cost = set_cost()
	var double_hit = BattleUnits.PlayerStats.roll_crit()
	if BattleUnits.Enemy != null and BattleUnits.PlayerStats != null:
		if BattleUnits.PlayerStats.mp >= cost:
			if double_hit == true:
				do_damage()
				yield(get_tree().create_timer(0.5),"timeout")
				do_damage()
			else:
				do_damage()
			BattleUnits.PlayerStats.mp -= cost
			BattleUnits.PlayerStats.ap -= 1

#function that create the animation and effects
func create_spell(position):
	var spell = Spell.instance()
	var main = get_tree().current_scene
	main.add_child(spell)
	spell.global_position = position

#function that determines that damage amount
func determine_damage():
	var levels = int(BattleUnits.PlayerStats.lvl)
	var size = levels/5
	var bonus = BattleUnits.PlayerStats.level_bonus_calc(size)
	var damage = 10 + bonus
	return damage

#function that actually does the damange, etc
func do_damage():
	var damage = determine_damage()
	var is_crit = false
	if global.aspect_of_rogue == true:
		is_crit = BattleUnits.PlayerStats.roll_crit()
		if is_crit == true:
			damage *= 2
	create_spell(BattleUnits.Enemy.global_position)
	BattleUnits.Enemy.take_damage(damage)
	BattleUnits.Enemy.show_floaty_text(damage,"Fireball",is_crit)

#function that sets the cost of the spell
func set_cost():
	var cost
	if global.aspect_of_sentinel == true:
		cost = 5
	else:
		cost = 10
	return cost
		
