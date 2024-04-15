class_name Player
extends CharacterBody2D

@export var stats: PlayerStats:
	set(value):
		stats = value
		if not is_inside_tree():
			await ready
		$Hurtbox.damage = stats.damage

signal health_changed(new_value: int)
signal xp_changed(new_value: int)

var health: int = 6:
	set(value):
		health_changed.emit(value)
		health = value
		
var xp: int = 0:
	set(value):
		xp_changed.emit(value)
		xp = value

var is_attacking=false
var is_dead=false
var prev_dir:Vector2=Vector2.ZERO

signal player_dead()

func _ready():
	$AnimatedSprite2D.play("stand")
	$Shovel.play("default")

func _physics_process(_delta):
	if health<=0:
		$AnimatedSprite2D.play("stand")
		$AnimatedSprite2D.rotation=PI/2
		player_dead.emit()
		is_dead = true
		return
		
	var direction = Input.get_vector("walk_left","walk_right","walk_up", "walk_down")
	velocity = direction*stats.speed
	if (sign(direction.x) != sign(prev_dir.x))&&((($AnimatedSprite2D.flip_h == false) && (sign(direction.x)>0)||(($AnimatedSprite2D.flip_h == true) && (sign(direction.x)<0)))):
		if velocity.x < 0.0:
			$AnimatedSprite2D.flip_h = false
			$Shovel.flip_h = false
			$Hurtbox.position.x-=384
		elif velocity.x > 0.0:
			$AnimatedSprite2D.flip_h = true
			$Shovel.flip_h = true
			$Hurtbox.position.x+=384

	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
		move_and_slide()
	else:
		$AnimatedSprite2D.play("stand")
		
		
	await get_tree().create_timer(0.1).timeout
	$Hurtbox.monitorable=true
	await get_tree().create_timer(0.1).timeout
	$Hurtbox.monitorable=false
	
	prev_dir=direction


func _on_hit_box_damage_taken(damage: Damage):
	health -= damage.amount


func _on_attack_timeout():
	$Attack.start()
	is_attacking=true
	$Hurtbox.monitoring=true


func _on_attack_cooldown_timeout():
	$AttackCooldown.start()
	is_attacking=false
	$Hurtbox.monitoring=false

func _on_pickup_radius_area_entered(area: Area2D):
	if not area is Pickup:
		return
	area._on_picked_up(self)
