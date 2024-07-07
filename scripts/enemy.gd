extends CharacterBody2D

var spd = 50
var player_chase = false
var player = null

var health = 30
var atk = 5
var player_inAttack_zone = false
var can_take_dmg = true

func _physics_process(delta):
	deal_with_dmg()
	update_healthbar()
	if player_chase:
		position += (player.position - position).normalized() * spd * delta
		move_and_collide(Vector2(0,0))
		$AnimatedSprite2D.play("walk")
		
		if player.position.x < position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inAttack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inAttack_zone = false

func deal_with_dmg():
	if player_inAttack_zone and Global.player_current_attack == true:
		if can_take_dmg == true:
			health -= player.atk
			$take_dmg_cd.start()
			can_take_dmg = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()

func _on_take_dmg_cd_timeout():
	can_take_dmg = true

func update_healthbar():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 30:
		healthbar.visible = false
	else:
		healthbar.visible = true
