extends Node

#BattleUnits
const BattleUnits = preload("res://BattleUnits.tres")

#player stat variables
var max_hp = 25 setget set_max_hp
var hp = max_hp setget set_hp
var max_ap = 3 setget set_max_ap
var ap = max_ap setget set_ap
var max_mp = 10 setget set_max_mp
var mp = 0 setget set_mp
var xp = 0 setget set_xp
var lvl = 0 setget set_lvl
var poisoned_slash = false
var blocking = false

#signals
signal hp_changed(value)
signal ap_changed(value)
signal mp_changed(value)
signal xp_changed(value)
signal lvl_changed(value)
signal end_turn

func _ready():
	BattleUnits.PlayerStats = self
	
func set_max_hp(value):
	max_hp = clamp(value,0,50)
	
func set_max_ap(value):
	max_ap = clamp(value,0,6)
	
func set_hp(value):
	hp = clamp(value,0,max_hp)
	emit_signal("hp_changed",hp)

#function thats sets player's max health based on level and aspects
func set_player_health():
	var levels = int(lvl)
	var size = levels/2
	var bonus = level_bonus_calc(size) * 5
	if global.aspect_of_knight == true:
		bonus += 20
	if levels > 20:
		bonus += 5
		bonus += bonus/2
	var health = 20 + bonus
	max_hp = health
	
func set_ap(value):
	ap = clamp(value,0,max_ap)
	emit_signal("ap_changed",ap)
	if ap == 0:
		emit_signal("end_turn")
	
func set_mp(value):
	mp = clamp(value,0,max_mp)
	emit_signal("mp_changed",mp)
	
func set_max_mp(value):
	max_mp = clamp(value,0,20)

#function that sets player's max mp based on level and aspects
func set_player_mana():
	var levels = int(lvl)
	var size = levels/4
	var bonus = level_bonus_calc(size) * 2
	if global.aspect_of_mage == true:
		bonus += 10
	var mana = 10 + bonus
	max_mp = mana

func set_xp(value):
	xp = clamp(value,0,9000)
	emit_signal("xp_changed",xp)
	set_lvl(xp)

func set_lvl(value):
	var playerLvl = (1.04 * sqrt(value))
	lvl = int(playerLvl)
	emit_signal("lvl_changed",lvl)

#function that sets default player stats
func default_stats():
	max_hp=25
	hp=25
	max_mp=10
	mp=0
	xp=-5   # set negative xp to nerf the early game leveling
	lvl= 0
	max_ap = 3
	global.world_tier = 1
	global.aspect_of_knight = false
	global.aspect_of_mage = false
	global.aspect_of_rogue = false
	global.aspect_of_sentinel = false

#function that operates similar to C++ for loop
func level_bonus_calc(size):
	var bonus = 0
	var i = 0
	while i < size:
		bonus += 1
		i += 1
	bonus = int(bonus)
	return bonus

#function that rolls whether the player crits or not
#returns a bool
func roll_crit():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var critRolledNum = randi() %101
	var critChance = 85
	var is_crit
	if global.aspect_of_rogue == true:
		critChance = 55
	if critRolledNum >= critChance:
		is_crit = true
	else:
		is_crit = false
	return is_crit

func _exit_tree():
	BattleUnits.PlayerStats = null

#function thats called to remove health from the player
func take_damage(amount):
	if(blocking == true):
		amount = amount/2
	self.hp -= amount

