extends "res://ActionButton.gd"

const Slash = preload("res://Slash.tscn")
const CritSlash = preload("res://CritSlash.tscn")
const PoisonEffect = preload("res://PoisonEffect.tscn")


var floaty_text_scene = preload("res://FloatingText.tscn")

#function thats called when the Slash Action Button is pressed
func _on_pressed():
	if BattleUnits.Enemy != null and BattleUnits.PlayerStats != null:
		do_damage()
		check_poison()
		BattleUnits.PlayerStats.ap -= 1
		
#function that determines that amount of damage the slash will do
func determine_damage():
	var levels = int(BattleUnits.PlayerStats.lvl)
	var size = levels/5
	var bonus = BattleUnits.PlayerStats.level_bonus_calc(size)
	var damage = 4 + bonus
	return damage

#function that actually does the damage to the enemy
func do_damage():
		var damage = determine_damage()
		var is_crit = BattleUnits.PlayerStats.roll_crit()
		var mp_gain = determine_mp()
		if is_crit == true:
			damage *= 2
			mp_gain *= 2
		BattleUnits.Enemy.take_damage(damage)
		BattleUnits.Enemy.show_floaty_text(damage,"Slash",is_crit)
		create_slash(BattleUnits.Enemy.global_position, is_crit)
		
		if BattleUnits.PlayerStats.mp <= BattleUnits.PlayerStats.max_mp - mp_gain:
			BattleUnits.Enemy.show_floaty_text(mp_gain,"MP",is_crit)
			BattleUnits.PlayerStats.mp += mp_gain

#function that checks whether the player has used poison or not
func check_poison():
	if (BattleUnits.PlayerStats.poisoned_slash == true):
		var damage = 3
		var heal = 1
		var is_crit = BattleUnits.PlayerStats.roll_crit()
		if is_crit == true:
			damage *= 2
			heal = 2
		BattleUnits.Enemy.take_damage(damage)
		BattleUnits.Enemy.show_floaty_text(damage,"Poison",is_crit)
		BattleUnits.PlayerStats.hp += heal
		BattleUnits.Enemy.show_floaty_text(heal,"HP",is_crit)

#function that determines the amount of mp returned
func determine_mp():
	var mp
	if (global.world_tier == 1):
		mp = 2
	if (global.world_tier == 2):
		mp = 3
	if (global.world_tier == 3):
		mp = 4	
	return mp
		
#function that creates the animations and effects
func create_slash(position, is_crit):
	var slash = Slash.instance()
	var critslash = CritSlash.instance()
	var poison = PoisonEffect.instance()
	var main = get_tree().current_scene
	if is_crit == true:
		main.add_child(critslash)
		critslash.global_position = position
	else:	
		main.add_child(slash)
		slash.global_position = position
	if BattleUnits.PlayerStats.poisoned_slash == true:
		main.add_child(poison)
		poison.global_position = position
