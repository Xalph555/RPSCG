# ----------------------------------------- #
# Game Script
# ----------------------------------------- #
extends Node2D

# Signals
# ----------------------------------------------
signal field_flipped



# Variables
# -----------------------------------------------
const DECK = preload("res://src/Deck/Deck.tscn")

var deck_player
var deck_ai

onready var game_state = GameState
onready var scene_changer = SceneChanger
onready var phase_nodes = $GamePhases.get_children()
onready var tween = $Tween
onready var ui = $BoardUI/UI
onready var p_hand_start = $BoardPositions/PlayerHandStart
onready var ai_hand_start = $BoardPositions/AIHandStart



# Functions:
# -----------------------------------------------
func _ready():
	spawn_decks()
	yield(scene_changer, "scene_changed")
	run_match()


func run_match():
	for i in range(game_state.STATES.size()):
		game_state.state_transition(i)
		
		ui.turn_start()
		yield(ui, "title_rev_done")
		
		phase_nodes[i].run_phase()
		yield(phase_nodes[i], "phase_end")
	
	run_match()


func spawn_decks():
	deck_player = DECK.instance()
	deck_player.global_position = $BoardPositions/DeckPlayer.global_position
	deck_player.connect("card_drawn", self, "on_card_draw")
	deck_player.is_player = true
	deck_player.connect("card_drawn", ui.game_ui, "update_lbl_player_deck_count")
	deck_player.connect("card_discarded", ui.game_ui, "update_lbl_player_discard_count")
	deck_player.connect("discard_restored", ui.game_ui, "update_lbl_player_discard_count")
	add_child(deck_player)
	$BoardUI/UI/GameUI/DeckPlayer/CountDeck.text = str(deck_player.deck_contents.size())
	$BoardUI/UI/GameUI/DeckPlayer/CountDiscard.text = str(0)
	
	deck_ai = DECK.instance()
	deck_ai.global_position = $BoardPositions/DeckAI.global_position
	deck_ai.connect("card_drawn", self, "on_card_draw")
	deck_ai.connect("card_drawn", ui.game_ui, "update_lbl_ai_deck_count")
	deck_ai.connect("card_discarded", ui.game_ui, "update_lbl_ai_discard_count")
	deck_ai.connect("discard_restored", ui.game_ui, "update_lbl_ai_discard_count")
	add_child(deck_ai)
	$BoardUI/UI/GameUI/DeckAI/CountDeck.text = str(deck_ai.deck_contents.size())
	$BoardUI/UI/GameUI/DeckAI/CountDiscard.text = str(0)


func move_object(pos1, pos2, offset = Vector2.ZERO, tween_time = 0.5):
	tween.interpolate_property(pos1, "global_position", 
							   null, pos2.global_position + offset, tween_time,
							   tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()


func turn_field(down = false):
	if down:
		for i in deck_ai.field_contents:
			i.face_down()
			yield(i, "card_flipped")
	
	else:
		for i in deck_ai.field_contents:
			i.face_up()
			yield(i, "card_flipped")
	
	emit_signal("field_flipped")


func rearrange_hand(deck):
	if deck.hand_contents.size() > 0:
		var start_pos = p_hand_start if deck == deck_player else ai_hand_start
		move_object(deck.hand_contents[0], start_pos, Vector2.ZERO, 0.04)
		deck.hand_contents[0].z_index = 0
		yield(tween, "tween_completed")
		
		for i in range(1, deck.hand_contents.size()):
			var shift = Vector2(120, 0) if deck == deck_player else Vector2(-120, 0)
			move_object(deck.hand_contents[i], deck.hand_contents[i-1], shift, 0.04)
			deck.hand_contents[i].z_index = i
			yield(tween, "tween_completed")


func reset_game():
	game_state.score_player = 0
	game_state.score_ai = 0
	scene_changer.change_scene("res://src/MainScene/GameMain.tscn")


func on_card_draw(deck):
	var current_card = deck.hand_contents[-1]
	if deck.hand_contents.size() <= 1:
		var start_pos = p_hand_start if deck == deck_player else ai_hand_start
		move_object(current_card, start_pos, Vector2.ZERO)
		if deck == deck_ai: deck.hand_contents[-1].play_sound(deck.hand_contents[-1].SOUNDS["draw"])
		current_card.z_index = 0
	
	else:
		var shift = Vector2(120, 0) if deck == deck_player else Vector2(-120, 0)
		move_object(current_card, deck.hand_contents[-2], shift)
		if deck == deck_ai: deck.hand_contents[-1].play_sound(deck.hand_contents[-1].SOUNDS["draw"])
		var i = deck.hand_contents.size() - 1
		current_card.z_index = i
