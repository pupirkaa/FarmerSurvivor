extends Node2D

@export var ghost: PackedScene
@export var slime: PackedScene
@export var bat: PackedScene
@export var upgrades: Array[Upgrade]

@onready var hearts_container:HBoxContainer = $CanvasLayer/GUI/HeartsContainer as HBoxContainer
@onready var progress_bar:TextureProgressBar = $CanvasLayer/GUI/VBoxContainer/TextureProgressBar as TextureProgressBar
@onready var level_label:Label = $CanvasLayer/GUI/VBoxContainer/Label as Label
@onready var full_heart: Texture2D = preload("res://Assets/Heart.png")
@onready var half_heart: Texture2D = preload("res://Assets/Half_heart.png")
@onready var upgrade_1: UpgradeCard = $CanvasLayer/Upgrades/HBoxContainer/Upgrade_1 as UpgradeCard
@onready var upgrade_2: UpgradeCard = $CanvasLayer/Upgrades/HBoxContainer/Upgrade_2 as UpgradeCard
@onready var upgrade_3: UpgradeCard = $CanvasLayer/Upgrades/HBoxContainer/Upgrade_3 as UpgradeCard

var score=0
var enemies:Array[Node]=[]
var hearts: Array[TextureRect]=[]
var hp: int = 6
var level: int = 1
var level_xp:int = int((1.2**level)*12)
var prev_xp: int =0
var curr_xp: int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 3:
		var heart:TextureRect = TextureRect.new()
		heart.texture=full_heart
		hearts_container.add_child(heart)
		hearts.append(heart)
	progress_bar.value=0
	progress_bar.max_value=level_xp
	$CanvasLayer/Upgrades.visible=false
	$CanvasLayer/GameOverUI.visible=false

func _on_spawn_cooldown_timeout():
	spawn(randi()%3)
	
func spawn(i: int):
	match i:
		0:
			var new_ghost = ghost.instantiate()
			new_ghost.global_position = get_enemie_position()
			new_ghost.player=$Pausable/Player
			$Pausable.add_child(new_ghost)
		1:
			var new_slime = slime.instantiate()
			new_slime.global_position = get_enemie_position()
			new_slime.player=$Pausable/Player
			$Pausable.add_child(new_slime)
		2:
			var new_bat = bat.instantiate()
			new_bat.global_position = get_enemie_position()
			new_bat.player=$Pausable/Player
			$Pausable.add_child(new_bat)
			
func get_enemie_position()-> Vector2:
	var enemie_spawn_location = $Pausable/Player/Path2D/EnemieSpawnLocation
	enemie_spawn_location.progress_ratio = randf()
	return enemie_spawn_location.position


func _on_player_health_changed(new_value):
	if new_value>hp:
		if new_value-hp==2:
			hearts[hearts.size()-1].texture=full_heart
			var heart:TextureRect = TextureRect.new()
			if hp%2 == 1:
				heart.texture=half_heart
			else:
				heart.texture=full_heart
			hearts_container.add_child(heart)
			hearts.append(heart)
		else:
			if hp%2 == 1:
				hearts[hearts.size()-1].texture=full_heart
			else:
				var heart:TextureRect = TextureRect.new()
				heart.texture=half_heart
				hearts_container.add_child(heart)
				hearts.append(heart)
	elif new_value<hp:
		if hp%2 == 1:
			hearts_container.remove_child(hearts[hearts.size()-1])
			hearts.remove_at(hearts.size()-1)
			
		else:
			hearts[hearts.size()-1].texture=half_heart
			
	hp=new_value
			
			


func _on_player_xp_changed(new_value):
	progress_bar.value=new_value-prev_xp
	if new_value-prev_xp>=level_xp:
		update_level()
		show_upgrade_panel()
	curr_xp=new_value
		
func update_level():
	prev_xp+=level_xp
	level+=1
	level_label.text= String("LV %s" %level)
	level_xp=int(1.2**level*12)
	progress_bar.max_value=level_xp
	progress_bar.value=0
	
	
		
func show_upgrade_panel():
	$Pausable.process_mode = Node.PROCESS_MODE_DISABLED
	var ug_1=upgrades[randi()%10]
	upgrade_1.upgrade = ug_1
	
	var ug_2=upgrades[randi()%10]
	upgrade_2.upgrade = ug_2
	
	var ug_3=upgrades[randi()%10]
	upgrade_3.upgrade = ug_3

	$CanvasLayer/Upgrades.visible = true

func _on_upgrade_picked(upgrade: Upgrade):
	$CanvasLayer/Upgrades.visible = false
	$Pausable.process_mode = Node.PROCESS_MODE_INHERIT
	upgrade.behavior.do(self)


func _on_player_player_dead():
	$Pausable.process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer/GameOverUI/VBoxContainer/HBoxContainer/Label.text=String("Your score: %s" %curr_xp)
	$CanvasLayer/GameOverUI.visible=true
	
	

func _on_texture_button_pressed():
	for pickup in get_tree().get_root().get_children():
		if pickup is Pickup:
			pickup.queue_free()
	get_tree().reload_current_scene()
