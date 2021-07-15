# ----------------------------------------- #
# Pause UI Script
# ----------------------------------------- #
extends Control


# Variables
# -----------------------------------------------
var can_input = false

onready var game_state = GameState
onready var parent = get_parent()
onready var scene_changer = SceneChanger
onready var anim_player = $AnimationPlayer



# Functions:
# -----------------------------------------------
func _ready():
	parent.connect("game_paused", self, "play_menu_reveal")
	parent.connect("game_resumed", self, "play_menu_hide")
	
	scene_changer.connect("scene_changed", self, "enable_input")


func _input(event):
	if can_input and event.is_action_pressed("ui_esc"):
		if parent.is_game_paused:
			parent.game_resume()
		
		else:
			parent.game_pause()


func enable_input(): can_input = true


func play_menu_reveal():
	anim_player.play("menu_reveal")


func play_menu_hide():
	anim_player.play("menu_hide")


func _on_ButtonResume_pressed():
	parent.game_resume()


func _on_ButtonMM_pressed():
	can_input = false
	game_state.score_player = 0
	game_state.score_ai = 0
	
	parent.game_resume()
	scene_changer.change_scene("res://src/UI/TitleScreen.tscn")
