extends Node2D


onready var buttonA = $OptionAVBox/OptionAButton
onready var buttonB = $OptionBVBox/OptionBButton
onready var textA = $OptionAVBox/OptionAPanel/OptionAText
onready var textB = $OptionBVBox/OptionBPanel/OptionBText

func _ready():
	set_button_text()
	
func set_button_text():
		buttonA.text = "Aspect of the Mage"
		buttonB.text = "Aspect of the Knight"
		textA.text = "Inherit the aspect of the Mage. Increase your max mp by 10 and gain +5mp on kills."
		textB.text = "Inherit the aspect of the Knight. Increase your max hp by 20 and gain +10hp on kills."

func _on_OptionAButton_pressed():
	if global.world_tier == 2:
		global.set_aspect_mage(true)
	if global.world_tier == 3:
		global.set_aspect_rogue(true)
	get_parent().remove_child(self)
	set_text_for_next()
	
func _on_OptionBButton_pressed():
	if global.world_tier == 2:
		global.set_aspect_knight(true)
	if global.world_tier == 3:
		global.set_aspect_sentinel(true)
	get_parent().remove_child(self)
	set_text_for_next()
	
func set_text_for_next():
	buttonA.text = "Aspect of the Rogue"
	buttonB.text = "Aspect of the Sentinel"
	textA.text = "All damaging abilites can crit and your crit chance triples. Gain access to the Poison Action."
	textB.text = "Your Heal does 50% more and all of your spells cost half the mp. Gain access to the Block Action."
	global.set_textbox_floor_complete()

