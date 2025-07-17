extends CharacterBody2D

var speed = 80
var health = 100
var player = null
var player_chase = false
var player_inattack_zone = false

func _physics_process(delta: float) -> void:
	handle_damage()
	
	if player_chase:
		position += (player.position - position) / speed
		
		$AnimatedSprite2D.play("side_walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("front_idle")

func enemy():
	pass

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func handle_damage():
	if player_inattack_zone && global.player_current_attack == true:
		health = health -20
		print("enemy health = ", health)
		if health <= 0:
			self.queue_free()
