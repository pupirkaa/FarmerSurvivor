class_name Sheep
extends RigidBody2D

@export var player: CharacterBody2D
@export var follow_min_dist = 384
@export var run_away_dist = 256
@export var bullet: PackedScene
@export var speed = 1400
@export var stats: SheepStats:
	set(value):
		stats = value
		if not is_inside_tree():
			await ready
		shoot_cooldown.wait_time = value.reload_time

func set_stats(s: AnimalStats):
	if not s is SheepStats:
		push_error("Sheep only accepts SheepStats")
	self.stats = s as SheepStats

@onready var wobble_anim: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var shoot_markers: Array[Marker2D] = []
@onready var center: Marker2D = $CenterMarker as Marker2D
@onready var shoot_cooldown: Timer = $ShootCooldown as Timer
@onready var anim_shoot_time: Timer = $ShootCooldown/AnimShootTime as Timer

var is_shooting = false

func _ready():
	shoot_markers.assign(find_children(
		"ShootMarker_*",
		"Marker2D",
	))
	$ShootCooldown.connect("timeout", on_shoot_cooldown_timeout)

func _physics_process(_delta):
	if is_shooting: return

	var dist = player.position - position
	if dist.length() > follow_min_dist:
		apply_central_force(dist.normalized()*speed)
	elif dist.length() < run_away_dist:
		apply_central_force(-dist.normalized()*speed/2)
	
	if wobble_anim.current_animation != "moving":
		wobble_anim.play("moving")

	wobble_anim.speed_scale = lerp(0, 2, linear_velocity.length()/600)
	
	if dist.x>0:
		sprite.flip_h=true
	elif dist.x<0:
		sprite.flip_h=false

func on_shoot_cooldown_timeout():
	is_shooting = true
	
	wobble_anim.play("shooting")
	wobble_anim.speed_scale = 3

	anim_shoot_time.start()
	await anim_shoot_time.timeout
	
	for marker in shoot_markers:
		var new_bullet = bullet.instantiate() as SheepBullet
		new_bullet.global_position = marker.global_position
		var dir = (marker.global_position - center.global_position).normalized()
		new_bullet.direction = dir
		new_bullet.damage = stats.damage
		
		get_tree().get_root().add_child(new_bullet)
	
	await wobble_anim.animation_finished
	is_shooting = false
