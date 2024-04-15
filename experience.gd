extends Pickup

func _on_pickup_finished(by: Node2D):
	if not by is Player:
		push_warning("heart pickup not implemented for anything but Player")
		return
	var p = by as Player
	p.xp += 1
