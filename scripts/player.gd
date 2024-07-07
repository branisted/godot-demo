extends CharacterBody2D

var enemy_inAttack_range = false
var enemy_attack_cd = true
var atk = 10
var player_alive = true

var enemy = null

var attack_inprog = false

const spd = 100
var curr_dir = "right"

func _ready():
	$AnimatedSprite2D.play("side_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_healthbar()
	if Global.player_health <= 0:
		player_alive = false
		Global.player_health = 0
		print("player has dieded")
		# todo end screen normal
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
	
func player_movement(delta):
	if Input.get_action_strength("ui_right"):
		play_anim(1)
		curr_dir = "right"
	elif Input.get_action_strength("ui_left"):
		play_anim(1)
		curr_dir = "left"
	elif Input.get_action_strength("ui_down"):
		play_anim(1)
		curr_dir = "down"
	elif Input.get_action_strength("ui_up"):
		play_anim(1)
		curr_dir = "up"
	else:
		play_anim(0)

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	velocity = input_vector * spd
	
	move_and_slide()
	
func play_anim(mov):
	#var dir = curr_dir
	var dir = curr_dir

	match dir:
		"up":
			$AnimatedSprite2D.flip_h = true
			if mov == 1:
				$AnimatedSprite2D.play("up_walk")
			elif mov == 0 and attack_inprog == false:
				$AnimatedSprite2D.play("up_idle")
		"down":
			$AnimatedSprite2D.flip_h = true
			if mov == 1:
				$AnimatedSprite2D.play("down_walk")
			elif mov == 0 and attack_inprog == false:
				$AnimatedSprite2D.play("down_idle")
		"left":
			$AnimatedSprite2D.flip_h = true
			if mov == 1:
				$AnimatedSprite2D.play("side_walk")
			elif mov == 0 and attack_inprog == false:
				$AnimatedSprite2D.play("side_idle")
		"right":
			$AnimatedSprite2D.flip_h = false
			if mov == 1:
				$AnimatedSprite2D.play("side_walk")
			elif mov == 0 and attack_inprog == false:
				$AnimatedSprite2D.play("side_idle")


func player():
	pass

func _on_player_hitbox_body_entered(body):
	if (body.has_method("enemy")):
		enemy = body
		enemy_inAttack_range = true

func _on_player_hitbox_body_exited(body):
	if (body.has_method("enemy")):
		enemy = null
		enemy_inAttack_range = false

func enemy_attack():
	if enemy_inAttack_range and enemy_attack_cd == true:
		Global.player_health -= enemy.atk
		print("player hp = ", Global.player_health)
		enemy_attack_cd = false
		$attack_cd.start()

func _on_attack_cd_timeout():
	enemy_attack_cd = true

func attack():
	var dir = curr_dir
	
	if Input.is_action_just_pressed("Attack"):
		Global.player_current_attack = true
		attack_inprog = true
		match dir:
			"up":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("up_att")
				$deal_attack_timer.start()
			"down":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("down_att")
				$deal_attack_timer.start()
			"left":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_att")
				$deal_attack_timer.start()
			"right":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_att")
				$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_inprog = false

#functie de schimbat camera daca e nevoie

func update_healthbar():
	var healthbar = $healthbar
	healthbar.value = Global.player_health
	#if Global.player_health >= 100:
		#Global.player_healthbar.visible = false
	#else:
		#Global.player_healthbar.visible = true

func _on_regen_timer_timeout():
	if Global.player_health < 100 and !enemy_inAttack_range:
		Global.player_health += 20
		if Global.player_health > 100:
			Global.player_health = 100
	if Global.player_health <= 0:
		Global.player_health = 0
