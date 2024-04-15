extends UpgradeScript

func do(tree_node: Node):
	var chickens = tree_node.find_children("*", "Chicken")
	for chicken_n in chickens:
		var chicken = chicken_n as Chicken
		chicken.stats.damage.amount *= 1.2
		
		chicken.stats = chicken.stats
	var chicken_penta = tree_node.find_child("PentagramChicken") as Pentagram
	if chicken_penta == null:
		push_error("No chicken pentagram")
	var chicken_stats = chicken_penta.animal_stats as ChickenStats
	if chicken_stats == null:
		push_error("Pentagram sheep stats is null")
	
	chicken_stats.damage.amount *= 1.2
