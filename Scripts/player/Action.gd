extends Node
class_name PlayerAction

func action_pressed():
	if Input.is_action_just_pressed("action"):
		Signals.emit_signal("ammo_picked")

func weapon_changed():
	if Input.is_action_just_pressed("weapon1"):
		Signals.emit_signal("change_weapon","w1")
		#Signals.emit_signal("change_weapon_sprite","w1")
	elif Input.is_action_just_pressed("weapon2"):
		Signals.emit_signal("change_weapon","w2")
		#Signals.emit_signal("change_weapon_sprite","w2")
	elif Input.is_action_just_pressed("weapon3"):
		Signals.emit_signal("change_weapon","w3")
		#Signals.emit_signal("change_weapon_sprite","w3")
