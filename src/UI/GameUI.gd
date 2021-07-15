# ----------------------------------------- #
# Game UI Script
# ----------------------------------------- #
extends Control


# Variables
# -----------------------------------------------
const MARKERLOSE = preload("res://src/Board/Markers/MarkerCross.tscn")
const MARKERWIN = preload("res://src/Board/Markers/MarkerCircle.tscn")
const MARKERDRAW = preload("res://src/Board/Markers/MarkerDot.tscn")

const MARKERS = {"win" : preload("res://src/Board/Markers/MarkerCircle.tscn"),
				 "lose" : preload("res://src/Board/Markers/MarkerCross.tscn"),
				 "draw" : preload("res://src/Board/Markers/MarkerDot.tscn")} 

onready var game_state = GameState
onready var parent = get_parent()
onready var anim_player = $AnimationPlayer
onready var markers = $Markers



# Functions:
# -----------------------------------------------
func _ready():
	game_state.connect("state_changed", self, "update_lbl_state")
	game_state.connect("score_changed_player", self, "update_lbl_player_score")
	game_state.connect("score_changed_ai", self, "update_lbl_ai_score")


func reveal_state_title():
	anim_player.play("phase_title_appear")
	yield(anim_player, "animation_finished")
	parent.emit_signal("title_rev_done")


func spawn_marker(pos, res):
	var marker = MARKERS[res].instance()
	
	marker.rect_global_position = get_node("MarkerPos/ResultMarker" + str(pos)).rect_global_position 
	markers.add_child(marker)


func clear_markers():
	for i in markers.get_children():
		i.queue_free()


func update_lbl_state(new_state):
	$TitlePhase.text = game_state.state_names[new_state]
	$TitlePhaseLarge/TitleLarge.text = game_state.state_names[new_state]

func update_lbl_player_score(score):
	$ScorePlayer.text = str(score)

func update_lbl_ai_score(score):
	$ScoreAI.text = str(score)


func update_lbl_player_deck_count(deck):
	$DeckPlayer/CountDeck.text = str(deck.deck_contents.size())

func update_lbl_player_discard_count(count):
	$DeckPlayer/CountDiscard.text = str(count)

func update_lbl_ai_deck_count(deck):
	$DeckAI/CountDeck.text = str(deck.deck_contents.size())

func update_lbl_ai_discard_count(count):
	$DeckAI/CountDiscard.text = str(count)


func _on_ButtonMenu_pressed():
	parent.game_pause()
