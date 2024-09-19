extends RigidBody2D

@onready var sprite = $AnimatedSprite2D
@onready var explosion: Area2D = $Explosion

var fuse = true
var exploded = false

func _process(_delta):
	if fuse == false:
		collision_layer = 16
		sprite.play("bomb_off")
		await sprite.animation_finished
		queue_free()

func _on_timer_timeout() -> void:
	if fuse == true:
		sprite.play("explosion")
	
		if sprite.animation == "explosion":
			await sprite.animation_finished
			queue_free()
