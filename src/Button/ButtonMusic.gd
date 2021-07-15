# ----------------------------------------- #
# Music Button Script
# ----------------------------------------- #
extends Button


# Variables
# -----------------------------------------------
const ICON_ENABLED = preload("res://assets/button/button_music.png")
const ICON_DISABLED = preload("res://assets/button/button_music_off.png")

onready var audio_control = AudioControl
onready var sound = $AudioStreamPlayer



# Functions:
# -----------------------------------------------
func _ready():
	self.icon = ICON_DISABLED if audio_control.is_music_muted else ICON_ENABLED
	
	audio_control.connect("music_unmuted", self, "icon_unmuted")
	audio_control.connect("music_muted", self, "icon_muted")


func _on_pressed():
	sound.play()
	audio_control.is_music_muted = !audio_control.is_music_muted


func icon_unmuted():
	self.icon = ICON_ENABLED

func icon_muted():
	self.icon = ICON_DISABLED
