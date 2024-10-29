extends KinematicBody2D
class_name Player

#onready var hearts = [UINodes.get_node("Heart5"),UINodes.get_node("Heart4"),UINodes.get_node("Heart3"),UINodes.get_node("Heart2"),UINodes.get_node("Heart1")]
onready var player_movement = $Controls/Movement as PlayerMovement
onready var player_action = $Controls/Action as PlayerAction
var current_velocity = Vector2()
var health = 125; #Puntos de HP del jugador
var get_hurt = true
export var speed=200
var player_sprite
var current_weapon
var heart_index;

signal hurt

func _ready():
	heart_index = 4;
#	for heart in hearts:
#		heart.modulate = Color(1,1,1)
	player_sprite = $AnimatedSprite
	Signals.connect("damage_taken",self,"on_damage_taken")


func _process(delta):
	handle_player_animation()
	if GameStatus.can_play:
		look_at(get_global_mouse_position())
		player_action.action_pressed()

func _physics_process(delta):
	if GameStatus.can_play:
		current_velocity = player_movement.get_player_movement()
		current_velocity = move_and_slide(current_velocity*speed)
	
func on_damage_taken():
	if health != 0: #solucion no optima para impedir jugar si health == 0
		if get_hurt:
			print("danio recibido")
			emit_signal("hurt",heart_index);
			heart_index -= 1;
			#hearts[heart_index].modulate = Color(0,0,0)
			health -= 25
			get_hurt = false
			yield(get_tree().create_timer(2),"timeout")
			#heart_index += 1
			get_hurt = true
	else:
		Signals.emit_signal("game_over")

func handle_player_animation():
	if current_velocity != Vector2.ZERO:
		if GameStatus.current_weapon == "w1":
			player_sprite.animation = "Pistol"
		elif GameStatus.current_weapon == "w2":
			player_sprite.animation = "Rifle"
		else:
			player_sprite.animation = "Shotgun"
	else:
		if GameStatus.current_weapon == "w1":
			player_sprite.animation = "Pistol_Still"
		elif GameStatus.current_weapon == "w2":
			player_sprite.animation = "Rifle_Still"
		else:
			player_sprite.animation = "Shotgun_Still"
		
