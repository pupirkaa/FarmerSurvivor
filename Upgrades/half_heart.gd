extends UpgradeScript

func do(tree_root: Node):
	var p_node = tree_root.find_child("Player")
	if p_node == null:
		push_error("Player node not found")
	var p = p_node as Player
	if p == null:
		push_error("Player node is not Player")
	if p.is_dead:
		return
	p.health += 1
