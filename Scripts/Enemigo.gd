extends KinematicBody2D

class_name EnemyClass

export(int) var min_speed = 75
export(int) var medium_speed = 110
export(int) var max_speed = 150

var target:Node2D; ##Lo agregue yo, benja
var hp = 100; ##Vida del enemigo
var collision
var enemy_sprite
var ammo_chance = 0.2
var enemy_type = ["1","2"] #distintos tipos de enemigo

signal dies;
var vel = Vector2.ZERO
var ammo_scene = preload("res://Scenes/Collectible.tscn")

func init(_target=null): ##benja
	target = _target


func _ready():
	randomize()
	collision = $CollisionShape2D
	enemy_sprite = $AnimatedSprite
	handle_enemy_animation()
	#sawprite.animation = enemy_type[randi()% enemy_type.size()]  #animacion distinta depende del enemigo
	
	#if sprite.animation == "Big":    Por si hay distintos tipos de enemigo
		#collision.scale.x = 1.6
		#collision.scale.y = 1.6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var playerPos = player.position
#	look_at(Vector2(playerPos.x,playerPos.y))
#	move_WhitPosition(playerPos,delta)
	##Benja:
#	if target:
#		var targetPos = target.position;
#		look_at(targetPos);
#		move_WithPosition(targetPos,delta);
	pass

func _physics_process(delta):
	if target:
		var targetPos = target.position;
		look_at(targetPos);
		vel = transform.x.normalized() * max_speed
	move_and_slide(vel);
#	vel = Vector2.ZERO
#	pass
#func move_WithPosition(playerPos, delta):
#	position = position.move_toward(playerPos, min_speed * delta)

func hurt(damage:int):
	hp-=damage;
	if hp<=0:
		emit_signal("dies");
		AudioManager.zombie_death_sound_play()
		#dropear ammo al morir de forma aleatoria
		randomize()
		var random_value = randf()
		if is_float_in_range(random_value,0,ammo_chance):
			instanciate_ammo(ammo_scene)
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AttackTimer.start()

func instanciate_ammo(object_scene: PackedScene): #instanciar la municion al dropearla
	var object_instance = object_scene.instance()
	object_instance.global_position = global_position
	get_tree().root.add_child(object_instance)

func is_float_in_range(value: float, minimum: float, maximum: float) -> bool:
	return value >= minimum and value <= maximum #control de probabilidad
	
func handle_enemy_animation():
	if vel != Vector2.ZERO:
		enemy_sprite.animation="Zombie_Still"
	else:
		enemy_sprite.animation="Zombie"

func _on_AttackTimer_timeout():
	Signals.emit_signal("damage_taken")

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$AttackTimer.stop()
