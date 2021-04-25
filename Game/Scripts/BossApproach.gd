extends Node2D

onready var boss_txt = $Label
onready var animationPlayer = $AnimationPlayer

func _ready():
	check_boss()
	yield(animationPlayer,"animation_finished")
	get_parent().remove_child(self)
	
func check_boss():
	if global.world_tier == 1:
		boss_txt.text = "Floor 1 Boss Fight!"
	if global.world_tier == 2:
		boss_txt.text = "Floor 2 Boss Fight!"
	if global.world_tier == 3:
		boss_txt.text = "Final Boss Fight!"


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

