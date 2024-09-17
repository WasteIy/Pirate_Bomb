extends RigidBody2D

@onready var sprite = $AnimatedSprite2D

var fuse = true

func _process(_delta):
	if fuse == false:
		sprite.play("bomb_off")
		await sprite.animation_finished
		queue_free()

func _on_timer_timeout() -> void:
	if fuse == true:
		sprite.play("explosion")
		if sprite.animation == "explosion":
			await sprite.animation_finished
			queue_free()

#TODO Fix rotation
