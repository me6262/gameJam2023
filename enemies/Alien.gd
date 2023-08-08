extends Enemy

class_name Alien

signal died

@onready var player = get_tree().get_first_node_in_group("player")
@export var loot: PackedScene
var unpacked_loot
var dead = false
var knockback = Vector2.ZERO
var gravity = 980
var can_injure = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 10
	get_tree().create_timer(1).timeout.connect(on_immunity_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if health <= 0 and not dead:
		die()

	velocity.y += gravity * delta
	move_and_slide()


func hurt(damage: int, source: Vector2):
	print("alien hurt")
	
	knockback = (Vector2(1, 0)) * source
	print(knockback)
	velocity += knockback

	health -= damage

func die():
	dead = true
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	if loot:
		unpacked_loot = loot.instantiate()
		get_tree().root.get_child(0).add_child(unpacked_loot)
	unpacked_loot.global_position = global_position
	$HitSound.play(0)
	died.emit()



func _on_area_2d_body_entered(body:Node2D):
	if body is Player:
		body.die()

func on_immunity_end():
	can_injure = true
