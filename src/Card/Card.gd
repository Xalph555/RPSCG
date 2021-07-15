# ----------------------------------------- #
# Card Script
# ----------------------------------------- #
extends Node2D

# Signals
# ----------------------------------------------
signal card_selected(card)
signal card_flipped



# Variables
# -----------------------------------------------
const SOUNDS = {"draw" : preload("res://assets/sound/cards/card_draw.ogg"),
				"move" : preload("res://assets/sound/cards/card_move.ogg"),
				"select" : preload("res://assets/sound/cards/card_select.ogg")}


export (String, " ", "rock", "paper", "scissors") var type

var select_raise = 120

var wins: String
var loses: String

var is_player = false

var is_face_up = false
var is_in_hand = false
var is_selected = false 

onready var game_state = GameState
onready var anim_player = $AnimationPlayer
onready var sound = $AudioStreamPlayer

onready var front_face = $FrontFace
onready var back_face = $Backface
onready var highlight = $Highlight



# Functions:
# -----------------------------------------------
func _ready():
	match type:
		"rock":
			wins = "scissors"
			loses = "paper"
		
		"paper":
			wins = "rock"
			loses = "scissors"
			
		"scissors":
			wins = "paper"
			loses = "rock"
		
	$FrontFace.connect("card_selected", self, "on_selected")
	$FrontFace.connect("card_hovered", self, "on_hovered")
	$FrontFace.connect("card_not_hovered", self, "on_not_hovered")


func get_type():
	return type

func will_win():
	return wins

func will_lose():
	return loses


func play_sound(sfx):
	sound.stream = sfx
	sound.play()


func set_face_down():
	is_face_up = false
	front_face.visible = false
	back_face.visible = true


func set_face_up():
	is_face_up = true
	front_face.visible = true
	back_face.visible = false


func face_down():
	if is_face_up:
		is_face_up = false
		anim_player.play("face_down")
		
		yield(anim_player, "animation_finished")
		emit_signal("card_flipped")


func face_up():
	if not is_face_up:
		is_face_up = true
		anim_player.play("face_up")
		
		yield(anim_player, "animation_finished")
		emit_signal("card_flipped")


func deselect():
	if is_selected:
		is_selected = false
		highlight.visible = false
		
		if is_in_hand:
			self.global_position.y += select_raise


func on_selected():
	if is_player and not is_selected:
		if game_state.state_current == game_state.STATES.PLAYER_PLAY:
			if is_in_hand:
				is_selected = true
				highlight.visible = true
				self.global_position.y -= select_raise
				play_sound(SOUNDS["select"])
				
				emit_signal("card_selected", self)
			
		elif game_state.state_current == game_state.STATES.SWAP:
			if not is_in_hand:
				is_selected = true
				highlight.visible = true
				play_sound(SOUNDS["select"])
				
				emit_signal("card_selected", self)
		
	else:
		deselect()


func on_hovered():
	if is_player: highlight.visible = true

func on_not_hovered():
	if not is_selected: highlight.visible = false
