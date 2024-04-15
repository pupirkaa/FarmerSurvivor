@icon("res://Nodes/hurtbox.svg")
class_name Hurtbox
extends Area2D

@export var damage: Damage

func _ready():
	# We don't try to check if we're colliding with a Hurtbox anywhere
	self.monitorable = false
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if not area is Hitbox:
		return
	area.take_damage(damage)
