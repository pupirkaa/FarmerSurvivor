class_name Mob
extends Area2D

@export var health: int
@export var speed: int
@export var xp: PackedScene
@export var hp: PackedScene
var direction: Vector2 = Vector2.ZERO
var is_attacking = false

@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play("default")
	if health<=0:
		_on_death()
		queue_free()
	
	direction=(player.global_position - global_position).normalized()
	translate(direction*speed*delta)
	if direction.x>0:
		$AnimatedSprite2D.flip_h=true
	elif direction.x<0:
		$AnimatedSprite2D.flip_h=false


func _on_hitbox_damage_taken(damage):
	health-=damage.amount# Replace with function body.


func _on_attack_timeout():
	$Attack.start()
	is_attacking=true
	$Hurtbox.monitoring=true


func _on_attack_cooldown_timeout():
	$AttackCooldown.start()
	is_attacking=false
	$Hurtbox.monitoring=false

func _on_death():
	drop_xp()
	drop_hp()
	
func drop_xp():
	var amount = randi()%3+1
	for xp in amount:
		var new_xp = self.xp.instantiate()
		new_xp.global_position = self.global_position
		new_xp.global_position.x+=randi_range(4, 12)
		new_xp.global_position.y+=randi_range(4, 12)
		get_tree().get_root().add_child(new_xp)

func drop_hp():
	if not randi()%10==0:
		return
	var new_hp = hp.instantiate()
	new_hp.global_position = self.global_position
	new_hp.global_position.x+=randi_range(4, 12)
	new_hp.global_position.y+=randi_range(4, 12)
	get_tree().get_root().add_child(new_hp)
