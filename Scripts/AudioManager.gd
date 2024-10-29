extends Node

onready var pickup_sound = $Pickup
onready var zombie_death_sound = $ZombieDeath
onready var zombie_sound = $ZombieSound

func pickup_sound_play() -> void:
	if !pickup_sound.playing:
		pickup_sound.play()

func zombie_death_sound_play() -> void:
	if !zombie_death_sound.playing:
		zombie_death_sound.play()

func zombie_sound_play() -> void:
	if !zombie_sound.playing:
		zombie_sound.play()

func zombie_sound_stop() -> void:
	if zombie_sound.playing:
		zombie_sound.stop()
