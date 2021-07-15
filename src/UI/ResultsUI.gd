# ----------------------------------------- #
# Results UI Script
# ----------------------------------------- #
extends Control


# Variables
# -----------------------------------------------
const SOUNDS = {"win" : preload("res://assets/sound/results/result_overall_win.ogg"),
				"lose" : preload("res://assets/sound/results/result_overall_lose.ogg"),
				"draw" : preload("res://assets/sound/results/result_overall_draw.ogg")}

onready var game_state = GameState
onready var scene_changer = SceneChanger
onready var parent = get_parent()

onready var anim_player = $AnimationPlayer
onready var sound = $AudioStreamPlayer
onready var sound_result = $AudioStreamResult



# Functions:
# -----------------------------------------------
func play_menu_reveal():
	anim_player.play("menu_reveal")


func play_sound(sfx):
	sound.stream = sfx
	sound.play()


func play_result_sound(sfx):
	sound_result.stream = sfx
	sound_result.play()


func _on_ButtonPlay_pressed():
	self.visible = false
	parent.parent.reset_game()


func _on_ButtonMM_pressed():
	game_state.score_player = 0
	game_state.score_ai = 0
	scene_changer.change_scene("res://src/UI/TitleScreen.tscn")
