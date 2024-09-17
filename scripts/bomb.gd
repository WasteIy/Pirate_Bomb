extends RigidBody2D
@onready var sprite = $AnimatedSprite2D

func _on_timer_timeout() -> void:
	sprite.play("explosion")
	if sprite.animation == "explosion":
		await sprite.animation_finished
		queue_free()

#TODO Fix rotation
