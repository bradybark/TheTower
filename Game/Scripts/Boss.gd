extends "res://Enemy.gd"


const slimeRatSpell = preload("res://SlimeRatSpell.tscn")
const redDragonSpell = preload("res://DragonFireLash.tscn")
const acidSpell = preload("res://AcidSpray.tscn")

#function that creates the animations and effects depending on the boss
func create_spell():
	var boss_spell
	if enemyName == "Slime Rat":
		boss_spell = slimeRatSpell.instance()
	if enemyName == "Red Dragon":
		boss_spell = redDragonSpell.instance()
	if enemyName == "Corrupted":
		var num = roll_crit()
		if num <= 50:
			boss_spell = acidSpell.instance()
		if num < 75 && num > 50: 
			boss_spell = slimeRatSpell.instance()
		if num >= 75:
			boss_spell = redDragonSpell.instance()
		final_boss()
	var main = get_tree().current_scene
	main.add_child(boss_spell)
	
#function that is called when the boss is fighting
func boss_fight():
	yield(get_tree().create_timer(0.5),"timeout")
	animationPlayer.play("SpellCast")
	yield(animationPlayer,"animation_finished")
	yield(get_tree().create_timer(0.5),"timeout")
	emit_signal("end_turn")

#function for the final boss that allows access to the T3 spell
func final_boss():
	yield(get_tree().create_timer(0.5),"timeout")
	animationPlayer.play("Attack")
	t3_spell()
	yield(animationPlayer,"animation_finished")
