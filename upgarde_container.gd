@tool
class_name UpgradeCard
extends Control

signal upgrade_picked(upgrade: Upgrade)

@onready var action: Label = $Action as Label
@onready var amount: Label = $Amount as Label
@onready var icon: TextureRect = $TextureRect as TextureRect

@export var upgrade: Upgrade:
	set(value):
		upgrade = value
		if not is_inside_tree():
			await ready
		action.text = upgrade.heading
		amount.text = upgrade.text
		icon.texture = upgrade.icon

func _on_texture_button_pressed():
	upgrade_picked.emit(self.upgrade)
