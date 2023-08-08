extends Node2D

class_name Level

@export var next_level: PackedScene
@export var starting_mail: int
@export var mail_required = 1

@onready var player: Player = get_tree().get_first_node_in_group("Player")

signal level_completed(next: PackedScene)
signal level_failed(message: String)
signal level_started

