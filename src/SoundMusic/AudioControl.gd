# ----------------------------------------- #
# Audio Controller Script
# ----------------------------------------- #

extends Node

# Signals
# ----------------------------------------------
signal music_unmuted
signal music_muted
signal sound_unmuted
signal sound_muted



# Variables
# -----------------------------------------------
var is_music_muted = false setget set_music
var is_sound_muted = false setget set_sound



# Functions:
# -----------------------------------------------
func set_music(value):
	is_music_muted = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value)
	
	if is_music_muted:
		emit_signal("music_muted")
	else:
		emit_signal("music_unmuted")


func set_sound(value):
	is_sound_muted = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), value)
	
	if is_sound_muted:
		emit_signal("sound_muted")
	else:
		emit_signal("sound_unmuted")
