@tool
class_name Pentagram
extends Area2D

@onready var sign_sprite: Sprite2D = $SignSprite as Sprite2D
@onready var standing_timer: Timer = $StandingTimer as Timer
@onready var bar: TextureProgressBar = $ProgressBar as TextureProgressBar

@export var root: Node = self
@export var damage: Damage
@export var animal_stats: AnimalStats
@export var summon: PackedScene
@export var sign_tex: Texture2D:
	set(value):
		if sign_sprite != null:
			sign_sprite.texture = value
		sign_tex = value

var is_player_in_area = false
var hitbox:Hitbox

func _ready():
	sign_sprite.texture = sign_tex
	bar.visible = false

func _process(_delta):
	bar.value = (1 - (standing_timer.time_left/standing_timer.wait_time))*100


func _on_standing_timer_timeout():
	on_summon(summon)
	hitbox.take_damage(damage)
	

func on_summon(_animal:PackedScene):
	var new_animal = summon.instantiate()
	new_animal.global_position = self.global_position
	new_animal.player=hitbox.get_parent()
	if new_animal.has_method("set_stats"):
		new_animal.set_stats(animal_stats)

	root.add_child(new_animal)


func _on_area_entered(area):
	if not area.get_parent() is Player:
		return
	is_player_in_area = true
	bar.visible = true
	standing_timer.start()
	hitbox=area


func _on_area_exited(_area):
	is_player_in_area = false
	bar.visible = false
	standing_timer.stop()
	hitbox=null
