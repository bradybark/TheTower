extends Node2D
const BattleUnits = preload("res://BattleUnits.tres")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

func player_lose_mp():
	if BattleUnits.PlayerStats.mp >= 2:
		BattleUnits.PlayerStats.mp1 -= 2
