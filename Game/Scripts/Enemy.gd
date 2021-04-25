extends Node2D

# BattleUnits
const BattleUnits = preload("res://BattleUnits.tres")

# enemy stat variables
export(int) var hp = 25 setget set_hp
var max_hp = 25 setget set_max_hp
export(int) var damage = 4
export(int) var crit_chance = 5
export(int) var kill_xp = 15
export (String) var enemyName = "Enemy Name"

# UI elements, animations, etc
onready var hpLabel = $HPLabel
onready var animationPlayer = $AnimationPlayer
onready var executable = $Executable
var floaty_text_scene = preload("res://FloatingText.tscn")
const shadowLash = preload("res://ShadowLash.tscn")

signal died 
signal end_turn

func set_hp(new_hp):
	hp = new_hp
	if hpLabel != null:
		hpLabel.text = str(hp) + "hp"
	if self.hp <= 0:
		hpLabel.text = "DEAD"

func set_max_hp(new_hp):
	max_hp = new_hp
	
func _ready():
	BattleUnits.Enemy = self
	
func _exit_tree():
	BattleUnits.Enemy = null
	
#enemy attack function
func attack() -> void:
	yield(get_tree().create_timer(0.4),"timeout")
	animationPlayer.play("Attack")
	yield(animationPlayer,"animation_finished")
	emit_signal("end_turn")

#creates the shadowlash world_tier 3 spell
func t3_spell():
	var spell = shadowLash.instance()
	var main = get_tree().current_scene
	main.add_child(spell)
	yield(get_tree().create_timer(1),"timeout")
	yield(animationPlayer,"animation_finished")

#function that deals damage to the Player
func deal_damage():
	var main = get_tree().current_scene
	var textbox = main.find_node("Textbox")
	var crit = roll_crit()
	if crit < crit_chance:
		BattleUnits.PlayerStats.take_damage(damage*2)
		textbox.text = "The " + str(BattleUnits.Enemy.enemyName) + "'s attack did critical damage"
	else:
		BattleUnits.PlayerStats.take_damage(damage)
		textbox.text = "The " + str(BattleUnits.Enemy.enemyName) +  " attacked you!"
	
	if(global.world_tier == 3):
		t3_spell()
		yield(get_tree().create_timer(0.5),"timeout")

#function that actually does damage to the enemy
func take_damage(amount):
	self.hp -= amount
	var main = get_tree().current_scene
	if is_dead():
		var textbox = main.find_node("Textbox")
		animationPlayer.play("Death")
		BattleUnits.PlayerStats.xp += kill_xp
		emit_signal("died")
		yield(get_tree().create_timer(0.5),"timeout")
		textbox.text = "You defeated the " + str(BattleUnits.Enemy.enemyName) + "!"
		queue_free()
	else:
		animationPlayer.play("Shake")
		executable.show_effects()


func is_dead():
	return hp <= 0 

#determines if the Siphon ability can be used
#displays an icon, returns a bool
func is_executable():
	var can_execute
	var threshold = max_hp/5
	threshold = round(threshold)
	if hp <= threshold:
		can_execute = true
	else:
		can_execute = false
	return can_execute

#function that rolls the enemy's crit
#returns a number 
func roll_crit():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var crit = randi() %101
	return crit

#function that displays the floating damage numbers!
func show_floaty_text(value, attack_type, is_crit):
	var floaty_text = floaty_text_scene.instance()
	floaty_text.text = value
	
	if attack_type == "Slash":
		floaty_text.position = position
		if is_crit == true:
			floaty_text.modulate =	Color( 1, 0, 0, 1 )
			floaty_text.text = str(value) + "!"
			floaty_text.velocity = Vector2(rand_range(-50,50),-100)
		else:
			floaty_text.modulate = Color( 0.96, 0.96, 0.96, 1 )
			floaty_text.velocity = Vector2(rand_range(-20,20),-100)
			
	if attack_type == "Blast":
		floaty_text.position = position
		if is_crit == true:
			floaty_text.text = str(value) + "!"
			floaty_text.modulate = Color( 0.25, 0.41, 0.88, 1 )
			floaty_text.velocity = Vector2(rand_range(-50,50),-100)
		else:
			floaty_text.modulate = Color( 0.53, 0.81, 0.92, 1 )
			floaty_text.velocity = Vector2(rand_range(-30,30),-100)
			
	if attack_type == "Siphon":
		floaty_text.position = position
		if is_crit == true:
			floaty_text.modulate = Color( 0.58, 0.44, 0.86, 1 )
			floaty_text.velocity = Vector2(rand_range(-50,50),-100)
		else:
			floaty_text.modulate = Color( 1, 1, 0.80, 1 )
			floaty_text.velocity = Vector2(rand_range(-10,10),-100)
		
	if attack_type == "Fireball":
		floaty_text.position = position
		if is_crit == true:
			floaty_text.modulate = Color( 1, 0.27, 0, 1 )
			floaty_text.text = str(value) + "!"
			floaty_text.velocity = Vector2(rand_range(-50,50),-100)
		else:
			floaty_text.modulate =  Color( 1, 0.55, 0, 1 )
			floaty_text.velocity = Vector2(rand_range(-30,30),-100)
			
			
	if attack_type == "MP":
		if is_crit == true:
			floaty_text.text = "+" + str(value) + "mp!"
		else:
			floaty_text.text = "+" + str(value) + "mp"
			
		floaty_text.modulate = Color( 0.1, 0.1, 0.44, 1 )
		floaty_text.velocity = Vector2(rand_range(0,10),-85)

	if attack_type == "HP":
		floaty_text.modulate =  Color( 0, 0.5, 0, 1 )
		if is_crit == true:
			floaty_text.text = "+" + str(value) + "hp!"
		else:
			floaty_text.text = "+" + str(value) + "hp"
			
		floaty_text.velocity = Vector2(rand_range(-10,0),-85)	
		
		#avoids overlap with the +mp text
		if BattleUnits.PlayerStats.poisoned_slash == true:
			floaty_text.velocity = Vector2(rand_range(-25,-20),-85)	
			
		
	if attack_type == "Poison":
		floaty_text.position = position
		floaty_text.modulate =  Color( 0.6, 0.98, 0.6, 1 )
		if is_crit == true:
			floaty_text.text = str(value) + "!"
			floaty_text.velocity = Vector2(rand_range(-20,20),-70)
		else:
			floaty_text.velocity = Vector2(rand_range(-10,10),-40)

	add_child(floaty_text)
	
	
