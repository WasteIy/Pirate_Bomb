extends Area2D

@onready var timer: Timer = $Timer
@onready var bomb: RigidBody2D = $".."

var entity = null
var direction = null
var knockback = Vector2(400, -400)

func _on_timer_timeout():
	if bomb.fuse == true:
		var overlapping_bodies = get_overlapping_bodies()
		if overlapping_bodies.size() > 0:
			for body in overlapping_bodies:
				apply_knockback(body)

func apply_knockback(body: Node2D):
	direction = sign(body.global_position.x - global_position.x)
	body.velocity = knockback
