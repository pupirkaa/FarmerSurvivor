class_name PlayerStats
extends Resource

@export var damage: Damage
@export var pickup_radius: int = 76
@export var speed: int = 600

func _init():
    if damage == null:
        damage = Damage.new()
        damage.amount = 10