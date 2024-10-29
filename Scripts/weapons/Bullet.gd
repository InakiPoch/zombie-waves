extends Area2D
class_name Bullet

var bullet_speed = 15
var direction = Vector2()
var power; #la potencia de la bala, depende del arma.

func _physics_process(delta):
	var velocity = direction*bullet_speed
	global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()

#
#func _on_BulletCollision_body_entered(body):
#	if !body.is_in_group("player"):
#		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.hurt(power);
	queue_free()
