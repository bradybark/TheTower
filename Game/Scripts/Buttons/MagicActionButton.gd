extends "res://ActionButton.gd"

const Spell = preload("res://Magic.tscn")

#function thats called when the Blast Action Button is pressed
func _on_pressed():
	var cost = set_cost()
	if BattleUnits.Enemy != null and BattleUnits.PlayerStats != null:
		if BattleUnits.PlayerStats.mp >= cost:
			create_spell(BattleUnits.Enemy.global_position)
			do_damage()

func create_spell(position):
	var spell = Spell.instance()
	var main = get_tree().current_scene
	main.add_child(spell)
	spell.global_position = position
	
func determine_damage(is_crit):
	var levels = int(BattleUnits.PlayerStats.lvl)
	var size = levels/5
	var bonus = BattleUnits.PlayerStats.level_bonus_calc(size)
	var damage = 6 + bonus
	if is_crit == true:
		damage *= 2
	return damage

func determine_heal(is_crit):
	var levels = int(BattleUnits.PlayerStats.lvl)
	var size = levels/8
	var bonus = BattleUnits.PlayerStats.level_bonus_calc(size)
	var heal = 1 + bonus
	if is_crit == true:
		heal *= 2
	if global.aspect_of_sentinel == true:
		heal *= 1.5
	return heal

func do_damage():
	var cost = set_cost()
	var is_crit = false
	var damage = determine_damage(false)
	var heal = determine_heal(false)
	
	#have to roll crit here so that the heal and damage don't roll crit independently
	if global.aspect_of_rogue == true:
		is_crit = BattleUnits.PlayerStats.roll_crit()
		if is_crit == true:
			damage = determine_damage(true)
			heal = determine_heal(true)
	
	BattleUnits.Enemy.take_damage(damage)
	BattleUnits.Enemy.show_floaty_text(damage,"Blast",is_crit)
	BattleUnits.PlayerStats.hp += heal
	BattleUnits.Enemy.show_floaty_text(heal,"HP",is_crit)
	BattleUnits.PlayerStats.mp -= cost
	BattleUnits.PlayerStats.ap -= 1
	
func set_cost():
	var cost
	if global.aspect_of_sentinel == true:
		cost = 1
	else:
		cost = 2
	return cost
		
