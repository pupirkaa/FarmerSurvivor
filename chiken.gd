class_name Chicken
extends RigidBody2D

@export var stats: ChickenStats

func set_stats(s: AnimalStats):
	if not s is ChickenStats:
		push_error("Chicken only accepts ChickenStats")
	self.stats = s as ChickenStats

@export var player: CharacterBody2D
@export var follow_min_dist = 384
@export var run_away_dist = 256
@export var egg: PackedScene

@onready var egg_cooldown_timer: Timer = $EggCooldownTimer as Timer

var speed = 1600

func _physics_process(_delta):
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


func _on_egg_cooldown_timer_timeout():
	var new_egg = egg.instantiate() as Egg
	new_egg.global_position = self.global_position
	new_egg.explosion_radius = stats.radius
	get_tree().get_root().add_child(new_egg)
