# ----------------------------------------- #
# Sound Button Script
# ----------------------------------------- #
extends Button


# Variables
# -----------------------------------------------
const ICON_ENABLED = preload("res://assets/button/button_sound.png")
const ICON_DISABLED = preload("res://assets/button/button_sound_off.png")

onready var audio_control = AudioControl
onready var sound = $AudioStreamPlayer



# Functions:
# -----------------------------------------------
func _ready():
	self.icon = ICON_DISABLED if audio_control.is_sound_muted else ICON_ENABLED
	
	audio_control.connect("sound_unmuted", self, "icon_unmuted")
	audio_control.connect("sound_muted", self, "icon_muted")


func _on_pressed():
	sound.play()
	audio_control.is_sound_muted = !audio_control.is_sound_muted


func icon_unmuted():
	self.icon = ICON_ENABLED

func icon_muted():
	self.icon = ICON_DISABLED
