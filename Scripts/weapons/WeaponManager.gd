extends Node2D

onready var current_weapon = $w1
onready var current_weapon_shooting_point = $w1/ShootingPoint
onready var current_weapon_direction = $w1/GunDirection
onready var change_weapon = get_parent().get_node("Controls/Action")
var weapons=[]
var bullet = preload("res://Scenes/weapons/Bullet.tscn")
export var bullet_speed=1000	

var potencia = 10; #La potencia del arma que estamos usando, afecta a la bala.

func _ready():
	Signals.connect("change_weapon",self,"switch_weapon")
	Signals.connect("fire_button_pressed",self,"on_player_attack")
	weapons = get_children()
	for weapon in weapons:
		weapon.hide()
	current_weapon.show()

func _process(delta):
	change_weapon.weapon_changed()
	current_weapon.shoot_key_pressed()
	
func switch_weapon(weapon: String):
	if weapon == "w1":
		current_weapon.hide()
		weapons[0].show()
		current_weapon = weapons[0]
		GameStatus.current_weapon = "w1"
		potencia = 10;
	elif weapon == "w2":
		current_weapon.hide()
		weapons[1].show()
		current_weapon = weapons[1]
		GameStatus.current_weapon = "w2"
		potencia = 15;
		#Signals.emit_signal("current_weapon","smg")
	elif weapon == "w3":
		current_weapon.hide()
		weapons[2].show()
		current_weapon = weapons[2]
		GameStatus.current_weapon = "w3"
		potencia = 50;
		#Signals.emit_signal("current_weapon","shotgun")

func on_player_attack():
	var bullet_instance=bullet.instance()
	var direction = (current_weapon_direction.global_position - current_weapon_shooting_point.global_position).normalized()
	bullet_instance.power = potencia;
	#Cambia el sprite de la bala para la escopeta.
	if(GameStatus.current_weapon == "w3"):
		bullet_instance.get_node("Sprite").texture = load("res://Sprites/FOGONAZO.png")
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.global_position=current_weapon_shooting_point.global_position
	bullet_instance.set_direction(direction)
