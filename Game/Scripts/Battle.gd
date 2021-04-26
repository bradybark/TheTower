extends Node

#BattleUnits
const BattleUnits = preload("res://BattleUnits.tres")

#all of the enemy arrays
export(Array, PackedScene) var tier1_enemies = []
export(Array,PackedScene) var bosses = []
export(Array, PackedScene) var tier2_enemies = []
export(Array, PackedScene) var tier3_enemies = []

#onready calls all the possible action buttons
onready var battleActionButtons = $UI/BattleActionButtons
onready var magicActionButton = $UI/BattleActionButtons/MagicActionButton
onready var healActionButton = $UI/BattleActionButtons/HealActionButton
onready var executeActionButton = $UI/BattleActionButtons/ExecuteActionButton
onready var fireballActionButton = $UI/BattleActionButtons/FireballActionButton
onready var poisonActionButton = $UI/BattleActionButtons/PoisonActionButton
onready var blockActionButton = $UI/BattleActionButtons/BlockActionButton

#necessary calls for UI elements/animations/scene changes
onready var animationPlayer = $AnimationPlayer
onready var nextRoomButton = $UI/CenterContainer/NextRoomButton
onready var	newGameButton = $UI/CenterContainer/NewGameButton
onready var	nextFloorButton = $UI/CenterContainer/NextFloorButton
onready var enemyPosition = $EnemyPosition
onready var afterBattle = $UI/AfterBattle
onready var dungeonScenes = $DungeonScenes
onready var upgradeScene = load("res://FloorComplete.tscn").instance()
onready var boss_approach = load("res://BossApproach.tscn")

#bool variable that determines if the enemy is a boss
onready var its_a_boss = false

#functions thats called when the scene is first ready
func _ready():
	var main = get_tree().current_scene
	var textbox = main.find_node("Textbox")
	randomize()
	BattleUnits.PlayerStats.default_stats()
	decide_enemy_tier()
	textbox.text = "Welcome to the Tower! Use your available actions to defeat the " + str(BattleUnits.Enemy.enemyName) + "!"
	start_player_turn()

#function that starts the enemy's turn
func start_enemy_turn():
	battleActionButtons.hide()
	if BattleUnits.Enemy != null and not BattleUnits.Enemy.is_queued_for_deletion():
		if its_a_boss == true:
			BattleUnits.Enemy.boss_fight()
			yield(BattleUnits.Enemy, "end_turn")
		else:
			BattleUnits.Enemy.attack()
			yield(BattleUnits.Enemy, "end_turn")
	BattleUnits.PlayerStats.blocking = false
	start_player_turn()

#function that starts the player's turn	
func start_player_turn():
	set_player_stats(false)
	if BattleUnits.PlayerStats.hp <= 0:
		_on_Player_died()
	else:
		battleActionButtons.show()
		available_actions()
		#sets action points to max every round
		BattleUnits.PlayerStats.ap = BattleUnits.PlayerStats.max_ap
		#we wait for the end turn signal from playerStats
		yield(BattleUnits.PlayerStats,"end_turn")
		BattleUnits.PlayerStats.poisoned_slash = false
		start_enemy_turn()

#function that determine which actions the player can use based on level or aspects
func available_actions():
	#determines if Heal is available
	if(BattleUnits.PlayerStats.lvl >= 4):
		healActionButton.show()
	else:
		healActionButton.hide()
	#determines if Siphon is available	
	if(BattleUnits.PlayerStats.lvl >= 11):
		executeActionButton.show()
	else:
		executeActionButton.hide()
	#determines if Fireball is available	
	if(BattleUnits.PlayerStats.lvl >= 21):
		fireballActionButton.show()
	else:
		fireballActionButton.hide()
	#determines if Poison is available
	if(global.aspect_of_rogue == true):
		poisonActionButton.show()
	else:
		poisonActionButton.hide()
	#determines if Block is available
	if(global.aspect_of_sentinel == true):
		blockActionButton.show()
	else:
		blockActionButton.hide()
		
#function that determines if the enemy is going to be a boss or not
func determine_enemy():
	if BattleUnits.PlayerStats.lvl == 10 || BattleUnits.PlayerStats.lvl ==  20 || BattleUnits.PlayerStats.lvl == 30:
		its_a_boss = true
		decide_boss_tier()
	else:
		decide_enemy_tier()
	start_player_turn()
	
#function that decides which boss to spawn from the bosses array
#called by determine_enemy()
func decide_boss_tier():
	var Boss
	if  (global.world_tier == 1):
		Boss = bosses.front()
	if (global.world_tier == 2):
		Boss = bosses[1]
	if (global.world_tier == 3):
		Boss = bosses.back()
	create_new_boss(Boss)

#decides which array we pick the enemy from based on the world_tier
func decide_enemy_tier():
	var Enemy
	if  (global.world_tier == 1):
		tier1_enemies.shuffle()
		Enemy = tier1_enemies.front()
	if (global.world_tier == 2):
		tier2_enemies.shuffle()
		Enemy = tier2_enemies.front()
	if (global.world_tier == 3):
		tier3_enemies.shuffle()
		Enemy = tier3_enemies.front()
	create_new_enemy(Enemy)

#function that creates and instances the enemy
#called by determine_enemy()
func create_new_enemy(Enemy):
	nextFloorButton.hide()
	var enemy = Enemy.instance()
	enemyPosition.add_child(enemy)
	enemy.connect("died",self,"_on_Enemy_died")
	enemy.max_hp = enemy.hp

#function that creates and instances the boss
#called by decide_boss_tier
func create_new_boss(Enemy):
	BattleUnits.PlayerStats.hp = BattleUnits.PlayerStats.max_hp
	BattleUnits.PlayerStats.mp = 0
	var enemy = Enemy.instance()
	enemyPosition.add_child(enemy)
	enemy.connect("died",self,"_on_Boss_died")
	set_Boss_Approach()

#sets the flashing boss approach text
func set_Boss_Approach():
	var b_app_txt = boss_approach.instance()
	var main = get_tree().current_scene
	main.add_child(b_app_txt)

#function called when an enemy has been defeated
func _on_Enemy_died():
	if (global.aspect_of_mage == true):
		BattleUnits.PlayerStats.mp += 10
	if (global.aspect_of_knight == true):
		BattleUnits.PlayerStats.hp += 20
	battleActionButtons.hide()
	after_battle()
	nextRoomButton.show()

#function called when a boss has been defeated
func _on_Boss_died():
	its_a_boss = false
	BattleUnits.PlayerStats.max_ap += 1
	battleActionButtons.hide()
	after_battle()
	nextFloorButton.show()

#function that is called when the player is dead
func _on_Player_died():
	print("player def died")
	battleActionButtons.hide()
	newGameButton.show()
	var main = get_tree().current_scene
	var textbox = main.find_node("Textbox")
	textbox.text = "	 YOU ARE DEAD"


#function callled after the enemy is defeated
#sets the Reward box
func after_battle():
	afterBattle.show()
	var main = get_tree().current_scene
	var xpBox = main.find_node("XPBox")
	xpBox.text = "+	" + str(BattleUnits.Enemy.kill_xp) + "xp"
	var lvlBox = main.find_node("LevelBox")
	lvlBox.text =" Level: " + str(BattleUnits.PlayerStats.lvl)

#function that is called if the Next Room Button is pressed
func _on_NextRoomButton_pressed():
	dungeonScenes.determine_scene(global.world_tier)
	nextRoomButton.hide()
	afterBattle.hide()
	animationPlayer.play("FadeToNewRoom")
	yield(animationPlayer,"animation_finished")
	set_player_stats(false)
	battleActionButtons.show()
	determine_enemy()
	
#function that sets the Player Stats.
#set max is true if the player is advancing floors
func set_player_stats(set_max):
	BattleUnits.PlayerStats.ap = BattleUnits.PlayerStats.max_ap
	BattleUnits.PlayerStats.set_player_mana()
	BattleUnits.PlayerStats.set_player_health()
	if set_max == true:
		BattleUnits.PlayerStats.hp = BattleUnits.PlayerStats.max_hp
		BattleUnits.PlayerStats.mp = 0

#function that is called when the New Game Button is pressed
func _on_NewGameButton_pressed():
	BattleUnits.PlayerStats.default_stats()
	var change = get_tree().change_scene("res://StartMenu.tscn")
	if change != 0:
		print("Error Code: ", change)

#the function thats called after the Next Floor Button is pressed
func _on_NextFloorButton_pressed():
	global.world_tier += 1
	get_parent().add_child(upgradeScene)
	set_player_stats(true)
	_on_NextRoomButton_pressed()
	if global.world_tier == 4:
		var change = get_tree().change_scene("res://PlayerWon.tscn")
		if change != 0:
			print("Error Code: ", change)
