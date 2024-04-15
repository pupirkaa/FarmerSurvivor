@tool
class_name Cow
extends RigidBody2D

@onready var hurtbox: Hurtbox = $Hurtbox as Hurtbox

@export var player: CharacterBody2D
@export var follow_min_dist = 384
@export var run_away_dist = 256
@export var stats: CowStats:
	set(value):
		stats = value
		if not is_inside_tree():
			await ready
		hurtbox.damage = stats.damage

func set_stats(s: AnimalStats):
	if not s is CowStats:
		push_error("Cow only accepts CowStats")
	self.stats = s as CowStats
	
var speed = 1200
var is_attacking = false

func _physics_process(_delta):
	await get_tree().create_timer(0.1).timeout
	$Hurtbox.monitorable=true
	await get_tree().create_timer(0.1).timeout
	$Hurtbox.monitorable=false
	var dist = player.position - position
	if dist.length() > follow_min_dist:
		apply_central_force(dist.normalized()*speed)
	elif dist.length() < run_away_dist:
		apply_central_force(-dist.normalized()*speed/2)
		
	($AnimationPlayer as AnimationPlayer).speed_scale = lerp(0, 2, linear_velocity.length()/600)
	
	if dist.x>0:
		$Sprite2D.flip_h=true
	elif dist.x<0:
		$Sprite2D.flip_h=false

	


func _on_attack_timeout():
	$Attack.start()
	is_attacking=true
	$Hurtbox.monitoring=true


func _on_attack_cooldown_timeout():
	$AttackCooldown.start()
	is_attacking=false
	$Hurtbox.monitoring=false
