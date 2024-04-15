class_name SheepBullet
extends Area2D

@export var direction = Vector2.RIGHT
@export var damage:Damage
@export var speed = 600

func _ready():
	$Hurtbox.monitoring=true
	($Hurtbox as Hurtbox).damage = damage
	await get_tree().create_timer(1.0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	translate(direction.normalized()*speed*delta)
	
