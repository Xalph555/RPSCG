# ----------------------------------------- #
# Title Screen Script
# ----------------------------------------- #
extends Control


# Variables
# -----------------------------------------------
onready var scene_changer = SceneChanger
onready var cards = $Cards



# Functions:
# -----------------------------------------------
func flip_cards():
	for i in cards.get_children():
		i.anim_player.play("face_up")
		


func _on_ButtonPlay_pressed():
	$ButtonMain/ButtonPlay.disabled = true
	scene_changer.change_scene("res://src/MainScene/GameMain.tscn")


func _on_ButtonQuit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
