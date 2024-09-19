extends Area2D

@onready var timer: Timer = $Timer
@onready var bomb: RigidBody2D = $".."

var entity = null
var direction = null

func _on_timer_timeout():
	if bomb.fuse == true:
		var overlapping_bodies = get_overlapping_bodies()
		if overlapping_bodies.size() > 0:
			for body in overlapping_bodies:
				call_knockback(body)

func call_knockback(body: Node2D):
	entity = body as CharacterBody2D
	direction = sign(body.position.x - position.x)
	entity.knockback = true
	knockback()
	
func knockback():
	if entity.knockback == true:
		entity.velocity.x = 300 * direction
		entity.velocity.y = -300
		entity.knockback = false
