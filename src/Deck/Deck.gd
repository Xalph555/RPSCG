# ----------------------------------------- #
# Deck Script
# ----------------------------------------- #
extends Node2D


# Signals
# ----------------------------------------------
signal card_drawn(deck)
signal card_discarded(count)
signal discard_restored(count)



# Variables
# -----------------------------------------------
const CARDS = {"rock" : preload("res://src/Card/Rock/CardRock.tscn"),
			   "paper" : preload("res://src/Card/Paper/CardPaper.tscn"),
			   "scissors" : preload("res://src/Card/Scissors/CardScissors.tscn")}

const SOUNDS = {"restore" : preload("res://assets/sound/cards/card_restore.ogg")}

export (int) var max_deck_size = 15

var is_player = false

var deck_contents = []
var hand_contents = []
var discard_contents = []
var field_contents = [0, 0, 0]

onready var game_state = GameState
onready var sound = $AudioStreamPlayer
onready var cards = $Cards



# Functions:
# -----------------------------------------------
func _ready():
	create_new()


func is_field_full():
	return false if 0 in field_contents else true


func get_selected_hand():
	for i in range(hand_contents.size()):
		if hand_contents[i].is_selected: return i


func get_selected_field():
	var selected = []
	for i in range(field_contents.size()):
		if field_contents[i].is_selected:
			selected.append(i)
	
	return selected


func play_sound(sfx):
	sound.stream = sfx
	sound.play()


func create_new():
	deck_contents = []
	hand_contents = []
	discard_contents = []
	field_contents = [0, 0, 0]
	
	for _i in range(5):
		var new_rock = CARDS["rock"].instance()
		var new_paper = CARDS["paper"].instance()
		var new_scissors = CARDS["scissors"].instance()
		
		cards.add_child(new_rock)
		cards.add_child(new_paper)
		cards.add_child(new_scissors)
	
	for i in cards.get_children():
		i.connect("card_selected", self, "on_selected")
		deck_contents.append(i)
		i.set_face_down()
	
		if is_player: i.is_player = true
	
	shuffle_deck()


func draw_card():
	hand_contents.append(deck_contents.pop_back())
	hand_contents[-1].is_in_hand = true
	
	if is_player: hand_contents[-1].face_up()
	
	emit_signal("card_drawn", self)


func shuffle_deck():
	randomize()
	deck_contents.shuffle()


func place_card(i_hand, i_field):
	field_contents[i_field] = hand_contents[i_hand]
	hand_contents[i_hand].is_in_hand = false
	hand_contents.remove(i_hand)


func swap_cards(index1, index2):
	var temp = field_contents[index1]
	field_contents[index1] = field_contents[index2]
	field_contents[index2] = temp


func restore_discard():
	for _i in range(discard_contents.size()):
		deck_contents.append(discard_contents.pop_back())
	
	emit_signal("discard_restored", discard_contents.size())


func clear_card(i):
	discard_contents.append(field_contents[i])
	field_contents[i] = 0
	
	emit_signal("card_discarded", discard_contents.size())


func on_selected(card):
	if game_state.state_current == game_state.STATES.PLAYER_PLAY:
		for i in hand_contents:
			if i != card: i.deselect()
	
	if game_state.state_current == game_state.STATES.SWAP:
		if get_selected_field().size() > 2:
			card.deselect()
