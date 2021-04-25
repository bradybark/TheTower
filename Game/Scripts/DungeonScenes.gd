extends Node2D

onready var tier1 = $Tier1
onready var tier2 = $Tier2
onready var tier3 = $Tier3

func determine_scene(world_tier):
	if(world_tier == 1):
		tier2.hide()
		tier3.hide()
		tier1.show()
	if(world_tier == 2):	
		tier1.hide()
		tier3.hide()
		tier2.show()
	if(world_tier == 3):
		tier1.hide()
		tier2.hide()
		tier3.show()
		
