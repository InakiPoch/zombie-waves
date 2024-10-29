extends Node
class_name PlayerMovement

func get_player_movement()->Vector2:
	var velocity = Vector2()
	if Input.is_action_pressed("left"):
		velocity.x = -1
	elif Input.is_action_pressed("right"):
		velocity.x = 1
	elif Input.is_action_pressed("up"):
		velocity.y = -1
	elif Input.is_action_pressed("down"):
		velocity.y = 1
	return velocity.normalized()
