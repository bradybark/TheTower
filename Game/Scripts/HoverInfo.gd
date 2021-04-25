extends Control

export (String, MULTILINE) var description = ""
	
#function thats called when the mouse moves ON the box
func _on_HoverInfo_mouse_entered():
	set_description()
	var main = get_tree().current_scene
	var textbox = main.find_node("Textbox")
	if textbox != null:
		textbox.text = description

#function thats called when the mouse moves OFF the box
func _on_HoverInfo_mouse_exited():
	set_description()
	var main = get_tree().current_scene
	var textbox = main.find_node("Textbox")
	if textbox != null:
		textbox.text = ""
		
#function that sets the description of the Button
func set_description():
	var cost
	#sets decription for Blast
	if "Blast" in description:
		if global.aspect_of_sentinel == true:
			cost = 1
		else:
			cost = 2
		description = "Soul Blast. Does damage and heals. Costs " + str(cost) + " mp."
		if global.aspect_of_rogue == true:
			description += " Can crit."
	#sets decription for Heal	
	if "Restores" in description:
		if global.aspect_of_sentinel == true:
			cost = 4
		else:
			cost = 8
		description = "Heal. Restores your hp. Costs " + str(cost) + " mp"
	#sets decription for Siphon
	if "Siphon" in description:
		if global.aspect_of_sentinel == true:
			cost = 4
		else:
			cost = 8
		description = "Siphon. Kills an enemy under 20% hp and heals you for half your max hp. Costs " + str(cost) + "mp"
	#sets decription for Fireball
	if "Fireball" in description:
		if global.aspect_of_sentinel == true:
			cost = 5
		else:
			cost = 10
		description = "Fireball. Deals damage. Has a chance to double cast. Costs " + str(cost) + "mp"
		if global.aspect_of_rogue == true:
			description += " Can crit."
	#sets decription for Slash
	if "Slash" in description:
		var mp
		if (global.world_tier == 1):
			mp = 2
		if (global.world_tier == 2):
			mp = 3
		if (global.world_tier == 3):
			mp = 4	
		description = "Slash. Gain mp +" + str(mp) + " on hit. Can crit."
	#sets decription for Poison
	if "Poison" in description:
		description = "Poisons your slash for the rest of your turn. Does +3 damage. Heals +1 hp. Can crit."
	#sets decription for Block
	if "Block" in description: 
		description = "Block. Take 50% less damage from the next attack."
