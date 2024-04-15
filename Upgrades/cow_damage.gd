extends UpgradeScript

func do(tree_node: Node):
	var cows = tree_node.find_children("*", "Cow")
	for cow_n in cows:
		var cow = cow_n as Cow
		cow.stats.damage *= 1.2
		cow.stats = cow.stats
	var cow_penta = tree_node.find_child("PentagramCow") as Pentagram
	if cow_penta == null:
		push_error("No cow pentagram")
	var cow_stats = cow_penta.animal_stats as CowStats
	if cow_stats == null:
		push_error("Pentagram cow stats is null")
	cow_stats.damage.amount *= 1.2
