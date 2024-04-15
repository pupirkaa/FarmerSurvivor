class_name Egg
extends Node2D

@export var explosion_radius: int = 200
@onready var explosion_timer: Timer = $ExplosionTimer as Timer
@onready var before_pulse_timer: Timer = $BeforePulse as Timer
@onready var anim_player: AnimationPlayer = $Sprite2D/AnimationPlayer as AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO: Hurtbox radius & Sprite2D radius depend on explosion_radius
	$Hurtbox.monitoring=false
	$Sprite2D.animation="default"
	await before_pulse_timer.timeout
	anim_player.play("before_exploding")
	explosion_timer.start()
	await explosion_timer.timeout
	explode()

func explode():
	$Hurtbox.monitoring=true
	anim_player.stop()
	$Sprite2D.animation="explosion"
	$Sprite2D.play()
	await $Sprite2D.animation_finished
	queue_free()
