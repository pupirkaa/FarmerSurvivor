class_name Upgrade
extends Resource

@export var name: String
@export var icon: Texture2D
@export var apply_script: GDScript
@export var heading: String
@export var text: String

var behavior: UpgradeScript:
	get:
		if !_scripts.has(name):
			_scripts[name] = apply_script.new()
		return _scripts[name]
	set(value):
		push_error("Behavior must not be tweaked manually")

static var _scripts: Dictionary
