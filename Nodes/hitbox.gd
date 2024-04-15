@icon("res://Nodes/hitbox.svg")
class_name Hitbox
extends Area2D

signal damage_taken(damage: Damage)

func _ready():
	# We are not checking collisions anywhere here
	self.monitoring = false

func take_damage(damage: Damage):
	damage_taken.emit(damage)
