extends UpgradeScript

func do(tree_node: Node):
	var player = tree_node.find_child("Player") as Player
	if player == null:
		push_error("Player is null")
	player.stats.pickup_radius *= 1.2
	player.stats = player.stats
