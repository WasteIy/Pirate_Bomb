extends Area2D

@onready var timer: Timer = $Timer
@onready var bomb: RigidBody2D = $".."

var explosion_force: float = 300.0
var explosion_radius: float = 100.0

func _on_timer_timeout():
	if bomb.fuse == true:
		var overlapping_bodies = get_overlapping_bodies()
		if overlapping_bodies.size() > 0:
			for body in overlapping_bodies:
				apply_explosion_force(body)

func apply_explosion_force(body: Node2D):
	var entity = body as CharacterBody2D
	var direction = sign(body.position - position)
	entity.velocity += direction * explosion_force

func is_touching_floor(entity: CharacterBody2D) -> bool:
	return entity.is_on_floor()

func is_touching_wall(entity: CharacterBody2D) -> bool:
	return entity.is_on_wall()
