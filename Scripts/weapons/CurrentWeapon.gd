extends Node2D
class_name Weapon


onready var current_ammo_label = UINodes.get_node("CurrentAmmo")
onready var max_ammo_label = UINodes.get_node("MaxAmmo")
var can_shoot = true
export (float) var fire_rate
export (int) var max_ammo
var current_ammo = max_ammo setget set_current_ammo

func _ready():
	Signals.connect("change_weapon",self,"set_ammo_label")
	Signals.connect("charge_ammo",self,"set_ammo_amount")
	current_ammo = max_ammo
	set_ammo_label(GameStatus.current_weapon)
#	current_ammo_label.text = "?"
#	max_ammo_label.text = "?"

func shoot_key_pressed():
	if GameStatus.can_play:
		if Input.is_action_pressed("fire") and can_shoot:
			if !GameStatus.current_weapon == "w1":
				current_ammo_label.text = str(current_ammo - 1)
			Signals.emit_signal("fire_button_pressed")
			can_shoot = false
			$ShootingSound.play()
			yield(get_tree().create_timer(fire_rate),"timeout")
			can_shoot = true
			$ShootingSound.stop()
			set_current_ammo(current_ammo - 1)

func set_current_ammo(new_ammo: int):
	var actual_ammo = clamp(new_ammo,0,max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			can_shoot = false

func set_ammo_amount():
	can_shoot = true
	current_ammo = max_ammo
	#current_ammo_label.text = str(current_ammo)

func set_ammo_label(weapon: String):
	if GameStatus.current_weapon == "w1":
		current_ammo_label.text = "?"
		max_ammo_label.text = "?"
	elif GameStatus.current_weapon == "w2":
		max_ammo_label.text = "180"
		current_ammo_label.text = str(current_ammo)
	elif GameStatus.current_weapon == "w3":
		max_ammo_label.text = "30"
		current_ammo_label.text = str(current_ammo)
