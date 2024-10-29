extends Area2D
class_name Ammo

func _ready():
	connect("body_entered",self,"on_body_entered")
	
func on_body_entered(body):
	if body.is_in_group("player"):
		Signals.connect("ammo_picked",self,"on_ammo_picked")

func on_ammo_picked():
	Signals.emit_signal("charge_ammo")
	AudioManager.pickup_sound_play()
	queue_free()
