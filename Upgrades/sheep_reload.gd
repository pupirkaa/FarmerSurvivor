extends UpgradeScript

func do(tree_node: Node):
	var sheeps = tree_node.find_children("*", "Sheep")
	for sheep_n in sheeps:
		var sheep = sheep_n as Sheep
		sheep.stats.reload_time *= 0.8
		sheep.stats = sheep.stats
	var sheep_penta = tree_node.find_child("PentagramSheep") as Pentagram
	if sheep_penta == null:
		push_error("No cow pentagram")
	var sheep_stats = sheep_penta.animal_stats as SheepStats
	if sheep_stats == null:
		push_error("Pentagram sheep stats is null")
	sheep_stats.reload_time *= 0.8
