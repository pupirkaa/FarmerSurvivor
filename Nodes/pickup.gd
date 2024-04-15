@icon("res://Nodes/pickup.svg")
class_name Pickup
extends Area2D

var speed: int = 10
var is_picked_up: bool = false
var picked_up_by: Node2D

signal pickup_finished(by: Node2D)

func _physics_process(delta):
	if !is_picked_up:
		return
	var dist = picked_up_by.global_position - global_position
	# Просто наобум выбрали 24 писеля
	if dist.length() < 24:
		pickup_finished.emit(picked_up_by)
		queue_free()
		return
	
	var dir = dist.normalized()
	translate(dir*speed)

func _on_picked_up(by: Node2D):
	if is_picked_up:
		return
	is_picked_up = true
	picked_up_by = by
